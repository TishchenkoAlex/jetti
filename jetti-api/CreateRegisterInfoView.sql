
    CREATE OR ALTER VIEW [Register.Info.PriceList]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company, kind
        , CAST(ISNULL(JSON_VALUE(data, N'$."currency"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "currency"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Product"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Product"

        , CAST(ISNULL(JSON_VALUE(data, N'$."PriceType"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "PriceType"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Unit"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Unit"

        , CAST(ISNULL(JSON_VALUE(data, N'$.Price'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Price"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Price'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Price.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Price'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Price.Out" 

      FROM dbo.[Register.Info] WHERE type = N'Register.Info.PriceList';
    GO

    CREATE UNIQUE CLUSTERED INDEX [Register.Info.PriceList] ON [dbo].[Register.Info.PriceList](
      date,company,[currency],[Product],[PriceType],[Unit],[Price],document,kind,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Info.ExchangeRates]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company, kind
        , CAST(ISNULL(JSON_VALUE(data, N'$."currency"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "currency"

        , CAST(ISNULL(JSON_VALUE(data, N'$.Rate'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Rate"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Rate'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Rate.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Rate'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Rate.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.Mutiplicity'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Mutiplicity"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Mutiplicity'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Mutiplicity.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Mutiplicity'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Mutiplicity.Out" 

      FROM dbo.[Register.Info] WHERE type = N'Register.Info.ExchangeRates';
    GO

    CREATE UNIQUE CLUSTERED INDEX [Register.Info.ExchangeRates] ON [dbo].[Register.Info.ExchangeRates](
      date,company,[currency],[Rate],[Mutiplicity],document,kind,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Info.Settings]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company, kind
        , CAST(ISNULL(JSON_VALUE(data, N'$."balanceCurrency"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "balanceCurrency"

        , CAST(ISNULL(JSON_VALUE(data, N'$."accountingCurrency"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "accountingCurrency"

      FROM dbo.[Register.Info] WHERE type = N'Register.Info.Settings';
    GO

    CREATE UNIQUE CLUSTERED INDEX [Register.Info.Settings] ON [dbo].[Register.Info.Settings](
      date,company,[balanceCurrency],[accountingCurrency],document,kind,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Info.Depreciation]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company, kind
        , CAST(ISNULL(JSON_VALUE(data, N'$."OE"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "OE"

        , CAST(ISNULL(JSON_VALUE(data, N'$.StartDate'), '1970-01-01T00:00:00.000Z') AS VARCHAR(20)) "StartDate" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.Period'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Period"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Period'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Period.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Period'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Period.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.StartCost'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "StartCost"
        , CAST(ISNULL(JSON_VALUE(data, N'$.StartCost'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "StartCost.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.StartCost'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "StartCost.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.EndCost'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "EndCost"
        , CAST(ISNULL(JSON_VALUE(data, N'$.EndCost'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "EndCost.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.EndCost'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "EndCost.Out" 

        , CAST(ISNULL(JSON_VALUE(data, '$.Method'), '') AS NVARCHAR(400)) "Method" 

      FROM dbo.[Register.Info] WHERE type = N'Register.Info.Depreciation';
    GO

    CREATE UNIQUE CLUSTERED INDEX [Register.Info.Depreciation] ON [dbo].[Register.Info.Depreciation](
      date,company,[OE],[StartDate],[Period],[StartCost],[EndCost],[Method],document,kind,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Info.RLS]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company, kind
        , CAST(ISNULL(JSON_VALUE(data, '$.user'), '') AS NVARCHAR(400)) "user" 

      FROM dbo.[Register.Info] WHERE type = N'Register.Info.RLS';
    GO

    CREATE UNIQUE CLUSTERED INDEX [Register.Info.RLS] ON [dbo].[Register.Info.RLS](
      date,company,[user],document,kind,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Info.BudgetItemRule]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company, kind
        , CAST(ISNULL(JSON_VALUE(data, N'$."BudgetItem"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "BudgetItem"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Scenario"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Scenario"

        , CAST(ISNULL(JSON_VALUE(data, '$.Rule'), '') AS NVARCHAR(400)) "Rule" 

      FROM dbo.[Register.Info] WHERE type = N'Register.Info.BudgetItemRule';
    GO

    CREATE UNIQUE CLUSTERED INDEX [Register.Info.BudgetItemRule] ON [dbo].[Register.Info.BudgetItemRule](
      date,company,[BudgetItem],[Scenario],[Rule],document,kind,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Info.DepartmentCompanyHistory]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company, kind
        , CAST(ISNULL(JSON_VALUE(data, N'$."Department"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Department"

      FROM dbo.[Register.Info] WHERE type = N'Register.Info.DepartmentCompanyHistory';
    GO

    CREATE UNIQUE CLUSTERED INDEX [Register.Info.DepartmentCompanyHistory] ON [dbo].[Register.Info.DepartmentCompanyHistory](
      date,company,[Department],document,kind,id
    )
    GO
    