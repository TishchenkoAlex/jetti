
    CREATE OR ALTER VIEW [Register.Info.PriceList]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')), '00000000-0000-0000-0000-000000000000') "currency"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Product"')), '00000000-0000-0000-0000-000000000000') "Product"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."PriceType"')), '00000000-0000-0000-0000-000000000000') "PriceType"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Unit"')), '00000000-0000-0000-0000-000000000000') "Unit"
        , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Price')), 0) "Price"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.PriceList';
    GO
    GRANT SELECT,DELETE ON [Register.Info.PriceList] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.PriceList] ON [dbo].[Register.Info.PriceList](
      date,company,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Info.ExchangeRates]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')), '00000000-0000-0000-0000-000000000000') "currency"
        , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Rate')), 0) "Rate"
        , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Mutiplicity')), 0) "Mutiplicity"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.ExchangeRates';
    GO
    GRANT SELECT,DELETE ON [Register.Info.ExchangeRates] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.ExchangeRates] ON [dbo].[Register.Info.ExchangeRates](
      date,company,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Info.Settings]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."balanceCurrency"')), '00000000-0000-0000-0000-000000000000') "balanceCurrency"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."accountingCurrency"')), '00000000-0000-0000-0000-000000000000') "accountingCurrency"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.Settings';
    GO
    GRANT SELECT,DELETE ON [Register.Info.Settings] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.Settings] ON [dbo].[Register.Info.Settings](
      date,company,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Info.Depreciation]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."OE"')), '00000000-0000-0000-0000-000000000000') "OE"
        , ISNULL(TRY_CONVERT(DATE,JSON_VALUE(data, N'$.StartDate'),127), TRY_CONVERT(DATE, '1970-01-01', 102)) "StartDate"
        , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Period')), 0) "Period"
        , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.StartCost')), 0) "StartCost"
        , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.EndCost')), 0) "EndCost"
        , ISNULL(JSON_VALUE(data, '$.Method'), '') "Method"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.Depreciation';
    GO
    GRANT SELECT,DELETE ON [Register.Info.Depreciation] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.Depreciation] ON [dbo].[Register.Info.Depreciation](
      date,company,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Info.RLS]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , ISNULL(JSON_VALUE(data, '$.user'), '') "user"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.RLS';
    GO
    GRANT SELECT,DELETE ON [Register.Info.RLS] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.RLS] ON [dbo].[Register.Info.RLS](
      date,company,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Info.BudgetItemRule]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BudgetItem"')), '00000000-0000-0000-0000-000000000000') "BudgetItem"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Scenario"')), '00000000-0000-0000-0000-000000000000') "Scenario"
        , ISNULL(JSON_VALUE(data, '$.Rule'), '') "Rule"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.BudgetItemRule';
    GO
    GRANT SELECT,DELETE ON [Register.Info.BudgetItemRule] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.BudgetItemRule] ON [dbo].[Register.Info.BudgetItemRule](
      date,company,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Info.DepartmentCompanyHistory]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')), '00000000-0000-0000-0000-000000000000') "Department"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.DepartmentCompanyHistory';
    GO
    GRANT SELECT,DELETE ON [Register.Info.DepartmentCompanyHistory] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.DepartmentCompanyHistory] ON [dbo].[Register.Info.DepartmentCompanyHistory](
      date,company,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Info.CounterpartiePriceList]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , ISNULL(JSON_VALUE(data, '$.Scenario'), '') "Scenario"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Counterpartie"')), '00000000-0000-0000-0000-000000000000') "Counterpartie"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Product"')), '00000000-0000-0000-0000-000000000000') "Product"
        , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Price')), 0) "Price"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')), '00000000-0000-0000-0000-000000000000') "currency"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.CounterpartiePriceList';
    GO
    GRANT SELECT,DELETE ON [Register.Info.CounterpartiePriceList] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.CounterpartiePriceList] ON [dbo].[Register.Info.CounterpartiePriceList](
      date,company,id
    )
    GO
    