
      DROP TABLE IF EXISTS [Accumulation.Copy];
      SELECT * INTO [Accumulation.Copy] FROM [Accumulation];
      BEGIN TRANSACTION
      BEGIN TRY
      TRUNCATE TABLE [Accumulation];
      

      DROP VIEW IF EXISTS "Register.Accumulation.AccountablePersons.Totals";
      DROP TABLE IF EXISTS "Register.Accumulation.AccountablePersons";
      CREATE TABLE "Register.Accumulation.AccountablePersons" (
        [kind] [bit] NOT NULL,
        [id] [uniqueidentifier] NOT NULL DEFAULT newid(),
        [calculated] [bit] NOT NULL DEFAULT 0,
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL,
        [DT] [BIGINT] NOT NULL,
        [parent] [uniqueidentifier] NULL,
        [exchangeRate] [float] NOT NULL DEFAULT 1
        
        , "currency" UNIQUEIDENTIFIER NOT NULL 

        , "Employee" UNIQUEIDENTIFIER NOT NULL 

        , "CashFlow" UNIQUEIDENTIFIER NOT NULL 

        , "Amount" MONEY NOT NULL
        , "Amount.In" MONEY NOT NULL
        , "Amount.Out" MONEY NOT NULL 

        , "AmountInBalance" MONEY NOT NULL
        , "AmountInBalance.In" MONEY NOT NULL
        , "AmountInBalance.Out" MONEY NOT NULL 

        , "AmountInAccounting" MONEY NOT NULL
        , "AmountInAccounting.In" MONEY NOT NULL
        , "AmountInAccounting.Out" MONEY NOT NULL 

      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.Register.Accumulation.AccountablePersons" ON "Register.Accumulation.AccountablePersons";
      GRANT SELECT ON "Register.Accumulation.AccountablePersons" TO jetti;


      DROP VIEW IF EXISTS "Register.Accumulation.AP.Totals";
      DROP TABLE IF EXISTS "Register.Accumulation.AP";
      CREATE TABLE "Register.Accumulation.AP" (
        [kind] [bit] NOT NULL,
        [id] [uniqueidentifier] NOT NULL DEFAULT newid(),
        [calculated] [bit] NOT NULL DEFAULT 0,
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL,
        [DT] [BIGINT] NOT NULL,
        [parent] [uniqueidentifier] NULL,
        [exchangeRate] [float] NOT NULL DEFAULT 1
        
        , "currency" UNIQUEIDENTIFIER NOT NULL 

        , "Department" UNIQUEIDENTIFIER NOT NULL 

        , "AO" UNIQUEIDENTIFIER NOT NULL 

        , "Supplier" UNIQUEIDENTIFIER NOT NULL 

        , "PayDay" DATE NOT NULL 

        , "Amount" MONEY NOT NULL
        , "Amount.In" MONEY NOT NULL
        , "Amount.Out" MONEY NOT NULL 

        , "AmountInBalance" MONEY NOT NULL
        , "AmountInBalance.In" MONEY NOT NULL
        , "AmountInBalance.Out" MONEY NOT NULL 

        , "AmountInAccounting" MONEY NOT NULL
        , "AmountInAccounting.In" MONEY NOT NULL
        , "AmountInAccounting.Out" MONEY NOT NULL 

      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.Register.Accumulation.AP" ON "Register.Accumulation.AP";
      GRANT SELECT ON "Register.Accumulation.AP" TO jetti;


      DROP VIEW IF EXISTS "Register.Accumulation.AR.Totals";
      DROP TABLE IF EXISTS "Register.Accumulation.AR";
      CREATE TABLE "Register.Accumulation.AR" (
        [kind] [bit] NOT NULL,
        [id] [uniqueidentifier] NOT NULL DEFAULT newid(),
        [calculated] [bit] NOT NULL DEFAULT 0,
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL,
        [DT] [BIGINT] NOT NULL,
        [parent] [uniqueidentifier] NULL,
        [exchangeRate] [float] NOT NULL DEFAULT 1
        
        , "currency" UNIQUEIDENTIFIER NOT NULL 

        , "Department" UNIQUEIDENTIFIER NOT NULL 

        , "AO" UNIQUEIDENTIFIER NOT NULL 

        , "Customer" UNIQUEIDENTIFIER NOT NULL 

        , "PayDay" DATE NOT NULL 

        , "AR" MONEY NOT NULL
        , "AR.In" MONEY NOT NULL
        , "AR.Out" MONEY NOT NULL 

        , "AmountInBalance" MONEY NOT NULL
        , "AmountInBalance.In" MONEY NOT NULL
        , "AmountInBalance.Out" MONEY NOT NULL 

        , "AmountInAccounting" MONEY NOT NULL
        , "AmountInAccounting.In" MONEY NOT NULL
        , "AmountInAccounting.Out" MONEY NOT NULL 

      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.Register.Accumulation.AR" ON "Register.Accumulation.AR";
      GRANT SELECT ON "Register.Accumulation.AR" TO jetti;


      DROP VIEW IF EXISTS "Register.Accumulation.Bank.Totals";
      DROP TABLE IF EXISTS "Register.Accumulation.Bank";
      CREATE TABLE "Register.Accumulation.Bank" (
        [kind] [bit] NOT NULL,
        [id] [uniqueidentifier] NOT NULL DEFAULT newid(),
        [calculated] [bit] NOT NULL DEFAULT 0,
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL,
        [DT] [BIGINT] NOT NULL,
        [parent] [uniqueidentifier] NULL,
        [exchangeRate] [float] NOT NULL DEFAULT 1
        
        , "currency" UNIQUEIDENTIFIER NOT NULL 

        , "BankAccount" UNIQUEIDENTIFIER NOT NULL 

        , "CashFlow" UNIQUEIDENTIFIER NOT NULL 

        , "Analytics" UNIQUEIDENTIFIER NOT NULL 

        , "Amount" MONEY NOT NULL
        , "Amount.In" MONEY NOT NULL
        , "Amount.Out" MONEY NOT NULL 

        , "AmountInBalance" MONEY NOT NULL
        , "AmountInBalance.In" MONEY NOT NULL
        , "AmountInBalance.Out" MONEY NOT NULL 

        , "AmountInAccounting" MONEY NOT NULL
        , "AmountInAccounting.In" MONEY NOT NULL
        , "AmountInAccounting.Out" MONEY NOT NULL 

      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.Register.Accumulation.Bank" ON "Register.Accumulation.Bank";
      GRANT SELECT ON "Register.Accumulation.Bank" TO jetti;


      DROP VIEW IF EXISTS "Register.Accumulation.Balance.Totals";
      DROP TABLE IF EXISTS "Register.Accumulation.Balance";
      CREATE TABLE "Register.Accumulation.Balance" (
        [kind] [bit] NOT NULL,
        [id] [uniqueidentifier] NOT NULL DEFAULT newid(),
        [calculated] [bit] NOT NULL DEFAULT 0,
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL,
        [DT] [BIGINT] NOT NULL,
        [parent] [uniqueidentifier] NULL,
        [exchangeRate] [float] NOT NULL DEFAULT 1
        
        , "Department" UNIQUEIDENTIFIER NOT NULL 

        , "Balance" UNIQUEIDENTIFIER NOT NULL 

        , "Analytics" UNIQUEIDENTIFIER NOT NULL 

        , "Amount" MONEY NOT NULL
        , "Amount.In" MONEY NOT NULL
        , "Amount.Out" MONEY NOT NULL 

      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.Register.Accumulation.Balance" ON "Register.Accumulation.Balance";
      GRANT SELECT ON "Register.Accumulation.Balance" TO jetti;


      DROP VIEW IF EXISTS "Register.Accumulation.Cash.Totals";
      DROP TABLE IF EXISTS "Register.Accumulation.Cash";
      CREATE TABLE "Register.Accumulation.Cash" (
        [kind] [bit] NOT NULL,
        [id] [uniqueidentifier] NOT NULL DEFAULT newid(),
        [calculated] [bit] NOT NULL DEFAULT 0,
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL,
        [DT] [BIGINT] NOT NULL,
        [parent] [uniqueidentifier] NULL,
        [exchangeRate] [float] NOT NULL DEFAULT 1
        
        , "currency" UNIQUEIDENTIFIER NOT NULL 

        , "CashRegister" UNIQUEIDENTIFIER NOT NULL 

        , "CashFlow" UNIQUEIDENTIFIER NOT NULL 

        , "Analytics" UNIQUEIDENTIFIER NOT NULL 

        , "Amount" MONEY NOT NULL
        , "Amount.In" MONEY NOT NULL
        , "Amount.Out" MONEY NOT NULL 

        , "AmountInBalance" MONEY NOT NULL
        , "AmountInBalance.In" MONEY NOT NULL
        , "AmountInBalance.Out" MONEY NOT NULL 

        , "AmountInAccounting" MONEY NOT NULL
        , "AmountInAccounting.In" MONEY NOT NULL
        , "AmountInAccounting.Out" MONEY NOT NULL 

      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.Register.Accumulation.Cash" ON "Register.Accumulation.Cash";
      GRANT SELECT ON "Register.Accumulation.Cash" TO jetti;


      DROP VIEW IF EXISTS "Register.Accumulation.Cash.Transit.Totals";
      DROP TABLE IF EXISTS "Register.Accumulation.Cash.Transit";
      CREATE TABLE "Register.Accumulation.Cash.Transit" (
        [kind] [bit] NOT NULL,
        [id] [uniqueidentifier] NOT NULL DEFAULT newid(),
        [calculated] [bit] NOT NULL DEFAULT 0,
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL,
        [DT] [BIGINT] NOT NULL,
        [parent] [uniqueidentifier] NULL,
        [exchangeRate] [float] NOT NULL DEFAULT 1
        
        , "currency" UNIQUEIDENTIFIER NOT NULL 

        , "Sender" UNIQUEIDENTIFIER NOT NULL 

        , "Recipient" UNIQUEIDENTIFIER NOT NULL 

        , "CashFlow" UNIQUEIDENTIFIER NOT NULL 

        , "Amount" MONEY NOT NULL
        , "Amount.In" MONEY NOT NULL
        , "Amount.Out" MONEY NOT NULL 

        , "AmountInBalance" MONEY NOT NULL
        , "AmountInBalance.In" MONEY NOT NULL
        , "AmountInBalance.Out" MONEY NOT NULL 

        , "AmountInAccounting" MONEY NOT NULL
        , "AmountInAccounting.In" MONEY NOT NULL
        , "AmountInAccounting.Out" MONEY NOT NULL 

      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.Register.Accumulation.Cash.Transit" ON "Register.Accumulation.Cash.Transit";
      GRANT SELECT ON "Register.Accumulation.Cash.Transit" TO jetti;


      DROP VIEW IF EXISTS "Register.Accumulation.Inventory.Totals";
      DROP TABLE IF EXISTS "Register.Accumulation.Inventory";
      CREATE TABLE "Register.Accumulation.Inventory" (
        [kind] [bit] NOT NULL,
        [id] [uniqueidentifier] NOT NULL DEFAULT newid(),
        [calculated] [bit] NOT NULL DEFAULT 0,
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL,
        [DT] [BIGINT] NOT NULL,
        [parent] [uniqueidentifier] NULL,
        [exchangeRate] [float] NOT NULL DEFAULT 1
        
        , "OperationType" UNIQUEIDENTIFIER NOT NULL 

        , "Expense" UNIQUEIDENTIFIER NOT NULL 

        , "ExpenseAnalytics" UNIQUEIDENTIFIER NOT NULL 

        , "Income" UNIQUEIDENTIFIER NOT NULL 

        , "IncomeAnalytics" UNIQUEIDENTIFIER NOT NULL 

        , "BalanceIn" UNIQUEIDENTIFIER NOT NULL 

        , "BalanceInAnalytics" UNIQUEIDENTIFIER NOT NULL 

        , "BalanceOut" UNIQUEIDENTIFIER NOT NULL 

        , "BalanceOutAnalytics" UNIQUEIDENTIFIER NOT NULL 

        , "Storehouse" UNIQUEIDENTIFIER NOT NULL 

        , "SKU" UNIQUEIDENTIFIER NOT NULL 

        , "batch" UNIQUEIDENTIFIER NOT NULL 

        , "Cost" MONEY NOT NULL
        , "Cost.In" MONEY NOT NULL
        , "Cost.Out" MONEY NOT NULL 

        , "Qty" MONEY NOT NULL
        , "Qty.In" MONEY NOT NULL
        , "Qty.Out" MONEY NOT NULL 

      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.Register.Accumulation.Inventory" ON "Register.Accumulation.Inventory";
      GRANT SELECT ON "Register.Accumulation.Inventory" TO jetti;


      DROP VIEW IF EXISTS "Register.Accumulation.Loan.Totals";
      DROP TABLE IF EXISTS "Register.Accumulation.Loan";
      CREATE TABLE "Register.Accumulation.Loan" (
        [kind] [bit] NOT NULL,
        [id] [uniqueidentifier] NOT NULL DEFAULT newid(),
        [calculated] [bit] NOT NULL DEFAULT 0,
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL,
        [DT] [BIGINT] NOT NULL,
        [parent] [uniqueidentifier] NULL,
        [exchangeRate] [float] NOT NULL DEFAULT 1
        
        , "Loan" UNIQUEIDENTIFIER NOT NULL 

        , "Counterpartie" UNIQUEIDENTIFIER NOT NULL 

        , "CashFlow" UNIQUEIDENTIFIER NOT NULL 

        , "Amount" MONEY NOT NULL
        , "Amount.In" MONEY NOT NULL
        , "Amount.Out" MONEY NOT NULL 

        , "AmountInBalance" MONEY NOT NULL
        , "AmountInBalance.In" MONEY NOT NULL
        , "AmountInBalance.Out" MONEY NOT NULL 

        , "AmountInAccounting" MONEY NOT NULL
        , "AmountInAccounting.In" MONEY NOT NULL
        , "AmountInAccounting.Out" MONEY NOT NULL 

      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.Register.Accumulation.Loan" ON "Register.Accumulation.Loan";
      GRANT SELECT ON "Register.Accumulation.Loan" TO jetti;


      DROP VIEW IF EXISTS "Register.Accumulation.PL.Totals";
      DROP TABLE IF EXISTS "Register.Accumulation.PL";
      CREATE TABLE "Register.Accumulation.PL" (
        [kind] [bit] NOT NULL,
        [id] [uniqueidentifier] NOT NULL DEFAULT newid(),
        [calculated] [bit] NOT NULL DEFAULT 0,
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL,
        [DT] [BIGINT] NOT NULL,
        [parent] [uniqueidentifier] NULL,
        [exchangeRate] [float] NOT NULL DEFAULT 1
        
        , "Department" UNIQUEIDENTIFIER NOT NULL 

        , "PL" UNIQUEIDENTIFIER NOT NULL 

        , "Analytics" UNIQUEIDENTIFIER NOT NULL 

        , "Amount" MONEY NOT NULL
        , "Amount.In" MONEY NOT NULL
        , "Amount.Out" MONEY NOT NULL 

      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.Register.Accumulation.PL" ON "Register.Accumulation.PL";
      GRANT SELECT ON "Register.Accumulation.PL" TO jetti;


      DROP VIEW IF EXISTS "Register.Accumulation.Sales.Totals";
      DROP TABLE IF EXISTS "Register.Accumulation.Sales";
      CREATE TABLE "Register.Accumulation.Sales" (
        [kind] [bit] NOT NULL,
        [id] [uniqueidentifier] NOT NULL DEFAULT newid(),
        [calculated] [bit] NOT NULL DEFAULT 0,
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL,
        [DT] [BIGINT] NOT NULL,
        [parent] [uniqueidentifier] NULL,
        [exchangeRate] [float] NOT NULL DEFAULT 1
        
        , "currency" UNIQUEIDENTIFIER NOT NULL 

        , "Department" UNIQUEIDENTIFIER NOT NULL 

        , "Customer" UNIQUEIDENTIFIER NOT NULL 

        , "Product" UNIQUEIDENTIFIER NOT NULL 

        , "Manager" UNIQUEIDENTIFIER NOT NULL 

        , "AO" UNIQUEIDENTIFIER NOT NULL 

        , "Storehouse" UNIQUEIDENTIFIER NOT NULL 

        , "Cost" MONEY NOT NULL
        , "Cost.In" MONEY NOT NULL
        , "Cost.Out" MONEY NOT NULL 

        , "Qty" MONEY NOT NULL
        , "Qty.In" MONEY NOT NULL
        , "Qty.Out" MONEY NOT NULL 

        , "Amount" MONEY NOT NULL
        , "Amount.In" MONEY NOT NULL
        , "Amount.Out" MONEY NOT NULL 

        , "Discount" MONEY NOT NULL
        , "Discount.In" MONEY NOT NULL
        , "Discount.Out" MONEY NOT NULL 

        , "Tax" MONEY NOT NULL
        , "Tax.In" MONEY NOT NULL
        , "Tax.Out" MONEY NOT NULL 

        , "AmountInDoc" MONEY NOT NULL
        , "AmountInDoc.In" MONEY NOT NULL
        , "AmountInDoc.Out" MONEY NOT NULL 

        , "AmountInAR" MONEY NOT NULL
        , "AmountInAR.In" MONEY NOT NULL
        , "AmountInAR.Out" MONEY NOT NULL 

      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.Register.Accumulation.Sales" ON "Register.Accumulation.Sales";
      GRANT SELECT ON "Register.Accumulation.Sales" TO jetti;


      DROP VIEW IF EXISTS "Register.Accumulation.Depreciation.Totals";
      DROP TABLE IF EXISTS "Register.Accumulation.Depreciation";
      CREATE TABLE "Register.Accumulation.Depreciation" (
        [kind] [bit] NOT NULL,
        [id] [uniqueidentifier] NOT NULL DEFAULT newid(),
        [calculated] [bit] NOT NULL DEFAULT 0,
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL,
        [DT] [BIGINT] NOT NULL,
        [parent] [uniqueidentifier] NULL,
        [exchangeRate] [float] NOT NULL DEFAULT 1
        
        , "BusinessOperation" NVARCHAR(150) NOT NULL 

        , "currency" UNIQUEIDENTIFIER NOT NULL 

        , "Department" UNIQUEIDENTIFIER NOT NULL 

        , "OE" UNIQUEIDENTIFIER NOT NULL 

        , "Amount" MONEY NOT NULL
        , "Amount.In" MONEY NOT NULL
        , "Amount.Out" MONEY NOT NULL 

        , "AmountInBalance" MONEY NOT NULL
        , "AmountInBalance.In" MONEY NOT NULL
        , "AmountInBalance.Out" MONEY NOT NULL 

        , "AmountInAccounting" MONEY NOT NULL
        , "AmountInAccounting.In" MONEY NOT NULL
        , "AmountInAccounting.Out" MONEY NOT NULL 

      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.Register.Accumulation.Depreciation" ON "Register.Accumulation.Depreciation";
      GRANT SELECT ON "Register.Accumulation.Depreciation" TO jetti;


      DROP VIEW IF EXISTS "Register.Accumulation.BudgetItemTurnover.Totals";
      DROP TABLE IF EXISTS "Register.Accumulation.BudgetItemTurnover";
      CREATE TABLE "Register.Accumulation.BudgetItemTurnover" (
        [kind] [bit] NOT NULL,
        [id] [uniqueidentifier] NOT NULL DEFAULT newid(),
        [calculated] [bit] NOT NULL DEFAULT 0,
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL,
        [DT] [BIGINT] NOT NULL,
        [parent] [uniqueidentifier] NULL,
        [exchangeRate] [float] NOT NULL DEFAULT 1
        
        , "Department" UNIQUEIDENTIFIER NOT NULL 

        , "Scenario" UNIQUEIDENTIFIER NOT NULL 

        , "BudgetItem" UNIQUEIDENTIFIER NOT NULL 

        , "Anatitic1" UNIQUEIDENTIFIER NOT NULL 

        , "Anatitic2" UNIQUEIDENTIFIER NOT NULL 

        , "Anatitic3" UNIQUEIDENTIFIER NOT NULL 

        , "Anatitic4" UNIQUEIDENTIFIER NOT NULL 

        , "Anatitic5" UNIQUEIDENTIFIER NOT NULL 

        , "currency" UNIQUEIDENTIFIER NOT NULL 

        , "Amount" MONEY NOT NULL
        , "Amount.In" MONEY NOT NULL
        , "Amount.Out" MONEY NOT NULL 

        , "AmountInScenatio" MONEY NOT NULL
        , "AmountInScenatio.In" MONEY NOT NULL
        , "AmountInScenatio.Out" MONEY NOT NULL 

        , "AmountInCurrency" MONEY NOT NULL
        , "AmountInCurrency.In" MONEY NOT NULL
        , "AmountInCurrency.Out" MONEY NOT NULL 

        , "AmountInAccounting" MONEY NOT NULL
        , "AmountInAccounting.In" MONEY NOT NULL
        , "AmountInAccounting.Out" MONEY NOT NULL 

        , "Qty" MONEY NOT NULL
        , "Qty.In" MONEY NOT NULL
        , "Qty.Out" MONEY NOT NULL 

      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.Register.Accumulation.BudgetItemTurnover" ON "Register.Accumulation.BudgetItemTurnover";
      GRANT SELECT ON "Register.Accumulation.BudgetItemTurnover" TO jetti;


      END TRY
      BEGIN CATCH
        IF @@TRANCOUNT > 0
          ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
      END CATCH;
      IF @@TRANCOUNT > 0
        COMMIT TRANSACTION;
      GO
      
      ALTER TRIGGER "Accumulation.Insert" ON dbo."Accumulation"
      AFTER INSERT AS
      BEGIN
        
      INSERT INTO "Register.Accumulation.AccountablePersons" (DT, id, parent, date, document, company, kind, calculated, exchangeRate
        , "currency"
        , "Employee"
        , "CashFlow"
        , "Amount"
        , "Amount.In"
        , "Amount.Out"
        , "AmountInBalance"
        , "AmountInBalance.In"
        , "AmountInBalance.Out"
        , "AmountInAccounting"
        , "AmountInAccounting.In"
        , "AmountInAccounting.Out")
        SELECT
          DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
            CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
            ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS FLOAT) exchangeRate
 
        , CAST(ISNULL(JSON_VALUE(data, N'$."currency"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "currency"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Employee"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Employee"

        , CAST(ISNULL(JSON_VALUE(data, N'$."CashFlow"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "CashFlow"

        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Amount"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Amount.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Amount.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInBalance.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInBalance.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInAccounting.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInAccounting.Out" 

      FROM INSERTED WHERE type = N'Register.Accumulation.AccountablePersons'; 


      INSERT INTO "Register.Accumulation.AP" (DT, id, parent, date, document, company, kind, calculated, exchangeRate
        , "currency"
        , "Department"
        , "AO"
        , "Supplier"
        , "PayDay"
        , "Amount"
        , "Amount.In"
        , "Amount.Out"
        , "AmountInBalance"
        , "AmountInBalance.In"
        , "AmountInBalance.Out"
        , "AmountInAccounting"
        , "AmountInAccounting.In"
        , "AmountInAccounting.Out")
        SELECT
          DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
            CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
            ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS FLOAT) exchangeRate
 
        , CAST(ISNULL(JSON_VALUE(data, N'$."currency"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "currency"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Department"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Department"

        , CAST(ISNULL(JSON_VALUE(data, N'$."AO"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "AO"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Supplier"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Supplier"

        , ISNULL(JSON_VALUE(data, N'$.PayDay'), '1970-01-01T00:00:00.000Z') "PayDay" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Amount"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Amount.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Amount.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInBalance.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInBalance.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInAccounting.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInAccounting.Out" 

      FROM INSERTED WHERE type = N'Register.Accumulation.AP'; 


      INSERT INTO "Register.Accumulation.AR" (DT, id, parent, date, document, company, kind, calculated, exchangeRate
        , "currency"
        , "Department"
        , "AO"
        , "Customer"
        , "PayDay"
        , "AR"
        , "AR.In"
        , "AR.Out"
        , "AmountInBalance"
        , "AmountInBalance.In"
        , "AmountInBalance.Out"
        , "AmountInAccounting"
        , "AmountInAccounting.In"
        , "AmountInAccounting.Out")
        SELECT
          DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
            CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
            ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS FLOAT) exchangeRate
 
        , CAST(ISNULL(JSON_VALUE(data, N'$."currency"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "currency"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Department"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Department"

        , CAST(ISNULL(JSON_VALUE(data, N'$."AO"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "AO"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Customer"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Customer"

        , ISNULL(JSON_VALUE(data, N'$.PayDay'), '1970-01-01T00:00:00.000Z') "PayDay" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AR'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AR"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AR'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AR.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AR'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AR.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInBalance.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInBalance.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInAccounting.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInAccounting.Out" 

      FROM INSERTED WHERE type = N'Register.Accumulation.AR'; 


      INSERT INTO "Register.Accumulation.Bank" (DT, id, parent, date, document, company, kind, calculated, exchangeRate
        , "currency"
        , "BankAccount"
        , "CashFlow"
        , "Analytics"
        , "Amount"
        , "Amount.In"
        , "Amount.Out"
        , "AmountInBalance"
        , "AmountInBalance.In"
        , "AmountInBalance.Out"
        , "AmountInAccounting"
        , "AmountInAccounting.In"
        , "AmountInAccounting.Out")
        SELECT
          DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
            CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
            ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS FLOAT) exchangeRate
 
        , CAST(ISNULL(JSON_VALUE(data, N'$."currency"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "currency"

        , CAST(ISNULL(JSON_VALUE(data, N'$."BankAccount"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "BankAccount"

        , CAST(ISNULL(JSON_VALUE(data, N'$."CashFlow"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "CashFlow"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Analytics"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Analytics"

        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Amount"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Amount.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Amount.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInBalance.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInBalance.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInAccounting.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInAccounting.Out" 

      FROM INSERTED WHERE type = N'Register.Accumulation.Bank'; 


      INSERT INTO "Register.Accumulation.Balance" (DT, id, parent, date, document, company, kind, calculated, exchangeRate
        , "Department"
        , "Balance"
        , "Analytics"
        , "Amount"
        , "Amount.In"
        , "Amount.Out")
        SELECT
          DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
            CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
            ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS FLOAT) exchangeRate
 
        , CAST(ISNULL(JSON_VALUE(data, N'$."Department"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Department"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Balance"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Balance"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Analytics"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Analytics"

        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Amount"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Amount.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Amount.Out" 

      FROM INSERTED WHERE type = N'Register.Accumulation.Balance'; 


      INSERT INTO "Register.Accumulation.Cash" (DT, id, parent, date, document, company, kind, calculated, exchangeRate
        , "currency"
        , "CashRegister"
        , "CashFlow"
        , "Analytics"
        , "Amount"
        , "Amount.In"
        , "Amount.Out"
        , "AmountInBalance"
        , "AmountInBalance.In"
        , "AmountInBalance.Out"
        , "AmountInAccounting"
        , "AmountInAccounting.In"
        , "AmountInAccounting.Out")
        SELECT
          DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
            CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
            ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS FLOAT) exchangeRate
 
        , CAST(ISNULL(JSON_VALUE(data, N'$."currency"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "currency"

        , CAST(ISNULL(JSON_VALUE(data, N'$."CashRegister"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "CashRegister"

        , CAST(ISNULL(JSON_VALUE(data, N'$."CashFlow"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "CashFlow"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Analytics"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Analytics"

        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Amount"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Amount.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Amount.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInBalance.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInBalance.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInAccounting.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInAccounting.Out" 

      FROM INSERTED WHERE type = N'Register.Accumulation.Cash'; 


      INSERT INTO "Register.Accumulation.Cash.Transit" (DT, id, parent, date, document, company, kind, calculated, exchangeRate
        , "currency"
        , "Sender"
        , "Recipient"
        , "CashFlow"
        , "Amount"
        , "Amount.In"
        , "Amount.Out"
        , "AmountInBalance"
        , "AmountInBalance.In"
        , "AmountInBalance.Out"
        , "AmountInAccounting"
        , "AmountInAccounting.In"
        , "AmountInAccounting.Out")
        SELECT
          DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
            CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
            ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS FLOAT) exchangeRate
 
        , CAST(ISNULL(JSON_VALUE(data, N'$."currency"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "currency"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Sender"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Sender"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Recipient"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Recipient"

        , CAST(ISNULL(JSON_VALUE(data, N'$."CashFlow"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "CashFlow"

        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Amount"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Amount.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Amount.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInBalance.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInBalance.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInAccounting.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInAccounting.Out" 

      FROM INSERTED WHERE type = N'Register.Accumulation.Cash.Transit'; 


      INSERT INTO "Register.Accumulation.Inventory" (DT, id, parent, date, document, company, kind, calculated, exchangeRate
        , "OperationType"
        , "Expense"
        , "ExpenseAnalytics"
        , "Income"
        , "IncomeAnalytics"
        , "BalanceIn"
        , "BalanceInAnalytics"
        , "BalanceOut"
        , "BalanceOutAnalytics"
        , "Storehouse"
        , "SKU"
        , "batch"
        , "Cost"
        , "Cost.In"
        , "Cost.Out"
        , "Qty"
        , "Qty.In"
        , "Qty.Out")
        SELECT
          DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
            CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
            ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS FLOAT) exchangeRate
 
        , CAST(ISNULL(JSON_VALUE(data, N'$."OperationType"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "OperationType"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Expense"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Expense"

        , CAST(ISNULL(JSON_VALUE(data, N'$."ExpenseAnalytics"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "ExpenseAnalytics"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Income"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Income"

        , CAST(ISNULL(JSON_VALUE(data, N'$."IncomeAnalytics"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "IncomeAnalytics"

        , CAST(ISNULL(JSON_VALUE(data, N'$."BalanceIn"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "BalanceIn"

        , CAST(ISNULL(JSON_VALUE(data, N'$."BalanceInAnalytics"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "BalanceInAnalytics"

        , CAST(ISNULL(JSON_VALUE(data, N'$."BalanceOut"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "BalanceOut"

        , CAST(ISNULL(JSON_VALUE(data, N'$."BalanceOutAnalytics"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "BalanceOutAnalytics"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Storehouse"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Storehouse"

        , CAST(ISNULL(JSON_VALUE(data, N'$."SKU"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "SKU"

        , CAST(ISNULL(JSON_VALUE(data, N'$."batch"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "batch"

        , CAST(ISNULL(JSON_VALUE(data, N'$.Cost'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Cost"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Cost'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Cost.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Cost'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Cost.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.Qty'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Qty"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Qty'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Qty.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Qty'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Qty.Out" 

      FROM INSERTED WHERE type = N'Register.Accumulation.Inventory'; 


      INSERT INTO "Register.Accumulation.Loan" (DT, id, parent, date, document, company, kind, calculated, exchangeRate
        , "Loan"
        , "Counterpartie"
        , "CashFlow"
        , "Amount"
        , "Amount.In"
        , "Amount.Out"
        , "AmountInBalance"
        , "AmountInBalance.In"
        , "AmountInBalance.Out"
        , "AmountInAccounting"
        , "AmountInAccounting.In"
        , "AmountInAccounting.Out")
        SELECT
          DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
            CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
            ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS FLOAT) exchangeRate
 
        , CAST(ISNULL(JSON_VALUE(data, N'$."Loan"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Loan"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Counterpartie"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Counterpartie"

        , CAST(ISNULL(JSON_VALUE(data, N'$."CashFlow"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "CashFlow"

        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Amount"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Amount.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Amount.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInBalance.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInBalance.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInAccounting.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInAccounting.Out" 

      FROM INSERTED WHERE type = N'Register.Accumulation.Loan'; 


      INSERT INTO "Register.Accumulation.PL" (DT, id, parent, date, document, company, kind, calculated, exchangeRate
        , "Department"
        , "PL"
        , "Analytics"
        , "Amount"
        , "Amount.In"
        , "Amount.Out")
        SELECT
          DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
            CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
            ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS FLOAT) exchangeRate
 
        , CAST(ISNULL(JSON_VALUE(data, N'$."Department"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Department"

        , CAST(ISNULL(JSON_VALUE(data, N'$."PL"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "PL"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Analytics"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Analytics"

        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Amount"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Amount.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Amount.Out" 

      FROM INSERTED WHERE type = N'Register.Accumulation.PL'; 


      INSERT INTO "Register.Accumulation.Sales" (DT, id, parent, date, document, company, kind, calculated, exchangeRate
        , "currency"
        , "Department"
        , "Customer"
        , "Product"
        , "Manager"
        , "AO"
        , "Storehouse"
        , "Cost"
        , "Cost.In"
        , "Cost.Out"
        , "Qty"
        , "Qty.In"
        , "Qty.Out"
        , "Amount"
        , "Amount.In"
        , "Amount.Out"
        , "Discount"
        , "Discount.In"
        , "Discount.Out"
        , "Tax"
        , "Tax.In"
        , "Tax.Out"
        , "AmountInDoc"
        , "AmountInDoc.In"
        , "AmountInDoc.Out"
        , "AmountInAR"
        , "AmountInAR.In"
        , "AmountInAR.Out")
        SELECT
          DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
            CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
            ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS FLOAT) exchangeRate
 
        , CAST(ISNULL(JSON_VALUE(data, N'$."currency"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "currency"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Department"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Department"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Customer"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Customer"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Product"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Product"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Manager"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Manager"

        , CAST(ISNULL(JSON_VALUE(data, N'$."AO"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "AO"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Storehouse"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Storehouse"

        , CAST(ISNULL(JSON_VALUE(data, N'$.Cost'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Cost"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Cost'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Cost.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Cost'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Cost.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.Qty'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Qty"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Qty'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Qty.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Qty'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Qty.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Amount"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Amount.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Amount.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.Discount'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Discount"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Discount'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Discount.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Discount'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Discount.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.Tax'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Tax"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Tax'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Tax.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Tax'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Tax.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInDoc'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInDoc"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInDoc'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInDoc.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInDoc'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInDoc.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAR'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInAR"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAR'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInAR.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAR'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInAR.Out" 

      FROM INSERTED WHERE type = N'Register.Accumulation.Sales'; 


      INSERT INTO "Register.Accumulation.Depreciation" (DT, id, parent, date, document, company, kind, calculated, exchangeRate
        , "BusinessOperation"
        , "currency"
        , "Department"
        , "OE"
        , "Amount"
        , "Amount.In"
        , "Amount.Out"
        , "AmountInBalance"
        , "AmountInBalance.In"
        , "AmountInBalance.Out"
        , "AmountInAccounting"
        , "AmountInAccounting.In"
        , "AmountInAccounting.Out")
        SELECT
          DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
            CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
            ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS FLOAT) exchangeRate
 
        , ISNULL(JSON_VALUE(data, '$.BusinessOperation'), '') "BusinessOperation" 

        , CAST(ISNULL(JSON_VALUE(data, N'$."currency"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "currency"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Department"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Department"

        , CAST(ISNULL(JSON_VALUE(data, N'$."OE"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "OE"

        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Amount"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Amount.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Amount.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInBalance.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInBalance.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInAccounting.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInAccounting.Out" 

      FROM INSERTED WHERE type = N'Register.Accumulation.Depreciation'; 


      INSERT INTO "Register.Accumulation.BudgetItemTurnover" (DT, id, parent, date, document, company, kind, calculated, exchangeRate
        , "Department"
        , "Scenario"
        , "BudgetItem"
        , "Anatitic1"
        , "Anatitic2"
        , "Anatitic3"
        , "Anatitic4"
        , "Anatitic5"
        , "currency"
        , "Amount"
        , "Amount.In"
        , "Amount.Out"
        , "AmountInScenatio"
        , "AmountInScenatio.In"
        , "AmountInScenatio.Out"
        , "AmountInCurrency"
        , "AmountInCurrency.In"
        , "AmountInCurrency.Out"
        , "AmountInAccounting"
        , "AmountInAccounting.In"
        , "AmountInAccounting.Out"
        , "Qty"
        , "Qty.In"
        , "Qty.Out")
        SELECT
          DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
            CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
            ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS FLOAT) exchangeRate
 
        , CAST(ISNULL(JSON_VALUE(data, N'$."Department"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Department"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Scenario"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Scenario"

        , CAST(ISNULL(JSON_VALUE(data, N'$."BudgetItem"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "BudgetItem"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Anatitic1"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Anatitic1"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Anatitic2"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Anatitic2"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Anatitic3"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Anatitic3"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Anatitic4"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Anatitic4"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Anatitic5"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Anatitic5"

        , CAST(ISNULL(JSON_VALUE(data, N'$."currency"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "currency"

        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Amount"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Amount.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Amount.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInScenatio'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInScenatio"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInScenatio'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInScenatio.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInScenatio'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInScenatio.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInCurrency'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInCurrency"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInCurrency'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInCurrency.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInCurrency'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInCurrency.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInAccounting.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInAccounting.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.Qty'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Qty"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Qty'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Qty.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Qty'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Qty.Out" 

      FROM INSERTED WHERE type = N'Register.Accumulation.BudgetItemTurnover'; 


      END;
      GO

      INSERT INTO [Accumulation] SELECT * FROM [Accumulation.COPY];
    