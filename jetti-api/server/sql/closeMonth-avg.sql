ALTER PROCEDURE [dbo].[Invetory.Close.Month-mem] @company uniqueidentifier, @date DATE, @iterations INT = 30
AS
BEGIN

PRINT CAST(GETDATE() AS VARCHAR(25)) + ' Start'

SET NOCOUNT ON;

DECLARE @BeginDate DATE = DATEADD(DAY, 1, EOMONTH(@Date, -1));
DECLARE @EndDate DATE = EOMONTH(@BeginDate);
DECLARE @cost TABLE (company uniqueidentifier, Storehouse uniqueidentifier, SKU uniqueidentifier, [Cost] FLOAT);
DECLARE @CompanyHolding uniqueidentifier = (SELECT id FROM Documents WHERE type = N'Catalog.Company' AND code = N'HOLDING')
DECLARE @NULL uniqueidentifier = '00000000-0000-0000-0000-000000000000';
DECLARE @BeforeCost MONEY, @AfterCost MONEY;
DECLARE @companys [dbo].[companyList];
DECLARE @OperationTypeINTHOLDING uniqueidentifier = (SELECT id FROM Documents WHERE type = N'Catalog.Operation.Type' AND code = N'INT.HOLDING');

-- DECLARE @Inventory AS [dbo].[InventoryTable];
INSERT INTO @companys SELECT company FROM [dbo].[GetCompanyList](@company, @BeginDate, @EndDate);

SELECT company, Storehouse, SKU, SUM([Cost]) [Cost], SUM([Qty]) [Qty] 
INTO #beginBalance
FROM [dbo].[Register.Accumulation.Inventory] r
WHERE date < @BeginDate AND company IN (SELECT company FROM @companys)
GROUP BY company, Storehouse, SKU;
BEGIN TRY
BEGIN TRANSACTION
DELETE FROM [Register.Accumulation.Inventory] WHERE date BETWEEN @BeginDate AND @EndDate AND calculated = 1 AND company IN (SELECT company FROM @companys);

--INSERT INTO @Inventory (
--	[kind], [id], [calculated], [company], [document], [date], [DT], [parent], [exchangeRate], [OperationType], [Expense], [ExpenseAnalytics], [Income], [IncomeAnalytics], [BalanceIn], [BalanceInAnalytics], [BalanceOut], [BalanceOutAnalytics], [Storehouse], [SKU], [batch], [Cost], [Cost.In], [Cost.Out], [Qty], [Qty.In], [Qty.Out], [Department])
SELECT 
	[kind], [id], [calculated], [company], [document], [date], [DT], [parent], [exchangeRate], [OperationType], [Expense], [ExpenseAnalytics], [Income], [IncomeAnalytics], [BalanceIn], [BalanceInAnalytics], [BalanceOut], [BalanceOutAnalytics], [Storehouse], [SKU], [batch], [Cost], [Cost.In], [Cost.Out], [Qty], [Qty.In], [Qty.Out], [Department]
INTO #Inventory
FROM [dbo].[Register.Accumulation.Inventory]
WHERE date BETWEEN @BeginDate AND @EndDate AND company IN (SELECT company FROM @companys);

WHILE (@iterations > 0)
BEGIN

SELECT @BeforeCost = SUM(Cost) FROM #Inventory;

DELETE FROM @cost;
INSERT INTO @cost 
SELECT q.company, q.Storehouse, q.SKU, ISNULL(CAST(SUM(q.Cost) / NULLIF(SUM(q.Qty), 0) AS float), 0) Cost FROM (
	SELECT company, Storehouse, SKU, Cost, Qty FROM #beginBalance
	UNION ALL 
	SELECT company, Storehouse, SKU, SUM([Cost.In]) [Cost], SUM([Qty.In]) [Qty] FROM #Inventory r WHERE kind = 1 GROUP BY company, Storehouse, SKU
) q
GROUP BY q.company, q.Storehouse, q.SKU;

