
    
    RAISERROR('Register.Accumulation.AccountablePersons start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.AccountablePersons]
    WITH SCHEMABINDING
    AS
    SELECT
      id, parent, CAST(date AS DATE) date, document, company, kind, calculated
        , TRY_CONVERT(NUMERIC(15,10), JSON_VALUE(data, N'$.exchangeRate')) exchangeRate
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) "currency"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Employee"')) "Employee"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashFlow"')) "CashFlow"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, -1) "Amount"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1,  null) "Amount.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, null,  1) "Amount.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1,  null) "AmountInBalance.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, null,  1) "AmountInBalance.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1,  null) "AmountInAccounting.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, null,  1) "AmountInAccounting.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountToPay')) * IIF(kind = 1, 1, -1) "AmountToPay"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountToPay')) * IIF(kind = 1, 1,  null) "AmountToPay.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountToPay')) * IIF(kind = 1, null,  1) "AmountToPay.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountIsPaid')) * IIF(kind = 1, 1, -1) "AmountIsPaid"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountIsPaid')) * IIF(kind = 1, 1,  null) "AmountIsPaid.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountIsPaid')) * IIF(kind = 1, null,  1) "AmountIsPaid.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.AccountablePersons';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.AccountablePersons] TO JETTI;
    GO
      CREATE UNIQUE INDEX [Register.Accumulation.AccountablePersons.id] ON [dbo].[Register.Accumulation.AccountablePersons](id);
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.AccountablePersons] ON [dbo].[Register.Accumulation.AccountablePersons](company,date,calculated,id);
      GO
    RAISERROR('Register.Accumulation.AccountablePersons finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.AP start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.AP]
    WITH SCHEMABINDING
    AS
    SELECT
      id, parent, CAST(date AS DATE) date, document, company, kind, calculated
        , TRY_CONVERT(NUMERIC(15,10), JSON_VALUE(data, N'$.exchangeRate')) exchangeRate
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) "currency"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) "Department"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."AO"')) "AO"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Supplier"')) "Supplier"
        , TRY_CONVERT(DATE, JSON_VALUE(data, N'$.PayDay'),127) "PayDay"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, -1) "Amount"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1,  null) "Amount.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, null,  1) "Amount.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1,  null) "AmountInBalance.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, null,  1) "AmountInBalance.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1,  null) "AmountInAccounting.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, null,  1) "AmountInAccounting.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountToPay')) * IIF(kind = 1, 1, -1) "AmountToPay"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountToPay')) * IIF(kind = 1, 1,  null) "AmountToPay.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountToPay')) * IIF(kind = 1, null,  1) "AmountToPay.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountIsPaid')) * IIF(kind = 1, 1, -1) "AmountIsPaid"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountIsPaid')) * IIF(kind = 1, 1,  null) "AmountIsPaid.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountIsPaid')) * IIF(kind = 1, null,  1) "AmountIsPaid.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.AP';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.AP] TO JETTI;
    GO
      CREATE UNIQUE INDEX [Register.Accumulation.AP.id] ON [dbo].[Register.Accumulation.AP](id);
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.AP] ON [dbo].[Register.Accumulation.AP](company,date,calculated,id);
      GO
    RAISERROR('Register.Accumulation.AP finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.AR start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.AR]
    WITH SCHEMABINDING
    AS
    SELECT
      id, parent, CAST(date AS DATE) date, document, company, kind, calculated
        , TRY_CONVERT(NUMERIC(15,10), JSON_VALUE(data, N'$.exchangeRate')) exchangeRate
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) "currency"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) "Department"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."AO"')) "AO"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Customer"')) "Customer"
        , TRY_CONVERT(DATE, JSON_VALUE(data, N'$.PayDay'),127) "PayDay"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AR')) * IIF(kind = 1, 1, -1) "AR"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AR')) * IIF(kind = 1, 1,  null) "AR.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AR')) * IIF(kind = 1, null,  1) "AR.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1,  null) "AmountInBalance.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, null,  1) "AmountInBalance.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1,  null) "AmountInAccounting.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, null,  1) "AmountInAccounting.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountToPay')) * IIF(kind = 1, 1, -1) "AmountToPay"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountToPay')) * IIF(kind = 1, 1,  null) "AmountToPay.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountToPay')) * IIF(kind = 1, null,  1) "AmountToPay.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountIsPaid')) * IIF(kind = 1, 1, -1) "AmountIsPaid"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountIsPaid')) * IIF(kind = 1, 1,  null) "AmountIsPaid.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountIsPaid')) * IIF(kind = 1, null,  1) "AmountIsPaid.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.AR';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.AR] TO JETTI;
    GO
      CREATE UNIQUE INDEX [Register.Accumulation.AR.id] ON [dbo].[Register.Accumulation.AR](id);
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.AR] ON [dbo].[Register.Accumulation.AR](company,date,calculated,id);
      GO
    RAISERROR('Register.Accumulation.AR finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Bank start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Bank]
    WITH SCHEMABINDING
    AS
    SELECT
      id, parent, CAST(date AS DATE) date, document, company, kind, calculated
        , TRY_CONVERT(NUMERIC(15,10), JSON_VALUE(data, N'$.exchangeRate')) exchangeRate
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) "currency"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BankAccount"')) "BankAccount"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashFlow"')) "CashFlow"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"')) "Analytics"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, -1) "Amount"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1,  null) "Amount.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, null,  1) "Amount.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1,  null) "AmountInBalance.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, null,  1) "AmountInBalance.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1,  null) "AmountInAccounting.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, null,  1) "AmountInAccounting.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Bank';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Bank] TO JETTI;
    GO
      CREATE UNIQUE INDEX [Register.Accumulation.Bank.id] ON [dbo].[Register.Accumulation.Bank](id);
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Bank] ON [dbo].[Register.Accumulation.Bank](company,date,calculated,id);
      GO
    RAISERROR('Register.Accumulation.Bank finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Balance start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Balance]
    WITH SCHEMABINDING
    AS
    SELECT
      id, parent, CAST(date AS DATE) date, document, company, kind, calculated
        , TRY_CONVERT(NUMERIC(15,10), JSON_VALUE(data, N'$.exchangeRate')) exchangeRate
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) "Department"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Balance"')) "Balance"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"')) "Analytics"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, -1) "Amount"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1,  null) "Amount.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, null,  1) "Amount.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Balance';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Balance] TO JETTI;
    GO
      CREATE UNIQUE INDEX [Register.Accumulation.Balance.id] ON [dbo].[Register.Accumulation.Balance](id);
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Balance] ON [dbo].[Register.Accumulation.Balance](company,date,calculated,id);
      GO
    RAISERROR('Register.Accumulation.Balance finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Balance.Report start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Balance.Report]
    WITH SCHEMABINDING
    AS
    SELECT
      id, parent, CAST(date AS DATE) date, document, company, kind, calculated
        , TRY_CONVERT(NUMERIC(15,10), JSON_VALUE(data, N'$.exchangeRate')) exchangeRate
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) "currency"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) "Department"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Balance"')) "Balance"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"')) "Analytics"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, -1) "Amount"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1,  null) "Amount.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, null,  1) "Amount.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1,  null) "AmountInBalance.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, null,  1) "AmountInBalance.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1,  null) "AmountInAccounting.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, null,  1) "AmountInAccounting.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Balance.Report';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Balance.Report] TO JETTI;
    GO
      CREATE UNIQUE INDEX [Register.Accumulation.Balance.Report.id] ON [dbo].[Register.Accumulation.Balance.Report](id);
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Balance.Report] ON [dbo].[Register.Accumulation.Balance.Report](company,date,calculated,id);
      GO
    RAISERROR('Register.Accumulation.Balance.Report finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Cash start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Cash]
    WITH SCHEMABINDING
    AS
    SELECT
      id, parent, CAST(date AS DATE) date, document, company, kind, calculated
        , TRY_CONVERT(NUMERIC(15,10), JSON_VALUE(data, N'$.exchangeRate')) exchangeRate
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) "currency"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashRegister"')) "CashRegister"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashFlow"')) "CashFlow"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"')) "Analytics"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, -1) "Amount"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1,  null) "Amount.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, null,  1) "Amount.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1,  null) "AmountInBalance.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, null,  1) "AmountInBalance.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1,  null) "AmountInAccounting.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, null,  1) "AmountInAccounting.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Cash';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Cash] TO JETTI;
    GO
      CREATE UNIQUE INDEX [Register.Accumulation.Cash.id] ON [dbo].[Register.Accumulation.Cash](id);
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Cash] ON [dbo].[Register.Accumulation.Cash](company,date,calculated,id);
      GO
    RAISERROR('Register.Accumulation.Cash finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Cash.Transit start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Cash.Transit]
    WITH SCHEMABINDING
    AS
    SELECT
      id, parent, CAST(date AS DATE) date, document, company, kind, calculated
        , TRY_CONVERT(NUMERIC(15,10), JSON_VALUE(data, N'$.exchangeRate')) exchangeRate
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CompanyRecipient"')) "CompanyRecipient"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) "currency"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Sender"')) "Sender"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Recipient"')) "Recipient"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashFlow"')) "CashFlow"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, -1) "Amount"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1,  null) "Amount.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, null,  1) "Amount.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1,  null) "AmountInBalance.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, null,  1) "AmountInBalance.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1,  null) "AmountInAccounting.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, null,  1) "AmountInAccounting.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Cash.Transit';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Cash.Transit] TO JETTI;
    GO
      CREATE UNIQUE INDEX [Register.Accumulation.Cash.Transit.id] ON [dbo].[Register.Accumulation.Cash.Transit](id);
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Cash.Transit] ON [dbo].[Register.Accumulation.Cash.Transit](company,date,calculated,id);
      GO
    RAISERROR('Register.Accumulation.Cash.Transit finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Inventory start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Inventory]
    WITH SCHEMABINDING
    AS
    SELECT
      id, parent, CAST(date AS DATE) date, document, company, kind, calculated
        , TRY_CONVERT(NUMERIC(15,10), JSON_VALUE(data, N'$.exchangeRate')) exchangeRate
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."OperationType"')) "OperationType"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Expense"')) "Expense"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."ExpenseAnalytics"')) "ExpenseAnalytics"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Income"')) "Income"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."IncomeAnalytics"')) "IncomeAnalytics"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BalanceIn"')) "BalanceIn"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BalanceInAnalytics"')) "BalanceInAnalytics"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BalanceOut"')) "BalanceOut"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BalanceOutAnalytics"')) "BalanceOutAnalytics"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Storehouse"')) "Storehouse"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."SKU"')) "SKU"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."batch"')) "batch"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) "Department"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Cost')) * IIF(kind = 1, 1, -1) "Cost"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Cost')) * IIF(kind = 1, 1,  null) "Cost.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Cost')) * IIF(kind = 1, null,  1) "Cost.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Qty')) * IIF(kind = 1, 1, -1) "Qty"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Qty')) * IIF(kind = 1, 1,  null) "Qty.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Qty')) * IIF(kind = 1, null,  1) "Qty.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Inventory';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Inventory] TO JETTI;
    GO
      CREATE UNIQUE INDEX [Register.Accumulation.Inventory.id] ON [dbo].[Register.Accumulation.Inventory](id);
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Inventory] ON [dbo].[Register.Accumulation.Inventory](company,date,calculated,id);
      GO
    RAISERROR('Register.Accumulation.Inventory finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Loan start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Loan]
    WITH SCHEMABINDING
    AS
    SELECT
      id, parent, CAST(date AS DATE) date, document, company, kind, calculated
        , TRY_CONVERT(NUMERIC(15,10), JSON_VALUE(data, N'$.exchangeRate')) exchangeRate
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Loan"')) "Loan"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Counterpartie"')) "Counterpartie"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashFlow"')) "CashFlow"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) "currency"
        , TRY_CONVERT(NVARCHAR(150), JSON_VALUE(data, '$.PaymentKind')) "PaymentKind" 

        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, -1) "Amount"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1,  null) "Amount.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, null,  1) "Amount.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1,  null) "AmountInBalance.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, null,  1) "AmountInBalance.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1,  null) "AmountInAccounting.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, null,  1) "AmountInAccounting.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountToPay')) * IIF(kind = 1, 1, -1) "AmountToPay"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountToPay')) * IIF(kind = 1, 1,  null) "AmountToPay.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountToPay')) * IIF(kind = 1, null,  1) "AmountToPay.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountIsPaid')) * IIF(kind = 1, 1, -1) "AmountIsPaid"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountIsPaid')) * IIF(kind = 1, 1,  null) "AmountIsPaid.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountIsPaid')) * IIF(kind = 1, null,  1) "AmountIsPaid.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Loan';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Loan] TO JETTI;
    GO
      CREATE UNIQUE INDEX [Register.Accumulation.Loan.id] ON [dbo].[Register.Accumulation.Loan](id);
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Loan] ON [dbo].[Register.Accumulation.Loan](company,date,calculated,id);
      GO
    RAISERROR('Register.Accumulation.Loan finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.PL start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.PL]
    WITH SCHEMABINDING
    AS
    SELECT
      id, parent, CAST(date AS DATE) date, document, company, kind, calculated
        , TRY_CONVERT(NUMERIC(15,10), JSON_VALUE(data, N'$.exchangeRate')) exchangeRate
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) "Department"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."PL"')) "PL"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"')) "Analytics"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, -1) "Amount"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1,  null) "Amount.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, null,  1) "Amount.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.PL';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.PL] TO JETTI;
    GO
      CREATE UNIQUE INDEX [Register.Accumulation.PL.id] ON [dbo].[Register.Accumulation.PL](id);
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.PL] ON [dbo].[Register.Accumulation.PL](company,date,calculated,id);
      GO
    RAISERROR('Register.Accumulation.PL finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Sales start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Sales]
    WITH SCHEMABINDING
    AS
    SELECT
      id, parent, CAST(date AS DATE) date, document, company, kind, calculated
        , TRY_CONVERT(NUMERIC(15,10), JSON_VALUE(data, N'$.exchangeRate')) exchangeRate
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) "currency"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) "Department"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Customer"')) "Customer"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Product"')) "Product"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Manager"')) "Manager"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."AO"')) "AO"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Storehouse"')) "Storehouse"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.CashShift')) * IIF(kind = 1, 1, -1) "CashShift"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.CashShift')) * IIF(kind = 1, 1,  null) "CashShift.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.CashShift')) * IIF(kind = 1, null,  1) "CashShift.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Cost')) * IIF(kind = 1, 1, -1) "Cost"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Cost')) * IIF(kind = 1, 1,  null) "Cost.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Cost')) * IIF(kind = 1, null,  1) "Cost.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Qty')) * IIF(kind = 1, 1, -1) "Qty"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Qty')) * IIF(kind = 1, 1,  null) "Qty.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Qty')) * IIF(kind = 1, null,  1) "Qty.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, -1) "Amount"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1,  null) "Amount.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, null,  1) "Amount.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Discount')) * IIF(kind = 1, 1, -1) "Discount"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Discount')) * IIF(kind = 1, 1,  null) "Discount.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Discount')) * IIF(kind = 1, null,  1) "Discount.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Tax')) * IIF(kind = 1, 1, -1) "Tax"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Tax')) * IIF(kind = 1, 1,  null) "Tax.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Tax')) * IIF(kind = 1, null,  1) "Tax.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInDoc')) * IIF(kind = 1, 1, -1) "AmountInDoc"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInDoc')) * IIF(kind = 1, 1,  null) "AmountInDoc.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInDoc')) * IIF(kind = 1, null,  1) "AmountInDoc.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAR')) * IIF(kind = 1, 1, -1) "AmountInAR"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAR')) * IIF(kind = 1, 1,  null) "AmountInAR.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAR')) * IIF(kind = 1, null,  1) "AmountInAR.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Sales';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Sales] TO JETTI;
    GO
      CREATE UNIQUE INDEX [Register.Accumulation.Sales.id] ON [dbo].[Register.Accumulation.Sales](id);
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Sales] ON [dbo].[Register.Accumulation.Sales](company,date,calculated,id);
      GO
    RAISERROR('Register.Accumulation.Sales finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Salary start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Salary]
    WITH SCHEMABINDING
    AS
    SELECT
      id, parent, CAST(date AS DATE) date, document, company, kind, calculated
        , TRY_CONVERT(NUMERIC(15,10), JSON_VALUE(data, N'$.exchangeRate')) exchangeRate
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) "currency"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."KorrCompany"')) "KorrCompany"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) "Department"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Person"')) "Person"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Employee"')) "Employee"
        , TRY_CONVERT(NVARCHAR(150), JSON_VALUE(data, '$.SalaryKind')) "SalaryKind" 

        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"')) "Analytics"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."PL"')) "PL"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."PLAnalytics"')) "PLAnalytics"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, -1) "Amount"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1,  null) "Amount.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, null,  1) "Amount.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1,  null) "AmountInBalance.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, null,  1) "AmountInBalance.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1,  null) "AmountInAccounting.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, null,  1) "AmountInAccounting.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Salary';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Salary] TO JETTI;
    GO
      CREATE UNIQUE INDEX [Register.Accumulation.Salary.id] ON [dbo].[Register.Accumulation.Salary](id);
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Salary] ON [dbo].[Register.Accumulation.Salary](company,date,calculated,id);
      GO
    RAISERROR('Register.Accumulation.Salary finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Depreciation start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Depreciation]
    WITH SCHEMABINDING
    AS
    SELECT
      id, parent, CAST(date AS DATE) date, document, company, kind, calculated
        , TRY_CONVERT(NUMERIC(15,10), JSON_VALUE(data, N'$.exchangeRate')) exchangeRate
        , TRY_CONVERT(NVARCHAR(150), JSON_VALUE(data, '$.BusinessOperation')) "BusinessOperation" 

        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) "currency"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) "Department"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."OE"')) "OE"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, -1) "Amount"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1,  null) "Amount.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, null,  1) "Amount.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1,  null) "AmountInBalance.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, null,  1) "AmountInBalance.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1,  null) "AmountInAccounting.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, null,  1) "AmountInAccounting.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Depreciation';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Depreciation] TO JETTI;
    GO
      CREATE UNIQUE INDEX [Register.Accumulation.Depreciation.id] ON [dbo].[Register.Accumulation.Depreciation](id);
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Depreciation] ON [dbo].[Register.Accumulation.Depreciation](company,date,calculated,id);
      GO
    RAISERROR('Register.Accumulation.Depreciation finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.CashToPay start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.CashToPay]
    WITH SCHEMABINDING
    AS
    SELECT
      id, parent, CAST(date AS DATE) date, document, company, kind, calculated
        , TRY_CONVERT(NUMERIC(15,10), JSON_VALUE(data, N'$.exchangeRate')) exchangeRate
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) "currency"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashFlow"')) "CashFlow"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashRequest"')) "CashRequest"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Contract"')) "Contract"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BankAccountPerson"')) "BankAccountPerson"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) "Department"
        , TRY_CONVERT(NVARCHAR(150), JSON_VALUE(data, '$.OperationType')) "OperationType" 

        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Loan"')) "Loan"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashOrBank"')) "CashOrBank"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashRecipient"')) "CashRecipient"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."ExpenseOrBalance"')) "ExpenseOrBalance"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."ExpenseAnalytics"')) "ExpenseAnalytics"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BalanceAnalytics"')) "BalanceAnalytics"
        , TRY_CONVERT(DATE, JSON_VALUE(data, N'$.PayDay'),127) "PayDay"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, -1) "Amount"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1,  null) "Amount.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, null,  1) "Amount.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.CashToPay';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.CashToPay] TO JETTI;
    GO
      CREATE UNIQUE INDEX [Register.Accumulation.CashToPay.id] ON [dbo].[Register.Accumulation.CashToPay](id);
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.CashToPay] ON [dbo].[Register.Accumulation.CashToPay](company,date,calculated,id);
      GO
    RAISERROR('Register.Accumulation.CashToPay finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.BudgetItemTurnover start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.BudgetItemTurnover]
    WITH SCHEMABINDING
    AS
    SELECT
      id, parent, CAST(date AS DATE) date, document, company, kind, calculated
        , TRY_CONVERT(NUMERIC(15,10), JSON_VALUE(data, N'$.exchangeRate')) exchangeRate
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) "Department"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Scenario"')) "Scenario"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BudgetItem"')) "BudgetItem"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Anatitic1"')) "Anatitic1"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Anatitic2"')) "Anatitic2"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Anatitic3"')) "Anatitic3"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Anatitic4"')) "Anatitic4"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Anatitic5"')) "Anatitic5"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) "currency"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, -1) "Amount"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1,  null) "Amount.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, null,  1) "Amount.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInScenatio')) * IIF(kind = 1, 1, -1) "AmountInScenatio"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInScenatio')) * IIF(kind = 1, 1,  null) "AmountInScenatio.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInScenatio')) * IIF(kind = 1, null,  1) "AmountInScenatio.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInCurrency')) * IIF(kind = 1, 1, -1) "AmountInCurrency"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInCurrency')) * IIF(kind = 1, 1,  null) "AmountInCurrency.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInCurrency')) * IIF(kind = 1, null,  1) "AmountInCurrency.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1,  null) "AmountInAccounting.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, null,  1) "AmountInAccounting.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Qty')) * IIF(kind = 1, 1, -1) "Qty"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Qty')) * IIF(kind = 1, 1,  null) "Qty.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Qty')) * IIF(kind = 1, null,  1) "Qty.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.BudgetItemTurnover';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.BudgetItemTurnover] TO JETTI;
    GO
      CREATE UNIQUE INDEX [Register.Accumulation.BudgetItemTurnover.id] ON [dbo].[Register.Accumulation.BudgetItemTurnover](id);
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.BudgetItemTurnover] ON [dbo].[Register.Accumulation.BudgetItemTurnover](company,date,calculated,id);
      GO
    RAISERROR('Register.Accumulation.BudgetItemTurnover finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Intercompany start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Intercompany]
    WITH SCHEMABINDING
    AS
    SELECT
      id, parent, CAST(date AS DATE) date, document, company, kind, calculated
        , TRY_CONVERT(NUMERIC(15,10), JSON_VALUE(data, N'$.exchangeRate')) exchangeRate
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Intercompany"')) "Intercompany"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."LegalCompanySender"')) "LegalCompanySender"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."LegalCompanyRecipient"')) "LegalCompanyRecipient"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Contract"')) "Contract"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."OperationType"')) "OperationType"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) "currency"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, -1) "Amount"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1,  null) "Amount.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, null,  1) "Amount.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1,  null) "AmountInBalance.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, null,  1) "AmountInBalance.Out"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1,  null) "AmountInAccounting.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, null,  1) "AmountInAccounting.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Intercompany';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Intercompany] TO JETTI;
    GO
      CREATE UNIQUE INDEX [Register.Accumulation.Intercompany.id] ON [dbo].[Register.Accumulation.Intercompany](id);
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Intercompany] ON [dbo].[Register.Accumulation.Intercompany](company,date,calculated,id);
      GO
    RAISERROR('Register.Accumulation.Intercompany finish', 0 ,1) WITH NOWAIT;
    GO
    
    EXEC [rpt].[CreateIndexReportHelper]
    GO
    