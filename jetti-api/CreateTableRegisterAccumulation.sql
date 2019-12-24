
      DROP TABLE IF EXISTS [Accumulation.Copy];
      SELECT * INTO [Accumulation.Copy] FROM [Accumulation];
      BEGIN TRANSACTION
      BEGIN TRY
      TRUNCATE TABLE [Accumulation];
      

      DROP VIEW IF EXISTS "Register.Accumulation.AccountablePersons.Totals";
      DROP TABLE IF EXISTS "Register.Accumulation.AccountablePersons";
      CREATE TABLE "Register.Accumulation.AccountablePersons" (
        [kind] [bit] NOT NULL,
        [id] [uniqueidentifier] PRIMARY KEY NONCLUSTERED DEFAULT NEWID() ,
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

        , "AmountToPay" MONEY NOT NULL
        , "AmountToPay.In" MONEY NOT NULL
        , "AmountToPay.Out" MONEY NOT NULL 

        , "AmountIsPaid" MONEY NOT NULL
        , "AmountIsPaid.In" MONEY NOT NULL
        , "AmountIsPaid.Out" MONEY NOT NULL 
,
        CONSTRAINT [FK_Register.Accumulation.AccountablePersons_Accumulation] FOREIGN KEY (id) REFERENCES dbo.Accumulation (id) ON UPDATE CASCADE ON DELETE CASCADE
      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.Register.Accumulation.AccountablePersons" ON "Register.Accumulation.AccountablePersons";

      GRANT SELECT ON "Register.Accumulation.AccountablePersons" TO jetti;

      DROP VIEW IF EXISTS "Register.Accumulation.AP.Totals";
      DROP TABLE IF EXISTS "Register.Accumulation.AP";
      CREATE TABLE "Register.Accumulation.AP" (
        [kind] [bit] NOT NULL,
        [id] [uniqueidentifier] PRIMARY KEY NONCLUSTERED DEFAULT NEWID() ,
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

        , "AmountToPay" MONEY NOT NULL
        , "AmountToPay.In" MONEY NOT NULL
        , "AmountToPay.Out" MONEY NOT NULL 

        , "AmountIsPaid" MONEY NOT NULL
        , "AmountIsPaid.In" MONEY NOT NULL
        , "AmountIsPaid.Out" MONEY NOT NULL 
,
        CONSTRAINT [FK_Register.Accumulation.AP_Accumulation] FOREIGN KEY (id) REFERENCES dbo.Accumulation (id) ON UPDATE CASCADE ON DELETE CASCADE
      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.Register.Accumulation.AP" ON "Register.Accumulation.AP";

      GRANT SELECT ON "Register.Accumulation.AP" TO jetti;

      DROP VIEW IF EXISTS "Register.Accumulation.AR.Totals";
      DROP TABLE IF EXISTS "Register.Accumulation.AR";
      CREATE TABLE "Register.Accumulation.AR" (
        [kind] [bit] NOT NULL,
        [id] [uniqueidentifier] PRIMARY KEY NONCLUSTERED DEFAULT NEWID() ,
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

        , "AmountToPay" MONEY NOT NULL
        , "AmountToPay.In" MONEY NOT NULL
        , "AmountToPay.Out" MONEY NOT NULL 

        , "AmountIsPaid" MONEY NOT NULL
        , "AmountIsPaid.In" MONEY NOT NULL
        , "AmountIsPaid.Out" MONEY NOT NULL 
,
        CONSTRAINT [FK_Register.Accumulation.AR_Accumulation] FOREIGN KEY (id) REFERENCES dbo.Accumulation (id) ON UPDATE CASCADE ON DELETE CASCADE
      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.Register.Accumulation.AR" ON "Register.Accumulation.AR";

      GRANT SELECT ON "Register.Accumulation.AR" TO jetti;

      DROP VIEW IF EXISTS "Register.Accumulation.Bank.Totals";
      DROP TABLE IF EXISTS "Register.Accumulation.Bank";
      CREATE TABLE "Register.Accumulation.Bank" (
        [kind] [bit] NOT NULL,
        [id] [uniqueidentifier] PRIMARY KEY NONCLUSTERED DEFAULT NEWID() ,
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
,
        CONSTRAINT [FK_Register.Accumulation.Bank_Accumulation] FOREIGN KEY (id) REFERENCES dbo.Accumulation (id) ON UPDATE CASCADE ON DELETE CASCADE
      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.Register.Accumulation.Bank" ON "Register.Accumulation.Bank";

      GRANT SELECT ON "Register.Accumulation.Bank" TO jetti;

      DROP VIEW IF EXISTS "Register.Accumulation.Balance.Totals";
      DROP TABLE IF EXISTS "Register.Accumulation.Balance";
      CREATE TABLE "Register.Accumulation.Balance" (
        [kind] [bit] NOT NULL,
        [id] [uniqueidentifier] PRIMARY KEY NONCLUSTERED DEFAULT NEWID() ,
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
,
        CONSTRAINT [FK_Register.Accumulation.Balance_Accumulation] FOREIGN KEY (id) REFERENCES dbo.Accumulation (id) ON UPDATE CASCADE ON DELETE CASCADE
      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.Register.Accumulation.Balance" ON "Register.Accumulation.Balance";

      GRANT SELECT ON "Register.Accumulation.Balance" TO jetti;

      DROP VIEW IF EXISTS "Register.Accumulation.Cash.Totals";
      DROP TABLE IF EXISTS "Register.Accumulation.Cash";
      CREATE TABLE "Register.Accumulation.Cash" (
        [kind] [bit] NOT NULL,
        [id] [uniqueidentifier] PRIMARY KEY NONCLUSTERED DEFAULT NEWID() ,
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
,
        CONSTRAINT [FK_Register.Accumulation.Cash_Accumulation] FOREIGN KEY (id) REFERENCES dbo.Accumulation (id) ON UPDATE CASCADE ON DELETE CASCADE
      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.Register.Accumulation.Cash" ON "Register.Accumulation.Cash";

      GRANT SELECT ON "Register.Accumulation.Cash" TO jetti;

      DROP VIEW IF EXISTS "Register.Accumulation.Cash.Transit.Totals";
      DROP TABLE IF EXISTS "Register.Accumulation.Cash.Transit";
      CREATE TABLE "Register.Accumulation.Cash.Transit" (
        [kind] [bit] NOT NULL,
        [id] [uniqueidentifier] PRIMARY KEY NONCLUSTERED DEFAULT NEWID() ,
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
,
        CONSTRAINT [FK_Register.Accumulation.Cash.Transit_Accumulation] FOREIGN KEY (id) REFERENCES dbo.Accumulation (id) ON UPDATE CASCADE ON DELETE CASCADE
      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.Register.Accumulation.Cash.Transit" ON "Register.Accumulation.Cash.Transit";

      GRANT SELECT ON "Register.Accumulation.Cash.Transit" TO jetti;

      DROP VIEW IF EXISTS "Register.Accumulation.Inventory.Totals";
      DROP TABLE IF EXISTS "Register.Accumulation.Inventory";
      CREATE TABLE "Register.Accumulation.Inventory" (
        [kind] [bit] NOT NULL,
        [id] [uniqueidentifier] PRIMARY KEY NONCLUSTERED DEFAULT NEWID() ,
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

        , "Department" UNIQUEIDENTIFIER NOT NULL 

        , "Cost" MONEY NOT NULL
        , "Cost.In" MONEY NOT NULL
        , "Cost.Out" MONEY NOT NULL 

        , "Qty" MONEY NOT NULL
        , "Qty.In" MONEY NOT NULL
        , "Qty.Out" MONEY NOT NULL 
,
        CONSTRAINT [FK_Register.Accumulation.Inventory_Accumulation] FOREIGN KEY (id) REFERENCES dbo.Accumulation (id) ON UPDATE CASCADE ON DELETE CASCADE
      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.Register.Accumulation.Inventory" ON "Register.Accumulation.Inventory";

      GRANT SELECT ON "Register.Accumulation.Inventory" TO jetti;

      DROP VIEW IF EXISTS "Register.Accumulation.Loan.Totals";
      DROP TABLE IF EXISTS "Register.Accumulation.Loan";
      CREATE TABLE "Register.Accumulation.Loan" (
        [kind] [bit] NOT NULL,
        [id] [uniqueidentifier] PRIMARY KEY NONCLUSTERED DEFAULT NEWID() ,
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

        , "AmountToPay" MONEY NOT NULL
        , "AmountToPay.In" MONEY NOT NULL
        , "AmountToPay.Out" MONEY NOT NULL 

        , "AmountIsPaid" MONEY NOT NULL
        , "AmountIsPaid.In" MONEY NOT NULL
        , "AmountIsPaid.Out" MONEY NOT NULL 
,
        CONSTRAINT [FK_Register.Accumulation.Loan_Accumulation] FOREIGN KEY (id) REFERENCES dbo.Accumulation (id) ON UPDATE CASCADE ON DELETE CASCADE
      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.Register.Accumulation.Loan" ON "Register.Accumulation.Loan";

      GRANT SELECT ON "Register.Accumulation.Loan" TO jetti;

      DROP VIEW IF EXISTS "Register.Accumulation.PL.Totals";
      DROP TABLE IF EXISTS "Register.Accumulation.PL";
      CREATE TABLE "Register.Accumulation.PL" (
        [kind] [bit] NOT NULL,
        [id] [uniqueidentifier] PRIMARY KEY NONCLUSTERED DEFAULT NEWID() ,
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
,
        CONSTRAINT [FK_Register.Accumulation.PL_Accumulation] FOREIGN KEY (id) REFERENCES dbo.Accumulation (id) ON UPDATE CASCADE ON DELETE CASCADE
      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.Register.Accumulation.PL" ON "Register.Accumulation.PL";

      GRANT SELECT ON "Register.Accumulation.PL" TO jetti;

      DROP VIEW IF EXISTS "Register.Accumulation.Sales.Totals";
      DROP TABLE IF EXISTS "Register.Accumulation.Sales";
      CREATE TABLE "Register.Accumulation.Sales" (
        [kind] [bit] NOT NULL,
        [id] [uniqueidentifier] PRIMARY KEY NONCLUSTERED DEFAULT NEWID() ,
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
,
        CONSTRAINT [FK_Register.Accumulation.Sales_Accumulation] FOREIGN KEY (id) REFERENCES dbo.Accumulation (id) ON UPDATE CASCADE ON DELETE CASCADE
      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.Register.Accumulation.Sales" ON "Register.Accumulation.Sales";

      GRANT SELECT ON "Register.Accumulation.Sales" TO jetti;

      DROP VIEW IF EXISTS "Register.Accumulation.Depreciation.Totals";
      DROP TABLE IF EXISTS "Register.Accumulation.Depreciation";
      CREATE TABLE "Register.Accumulation.Depreciation" (
        [kind] [bit] NOT NULL,
        [id] [uniqueidentifier] PRIMARY KEY NONCLUSTERED DEFAULT NEWID() ,
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
,
        CONSTRAINT [FK_Register.Accumulation.Depreciation_Accumulation] FOREIGN KEY (id) REFERENCES dbo.Accumulation (id) ON UPDATE CASCADE ON DELETE CASCADE
      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.Register.Accumulation.Depreciation" ON "Register.Accumulation.Depreciation";

      GRANT SELECT ON "Register.Accumulation.Depreciation" TO jetti;

      DROP VIEW IF EXISTS "Register.Accumulation.CashToPay.Totals";
      DROP TABLE IF EXISTS "Register.Accumulation.CashToPay";
      CREATE TABLE "Register.Accumulation.CashToPay" (
        [kind] [bit] NOT NULL,
        [id] [uniqueidentifier] PRIMARY KEY NONCLUSTERED DEFAULT NEWID() ,
        [calculated] [bit] NOT NULL DEFAULT 0,
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL,
        [DT] [BIGINT] NOT NULL,
        [parent] [uniqueidentifier] NULL,
        [exchangeRate] [float] NOT NULL DEFAULT 1
        
        , "currency" UNIQUEIDENTIFIER NOT NULL 

        , "CashFlow" UNIQUEIDENTIFIER NOT NULL 

        , "Contract" UNIQUEIDENTIFIER NOT NULL 

        , "Department" UNIQUEIDENTIFIER NOT NULL 

        , "OperationType" NVARCHAR(150) NOT NULL 

        , "Loan" UNIQUEIDENTIFIER NOT NULL 

        , "CashOrBank" UNIQUEIDENTIFIER NOT NULL 

        , "CashRecipient" UNIQUEIDENTIFIER NOT NULL 

        , "ExpenseOrBalance" UNIQUEIDENTIFIER NOT NULL 

        , "ExpenseAnalytics" UNIQUEIDENTIFIER NOT NULL 

        , "BalanceAnalytics" UNIQUEIDENTIFIER NOT NULL 

        , "PayDay" DATE NOT NULL 

        , "Amount" MONEY NOT NULL
        , "Amount.In" MONEY NOT NULL
        , "Amount.Out" MONEY NOT NULL 
,
        CONSTRAINT [FK_Register.Accumulation.CashToPay_Accumulation] FOREIGN KEY (id) REFERENCES dbo.Accumulation (id) ON UPDATE CASCADE ON DELETE CASCADE
      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.Register.Accumulation.CashToPay" ON "Register.Accumulation.CashToPay";

      GRANT SELECT ON "Register.Accumulation.CashToPay" TO jetti;

      DROP VIEW IF EXISTS "Register.Accumulation.BudgetItemTurnover.Totals";
      DROP TABLE IF EXISTS "Register.Accumulation.BudgetItemTurnover";
      CREATE TABLE "Register.Accumulation.BudgetItemTurnover" (
        [kind] [bit] NOT NULL,
        [id] [uniqueidentifier] PRIMARY KEY NONCLUSTERED DEFAULT NEWID() ,
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
,
        CONSTRAINT [FK_Register.Accumulation.BudgetItemTurnover_Accumulation] FOREIGN KEY (id) REFERENCES dbo.Accumulation (id) ON UPDATE CASCADE ON DELETE CASCADE
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
      
    CREATE OR ALTER TRIGGER [Accumulation->Register.Accumulation.AccountablePersons] ON [dbo].[Accumulation]
    AFTER INSERT AS
    BEGIN
      INSERT INTO [Register.Accumulation.AccountablePersons] (DT, id, parent, date, document, company, kind, calculated, exchangeRate
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
        , "AmountInAccounting.Out"
        , "AmountToPay"
        , "AmountToPay.In"
        , "AmountToPay.Out"
        , "AmountIsPaid"
        , "AmountIsPaid.In"
        , "AmountIsPaid.Out")
        SELECT
          --DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
          --  CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
          --  ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          0, id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , ISNULL(CAST(JSON_VALUE(data, N'$.exchangeRate') AS NUMERIC(15,10)), 1) exchangeRate
 
        , ISNULL(CAST(JSON_VALUE(data, N'$."currency"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "currency"

        , ISNULL(CAST(JSON_VALUE(data, N'$."Employee"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Employee"

        , ISNULL(CAST(JSON_VALUE(data, N'$."CashFlow"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "CashFlow"

        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1), 0) "Amount"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, 0), 0) "Amount.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 0, 1), 0) "Amount.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1), 0) "AmountInBalance"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, 0), 0) "AmountInBalance.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 0, 1), 0) "AmountInBalance.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1), 0) "AmountInAccounting"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, 0), 0) "AmountInAccounting.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 0, 1), 0) "AmountInAccounting.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, 1, -1), 0) "AmountToPay"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, 1, 0), 0) "AmountToPay.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, 0, 1), 0) "AmountToPay.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, 1, -1), 0) "AmountIsPaid"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, 1, 0), 0) "AmountIsPaid.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, 0, 1), 0) "AmountIsPaid.Out"
        
      FROM INSERTED WHERE type = N'Register.Accumulation.AccountablePersons'
    END
    GO

    CREATE OR ALTER TRIGGER [Accumulation->Register.Accumulation.AP] ON [dbo].[Accumulation]
    AFTER INSERT AS
    BEGIN
      INSERT INTO [Register.Accumulation.AP] (DT, id, parent, date, document, company, kind, calculated, exchangeRate
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
        , "AmountInAccounting.Out"
        , "AmountToPay"
        , "AmountToPay.In"
        , "AmountToPay.Out"
        , "AmountIsPaid"
        , "AmountIsPaid.In"
        , "AmountIsPaid.Out")
        SELECT
          --DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
          --  CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
          --  ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          0, id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , ISNULL(CAST(JSON_VALUE(data, N'$.exchangeRate') AS NUMERIC(15,10)), 1) exchangeRate
 
        , ISNULL(CAST(JSON_VALUE(data, N'$."currency"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "currency"

        , ISNULL(CAST(JSON_VALUE(data, N'$."Department"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Department"

        , ISNULL(CAST(JSON_VALUE(data, N'$."AO"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "AO"

        , ISNULL(CAST(JSON_VALUE(data, N'$."Supplier"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Supplier"

        , ISNULL(CONVERT(DATETIME,JSON_VALUE(data, N'$.PayDay'),127), CONVERT(DATETIME, '1970-01-01', 102)) "PayDay"

        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1), 0) "Amount"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, 0), 0) "Amount.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 0, 1), 0) "Amount.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1), 0) "AmountInBalance"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, 0), 0) "AmountInBalance.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 0, 1), 0) "AmountInBalance.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1), 0) "AmountInAccounting"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, 0), 0) "AmountInAccounting.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 0, 1), 0) "AmountInAccounting.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, 1, -1), 0) "AmountToPay"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, 1, 0), 0) "AmountToPay.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, 0, 1), 0) "AmountToPay.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, 1, -1), 0) "AmountIsPaid"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, 1, 0), 0) "AmountIsPaid.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, 0, 1), 0) "AmountIsPaid.Out"
        
      FROM INSERTED WHERE type = N'Register.Accumulation.AP'
    END
    GO

    CREATE OR ALTER TRIGGER [Accumulation->Register.Accumulation.AR] ON [dbo].[Accumulation]
    AFTER INSERT AS
    BEGIN
      INSERT INTO [Register.Accumulation.AR] (DT, id, parent, date, document, company, kind, calculated, exchangeRate
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
        , "AmountInAccounting.Out"
        , "AmountToPay"
        , "AmountToPay.In"
        , "AmountToPay.Out"
        , "AmountIsPaid"
        , "AmountIsPaid.In"
        , "AmountIsPaid.Out")
        SELECT
          --DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
          --  CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
          --  ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          0, id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , ISNULL(CAST(JSON_VALUE(data, N'$.exchangeRate') AS NUMERIC(15,10)), 1) exchangeRate
 
        , ISNULL(CAST(JSON_VALUE(data, N'$."currency"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "currency"

        , ISNULL(CAST(JSON_VALUE(data, N'$."Department"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Department"

        , ISNULL(CAST(JSON_VALUE(data, N'$."AO"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "AO"

        , ISNULL(CAST(JSON_VALUE(data, N'$."Customer"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Customer"

        , ISNULL(CONVERT(DATETIME,JSON_VALUE(data, N'$.PayDay'),127), CONVERT(DATETIME, '1970-01-01', 102)) "PayDay"

        , ISNULL(CAST(JSON_VALUE(data, N'$.AR') AS MONEY) * IIF(kind = 1, 1, -1), 0) "AR"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AR') AS MONEY) * IIF(kind = 1, 1, 0), 0) "AR.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AR') AS MONEY) * IIF(kind = 1, 0, 1), 0) "AR.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1), 0) "AmountInBalance"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, 0), 0) "AmountInBalance.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 0, 1), 0) "AmountInBalance.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1), 0) "AmountInAccounting"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, 0), 0) "AmountInAccounting.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 0, 1), 0) "AmountInAccounting.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, 1, -1), 0) "AmountToPay"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, 1, 0), 0) "AmountToPay.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, 0, 1), 0) "AmountToPay.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, 1, -1), 0) "AmountIsPaid"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, 1, 0), 0) "AmountIsPaid.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, 0, 1), 0) "AmountIsPaid.Out"
        
      FROM INSERTED WHERE type = N'Register.Accumulation.AR'
    END
    GO

    CREATE OR ALTER TRIGGER [Accumulation->Register.Accumulation.Bank] ON [dbo].[Accumulation]
    AFTER INSERT AS
    BEGIN
      INSERT INTO [Register.Accumulation.Bank] (DT, id, parent, date, document, company, kind, calculated, exchangeRate
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
          --DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
          --  CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
          --  ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          0, id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , ISNULL(CAST(JSON_VALUE(data, N'$.exchangeRate') AS NUMERIC(15,10)), 1) exchangeRate
 
        , ISNULL(CAST(JSON_VALUE(data, N'$."currency"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "currency"

        , ISNULL(CAST(JSON_VALUE(data, N'$."BankAccount"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "BankAccount"

        , ISNULL(CAST(JSON_VALUE(data, N'$."CashFlow"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "CashFlow"

        , ISNULL(CAST(JSON_VALUE(data, N'$."Analytics"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Analytics"

        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1), 0) "Amount"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, 0), 0) "Amount.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 0, 1), 0) "Amount.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1), 0) "AmountInBalance"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, 0), 0) "AmountInBalance.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 0, 1), 0) "AmountInBalance.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1), 0) "AmountInAccounting"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, 0), 0) "AmountInAccounting.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 0, 1), 0) "AmountInAccounting.Out"
        
      FROM INSERTED WHERE type = N'Register.Accumulation.Bank'
    END
    GO

    CREATE OR ALTER TRIGGER [Accumulation->Register.Accumulation.Balance] ON [dbo].[Accumulation]
    AFTER INSERT AS
    BEGIN
      INSERT INTO [Register.Accumulation.Balance] (DT, id, parent, date, document, company, kind, calculated, exchangeRate
        , "Department"
        , "Balance"
        , "Analytics"
        , "Amount"
        , "Amount.In"
        , "Amount.Out")
        SELECT
          --DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
          --  CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
          --  ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          0, id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , ISNULL(CAST(JSON_VALUE(data, N'$.exchangeRate') AS NUMERIC(15,10)), 1) exchangeRate
 
        , ISNULL(CAST(JSON_VALUE(data, N'$."Department"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Department"

        , ISNULL(CAST(JSON_VALUE(data, N'$."Balance"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Balance"

        , ISNULL(CAST(JSON_VALUE(data, N'$."Analytics"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Analytics"

        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1), 0) "Amount"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, 0), 0) "Amount.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 0, 1), 0) "Amount.Out"
        
      FROM INSERTED WHERE type = N'Register.Accumulation.Balance'
    END
    GO

    CREATE OR ALTER TRIGGER [Accumulation->Register.Accumulation.Cash] ON [dbo].[Accumulation]
    AFTER INSERT AS
    BEGIN
      INSERT INTO [Register.Accumulation.Cash] (DT, id, parent, date, document, company, kind, calculated, exchangeRate
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
          --DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
          --  CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
          --  ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          0, id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , ISNULL(CAST(JSON_VALUE(data, N'$.exchangeRate') AS NUMERIC(15,10)), 1) exchangeRate
 
        , ISNULL(CAST(JSON_VALUE(data, N'$."currency"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "currency"

        , ISNULL(CAST(JSON_VALUE(data, N'$."CashRegister"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "CashRegister"

        , ISNULL(CAST(JSON_VALUE(data, N'$."CashFlow"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "CashFlow"

        , ISNULL(CAST(JSON_VALUE(data, N'$."Analytics"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Analytics"

        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1), 0) "Amount"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, 0), 0) "Amount.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 0, 1), 0) "Amount.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1), 0) "AmountInBalance"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, 0), 0) "AmountInBalance.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 0, 1), 0) "AmountInBalance.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1), 0) "AmountInAccounting"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, 0), 0) "AmountInAccounting.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 0, 1), 0) "AmountInAccounting.Out"
        
      FROM INSERTED WHERE type = N'Register.Accumulation.Cash'
    END
    GO

    CREATE OR ALTER TRIGGER [Accumulation->Register.Accumulation.Cash.Transit] ON [dbo].[Accumulation]
    AFTER INSERT AS
    BEGIN
      INSERT INTO [Register.Accumulation.Cash.Transit] (DT, id, parent, date, document, company, kind, calculated, exchangeRate
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
          --DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
          --  CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
          --  ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          0, id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , ISNULL(CAST(JSON_VALUE(data, N'$.exchangeRate') AS NUMERIC(15,10)), 1) exchangeRate
 
        , ISNULL(CAST(JSON_VALUE(data, N'$."currency"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "currency"

        , ISNULL(CAST(JSON_VALUE(data, N'$."Sender"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Sender"

        , ISNULL(CAST(JSON_VALUE(data, N'$."Recipient"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Recipient"

        , ISNULL(CAST(JSON_VALUE(data, N'$."CashFlow"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "CashFlow"

        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1), 0) "Amount"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, 0), 0) "Amount.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 0, 1), 0) "Amount.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1), 0) "AmountInBalance"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, 0), 0) "AmountInBalance.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 0, 1), 0) "AmountInBalance.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1), 0) "AmountInAccounting"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, 0), 0) "AmountInAccounting.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 0, 1), 0) "AmountInAccounting.Out"
        
      FROM INSERTED WHERE type = N'Register.Accumulation.Cash.Transit'
    END
    GO

    CREATE OR ALTER TRIGGER [Accumulation->Register.Accumulation.Inventory] ON [dbo].[Accumulation]
    AFTER INSERT AS
    BEGIN
      INSERT INTO [Register.Accumulation.Inventory] (DT, id, parent, date, document, company, kind, calculated, exchangeRate
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
        , "Department"
        , "Cost"
        , "Cost.In"
        , "Cost.Out"
        , "Qty"
        , "Qty.In"
        , "Qty.Out")
        SELECT
          --DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
          --  CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
          --  ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          0, id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , ISNULL(CAST(JSON_VALUE(data, N'$.exchangeRate') AS NUMERIC(15,10)), 1) exchangeRate
 
        , ISNULL(CAST(JSON_VALUE(data, N'$."OperationType"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "OperationType"

        , ISNULL(CAST(JSON_VALUE(data, N'$."Expense"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Expense"

        , ISNULL(CAST(JSON_VALUE(data, N'$."ExpenseAnalytics"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "ExpenseAnalytics"

        , ISNULL(CAST(JSON_VALUE(data, N'$."Income"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Income"

        , ISNULL(CAST(JSON_VALUE(data, N'$."IncomeAnalytics"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "IncomeAnalytics"

        , ISNULL(CAST(JSON_VALUE(data, N'$."BalanceIn"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "BalanceIn"

        , ISNULL(CAST(JSON_VALUE(data, N'$."BalanceInAnalytics"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "BalanceInAnalytics"

        , ISNULL(CAST(JSON_VALUE(data, N'$."BalanceOut"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "BalanceOut"

        , ISNULL(CAST(JSON_VALUE(data, N'$."BalanceOutAnalytics"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "BalanceOutAnalytics"

        , ISNULL(CAST(JSON_VALUE(data, N'$."Storehouse"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Storehouse"

        , ISNULL(CAST(JSON_VALUE(data, N'$."SKU"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "SKU"

        , ISNULL(CAST(JSON_VALUE(data, N'$."batch"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "batch"

        , ISNULL(CAST(JSON_VALUE(data, N'$."Department"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Department"

        , ISNULL(CAST(JSON_VALUE(data, N'$.Cost') AS MONEY) * IIF(kind = 1, 1, -1), 0) "Cost"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Cost') AS MONEY) * IIF(kind = 1, 1, 0), 0) "Cost.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Cost') AS MONEY) * IIF(kind = 1, 0, 1), 0) "Cost.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, 1, -1), 0) "Qty"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, 1, 0), 0) "Qty.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, 0, 1), 0) "Qty.Out"
        
      FROM INSERTED WHERE type = N'Register.Accumulation.Inventory'
    END
    GO

    CREATE OR ALTER TRIGGER [Accumulation->Register.Accumulation.Loan] ON [dbo].[Accumulation]
    AFTER INSERT AS
    BEGIN
      INSERT INTO [Register.Accumulation.Loan] (DT, id, parent, date, document, company, kind, calculated, exchangeRate
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
        , "AmountInAccounting.Out"
        , "AmountToPay"
        , "AmountToPay.In"
        , "AmountToPay.Out"
        , "AmountIsPaid"
        , "AmountIsPaid.In"
        , "AmountIsPaid.Out")
        SELECT
          --DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
          --  CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
          --  ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          0, id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , ISNULL(CAST(JSON_VALUE(data, N'$.exchangeRate') AS NUMERIC(15,10)), 1) exchangeRate
 
        , ISNULL(CAST(JSON_VALUE(data, N'$."Loan"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Loan"

        , ISNULL(CAST(JSON_VALUE(data, N'$."Counterpartie"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Counterpartie"

        , ISNULL(CAST(JSON_VALUE(data, N'$."CashFlow"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "CashFlow"

        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1), 0) "Amount"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, 0), 0) "Amount.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 0, 1), 0) "Amount.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1), 0) "AmountInBalance"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, 0), 0) "AmountInBalance.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 0, 1), 0) "AmountInBalance.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1), 0) "AmountInAccounting"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, 0), 0) "AmountInAccounting.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 0, 1), 0) "AmountInAccounting.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, 1, -1), 0) "AmountToPay"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, 1, 0), 0) "AmountToPay.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, 0, 1), 0) "AmountToPay.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, 1, -1), 0) "AmountIsPaid"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, 1, 0), 0) "AmountIsPaid.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, 0, 1), 0) "AmountIsPaid.Out"
        
      FROM INSERTED WHERE type = N'Register.Accumulation.Loan'
    END
    GO

    CREATE OR ALTER TRIGGER [Accumulation->Register.Accumulation.PL] ON [dbo].[Accumulation]
    AFTER INSERT AS
    BEGIN
      INSERT INTO [Register.Accumulation.PL] (DT, id, parent, date, document, company, kind, calculated, exchangeRate
        , "Department"
        , "PL"
        , "Analytics"
        , "Amount"
        , "Amount.In"
        , "Amount.Out")
        SELECT
          --DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
          --  CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
          --  ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          0, id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , ISNULL(CAST(JSON_VALUE(data, N'$.exchangeRate') AS NUMERIC(15,10)), 1) exchangeRate
 
        , ISNULL(CAST(JSON_VALUE(data, N'$."Department"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Department"

        , ISNULL(CAST(JSON_VALUE(data, N'$."PL"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "PL"

        , ISNULL(CAST(JSON_VALUE(data, N'$."Analytics"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Analytics"

        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1), 0) "Amount"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, 0), 0) "Amount.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 0, 1), 0) "Amount.Out"
        
      FROM INSERTED WHERE type = N'Register.Accumulation.PL'
    END
    GO

    CREATE OR ALTER TRIGGER [Accumulation->Register.Accumulation.Sales] ON [dbo].[Accumulation]
    AFTER INSERT AS
    BEGIN
      INSERT INTO [Register.Accumulation.Sales] (DT, id, parent, date, document, company, kind, calculated, exchangeRate
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
          --DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
          --  CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
          --  ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          0, id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , ISNULL(CAST(JSON_VALUE(data, N'$.exchangeRate') AS NUMERIC(15,10)), 1) exchangeRate
 
        , ISNULL(CAST(JSON_VALUE(data, N'$."currency"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "currency"

        , ISNULL(CAST(JSON_VALUE(data, N'$."Department"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Department"

        , ISNULL(CAST(JSON_VALUE(data, N'$."Customer"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Customer"

        , ISNULL(CAST(JSON_VALUE(data, N'$."Product"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Product"

        , ISNULL(CAST(JSON_VALUE(data, N'$."Manager"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Manager"

        , ISNULL(CAST(JSON_VALUE(data, N'$."AO"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "AO"

        , ISNULL(CAST(JSON_VALUE(data, N'$."Storehouse"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Storehouse"

        , ISNULL(CAST(JSON_VALUE(data, N'$.Cost') AS MONEY) * IIF(kind = 1, 1, -1), 0) "Cost"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Cost') AS MONEY) * IIF(kind = 1, 1, 0), 0) "Cost.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Cost') AS MONEY) * IIF(kind = 1, 0, 1), 0) "Cost.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, 1, -1), 0) "Qty"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, 1, 0), 0) "Qty.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, 0, 1), 0) "Qty.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1), 0) "Amount"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, 0), 0) "Amount.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 0, 1), 0) "Amount.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.Discount') AS MONEY) * IIF(kind = 1, 1, -1), 0) "Discount"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Discount') AS MONEY) * IIF(kind = 1, 1, 0), 0) "Discount.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Discount') AS MONEY) * IIF(kind = 1, 0, 1), 0) "Discount.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.Tax') AS MONEY) * IIF(kind = 1, 1, -1), 0) "Tax"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Tax') AS MONEY) * IIF(kind = 1, 1, 0), 0) "Tax.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Tax') AS MONEY) * IIF(kind = 1, 0, 1), 0) "Tax.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInDoc') AS MONEY) * IIF(kind = 1, 1, -1), 0) "AmountInDoc"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInDoc') AS MONEY) * IIF(kind = 1, 1, 0), 0) "AmountInDoc.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInDoc') AS MONEY) * IIF(kind = 1, 0, 1), 0) "AmountInDoc.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAR') AS MONEY) * IIF(kind = 1, 1, -1), 0) "AmountInAR"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAR') AS MONEY) * IIF(kind = 1, 1, 0), 0) "AmountInAR.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAR') AS MONEY) * IIF(kind = 1, 0, 1), 0) "AmountInAR.Out"
        
      FROM INSERTED WHERE type = N'Register.Accumulation.Sales'
    END
    GO

    CREATE OR ALTER TRIGGER [Accumulation->Register.Accumulation.Depreciation] ON [dbo].[Accumulation]
    AFTER INSERT AS
    BEGIN
      INSERT INTO [Register.Accumulation.Depreciation] (DT, id, parent, date, document, company, kind, calculated, exchangeRate
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
          --DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
          --  CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
          --  ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          0, id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , ISNULL(CAST(JSON_VALUE(data, N'$.exchangeRate') AS NUMERIC(15,10)), 1) exchangeRate
 
        , ISNULL(JSON_VALUE(data, '$.BusinessOperation'), '') "BusinessOperation" 

        , ISNULL(CAST(JSON_VALUE(data, N'$."currency"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "currency"

        , ISNULL(CAST(JSON_VALUE(data, N'$."Department"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Department"

        , ISNULL(CAST(JSON_VALUE(data, N'$."OE"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "OE"

        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1), 0) "Amount"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, 0), 0) "Amount.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 0, 1), 0) "Amount.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1), 0) "AmountInBalance"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, 0), 0) "AmountInBalance.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 0, 1), 0) "AmountInBalance.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1), 0) "AmountInAccounting"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, 0), 0) "AmountInAccounting.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 0, 1), 0) "AmountInAccounting.Out"
        
      FROM INSERTED WHERE type = N'Register.Accumulation.Depreciation'
    END
    GO

    CREATE OR ALTER TRIGGER [Accumulation->Register.Accumulation.CashToPay] ON [dbo].[Accumulation]
    AFTER INSERT AS
    BEGIN
      INSERT INTO [Register.Accumulation.CashToPay] (DT, id, parent, date, document, company, kind, calculated, exchangeRate
        , "currency"
        , "CashFlow"
        , "Contract"
        , "Department"
        , "OperationType"
        , "Loan"
        , "CashOrBank"
        , "CashRecipient"
        , "ExpenseOrBalance"
        , "ExpenseAnalytics"
        , "BalanceAnalytics"
        , "PayDay"
        , "Amount"
        , "Amount.In"
        , "Amount.Out")
        SELECT
          --DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
          --  CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
          --  ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          0, id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , ISNULL(CAST(JSON_VALUE(data, N'$.exchangeRate') AS NUMERIC(15,10)), 1) exchangeRate
 
        , ISNULL(CAST(JSON_VALUE(data, N'$."currency"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "currency"

        , ISNULL(CAST(JSON_VALUE(data, N'$."CashFlow"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "CashFlow"

        , ISNULL(CAST(JSON_VALUE(data, N'$."Contract"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Contract"

        , ISNULL(CAST(JSON_VALUE(data, N'$."Department"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Department"

        , ISNULL(JSON_VALUE(data, '$.OperationType'), '') "OperationType" 

        , ISNULL(CAST(JSON_VALUE(data, N'$."Loan"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Loan"

        , ISNULL(CAST(JSON_VALUE(data, N'$."CashOrBank"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "CashOrBank"

        , ISNULL(CAST(JSON_VALUE(data, N'$."CashRecipient"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "CashRecipient"

        , ISNULL(CAST(JSON_VALUE(data, N'$."ExpenseOrBalance"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "ExpenseOrBalance"

        , ISNULL(CAST(JSON_VALUE(data, N'$."ExpenseAnalytics"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "ExpenseAnalytics"

        , ISNULL(CAST(JSON_VALUE(data, N'$."BalanceAnalytics"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "BalanceAnalytics"

        , ISNULL(CONVERT(DATE,JSON_VALUE(data, N'$.PayDay'),127), CONVERT(DATE, '1970-01-01', 102)) "PayDay"

        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1), 0) "Amount"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, 0), 0) "Amount.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 0, 1), 0) "Amount.Out"
        
      FROM INSERTED WHERE type = N'Register.Accumulation.CashToPay'
    END
    GO

    CREATE OR ALTER TRIGGER [Accumulation->Register.Accumulation.BudgetItemTurnover] ON [dbo].[Accumulation]
    AFTER INSERT AS
    BEGIN
      INSERT INTO [Register.Accumulation.BudgetItemTurnover] (DT, id, parent, date, document, company, kind, calculated, exchangeRate
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
          --DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
          --  CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
          --  ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          0, id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , ISNULL(CAST(JSON_VALUE(data, N'$.exchangeRate') AS NUMERIC(15,10)), 1) exchangeRate
 
        , ISNULL(CAST(JSON_VALUE(data, N'$."Department"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Department"

        , ISNULL(CAST(JSON_VALUE(data, N'$."Scenario"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Scenario"

        , ISNULL(CAST(JSON_VALUE(data, N'$."BudgetItem"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "BudgetItem"

        , ISNULL(CAST(JSON_VALUE(data, N'$."Anatitic1"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Anatitic1"

        , ISNULL(CAST(JSON_VALUE(data, N'$."Anatitic2"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Anatitic2"

        , ISNULL(CAST(JSON_VALUE(data, N'$."Anatitic3"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Anatitic3"

        , ISNULL(CAST(JSON_VALUE(data, N'$."Anatitic4"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Anatitic4"

        , ISNULL(CAST(JSON_VALUE(data, N'$."Anatitic5"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Anatitic5"

        , ISNULL(CAST(JSON_VALUE(data, N'$."currency"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "currency"

        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1), 0) "Amount"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, 0), 0) "Amount.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 0, 1), 0) "Amount.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInScenatio') AS MONEY) * IIF(kind = 1, 1, -1), 0) "AmountInScenatio"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInScenatio') AS MONEY) * IIF(kind = 1, 1, 0), 0) "AmountInScenatio.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInScenatio') AS MONEY) * IIF(kind = 1, 0, 1), 0) "AmountInScenatio.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInCurrency') AS MONEY) * IIF(kind = 1, 1, -1), 0) "AmountInCurrency"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInCurrency') AS MONEY) * IIF(kind = 1, 1, 0), 0) "AmountInCurrency.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInCurrency') AS MONEY) * IIF(kind = 1, 0, 1), 0) "AmountInCurrency.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1), 0) "AmountInAccounting"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, 0), 0) "AmountInAccounting.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 0, 1), 0) "AmountInAccounting.Out"
        
        , ISNULL(CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, 1, -1), 0) "Qty"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, 1, 0), 0) "Qty.In"
        , ISNULL(CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, 0, 1), 0) "Qty.Out"
        
      FROM INSERTED WHERE type = N'Register.Accumulation.BudgetItemTurnover'
    END
    GO


    INSERT INTO [Accumulation] ([id], [date], [type], [data], [document], [kind], [company], [parent], [calculated])
	  SELECT [id], [date], [type], [data], [document], [kind], [company], [parent], [calculated] FROM [Accumulation.COPY];
    