DELETE FROM #Inventory WHERE calculated = 1;

INSERT INTO #Inventory ([id],
[kind], [company], [document], [date], [DT], [Storehouse], [SKU], [batch], 
[Cost], [Cost.In], [Cost.Out], [Qty], [Qty.In], [Qty.Out],
[parent], [Department], [calculated], [exchangeRate], 
[Expense], [ExpenseAnalytics], [Income], [IncomeAnalytics], [BalanceIn], [BalanceInAnalytics], [BalanceOut], [BalanceOutAnalytics], [OperationType])
SELECT NEWID() [id],
[kind], r.[company], [document], r.[date], [DT], r.[Storehouse], r.[SKU], [batch], 
c.cost * r.[Qty] [Cost], 0 [Cost.In], c.cost * r.[Qty.Out] [Cost.Out], 0 [Qty], 0 [Qty.In], 0 [Qty.Out], 
[parent],  [Department], 1 [calculated], [exchangeRate],
[Expense], [ExpenseAnalytics], [Income], [IncomeAnalytics], [BalanceIn], [BalanceInAnalytics], [BalanceOut], [BalanceOutAnalytics], [OperationType]
FROM #Inventory r
LEFT JOIN @cost c ON r.SKU = c.SKU AND r.company = c.company AND c.Storehouse = r.Storehouse
WHERE kind = 0 AND OperationType <> @OperationTypeINTHOLDING AND c.cost * r.[Qty] <> 0;

