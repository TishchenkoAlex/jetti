
      ALTER TRIGGER "Register.Info.Insert" ON dbo."Register.Info"
      FOR INSERT AS
      BEGIN
        
      INSERT INTO "Register.Info.PriceList" (date, document, company , "currency", "Product", "PriceType", "Unit", "Price")
      SELECT
        CAST(date AS datetime) date, document, company 
, CAST(JSON_VALUE(data, N'$."currency"') AS UNIQUEIDENTIFIER) "currency"
, CAST(JSON_VALUE(data, N'$."Product"') AS UNIQUEIDENTIFIER) "Product"
, CAST(JSON_VALUE(data, N'$."PriceType"') AS UNIQUEIDENTIFIER) "PriceType"
, CAST(JSON_VALUE(data, N'$."Unit"') AS UNIQUEIDENTIFIER) "Unit"
, CAST(JSON_VALUE(data, N'$.Price') AS MONEY) "Price"
      FROM INSERTED WHERE type = N'Register.Info.PriceList'; 


      INSERT INTO "Register.Info.ExchangeRates" (date, document, company , "currency", "Rate", "Mutiplicity")
      SELECT
        CAST(date AS datetime) date, document, company 
, CAST(JSON_VALUE(data, N'$."currency"') AS UNIQUEIDENTIFIER) "currency"
, CAST(JSON_VALUE(data, N'$.Rate') AS MONEY) "Rate"
, CAST(JSON_VALUE(data, N'$.Mutiplicity') AS MONEY) "Mutiplicity"
      FROM INSERTED WHERE type = N'Register.Info.ExchangeRates'; 


      INSERT INTO "Register.Info.Settings" (date, document, company , "balanceCurrency", "accountingCurrency")
      SELECT
        CAST(date AS datetime) date, document, company 
, CAST(JSON_VALUE(data, N'$."balanceCurrency"') AS UNIQUEIDENTIFIER) "balanceCurrency"
, CAST(JSON_VALUE(data, N'$."accountingCurrency"') AS UNIQUEIDENTIFIER) "accountingCurrency"
      FROM INSERTED WHERE type = N'Register.Info.Settings'; 


      INSERT INTO "Register.Info.Depreciation" (date, document, company , "OE", "StartDate", "Period", "StartCost", "EndCost", "Method")
      SELECT
        CAST(date AS datetime) date, document, company 
, CAST(JSON_VALUE(data, N'$."OE"') AS UNIQUEIDENTIFIER) "OE"
, JSON_VALUE(data, '$.StartDate') "StartDate"
, CAST(JSON_VALUE(data, N'$.Period') AS MONEY) "Period"
, CAST(JSON_VALUE(data, N'$.StartCost') AS MONEY) "StartCost"
, CAST(JSON_VALUE(data, N'$.EndCost') AS MONEY) "EndCost"
, JSON_VALUE(data, '$.Method') "Method"
      FROM INSERTED WHERE type = N'Register.Info.Depreciation'; 


      INSERT INTO "Register.Info.RLS" (date, document, company , "user")
      SELECT
        CAST(date AS datetime) date, document, company 
, JSON_VALUE(data, '$.user') "user"
      FROM INSERTED WHERE type = N'Register.Info.RLS'; 


      END;