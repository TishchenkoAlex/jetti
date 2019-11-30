
      ALTER TRIGGER "Register.Info.Insert" ON dbo."Register.Info"
      FOR INSERT AS
      BEGIN
        
      INSERT INTO "Register.Info.PriceList" (date, document, company , "currency", "Product", "PriceType", "Unit", "Price")
      SELECT
        CAST(date AS datetime) date, document, company 
        , CAST(ISNULL(JSON_VALUE(data, N'$."currency"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "currency"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Product"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Product"

        , CAST(ISNULL(JSON_VALUE(data, N'$."PriceType"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "PriceType"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Unit"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Unit"

, CAST(JSON_VALUE(data, N'$.Price') AS MONEY) "Price"
      FROM INSERTED WHERE type = N'Register.Info.PriceList'; 


      INSERT INTO "Register.Info.ExchangeRates" (date, document, company , "currency", "Rate", "Mutiplicity")
      SELECT
        CAST(date AS datetime) date, document, company 
        , CAST(ISNULL(JSON_VALUE(data, N'$."currency"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "currency"

, CAST(JSON_VALUE(data, N'$.Rate') AS MONEY) "Rate"
, CAST(JSON_VALUE(data, N'$.Mutiplicity') AS MONEY) "Mutiplicity"
      FROM INSERTED WHERE type = N'Register.Info.ExchangeRates'; 


      INSERT INTO "Register.Info.Settings" (date, document, company , "balanceCurrency", "accountingCurrency")
      SELECT
        CAST(date AS datetime) date, document, company 
        , CAST(ISNULL(JSON_VALUE(data, N'$."balanceCurrency"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "balanceCurrency"

        , CAST(ISNULL(JSON_VALUE(data, N'$."accountingCurrency"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "accountingCurrency"

      FROM INSERTED WHERE type = N'Register.Info.Settings'; 


      INSERT INTO "Register.Info.Depreciation" (date, document, company , "OE", "StartDate", "Period", "StartCost", "EndCost", "Method")
      SELECT
        CAST(date AS datetime) date, document, company 
        , CAST(ISNULL(JSON_VALUE(data, N'$."OE"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "OE"
, ISNULL(JSON_VALUE(data, N'$.StartDate'), '1970-01-01T00:00:00.000Z') "StartDate" 

, CAST(JSON_VALUE(data, N'$.Period') AS MONEY) "Period"
, CAST(JSON_VALUE(data, N'$.StartCost') AS MONEY) "StartCost"
, CAST(JSON_VALUE(data, N'$.EndCost') AS MONEY) "EndCost", ISNULL(JSON_VALUE(data, '$.Method'), '') "Method" 

      FROM INSERTED WHERE type = N'Register.Info.Depreciation'; 


      INSERT INTO "Register.Info.RLS" (date, document, company , "user")
      SELECT
        CAST(date AS datetime) date, document, company , ISNULL(JSON_VALUE(data, '$.user'), '') "user" 

      FROM INSERTED WHERE type = N'Register.Info.RLS'; 


      INSERT INTO "Register.Info.BudgetItemRule" (date, document, company , "BudgetItem", "Scenario", "Rule")
      SELECT
        CAST(date AS datetime) date, document, company 
        , CAST(ISNULL(JSON_VALUE(data, N'$."BudgetItem"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "BudgetItem"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Scenario"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Scenario"
, ISNULL(JSON_VALUE(data, '$.Rule'), '') "Rule" 

      FROM INSERTED WHERE type = N'Register.Info.BudgetItemRule'; 


      INSERT INTO "Register.Info.DepartmentCompanyHistory" (date, document, company , "Department")
      SELECT
        CAST(date AS datetime) date, document, company 
        , CAST(ISNULL(JSON_VALUE(data, N'$."Department"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Department"

      FROM INSERTED WHERE type = N'Register.Info.DepartmentCompanyHistory'; 


      END;