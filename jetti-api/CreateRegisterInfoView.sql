<<<<<<< HEAD
=======

    CREATE OR ALTER VIEW [Register.Info.PriceList]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , ISNULL(CAST(JSON_VALUE(data, N'$."currency"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "currency"
        , ISNULL(CAST(JSON_VALUE(data, N'$."Product"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Product"
        , ISNULL(CAST(JSON_VALUE(data, N'$."PriceType"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "PriceType"
        , ISNULL(CAST(JSON_VALUE(data, N'$."Unit"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Unit"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Price') AS MONEY), 0) "Price"
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
        , ISNULL(CAST(JSON_VALUE(data, N'$."currency"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "currency"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Rate') AS MONEY), 0) "Rate"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Mutiplicity') AS MONEY), 0) "Mutiplicity"
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
        , ISNULL(CAST(JSON_VALUE(data, N'$."balanceCurrency"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "balanceCurrency"
        , ISNULL(CAST(JSON_VALUE(data, N'$."accountingCurrency"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "accountingCurrency"
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
        , ISNULL(CAST(JSON_VALUE(data, N'$."OE"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "OE"
        , ISNULL(CONVERT(DATE,JSON_VALUE(data, N'$.StartDate'),127), CONVERT(DATE, '1970-01-01', 102)) "StartDate"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Period') AS MONEY), 0) "Period"
        , ISNULL(CAST(JSON_VALUE(data, N'$.StartCost') AS MONEY), 0) "StartCost"
        , ISNULL(CAST(JSON_VALUE(data, N'$.EndCost') AS MONEY), 0) "EndCost"
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
        , ISNULL(CAST(JSON_VALUE(data, N'$."BudgetItem"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "BudgetItem"
        , ISNULL(CAST(JSON_VALUE(data, N'$."Scenario"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Scenario"
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
        , ISNULL(CAST(JSON_VALUE(data, N'$."Department"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Department"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.DepartmentCompanyHistory';
    GO
    GRANT SELECT,DELETE ON [Register.Info.DepartmentCompanyHistory] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.DepartmentCompanyHistory] ON [dbo].[Register.Info.DepartmentCompanyHistory](
      date,company,id
    )
    GO
    
>>>>>>> d5c56fa94a25cc550f48ecaf82b6905bb311d19f
