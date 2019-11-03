
      BEGIN TRANSACTION
      BEGIN TRY
      

      DROP VIEW IF EXISTS "Register.Accumulation.AccountablePersons.Totals";
      DROP TABLE IF EXISTS "Register.Accumulation.AccountablePersons";
      CREATE TABLE "Register.Accumulation.AccountablePersons" (
        [kind] [bit] NOT NULL,
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL,
        DT BIGINT NOT NULL
        
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
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL,
        DT BIGINT NOT NULL
        
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
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL,
        DT BIGINT NOT NULL
        
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
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL,
        DT BIGINT NOT NULL
        
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
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL,
        DT BIGINT NOT NULL
        
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
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL,
        DT BIGINT NOT NULL
        
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
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL,
        DT BIGINT NOT NULL
        
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
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL,
        DT BIGINT NOT NULL
        
        , "Expense" UNIQUEIDENTIFIER NOT NULL 

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
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL,
        DT BIGINT NOT NULL
        
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
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL,
        DT BIGINT NOT NULL
        
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
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL,
        DT BIGINT NOT NULL
        
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
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL,
        DT BIGINT NOT NULL
        
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


      DROP TABLE IF EXISTS [Accumulation.Copy];

      SELECT * INTO [Accumulation.Copy] FROM [Accumulation];

      DELETE FROM [Accumulation];
      INSERT INTO [Accumulation] SELECT * FROM [Accumulation.COPY];

      END TRY
      BEGIN CATCH
        IF @@TRANCOUNT > 0
          ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
      END CATCH;
      IF @@TRANCOUNT > 0
        COMMIT TRANSACTION;
      GO
    