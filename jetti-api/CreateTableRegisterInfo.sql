

      DROP TABLE "Register.Info.PriceList";
      CREATE TABLE "Register.Info.PriceList" (
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL
        , "currency" UNIQUEIDENTIFIER  NOT NULL  
, "Product" UNIQUEIDENTIFIER  NOT NULL  
, "PriceType" UNIQUEIDENTIFIER  NOT NULL  
, "Unit" UNIQUEIDENTIFIER  NOT NULL  
, "Price" MONEY  NOT NULL 

      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.Register.Info.PriceList" ON "Register.Info.PriceList";
      GO
      GRANT SELECT ON "Register.Info.PriceList" TO jetti;
      GO

      DROP TABLE "Register.Info.ExchangeRates";
      CREATE TABLE "Register.Info.ExchangeRates" (
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL
        , "currency" UNIQUEIDENTIFIER  NOT NULL  
, "Rate" MONEY  NOT NULL 
, "Mutiplicity" MONEY  NULL 

      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.Register.Info.ExchangeRates" ON "Register.Info.ExchangeRates";
      GO
      GRANT SELECT ON "Register.Info.ExchangeRates" TO jetti;
      GO

      DROP TABLE "Register.Info.Settings";
      CREATE TABLE "Register.Info.Settings" (
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL
        , "balanceCurrency" UNIQUEIDENTIFIER  NOT NULL  
, "accountingCurrency" UNIQUEIDENTIFIER  NOT NULL  

      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.Register.Info.Settings" ON "Register.Info.Settings";
      GO
      GRANT SELECT ON "Register.Info.Settings" TO jetti;
      GO

      DROP TABLE "Register.Info.Depreciation";
      CREATE TABLE "Register.Info.Depreciation" (
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL
        , "OE" UNIQUEIDENTIFIER  NULL  
, "StartDate" DATE  NOT NULL  
, "Period" MONEY  NOT NULL 
, "StartCost" MONEY  NOT NULL 
, "EndCost" MONEY  NULL 
, "Method" NVARCHAR(150) 
  NULL 
      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.Register.Info.Depreciation" ON "Register.Info.Depreciation";
      GO
      GRANT SELECT ON "Register.Info.Depreciation" TO jetti;
      GO

      DROP TABLE "Register.Info.RLS";
      CREATE TABLE "Register.Info.RLS" (
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL
        , "user" NVARCHAR(150) 
  NOT NULL 
      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.Register.Info.RLS" ON "Register.Info.RLS";
      GO
      GRANT SELECT ON "Register.Info.RLS" TO jetti;
      GO

      DROP TABLE "Register.Info.BudgetItemRule";
      CREATE TABLE "Register.Info.BudgetItemRule" (
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL
        , "BudgetItem" UNIQUEIDENTIFIER  NOT NULL  
, "Scenario" UNIQUEIDENTIFIER  NOT NULL  
, "Rule" NVARCHAR(150) 
  NULL 
      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.Register.Info.BudgetItemRule" ON "Register.Info.BudgetItemRule";
      GO
      GRANT SELECT ON "Register.Info.BudgetItemRule" TO jetti;
      GO

      DROP TABLE "Register.Info.DepartmentCompanyHistory";
      CREATE TABLE "Register.Info.DepartmentCompanyHistory" (
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL
        , "Department" UNIQUEIDENTIFIER  NOT NULL  

      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.Register.Info.DepartmentCompanyHistory" ON "Register.Info.DepartmentCompanyHistory";
      GO
      GRANT SELECT ON "Register.Info.DepartmentCompanyHistory" TO jetti;
      GO