INSERT INTO #Inventory ([id],
[kind], [company], [document], [date], [DT], [Storehouse], [SKU], [batch], 
[Cost], [Cost.In], [Cost.Out], [Qty], [Qty.In], [Qty.Out], 
[parent],  [Department], [calculated], [exchangeRate],
[Expense], [ExpenseAnalytics], [Income], [IncomeAnalytics], [BalanceIn], [BalanceInAnalytics], [BalanceOut], [BalanceOutAnalytics], [OperationType])
SELECT NEWID() [id],
[kind], [company], [document], [date], [DT], [Storehouse], [SKU], [batch], 
ISNULL((SELECT SUM([Cost.Out]) FROM #Inventory WHERE parent = r.id and kind = 0), 0) [Cost], 
ISNULL((SELECT SUM([Cost.Out]) FROM #Inventory WHERE parent = r.id and kind = 0), 0) [Cost.In],
0 [Cost.Out], 0 [Qty], 0 [Qty.In], 0 [Qty.Out], 
parent, [Department], 1 [calculated], [exchangeRate],
[Expense], [ExpenseAnalytics], [Income], [IncomeAnalytics], [BalanceIn], [BalanceInAnalytics], [BalanceOut], [BalanceOutAnalytics], [OperationType]
FROM #Inventory r
WHERE kind = 1 AND EXISTS (SELECT * FROM #Inventory WHERE parent = r.id);

SET @iterations = @iterations - 1;

SELECT @AfterCost = SUM(Cost) FROM #Inventory;
--IF ABS(@AfterCost - @BeforeCost) < 0.0001 BREAK;

END

PRINT CAST(GETDATE() AS VARCHAR(25)) + ' End calc'

PRINT CAST(GETDATE() AS VARCHAR(25)) + ' start delete Register.Accumulation.Inventory'
DELETE FROM [dbo].[Accumulation] WHERE type = N'Register.Accumulation.Inventory' AND date BETWEEN @BeginDate AND @EndDate AND calculated = 1 AND company IN (SELECT company FROM @companys);
PRINT CAST(GETDATE() AS VARCHAR(25)) + ' start insert Register.Accumulation.Inventory'
INSERT INTO [dbo].[Accumulation] ([id], [kind], [date], [type], [document],[company], [parent], [calculated], [data])
SELECT NEWID() [id], [kind], [date], N'Register.Accumulation.Inventory' [type], [document], [company], [parent], 1 calculated,
(SELECT CAST([exchangeRate] AS numeric(38, 18)) [exchangeRate], [Storehouse], [SKU], [batch], CAST([Cost] AS money) [Cost], [Qty],
[Department], [Expense], [ExpenseAnalytics], [Income], [IncomeAnalytics], 
[BalanceIn], [BalanceInAnalytics], [BalanceOut], [BalanceOutAnalytics], [OperationType] FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) data FROM (
SELECT 
[id], [kind], r.[company], [document],  r.[Department], r.[date], [DT], [Storehouse], r.[SKU], [batch], 
r.[Cost] * IIF(kind = 1, 1, -1) [Cost], r.[Qty], [exchangeRate], [parent],
[Expense], [ExpenseAnalytics], [Income], [IncomeAnalytics], [BalanceIn], [BalanceInAnalytics], [BalanceOut], [BalanceOutAnalytics], [OperationType]
FROM #Inventory r WHERE calculated = 1) q;
PRINT CAST(GETDATE() AS VARCHAR(25)) + ' start delete Register.Accumulation.Sales'
DELETE FROM [dbo].[Accumulation] WHERE type = N'Register.Accumulation.Sales' AND date BETWEEN @BeginDate AND @EndDate AND calculated = 1 AND company IN (SELECT company FROM @companys);
PRINT CAST(GETDATE() AS VARCHAR(25)) + ' start insert Register.Accumulation.Sales'
INSERT INTO [dbo].[Accumulation] ([id], [kind], [date], [type], [document],[company], [parent], [calculated], [data])
SELECT NEWID() [id], [kind], [date], N'Register.Accumulation.Sales' [type], [document], [company], null [parent], 1 calculated,
(SELECT CAST([exchangeRate] AS numeric(38, 18)) [exchangeRate], [Department], [currency], [Customer], [Product], [Manager], [AO], [Storehouse],
CAST([Cost] AS money) [Cost] FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) data FROM (
SELECT 
	[kind], r.[company], [document], [date], [DT], [parent], [id], [exchangeRate], [currency],  
	[Department], [Customer], [Product], [Manager], [AO], r.[Storehouse], 
	c.Cost * [Qty.In] [Cost]
FROM [dbo].[Register.Accumulation.Sales] r
LEFT JOIN @cost c ON c.SKU = r.Product AND c.company = r.company AND c.Storehouse = r.Storehouse
WHERE r.date BETWEEN @BeginDate AND @EndDate AND kind = 1 AND r.company IN (SELECT company FROM @companys)) q;
PRINT CAST(GETDATE() AS VARCHAR(25)) + ' start delete Register.Accumulation.Balance'
DELETE FROM [dbo].[Accumulation] WHERE type = N'Register.Accumulation.Balance' AND date BETWEEN @BeginDate AND @EndDate AND calculated = 1 AND company IN (SELECT company FROM @companys);
PRINT CAST(GETDATE() AS VARCHAR(25)) + ' start insert Register.Accumulation.Balance'
INSERT INTO [dbo].[Accumulation] ([id], [kind], [date], [type], [document],[company], [parent], [calculated], [data])
SELECT NEWID() [id], [kind], [date], N'Register.Accumulation.Balance' [type], [document],  company, null [parent], 1 calculated,
(SELECT CAST([exchangeRate] AS numeric(38, 18)) [exchangeRate], [Balance], [Analytics], [Department],
CAST([Amount] AS MONEY) [Amount] FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) data FROM (
	SELECT 1 [kind], [document], [date], MAX([exchangeRate]) [exchangeRate], [company],
		[BalanceIn] [Balance], [BalanceInAnalytics] [Analytics], [Department], SUM([Cost] * IIF(kind = 1, 1, -1)) [Amount]
	FROM [dbo].[Register.Accumulation.Inventory] r
	WHERE r.date BETWEEN @BeginDate AND @EndDate AND r.company IN (SELECT company FROM @companys) AND [BalanceIn] <> @NULL
	GROUP BY [company], [date], [document], [Department], [BalanceIn], [BalanceInAnalytics]
	UNION ALL
	SELECT 0 [kind], [document], [date], MAX([exchangeRate]) [exchangeRate], [company],
		[BalanceOut] [Balance], [BalanceOutAnalytics] [Analytics], [Department], SUM([Cost] * IIF(kind = 1, 1, -1)) [Amount]
	FROM [dbo].[Register.Accumulation.Inventory] r
	WHERE r.date BETWEEN @BeginDate AND @EndDate AND r.company IN (SELECT company FROM @companys) AND [BalanceOut] <> @NULL
	GROUP BY [company], [date], [document], [Department], [BalanceOut], [BalanceOutAnalytics]) q;

	-------- HOLDING
PRINT CAST(GETDATE() AS VARCHAR(25)) + ' start delete Register.Accumulation.Balance HOLDING'
DELETE FROM [dbo].[Accumulation] WHERE type = N'Register.Accumulation.Balance' AND date BETWEEN @BeginDate AND @EndDate AND calculated = 1 AND company = @CompanyHolding
AND CAST(JSON_VALUE(data, N'$."Department"') AS UNIQUEIDENTIFIER) IN (SELECT company FROM @companys);
PRINT CAST(GETDATE() AS VARCHAR(25)) + ' start insert Register.Accumulation.Balance HOLDING'
INSERT INTO [dbo].[Accumulation] ([id], [kind], [date], [type], [document], [company], [parent], [calculated], [data])
SELECT NEWID() [id], [kind], [date], N'Register.Accumulation.Balance' [type], [document], @CompanyHolding, null [parent], 1 calculated,
(SELECT CAST([exchangeRate] AS numeric(38, 18)) [exchangeRate], [Balance], [Analytics], [Department],
CAST([Amount] AS MONEY) [Amount] FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) data FROM (
	SELECT 1 [kind], [document], [date], MAX([exchangeRate]) [exchangeRate],  [company] [Department],
		[BalanceIn] [Balance], [BalanceInAnalytics] [Analytics], SUM(CAST([Cost] * IIF(kind = 1, 1, -1) / [exchangeRate] AS FLOAT)) [Amount]
	FROM [dbo].[Register.Accumulation.Inventory] r
	WHERE r.date BETWEEN @BeginDate AND @EndDate AND r.company IN (SELECT company FROM @companys) AND [BalanceIn] <> @NULL
	GROUP BY [company], [date], [document], [BalanceIn], [BalanceInAnalytics]
	UNION ALL
	SELECT 0 [kind], [document], [date], MAX([exchangeRate]) [exchangeRate], [company] [Department],
		[BalanceOut] [Balance], [BalanceOutAnalytics] [Analytics], SUM(CAST([Cost] * IIF(kind = 1, 1, -1) / [exchangeRate] AS FLOAT)) [Amount]
	FROM [dbo].[Register.Accumulation.Inventory] r
	WHERE r.date BETWEEN @BeginDate AND @EndDate AND r.company IN (SELECT company FROM @companys) AND [BalanceOut] <> @NULL
	GROUP BY [company], [date], [document], [BalanceOut], [BalanceOutAnalytics]) q;
---------------------
PRINT CAST(GETDATE() AS VARCHAR(25)) + ' start delete Register.Accumulation.PL'
DELETE FROM [dbo].[Accumulation] WHERE type = N'Register.Accumulation.PL' AND date BETWEEN @BeginDate AND @EndDate AND calculated = 1 AND company IN (SELECT company FROM @companys);
PRINT CAST(GETDATE() AS VARCHAR(25)) + ' start insert Register.Accumulation.PL'
INSERT INTO [dbo].[Accumulation] ([id], [kind], [date], [type], [document],[company], [parent], [calculated], [data])
SELECT NEWID() [id], 1 [kind], [date], N'Register.Accumulation.PL' [type], [document],  [company], null [parent], 1 calculated,
(SELECT CAST([exchangeRate] AS numeric(38, 18)) [exchangeRate], [PL], [Analytics], [Department],
CAST([Amount] AS MONEY) [Amount] FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) data FROM (
	SELECT 1 [kind], [document], [date], MAX([exchangeRate]) [exchangeRate], [company],
		[Income] [PL], [IncomeAnalytics] [Analytics], [Department], -SUM([Cost]) [Amount]
	FROM [dbo].[Register.Accumulation.Inventory] r
	WHERE r.date BETWEEN @BeginDate AND @EndDate AND r.company IN (SELECT company FROM @companys) AND [Income] <> @NULL
	GROUP BY [kind], [company], [company], [date], [document], [Department], [Income], [IncomeAnalytics]
	UNION ALL
	SELECT 0 [kind], [document], [date], MAX([exchangeRate]) [exchangeRate], [company],
		[Expense] [PL], [ExpenseAnalytics] [Analytics], [Department], SUM([Cost]) [Amount]
	FROM [dbo].[Register.Accumulation.Inventory] r
	WHERE r.date BETWEEN @BeginDate AND @EndDate AND r.company IN (SELECT company FROM @companys) AND [Expense] <> @NULL
	GROUP BY [kind], [company], [date], [document], [Department], [Expense], [ExpenseAnalytics]) q;
	-------- HOLDING
PRINT CAST(GETDATE() AS VARCHAR(25)) + ' start delete Register.Accumulation.PL HOLDING'
DELETE FROM [dbo].[Accumulation] WHERE type = N'Register.Accumulation.PL' AND date BETWEEN @BeginDate AND @EndDate AND calculated = 1 AND company = @CompanyHolding
AND EXISTS (SELECT * FROM Documents WHERE id = [dbo].[Accumulation].document AND company IN (SELECT company FROM @companys));
PRINT CAST(GETDATE() AS VARCHAR(25)) + ' start insert Register.Accumulation.PL HOLDING'
INSERT INTO [dbo].[Accumulation] ([id], [kind], [date], [type], [document],[company], [parent], [calculated], [data])
SELECT NEWID() [id], 1 [kind], [date], N'Register.Accumulation.PL' [type], [document],  @CompanyHolding, null [parent], 1 calculated,
(SELECT CAST([exchangeRate] AS numeric(38, 18)) [exchangeRate], [PL], [Analytics], [Department],
CAST([Amount] AS MONEY) [Amount] FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) data FROM (
	SELECT 1 [kind], [document], [date], MAX([exchangeRate]) [exchangeRate],
		[Income] [PL], [IncomeAnalytics] [Analytics], [Department], -SUM(CAST([Cost] / [exchangeRate] AS FLOAT)) [Amount]
	FROM [dbo].[Register.Accumulation.Inventory] r
	WHERE r.date BETWEEN @BeginDate AND @EndDate AND r.company IN (SELECT company FROM @companys) AND [Income] <> @NULL 
	GROUP BY [kind], [company], [date], [document], [Department], [Income], [IncomeAnalytics]
	UNION ALL
	SELECT 0 [kind], [document], [date], MAX([exchangeRate]) [exchangeRate],
		[Expense] [PL], [ExpenseAnalytics] [Analytics], [Department], SUM(CAST([Cost] / [exchangeRate] AS FLOAT)) [Amount]
	FROM [dbo].[Register.Accumulation.Inventory] r
	WHERE r.date BETWEEN @BeginDate AND @EndDate AND r.company IN (SELECT company FROM @companys) AND [Expense] <> @NULL
	GROUP BY [kind], [company], [date], [document], [Department], [Expense], [ExpenseAnalytics]) q;
PRINT CAST(GETDATE() AS VARCHAR(25)) + ' start commit'
COMMIT;

PRINT CAST(GETDATE() AS VARCHAR(25)) + ' end commit'

END TRY
BEGIN CATCH  
	ROLLBACK;
	--THROW;
END CATCH;
END