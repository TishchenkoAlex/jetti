USE [sm]
GO
/****** Object:  StoredProcedure [dbo].[Invetory.Close.Month-mem]    Script Date: 27.10.2020 20:26:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Invetory.Close.Month-mem] @company uniqueidentifier, @date DATE, @iterations INT = 30
AS
BEGIN
PRINT CAST(GETDATE() AS VARCHAR(25)) + N' Start';
RAISERROR('', 0 ,1) WITH NOWAIT;

DECLARE @NULL uniqueidentifier = '00000000-0000-0000-0000-000000000000';
DECLARE @BeginDate DATE = DATEADD(DAY, 1, EOMONTH(@Date, -1));
DECLARE @EndDate DATE = EOMONTH(@BeginDate);
DECLARE @CompanyHolding uniqueidentifier = (SELECT id FROM Documents WHERE type = N'Catalog.Company' AND code = N'HOLDING')
DECLARE @OperationTypeINTHOLDING uniqueidentifier = (SELECT id FROM Documents WHERE type = N'Catalog.Operation.Type' AND code = N'INT.HOLDING');

BEGIN TRANSACTION CL
BEGIN TRY
DELETE FROM [dbo].[Register.Accumulation.Inventory] WHERE [date] BETWEEN @BeginDate AND @EndDate AND [company] = @company AND [calculated] = 1 AND [owner] IS NULL;
DELETE FROM [dbo].[Register.Accumulation.Sales] WHERE [date] BETWEEN @BeginDate AND @EndDate AND [company] = @company AND [calculated] = 1 AND [owner] IS NULL;

SELECT [Storehouse], [SKU], SUM([Cost]) [Cost], SUM([Qty]) [Qty] INTO #beginBalance FROM [dbo].[Register.Accumulation.Inventory] r WHERE [date] < @BeginDate AND [company] = @company GROUP BY [Storehouse], [SKU];
SELECT * INTO #Inventory FROM [dbo].[Register.Accumulation.Inventory] WHERE [date] BETWEEN @BeginDate AND @EndDate AND [company] = @company AND [calculated] = 0;

SELECT q.Storehouse, q.SKU, ISNULL(CAST(SUM(q.Cost) / NULLIF(SUM(q.Qty), 0) AS float), 0) Cost 
INTO #cost FROM (
	SELECT Storehouse, SKU, Cost, Qty FROM #beginBalance
	UNION ALL 
	SELECT Storehouse, SKU, SUM([Cost.In]) [Cost], SUM([Qty.In]) [Qty] FROM #Inventory r WHERE kind = 1 GROUP BY company, Storehouse, SKU
) q
GROUP BY q.Storehouse, q.SKU;

WHILE (@iterations > 0)
BEGIN
	DELETE FROM #Inventory WHERE calculated = 1;

	INSERT INTO #Inventory (
	[id], [owner], [kind], [company], [document], [date], [Storehouse], [SKU], [batch], [Cost], [Cost.In], [Cost.Out], [Qty], [Qty.In], [Qty.Out],
	[parent], [Department], [calculated], [exchangeRate], [Expense], [ExpenseAnalytics], [Income], [IncomeAnalytics], [BalanceIn], [BalanceInAnalytics], [BalanceOut], [BalanceOutAnalytics], [OperationType])
	SELECT
	[id], [id], [kind], r.[company], [document], r.[date], r.[Storehouse], r.[SKU], [batch], c.cost * r.[Qty] [Cost], NULL [Cost.In], c.cost * r.[Qty.Out] [Cost.Out], NULL [Qty], NULL [Qty.In], NULL [Qty.Out], 
	[parent], [Department], 1 [calculated], [exchangeRate], [Expense], [ExpenseAnalytics], [Income], [IncomeAnalytics], [BalanceIn], [BalanceInAnalytics], [BalanceOut], [BalanceOutAnalytics], [OperationType]
	FROM #Inventory r LEFT JOIN #cost c ON r.SKU = c.SKU AND c.Storehouse = r.Storehouse
	WHERE kind = 0 AND c.cost * r.[Qty] <> 0 AND ISNULL([OperationType], @NULL) <> @OperationTypeINTHOLDING;

	INSERT INTO #Inventory (
	[id], [owner], [kind], [company], [document], [date], [Storehouse], [SKU], [batch], [Cost], [Cost.In], [Cost.Out], [Qty], [Qty.In], [Qty.Out], 
	[parent],  [Department], [calculated], [exchangeRate],[Expense], [ExpenseAnalytics], [Income], [IncomeAnalytics], [BalanceIn], [BalanceInAnalytics], [BalanceOut], [BalanceOutAnalytics], [OperationType])
	SELECT
	[id], [id], [kind], [company], [document], [date], [Storehouse], [SKU], [batch], 
	ISNULL((SELECT SUM([Cost.Out]) FROM #Inventory WHERE parent = r.id and kind = 0), NULL) [Cost], 
	ISNULL((SELECT SUM([Cost.Out]) FROM #Inventory WHERE parent = r.id and kind = 0), NULL) [Cost.In],
	NULL [Cost.Out], NULL [Qty], NULL [Qty.In], NULL [Qty.Out], parent, [Department], 1 [calculated], [exchangeRate],[Expense], [ExpenseAnalytics], [Income], [IncomeAnalytics], [BalanceIn], [BalanceInAnalytics], [BalanceOut], [BalanceOutAnalytics], [OperationType]
	FROM #Inventory r
	WHERE kind = 1 AND EXISTS (SELECT * FROM #Inventory WHERE parent = r.id);

	TRUNCATE TABLE #cost;
	INSERT INTO #cost
	SELECT q.Storehouse, q.SKU, ISNULL(CAST(SUM(q.Cost) / NULLIF(SUM(q.Qty), 0) AS float), 0) Cost 
	FROM (
		SELECT Storehouse, SKU, Cost, Qty FROM #beginBalance
		UNION ALL 
		SELECT Storehouse, SKU, SUM([Cost.In]) [Cost], SUM([Qty.In]) [Qty] FROM #Inventory r WHERE kind = 1 GROUP BY company, Storehouse, SKU
	) q
	GROUP BY q.Storehouse, q.SKU;

	SET @iterations = @iterations - 1;	
END

PRINT CAST(GETDATE() AS VARCHAR(25)) + N' End calc'
RAISERROR('', 0 ,1) WITH NOWAIT;

PRINT CAST(GETDATE() AS VARCHAR(25)) + N' start delete Register.Accumulation.Inventory'
DELETE FROM [dbo].[Register.Accumulation.Inventory] WHERE [owner] IN (
SELECT [owner] FROM (
	SELECT [owner], [kind], [company], [document], [date], [Storehouse], [SKU], [batch], [Cost], [Cost.In], [Cost.Out], [Qty], [Qty.In], [Qty.Out], [parent], [Department], [exchangeRate], [Expense], [ExpenseAnalytics], [Income], [IncomeAnalytics], [BalanceIn], [BalanceInAnalytics], [BalanceOut], [BalanceOutAnalytics], [OperationType]
	FROM [dbo].[Register.Accumulation.Inventory] WHERE [date] BETWEEN @BeginDate AND @EndDate AND company = @company AND calculated = 1 
	EXCEPT
	SELECT [owner], [kind], [company], [document], [date], [Storehouse], [SKU], [batch], [Cost], [Cost.In], [Cost.Out], [Qty], [Qty.In], [Qty.Out], [parent], [Department], [exchangeRate], [Expense], [ExpenseAnalytics], [Income], [IncomeAnalytics], [BalanceIn], [BalanceInAnalytics], [BalanceOut], [BalanceOutAnalytics], [OperationType]
	FROM #Inventory WHERE calculated = 1) q
);

PRINT CAST(GETDATE() AS VARCHAR(25)) + N' start insert Register.Accumulation.Inventory'
INSERT INTO [dbo].[Accumulation] ([id], [owner], [kind], [date], [type], [document],[company], [parent], [calculated], [data])
SELECT NEWID() [id], [owner], [kind], [date], N'Register.Accumulation.Inventory' [type], [document], [company], [parent], 1 calculated,
(SELECT CAST([exchangeRate] AS numeric(38, 18)) [exchangeRate], [Storehouse], [SKU], [batch], CAST([Cost] AS money) * IIF(kind = 1, 1, -1) [Cost], [Qty], [Department], [Expense], [ExpenseAnalytics], [Income], [IncomeAnalytics], [BalanceIn], [BalanceInAnalytics], [BalanceOut], [BalanceOutAnalytics], [OperationType] FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) [data] 
FROM (
	SELECT [owner], [kind], [company], [document], [date], [Storehouse], [SKU], [batch], [Cost], [Cost.In], [Cost.Out], [Qty], [Qty.In], [Qty.Out], [parent], [Department], [exchangeRate], [Expense], [ExpenseAnalytics], [Income], [IncomeAnalytics], [BalanceIn], [BalanceInAnalytics], [BalanceOut], [BalanceOutAnalytics], [OperationType]
	FROM #Inventory WHERE [calculated] = 1
	EXCEPT
	SELECT [owner], [kind], [company], [document], [date], [Storehouse], [SKU], [batch], [Cost], [Cost.In], [Cost.Out], [Qty], [Qty.In], [Qty.Out], [parent], [Department], [exchangeRate], [Expense], [ExpenseAnalytics], [Income], [IncomeAnalytics], [BalanceIn], [BalanceInAnalytics], [BalanceOut], [BalanceOutAnalytics], [OperationType]
	FROM [dbo].[Register.Accumulation.Inventory] WHERE [date] BETWEEN @BeginDate AND @EndDate AND [calculated] = 1 AND company = @company
) q;

PRINT CAST(GETDATE() AS VARCHAR(25)) + N' start delete Register.Accumulation.Sales';
DELETE FROM [dbo].[Register.Accumulation.Sales] WHERE [owner] IN (
SELECT [owner] FROM (
	SELECT [owner], [kind], [company], [document], [date], [parent], [exchangeRate], [currency], [Department], [Customer], [Product], [Manager], [AO], r.[Storehouse], [Cost]
	FROM [dbo].[Register.Accumulation.Sales] r 
	WHERE [date] BETWEEN @BeginDate AND @EndDate AND r.company = @company AND r.calculated = 1
	EXCEPT
	SELECT [id] [owner], [kind], [company], [document], [date], [parent], [exchangeRate], [currency], [Department], [Customer], [Product], [Manager], [AO], r.[Storehouse], CAST(c.Cost * [Qty.In] AS MONEY) [Cost]
	FROM [dbo].[Register.Accumulation.Sales] r LEFT JOIN #cost c ON c.SKU = r.Product AND c.Storehouse = r.Storehouse
	WHERE r.date BETWEEN @BeginDate AND @EndDate AND r.company = @company AND r.calculated = 0) q);

PRINT CAST(GETDATE() AS VARCHAR(25)) + N' start insert Register.Accumulation.Sales'
INSERT INTO [dbo].[Accumulation] ([id], [owner], [kind], [date], [type], [document],[company], [parent], [calculated], [data])
SELECT NEWID() [id], [owner], [kind], [date], N'Register.Accumulation.Sales' [type], [document], [company], null [parent], 1 calculated,
(SELECT CAST([exchangeRate] AS numeric(38, 18)) [exchangeRate], [Department], [currency], [Customer], [Product], [Manager], [AO], [Storehouse],
CAST([Cost] AS money) [Cost] FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) data FROM (
	SELECT [id] [owner], [kind], [company], [document], [date], [parent], [exchangeRate], [currency], [Department], [Customer], [Product], [Manager], [AO], r.[Storehouse], CAST(c.Cost * [Qty.In] AS MONEY) [Cost]
	FROM [dbo].[Register.Accumulation.Sales] r LEFT JOIN #cost c ON c.SKU = r.Product AND c.Storehouse = r.Storehouse
	WHERE r.date BETWEEN @BeginDate AND @EndDate AND r.company = @company AND r.calculated = 0
	EXCEPT
	SELECT [owner], [kind], [company], [document], [date], [parent], [exchangeRate], [currency], [Department], [Customer], [Product], [Manager], [AO], r.[Storehouse], [Cost]
	FROM [dbo].[Register.Accumulation.Sales] r 
	WHERE [date] BETWEEN @BeginDate AND @EndDate AND r.company = @company AND r.calculated = 1) q;

PRINT CAST(GETDATE() AS VARCHAR(25)) + N' start delete Register.Accumulation.Balance'
DELETE FROM [dbo].[Register.Accumulation.Balance] WHERE date BETWEEN @BeginDate AND @EndDate AND calculated = 1 AND company = @company;
PRINT CAST(GETDATE() AS VARCHAR(25)) + N' start insert Register.Accumulation.Balance'
INSERT INTO [dbo].[Accumulation] ([id], [kind], [date], [type], [document],[company], [parent], [calculated], [data])
SELECT NEWID() [id], [kind], [date], N'Register.Accumulation.Balance' [type], [document],  company, null [parent], 1 calculated,
(SELECT CAST([exchangeRate] AS numeric(38, 18)) [exchangeRate], [Balance], [Analytics], [Department],
CAST([Amount] AS MONEY) [Amount] FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) data FROM (
	SELECT 1 [kind], [document], [date], MAX([exchangeRate]) [exchangeRate], [company],
		[BalanceIn] [Balance], [BalanceInAnalytics] [Analytics], [Department], SUM([Cost] * IIF(kind = 1, 1, -1)) [Amount]
	FROM [dbo].[Register.Accumulation.Inventory] r
	WHERE r.date BETWEEN @BeginDate AND @EndDate AND r.company = @company AND [BalanceIn] IS NOT NULL
	GROUP BY [company], [date], [document], [Department], [BalanceIn], [BalanceInAnalytics]
	UNION ALL
	SELECT 0 [kind], [document], [date], MAX([exchangeRate]) [exchangeRate], [company],
		[BalanceOut] [Balance], [BalanceOutAnalytics] [Analytics], [Department], SUM([Cost] * IIF(kind = 1, 1, -1)) [Amount]
	FROM [dbo].[Register.Accumulation.Inventory] r
	WHERE r.date BETWEEN @BeginDate AND @EndDate AND r.company = @company AND [BalanceOut] IS NOT NULL
	GROUP BY [company], [date], [document], [Department], [BalanceOut], [BalanceOutAnalytics]) q;

	-------- HOLDING
PRINT CAST(GETDATE() AS VARCHAR(25)) + N' start delete Register.Accumulation.Balance HOLDING'
DELETE FROM [dbo].[Register.Accumulation.Balance] WHERE date BETWEEN @BeginDate AND @EndDate AND calculated = 1 AND company = @CompanyHolding
AND [Department] = @company;
PRINT CAST(GETDATE() AS VARCHAR(25)) + N' start insert Register.Accumulation.Balance HOLDING'
INSERT INTO [dbo].[Accumulation] ([id], [kind], [date], [type], [document], [company], [parent], [calculated], [data])
SELECT NEWID() [id], [kind], [date], N'Register.Accumulation.Balance' [type], [document], @CompanyHolding, null [parent], 1 calculated,
(SELECT CAST([exchangeRate] AS numeric(38, 18)) [exchangeRate], [Balance], [Analytics], [Department],
CAST([Amount] AS MONEY) [Amount] FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) data FROM (
	SELECT 1 [kind], [document], [date], MAX([exchangeRate]) [exchangeRate],  [company] [Department],
		[BalanceIn] [Balance], [BalanceInAnalytics] [Analytics], SUM(CAST([Cost] * IIF(kind = 1, 1, -1) / [exchangeRate] AS FLOAT)) [Amount]
	FROM [dbo].[Register.Accumulation.Inventory] r
	WHERE r.date BETWEEN @BeginDate AND @EndDate AND r.company = @company AND [BalanceIn] IS NOT NULL
	GROUP BY [company], [date], [document], [BalanceIn], [BalanceInAnalytics]
	UNION ALL
	SELECT 0 [kind], [document], [date], MAX([exchangeRate]) [exchangeRate], [company] [Department],
		[BalanceOut] [Balance], [BalanceOutAnalytics] [Analytics], SUM(CAST([Cost] * IIF(kind = 1, 1, -1) / [exchangeRate] AS FLOAT)) [Amount]
	FROM [dbo].[Register.Accumulation.Inventory] r
	WHERE r.date BETWEEN @BeginDate AND @EndDate AND r.company = @company AND [BalanceOut] IS NOT NULL
	GROUP BY [company], [date], [document], [BalanceOut], [BalanceOutAnalytics]) q;
---------------------

PRINT CAST(GETDATE() AS VARCHAR(25)) + N' start delete Register.Accumulation.PL'
DELETE FROM [dbo].[Register.Accumulation.PL] WHERE date BETWEEN @BeginDate AND @EndDate AND calculated = 1 AND company = @company;
PRINT CAST(GETDATE() AS VARCHAR(25)) + N' start insert Register.Accumulation.PL'
INSERT INTO [dbo].[Accumulation] ([id], [kind], [date], [type], [document],[company], [parent], [calculated], [data])
SELECT NEWID() [id], 1 [kind], [date], N'Register.Accumulation.PL' [type], [document],  [company], null [parent], 1 calculated,
(SELECT CAST([exchangeRate] AS numeric(38, 18)) [exchangeRate], [PL], [Analytics], [Department],
CAST([Amount] AS MONEY) [Amount] FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) data FROM (
	SELECT 1 [kind], [document], [date], MAX([exchangeRate]) [exchangeRate], [company],
		[Income] [PL], [IncomeAnalytics] [Analytics], [Department], -SUM([Cost]) [Amount]
	FROM [dbo].[Register.Accumulation.Inventory] r
	WHERE r.date BETWEEN @BeginDate AND @EndDate AND r.company = @company AND [Income] IS NOT NULL
	GROUP BY [kind], [company], [company], [date], [document], [Department], [Income], [IncomeAnalytics]
	UNION ALL
	SELECT 0 [kind], [document], [date], MAX([exchangeRate]) [exchangeRate], [company],
		[Expense] [PL], [ExpenseAnalytics] [Analytics], [Department], SUM([Cost]) [Amount]
	FROM [dbo].[Register.Accumulation.Inventory] r
	WHERE r.date BETWEEN @BeginDate AND @EndDate AND r.company = @company AND [Expense] IS NOT NULL
	GROUP BY [kind], [company], [date], [document], [Department], [Expense], [ExpenseAnalytics]) q;

	-------- HOLDING
PRINT CAST(GETDATE() AS VARCHAR(25)) + N' start delete Register.Accumulation.PL HOLDING'
DELETE FROM [dbo].[Register.Accumulation.PL] WHERE date BETWEEN @BeginDate AND @EndDate AND calculated = 1 AND company = @CompanyHolding
AND EXISTS (SELECT * FROM Documents WHERE id = [dbo].[Register.Accumulation.PL].document AND company = @company);
PRINT CAST(GETDATE() AS VARCHAR(25)) + N' start insert Register.Accumulation.PL HOLDING'
INSERT INTO [dbo].[Accumulation] ([id], [kind], [date], [type], [document],[company], [parent], [calculated], [data])
SELECT NEWID() [id], 1 [kind], [date], N'Register.Accumulation.PL' [type], [document],  @CompanyHolding, null [parent], 1 calculated,
(SELECT CAST([exchangeRate] AS numeric(38, 18)) [exchangeRate], [PL], [Analytics], [Department],
CAST([Amount] AS MONEY) [Amount] FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) data FROM (
	SELECT 1 [kind], [document], [date], MAX([exchangeRate]) [exchangeRate],
		[Income] [PL], [IncomeAnalytics] [Analytics], [Department], -SUM(CAST([Cost] / [exchangeRate] AS FLOAT)) [Amount]
	FROM [dbo].[Register.Accumulation.Inventory] r
	WHERE r.date BETWEEN @BeginDate AND @EndDate AND r.company = @company AND [Income] IS NOT NULL 
	GROUP BY [kind], [company], [date], [document], [Department], [Income], [IncomeAnalytics]
	UNION ALL
	SELECT 0 [kind], [document], [date], MAX([exchangeRate]) [exchangeRate],
		[Expense] [PL], [ExpenseAnalytics] [Analytics], [Department], SUM(CAST([Cost] / [exchangeRate] AS FLOAT)) [Amount]
	FROM [dbo].[Register.Accumulation.Inventory] r 
	WHERE r.date BETWEEN @BeginDate AND @EndDate AND r.company = @company AND [Expense] IS NOT NULL
	GROUP BY [kind], [company], [date], [document], [Department], [Expense], [ExpenseAnalytics]) q;
PRINT CAST(GETDATE() AS VARCHAR(25)) + N' start commit'

END TRY
BEGIN CATCH  
	IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION CL;
	THROW;
END CATCH;

IF @@TRANCOUNT > 0 COMMIT TRANSACTION CL;
PRINT CAST(GETDATE() AS VARCHAR(25)) + N' end commit'
END