USE [sm]
GO
/****** Object:  StoredProcedure [dbo].[BalanceRC]    Script Date: 27.10.2020 20:24:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













ALTER PROCEDURE [dbo].[BalanceRC] @Doc char(36) 

AS

BEGIN
DECLARE @HoldingCompany VARCHAR(36) = '9f00dde0-f043-11e9-9115-b72821305a00' -- не учитываем проводки по Организации - "HOLDING (SUSHI MASTER)"
DECLARE @OfficeRC VARCHAR(36) = '08C4BF40-F808-11EA-9AEE-8B3476C66F63'; -- ЦФО - ХЭД - ОФИС
DECLARE @OfficeRCCurrency VARCHAR(36) = 'A4867005-66B8-4A8A-9105-3F25BB081936'; -- ЦФО - ХЭД - ОФИС - валюта
DECLARE @DefaultCompanyOfficeRC VARCHAR(36) = '1105CFD0-02D3-11EA-A524-E592E08C23A5'; -- RUSSIA - & X100 &
DECLARE @BalanceRCIntercompany VARCHAR(36) = '5B21BD40-F927-11EA-A1CE-EBBF912DFE2C' -- Интеркампани (ЦФО)
DECLARE @BalanceRCTransit VARCHAR(36) = 'F103BC70-1211-11EB-B418-D7B91F2BAA53' -- ТРАНЗИТ через ЗАЙМ МЕЖДУНАРОДНЫЙ (ЦФО)
DECLARE @BalanceRCTransitCash VARCHAR(36) = '2E65E330-1376-11EB-AC75-DD4220948F13' -- ТРАНЗИТ ДС (ЦФО)
DECLARE @BalanceIntercompany VARCHAR(36) = '2C8357B0-F76A-11E9-8D06-5D8515ECB76C' -- Интеркампани
DECLARE @LoanInternational VARCHAR(36) = '6BCD55B0-2F9D-11E8-9DD8-85E4FE93BABD' -- Кредиты/займы МЕЖДУНАРОДНЫЕ
DECLARE @ParamsRC TABLE ([Balance.id] VARCHAR(36), [DefaultTypeRC] NVARCHAR(20))
DECLARE @ParamsOperationRC TABLE ([Operation] VARCHAR(36), [DefaultAccumulation] NVARCHAR(50), [DefaultColumn] NVARCHAR(50))

-- Объявление переменных для мехнизма поиска Аналитики по настройка рекомпозиции Баланса ЦФО
DECLARE @RegisterName NVARCHAR(50) = '';
DECLARE @ColumnName NVARCHAR(50) = '';
DECLARE @SQLQuery NVARCHAR(max) = '';
DECLARE @AnalyticsRC NVARCHAR(36) = '';
DECLARE @tmp AS table ([RC.id] uniqueidentifier, [Com.id] uniqueidentifier);
DECLARE @ForRecalculationBalanceRC AS table (
											[id] uniqueidentifier NOT NULL,
											[parent] uniqueidentifier,
											[date] date,
											[document] uniqueidentifier,
											[company] uniqueidentifier,
											[kind] bit,
											[calculated] bit,
											[exchangeRate] numeric(15,10),
											[ResponsibilityCenter] uniqueidentifier,
											[Department] uniqueidentifier,
											[Balance] uniqueidentifier,
											[Analytics] uniqueidentifier,
											[Analytics2] uniqueidentifier,
											[Currency] uniqueidentifier,
											[Amount] money,
											[Amount.In] money,
											[Amount.Out] money,
											[koef] float,
											[AmountRC] money,
											[AmountRC.In] money,
											[AmountRC.Out] money,
											[Info] nvarchar(500),
											[Operation.id] uniqueidentifier
											);

DECLARE @ForRecalculationBalanceRCGroupBy AS table (
													[date] date,
													[company] uniqueidentifier,
													[document] uniqueidentifier,
													[ResponsibilityCenter] uniqueidentifier,
													[Currency] uniqueidentifier,
													[koef] float,
													[Operation.id] uniqueidentifier,
													[Amount] money,
													[Amount.In] money,
													[Amount.Out] money,
													[AmountRC] money,
													[AmountRC.In] money,
													[AmountRC.Out] money,
													[DefaultAccumulation] nvarchar(100),
													[DefaultColumn] nvarchar(100)
													);

INSERT INTO @ParamsRC
SELECT [Balance.id], [DefaultTypeRC]
FROM
    OPENJSON((SELECT JSON_QUERY([doc], '$.ItemsParameters') FROM [dbo].[Documents] WHERE [id] = '4A6E27E0-FB75-11EA-96B0-F95B42943214'), '$')
    WITH ([Balance.id] VARCHAR(36) '$.Balance', [DefaultTypeRC] NVARCHAR(20) '$.DefaultTypeRC')

INSERT INTO @ParamsOperationRC
SELECT [Operation], [DefaultAccumulation], [DefaultColumn]
FROM
    OPENJSON((SELECT JSON_QUERY([doc], '$.ItemsParametersOperation') FROM [dbo].[Documents] WHERE [id] = '4A6E27E0-FB75-11EA-96B0-F95B42943214'), '$')
    WITH ([Operation] VARCHAR(36) '$.Operation', [DefaultAccumulation] NVARCHAR(50) '$.DefaultAccumulation', [DefaultColumn] NVARCHAR(50) '$.DefaultColumn')

INSERT INTO @ForRecalculationBalanceRC
SELECT bal.[id], bal.[parent], bal.[date], bal.[document], bal.[company], bal.[kind], bal.[calculated], bal.[exchangeRate], bal.[ResponsibilityCenter], bal.[Department], bal.[Balance], bal.[Analytics], bal.[Analytics2], bal.[Currency], 
	bal.[Amount],
	bal.[Amount.In],
    bal.[Amount.Out],
	bal.[koef],
	cast(bal.[Amount] / bal.[koef] as money) as [AmountRC],
    cast(bal.[Amount.In] / bal.[koef] as money) as [AmountRC.In],
    cast(bal.[Amount.Out] / bal.[koef] as money) as [AmountRC.Out],
    bal.[Info],
	bal.[Operation.id]
FROM (	SELECT  reg.[id] as [id],
			reg.[parent] as [parent],
			reg.[date] as [date],
			reg.[document] as [document],
			reg.[company] as [company],
			reg.[kind] as [kind],
			reg.[calculated] as [calculated],
			reg.[exchangeRate] as [exchangeRate],
			IIF(ParRC.[DefaultTypeRC] = 'Catalog.Company', Cat_RC_Com.[id], Cat_RC_Dep.[id]) as [ResponsibilityCenter],
			reg.[Department] as [Department],
			reg.[Balance] as [Balance],
			reg.[Analytics] as [Analytics],
			NULL as [Analytics2],
			Cat_Com.[currency.id] as [Currency],
			reg.[Amount] as [Amount],
			reg.[Amount.In] as [Amount.In],
			reg.[Amount.Out] as [Amount.Out],
			([dbo].[ExchangeRate](Doc_Oper.[date], @HoldingCompany, Cat_Com.[currency.id]) /
			[dbo].[ExchangeRate](Doc_Oper.[date], @HoldingCompany, IIF(ParRC.[DefaultTypeRC] = 'Catalog.Company', Cat_RC_Com.[Currency.id], Cat_RC_Dep.[Currency.id]))) as [koef],
			reg.[Info] as [Info],
			Doc_Oper.[Operation.id] as [Operation.id]
		FROM [dbo].[Register.Accumulation.Balance] AS reg
			LEFT JOIN [Catalog.Company] AS Cat_Com ON Cat_Com.id = reg.[company]
			LEFT JOIN [Catalog.Department] AS Cat_Dep ON Cat_Dep.id = reg.[Analytics]
			LEFT JOIN [Catalog.ResponsibilityCenter] AS Cat_RC_Com ON Cat_RC_Com.id = Cat_Com.[ResponsibilityCenter.id]
			LEFT JOIN [Catalog.ResponsibilityCenter] AS Cat_RC_Dep ON Cat_RC_Dep.id = Cat_Dep.[ResponsibilityCenter.id]
			LEFT JOIN @ParamsRC AS ParRC ON ParRC.[Balance.id] = reg.[Balance]
			LEFT JOIN [Document.Operation] AS Doc_Oper ON Doc_Oper.[id] = reg.[document]
		WHERE 1 = 1
			AND reg.[document] = @Doc
			AND reg.[company] <> @HoldingCompany -- не учитываем проводки по Организации - "HOLDING (SUSHI MASTER)"
			AND NOT ParRC.[DefaultTypeRC] in ('NOT USED', 'VIA OfficeRC', 'VIA TransitRC')
) AS Bal

INSERT INTO @ForRecalculationBalanceRC
SELECT Bal_via.[id], Bal_via.[parent], Bal_via.[date], Bal_via.[document], Bal_via.[company], Bal_via.[kind], Bal_via.[calculated], Bal_via.[exchangeRate], Bal_via.[ResponsibilityCenter], Bal_via.[Department], Bal_via.[Balance], Bal_via.[Analytics], Bal_via.[Analytics2], Bal_via.[Currency], 
	Bal_via.[Amount],
	Bal_via.[Amount.In],
    Bal_via.[Amount.Out],
	Bal_via.[koef],
	cast(Bal_via.[Amount] / Bal_via.[koef] as money) as [AmountRC],
    cast(Bal_via.[Amount.In] / Bal_via.[koef] as money) as [AmountRC.In],
    cast(Bal_via.[Amount.Out] / Bal_via.[koef] as money) as [AmountRC.Out],
    Bal_via.[Info],
	Bal_via.[Operation.id]
FROM (	SELECT  reg.[id] as [id],
			reg.[parent] as [parent],
			reg.[date] as [date],
			reg.[document] as [document],
			reg.[company] as [company],
			reg.[kind] as [kind],
			reg.[calculated] as [calculated],
			reg.[exchangeRate] as [exchangeRate],
			@OfficeRC as [ResponsibilityCenter],
			reg.[Department] as [Department],
			reg.[Balance] as [Balance],
			reg.[Analytics] as [Analytics],
			null as [Analytics2],
			Cat_Com.[currency.id] as [Currency],
			reg.[Amount] as [Amount],
			reg.[Amount.In] as [Amount.In],
			reg.[Amount.Out] as [Amount.Out],
			([dbo].[ExchangeRate](Doc_Oper.[date], @HoldingCompany, Cat_Com.[currency.id]) /
			[dbo].[ExchangeRate](Doc_Oper.[date], @HoldingCompany, IIF(ParRC.[DefaultTypeRC] = 'Catalog.Company', Cat_RC_Com.[Currency.id], Cat_RC_Dep.[Currency.id]))) as [koef],
			reg.[Info] as [Info],
			Doc_Oper.[Operation.id] as [Operation.id]
		FROM [dbo].[Register.Accumulation.Balance] AS reg
			LEFT JOIN [Catalog.Company] AS Cat_Com ON Cat_Com.id = reg.[company]
			LEFT JOIN [Catalog.Department] AS Cat_Dep ON Cat_Dep.id = reg.[Analytics]
			LEFT JOIN [Catalog.ResponsibilityCenter] AS Cat_RC_Com ON Cat_RC_Com.id = Cat_Com.[ResponsibilityCenter.id]
			LEFT JOIN [Catalog.ResponsibilityCenter] AS Cat_RC_Dep ON Cat_RC_Dep.id = Cat_Dep.[ResponsibilityCenter.id]
			LEFT JOIN @ParamsRC AS ParRC ON ParRC.[Balance.id] = reg.[Balance]
			LEFT JOIN [Document.Operation] AS Doc_Oper ON Doc_Oper.[id] = reg.[document]
		WHERE 1 = 1
			AND reg.[document] = @Doc
			AND reg.[company] <> @HoldingCompany -- не учитываем проводки по Организации - "HOLDING (SUSHI MASTER)"
			AND ParRC.[DefaultTypeRC] = 'VIA OfficeRC'
) AS Bal_via

INSERT INTO @ForRecalculationBalanceRC
SELECT Bal_viaTr.[id], Bal_viaTr.[parent], Bal_viaTr.[date], Bal_viaTr.[document], Bal_viaTr.[company], Bal_viaTr.[kind], Bal_viaTr.[calculated], Bal_viaTr.[exchangeRate], Bal_viaTr.[ResponsibilityCenter], Bal_viaTr.[Department], Bal_viaTr.[Balance], Bal_viaTr.[Analytics], Bal_viaTr.[Analytics2], Bal_viaTr.[Currency], 
	Bal_viaTr.[Amount],
	Bal_viaTr.[Amount.In],
    Bal_viaTr.[Amount.Out],
	Bal_viaTr.[koef],
	cast(Bal_viaTr.[Amount] / Bal_viaTr.[koef] as money) as [AmountRC],
    cast(Bal_viaTr.[Amount.In] / Bal_viaTr.[koef] as money) as [AmountRC.In],
    cast(Bal_viaTr.[Amount.Out] / Bal_viaTr.[koef] as money) as [AmountRC.Out],
    Bal_viaTr.[Info],
	Bal_viaTr.[Operation.id]
FROM (	SELECT  reg.[id] as [id],
			reg.[parent] as [parent],
			reg.[date] as [date],
			reg.[document] as [document],
			reg.[company] as [company],
			reg.[kind] as [kind],
			reg.[calculated] as [calculated],
			reg.[exchangeRate] as [exchangeRate],
			@OfficeRC as [ResponsibilityCenter],
			reg.[Department] as [Department],
			@BalanceRCTransit as [Balance],
			ISNULL(IIF(reg.[kind] = 0, Cat_RC_Com.id, Cat_RC_Dep.id), @HoldingCompany) as [Analytics],
			ISNULL(IIF(reg.[kind] = 1, Cat_RC_Com.id, Cat_RC_Dep.id), @HoldingCompany) as [Analytics2],
			Cat_Com.[currency.id] as [Currency],
			reg.[Amount] as [Amount],
			reg.[Amount.In] as [Amount.In],
			reg.[Amount.Out] as [Amount.Out],
			([dbo].[ExchangeRate](Doc_Oper.[date], @HoldingCompany, Cat_Com.[currency.id]) /
			[dbo].[ExchangeRate](Doc_Oper.[date], @HoldingCompany, IIF(ParRC.[DefaultTypeRC] = 'Catalog.Company', Cat_RC_Com.[Currency.id], Cat_RC_Dep.[Currency.id]))) as [koef],
			reg.[Info] as [Info],
			Doc_Oper.[Operation.id] as [Operation.id]
		FROM [dbo].[Register.Accumulation.Balance] AS reg
			LEFT JOIN [Catalog.Company] AS Cat_Com ON Cat_Com.id = reg.[company]
			LEFT JOIN [Catalog.Company] AS Cat_Dep ON Cat_Dep.id = reg.[Analytics] -- Для данной проводки по ТРАНЗИТУ Из аналитики ТОЖЕ извлекаем компанию в поле аналитика должна быть ссылка на Catalog.Company
			LEFT JOIN [Catalog.ResponsibilityCenter] AS Cat_RC_Com ON Cat_RC_Com.id = Cat_Com.[ResponsibilityCenter.id]
			LEFT JOIN [Catalog.ResponsibilityCenter] AS Cat_RC_Dep ON Cat_RC_Dep.id = Cat_Dep.[ResponsibilityCenter.id]
			LEFT JOIN @ParamsRC AS ParRC ON ParRC.[Balance.id] = reg.[Balance]
			LEFT JOIN [Document.Operation] AS Doc_Oper ON Doc_Oper.[id] = reg.[document]
		WHERE 1 = 1
			AND reg.[document] = @Doc
			AND reg.[company] <> @HoldingCompany -- не учитываем проводки по Организации - "HOLDING (SUSHI MASTER)"
			AND ParRC.[DefaultTypeRC] = 'VIA TransitRC'
) AS Bal_viaTr

INSERT INTO @ForRecalculationBalanceRCGroupBy
SELECT Res.[date], Res.company, Res.[document], Res.[ResponsibilityCenter], Res.[Currency], Res.[koef], Res.[Operation.id],
	SUM(Res.[Amount]) as [Amount],
	SUM(Res.[Amount.In]) as [Amount.In],
	SUM(Res.[Amount.Out]) as [Amount.Out],
	SUM(Res.[AmountRC]) as [AmountRC],
	SUM(Res.[AmountRC.In]) as [AmountRC.In],
	SUM(Res.[AmountRC.Out]) as [AmountRC.Out],
	COALESCE(ParOperRC.[DefaultAccumulation], 'NOT PARAMETERS') as [DefaultAccumulation],
	COALESCE(ParOperRC.[DefaultColumn], 'NOT PARAMETERS') as [DefaultColumn]
from @ForRecalculationBalanceRC as Res
LEFT JOIN @ParamsOperationRC AS ParOperRC ON ParOperRC.[Operation] = Res.[Operation.id]
GROUP BY Res.[date], Res.company, Res.[document], Res.[ResponsibilityCenter], Res.[Currency], Res.[koef], Res.[Operation.id], ParOperRC.[DefaultAccumulation], ParOperRC.[DefaultColumn]
HAVING SUM(Res.[Amount]) <> 0

IF ((SELECT DISTINCT COUNT(*) FROM @ForRecalculationBalanceRCGroupBy AS t WHERE t.[DefaultAccumulation] = 'NOT PARAMETERS') > 0)
	INSERT INTO @ForRecalculationBalanceRC
	SELECT NEWID() AS [id],  
		   NULL AS [parent],
		   tmp.[date],
		   tmp.[document],
		   tmp.[company],
		   CAST(iif(tmp.[Amount.In] <> 0, 0, 1) as bit) as [kind],
		   cast(0 as bit) AS [calculated],
		   0 AS [exchangeRate],
		   tmp.[ResponsibilityCenter] as [ResponsibilityCenter],
		   null as [Department],
		   @BalanceRCIntercompany as [Balance],
		   @OfficeRC as [Analytics],
		   null as [Analytics2],
		   tmp.[Currency] AS [Currency],
		   -(tmp.[Amount]) as [Amount],
		   tmp.[Amount.Out] as [Amount.In],
		   tmp.[Amount.In] as [Amount.Out],
		   0 AS [koef],
		   -tmp.[AmountRC] as [AmountRC],
		   tmp.[AmountRC.Out] as [AmountRC.In],
		   tmp.[AmountRC.In] as [AmountRC.Out],
		   null as [Info],
		   tmp.[Operation.id] as [Operation.id]
	FROM @ForRecalculationBalanceRCGroupBy as tmp
	WHERE 1=1 
		AND tmp.ResponsibilityCenter <> @OfficeRC
		AND tmp.[document] = @Doc
		AND tmp.[DefaultAccumulation] = 'NOT PARAMETERS'

	UNION ALL

	SELECT NEWID() AS [id],  
			NULL AS [parent],
			tmp.[date],
			tmp.[document],
			COALESCE((SELECT TOP 1 Com.[company] FROM @ForRecalculationBalanceRCGroupBy AS Com WHERE Com.[ResponsibilityCenter] = @OfficeRC), @DefaultCompanyOfficeRC) AS [company],
			CAST(iif(tmp.[Amount.In] <> 0, 1, 0) as bit) as [kind],
			cast(0 as bit) AS [calculated],
			0 AS [exchangeRate],
			@OfficeRC as [ResponsibilityCenter],
			null as [Department],
			@BalanceRCIntercompany as [Balance],
			tmp.[ResponsibilityCenter] as [Analytics],
			null as [Analytics2],
			tmp.[Currency] AS [Currency],
			tmp.[Amount] as [Amount],
			tmp.[Amount.In] as [Amount.In],
			tmp.[Amount.Out] as [Amount.Out],
			([dbo].[ExchangeRate](Doc_Oper.[date], @HoldingCompany, tmp.[currency]) / [dbo].[ExchangeRate](Doc_Oper.[date], @HoldingCompany, @OfficeRCCurrency)) AS [koef],
			tmp.[Amount] / ([dbo].[ExchangeRate](Doc_Oper.[date], @HoldingCompany, tmp.[currency]) / [dbo].[ExchangeRate](Doc_Oper.[date], @HoldingCompany, @OfficeRCCurrency)) as [AmountRC],
			tmp.[Amount.In] / ([dbo].[ExchangeRate](Doc_Oper.[date], @HoldingCompany, tmp.[currency]) / [dbo].[ExchangeRate](Doc_Oper.[date], @HoldingCompany, @OfficeRCCurrency)) as [AmountRC.In],
			tmp.[Amount.Out] / ([dbo].[ExchangeRate](Doc_Oper.[date], @HoldingCompany, tmp.[currency]) / [dbo].[ExchangeRate](Doc_Oper.[date], @HoldingCompany, @OfficeRCCurrency)) as [AmountRC.Out],
			null as [Info],
		    tmp.[Operation.id] as [Operation.id]
	FROM @ForRecalculationBalanceRCGroupBy as tmp
	LEFT JOIN [Document.Operation] AS Doc_Oper ON Doc_Oper.[id] = tmp.[document] 
	WHERE 1=1 
		AND tmp.ResponsibilityCenter <> @OfficeRC
		AND tmp.[document] = @Doc
		AND tmp.[DefaultAccumulation] = 'NOT PARAMETERS'

IF ((SELECT DISTINCT COUNT(*) FROM @ForRecalculationBalanceRCGroupBy AS t WHERE t.[DefaultAccumulation] = 'Cash.Transit') > 0)

	--Универсальный Механизм получения аналитик для операцйи в которых Аналитика получается из регистров из настройки составления Баланса по ЦФО
	SET @RegisterName = 'Cash.Transit';
	SET @ColumnName = (SELECT TOP 1 [DefaultColumn] FROM @ForRecalculationBalanceRCGroupBy WHERE [document] = @Doc and [DefaultAccumulation] = 'Cash.Transit');
	
	SET @SQLQuery = 'SELECT Cat_Com.[ResponsibilityCenter.id] as [RC.id], Cat_Com.[id] as [Com.id]
				FROM [dbo].[Register.Accumulation.' + @RegisterName + '] as tmp1 
			LEFT JOIN [dbo].[Catalog.Company] AS Cat_Com ON Cat_Com.[id] = tmp1.[' +@ColumnName+ ']
			WHERE tmp1.[document] = '''+ @Doc +''''
	INSERT INTO @tmp
	EXECUTE (@SQLQuery);
	-- Конец механизма

	INSERT INTO @ForRecalculationBalanceRC
	SELECT NEWID() AS [id],  
		   NULL AS [parent],
		   tmp.[date],
		   tmp.[document],
		   tmp.[company],
		   CAST(iif(tmp.[Amount.In] <> 0, 0, 1) as bit) as [kind],
		   cast(0 as bit) AS [calculated],
		   0 AS [exchangeRate],
		   tmp.[ResponsibilityCenter] as [ResponsibilityCenter],
		   null as [Department],
		   @BalanceRCIntercompany as [Balance],
		   @OfficeRC as [Analytics],
		   --(SELECT TOP 1 [RC.id] FROM @tmp) as [Analytics],
		   null as [Analytics2],
		   tmp.[Currency] AS [Currency],
		   -(tmp.[Amount]) as [Amount],
		   tmp.[Amount.Out] as [Amount.In],
		   tmp.[Amount.In] as [Amount.Out],
		   0 AS [koef],
		   -tmp.[AmountRC] as [AmountRC],
		   tmp.[AmountRC.Out] as [AmountRC.In],
		   tmp.[AmountRC.In] as [AmountRC.Out],
		   null as [Info],
		   tmp.[Operation.id] as [Operation.id]
	FROM @ForRecalculationBalanceRCGroupBy as tmp
	WHERE 1=1 
		AND tmp.[document] = @Doc
		AND tmp.[DefaultAccumulation] = 'Cash.Transit'

	UNION ALL

	SELECT NEWID() AS [id],  
		   NULL AS [parent],
		   tmp.[date],
		   tmp.[document],
		   tmp.[company],
		   CAST(iif(tmp.[Amount.In] <> 0, 1, 0) as bit) as [kind],
		   cast(0 as bit) AS [calculated],
		   0 AS [exchangeRate],
		   @OfficeRC as [ResponsibilityCenter],
		   null as [Department],
		   @BalanceRCIntercompany as [Balance],
		   tmp.[ResponsibilityCenter] as [Analytics],
		   null as [Analytics2],
		   tmp.[Currency] AS [Currency],
		   tmp.[Amount] as [Amount],
		   tmp.[Amount.In] as [Amount.In],
		   tmp.[Amount.Out] as [Amount.Out],
		   0 AS [koef],
		   tmp.[AmountRC] as [AmountRC],
		   tmp.[AmountRC.In] as [AmountRC.In],
		   tmp.[AmountRC.Out] as [AmountRC.Out],
		   null as [Info],
		   tmp.[Operation.id] as [Operation.id]
	FROM @ForRecalculationBalanceRCGroupBy as tmp
	WHERE 1=1 
		AND tmp.[document] = @Doc
		AND tmp.[DefaultAccumulation] = 'Cash.Transit'
	
	UNION ALL

	SELECT NEWID() AS [id],  
		NULL AS [parent],
		tmp.[date],
		tmp.[document],
		tmp.[company],
		CAST(iif(tmp.[Amount.In] <> 0, 0, 1) as bit) as [kind],
		cast(0 as bit) AS [calculated],
		0 AS [exchangeRate],
		@OfficeRC as [ResponsibilityCenter],
		null as [Department],
		@BalanceRCTransitCash as [Balance],
		iif(tmp.[Amount.In] <> 0, tmp.[ResponsibilityCenter], (SELECT TOP 1 [RC.id] FROM @tmp))  as [Analytics],
		null as [Analytics2],
		tmp.[Currency] AS [Currency],
		-(tmp.[Amount]) as [Amount],
		tmp.[Amount.Out] as [Amount.In],
		tmp.[Amount.In] as [Amount.Out],
		0 AS [koef],
		-tmp.[AmountRC] as [AmountRC],
		tmp.[AmountRC.Out] as [AmountRC.In],
		tmp.[AmountRC.In] as [AmountRC.Out],
		null as [Info],
		tmp.[Operation.id] as [Operation.id]
	FROM @ForRecalculationBalanceRCGroupBy as tmp
	WHERE 1=1 
		AND tmp.[document] = @Doc
		AND tmp.[DefaultAccumulation] = 'Cash.Transit'

IF ((SELECT DISTINCT COUNT(*) FROM @ForRecalculationBalanceRCGroupBy AS t WHERE t.[DefaultAccumulation] = 'Intercompany') > 0)

	--Универсальный Механизм получения аналитик для операцйи в которых Аналитика получается из регистров из настройки составления Баланса по ЦФО
	SET @RegisterName = 'Intercompany';
	SET @ColumnName = (SELECT TOP 1 [DefaultColumn] FROM @ForRecalculationBalanceRCGroupBy WHERE [document] = @Doc and [DefaultAccumulation] = 'Intercompany');
	
	SET @SQLQuery = 'SELECT DISTINCT Cat_Com.[ResponsibilityCenter.id] as [RC.id], Cat_Com.[id] as [Com.id]
				FROM [dbo].[Register.Accumulation.' + @RegisterName + '] as tmp1 
			LEFT JOIN [dbo].[Catalog.Company] AS Cat_Com ON Cat_Com.[id] = tmp1.[' +@ColumnName+ ']
			WHERE tmp1.[document] = '''+ @Doc +''''
	INSERT INTO @tmp
	EXECUTE (@SQLQuery);
	-- Конец механизма

	INSERT INTO @ForRecalculationBalanceRC
	SELECT NEWID() AS [id],  
		   NULL AS [parent],
		   tmp.[date],
		   tmp.[document],
		   tmp.[company],
		   CAST(iif(tmp.[Amount.In] <> 0, 0, 1) as bit) as [kind],
		   cast(0 as bit) AS [calculated],
		   0 AS [exchangeRate],
		   tmp.[ResponsibilityCenter] as [ResponsibilityCenter],
		   null as [Department],
		   @BalanceRCIntercompany as [Balance],
		   @OfficeRC as [Analytics],
		   --(SELECT TOP 1 [RC.id] FROM @tmp WHERE [Com.id] <> tmp.[company]) as [Analytics],
		   null as [Analytics2],
		   tmp.[Currency] AS [Currency],
		   -(tmp.[Amount]) as [Amount],
		   tmp.[Amount.Out] as [Amount.In],
		   tmp.[Amount.In] as [Amount.Out],
		   0 AS [koef],
		   -tmp.[AmountRC] as [AmountRC],
		   tmp.[AmountRC.Out] as [AmountRC.In],
		   tmp.[AmountRC.In] as [AmountRC.Out],
		   null as [Info],
		   tmp.[Operation.id] as [Operation.id]
	FROM @ForRecalculationBalanceRCGroupBy as tmp
	WHERE 1=1 
		AND tmp.[document] = @Doc
		AND tmp.[DefaultAccumulation] = 'Intercompany'

	UNION ALL

		SELECT NEWID() AS [id],  
		   NULL AS [parent],
		   tmp.[date],
		   tmp.[document],
		   tmp.[company],
		   CAST(iif(tmp.[Amount.In] <> 0, 1, 0) as bit) as [kind],
		   cast(0 as bit) AS [calculated],
		   0 AS [exchangeRate],
		   @OfficeRC as [ResponsibilityCenter],
		   null as [Department],
		   @BalanceRCIntercompany as [Balance],
		   tmp.[ResponsibilityCenter] as [Analytics],
		   null as [Analytics2],
		   tmp.[Currency] AS [Currency],
		   tmp.[Amount] as [Amount],
		   tmp.[Amount.In] as [Amount.In],
		   tmp.[Amount.Out] as [Amount.Out],
		   0 AS [koef],
		   tmp.[AmountRC] as [AmountRC],
		   tmp.[AmountRC.In] as [AmountRC.In],
		   tmp.[AmountRC.Out] as [AmountRC.Out],
		   null as [Info],
		   tmp.[Operation.id] as [Operation.id]
	FROM @ForRecalculationBalanceRCGroupBy as tmp
	WHERE 1=1 
		AND tmp.[document] = @Doc
		AND tmp.[DefaultAccumulation] = 'Intercompany'

	UNION ALL

	SELECT NEWID() AS [id],  
		NULL AS [parent],
		tmp.[date],
		tmp.[document],
		tmp.[company],
		CAST(iif(tmp.[Amount.In] <> 0, 0, 1) as bit) as [kind],
		cast(0 as bit) AS [calculated],
		0 AS [exchangeRate],
		@OfficeRC as [ResponsibilityCenter],
		null as [Department],
		@BalanceRCTransitCash as [Balance],
		iif(tmp.[Amount.In] <> 0, tmp.[ResponsibilityCenter], (SELECT TOP 1 [RC.id] FROM @tmp WHERE [Com.id] <> tmp.[company]))  as [Analytics],
		null as [Analytics2],
		tmp.[Currency] AS [Currency],
		-(tmp.[Amount]) as [Amount],
		tmp.[Amount.Out] as [Amount.In],
		tmp.[Amount.In] as [Amount.Out],
		0 AS [koef],
		-tmp.[AmountRC] as [AmountRC],
		tmp.[AmountRC.Out] as [AmountRC.In],
		tmp.[AmountRC.In] as [AmountRC.Out],
		null as [Info],
		tmp.[Operation.id] as [Operation.id]
	FROM @ForRecalculationBalanceRCGroupBy as tmp
	WHERE 1=1 
		AND tmp.[document] = @Doc
		AND tmp.[DefaultAccumulation] = 'Intercompany'

	INSERT INTO [x100-DATA].[dbo].[_tempBalanceRC]
	SELECT [id],
		[parent],
		[date],
		[document],
		[company],
		[kind],
		[calculated],
		[exchangeRate],
		[ResponsibilityCenter],
		[Department],
		[Balance],
		[Analytics],
		[Analytics2],
		[Currency],
		[Amount],
		[Amount.In],
		[Amount.Out],
		[AmountRC],
		[AmountRC.In],
		[AmountRC.Out],
		[Info]
	FROM @ForRecalculationBalanceRC;

END
