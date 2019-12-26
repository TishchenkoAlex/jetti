
    CREATE OR ALTER VIEW [Register.Accumulation.AccountablePersons]
    WITH SCHEMABINDING
    AS
    SELECT
      id, ISNULL(parent, '00000000-0000-0000-0000-000000000000') parent, date, document, company, kind, calculated
        , ISNULL(CAST(JSON_VALUE(data, N'$.exchangeRate') AS NUMERIC(15,10)), 1) exchangeRate
        , ISNULL(CAST(JSON_VALUE(data, N'$."currency"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "currency"
        , ISNULL(CAST(JSON_VALUE(data, N'$."Employee"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Employee"
        , ISNULL(CAST(JSON_VALUE(data, N'$."CashFlow"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "CashFlow"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Amount"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Amount.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Amount.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInBalance"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInBalance.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInBalance.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInAccounting"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInAccounting.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInAccounting.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountToPay"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountToPay.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountToPay.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountIsPaid"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountIsPaid.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountIsPaid.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.AccountablePersons';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.AccountablePersons] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.AccountablePersons] ON [dbo].[Register.Accumulation.AccountablePersons](
      date,company,calculated,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.AP]
    WITH SCHEMABINDING
    AS
    SELECT
      id, ISNULL(parent, '00000000-0000-0000-0000-000000000000') parent, date, document, company, kind, calculated
        , ISNULL(CAST(JSON_VALUE(data, N'$.exchangeRate') AS NUMERIC(15,10)), 1) exchangeRate
        , ISNULL(CAST(JSON_VALUE(data, N'$."currency"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "currency"
        , ISNULL(CAST(JSON_VALUE(data, N'$."Department"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Department"
        , ISNULL(CAST(JSON_VALUE(data, N'$."AO"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "AO"
        , ISNULL(CAST(JSON_VALUE(data, N'$."Supplier"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Supplier"
        , ISNULL(CONVERT(DATE,JSON_VALUE(data, N'$.PayDay'),127), CONVERT(DATE, '1970-01-01', 102)) "PayDay"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Amount"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Amount.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Amount.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInBalance"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInBalance.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInBalance.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInAccounting"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInAccounting.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInAccounting.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountToPay"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountToPay.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountToPay.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountIsPaid"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountIsPaid.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountIsPaid.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.AP';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.AP] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.AP] ON [dbo].[Register.Accumulation.AP](
      date,company,calculated,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.AR]
    WITH SCHEMABINDING
    AS
    SELECT
      id, ISNULL(parent, '00000000-0000-0000-0000-000000000000') parent, date, document, company, kind, calculated
        , ISNULL(CAST(JSON_VALUE(data, N'$.exchangeRate') AS NUMERIC(15,10)), 1) exchangeRate
        , ISNULL(CAST(JSON_VALUE(data, N'$."currency"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "currency"
        , ISNULL(CAST(JSON_VALUE(data, N'$."Department"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Department"
        , ISNULL(CAST(JSON_VALUE(data, N'$."AO"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "AO"
        , ISNULL(CAST(JSON_VALUE(data, N'$."Customer"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Customer"
        , ISNULL(CONVERT(DATE,JSON_VALUE(data, N'$.PayDay'),127), CONVERT(DATE, '1970-01-01', 102)) "PayDay"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AR') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AR"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AR') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AR.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AR') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AR.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInBalance"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInBalance.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInBalance.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInAccounting"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInAccounting.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInAccounting.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountToPay"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountToPay.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountToPay.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountIsPaid"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountIsPaid.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountIsPaid.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.AR';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.AR] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.AR] ON [dbo].[Register.Accumulation.AR](
      date,company,calculated,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.Bank]
    WITH SCHEMABINDING
    AS
    SELECT
      id, ISNULL(parent, '00000000-0000-0000-0000-000000000000') parent, date, document, company, kind, calculated
        , ISNULL(CAST(JSON_VALUE(data, N'$.exchangeRate') AS NUMERIC(15,10)), 1) exchangeRate
        , ISNULL(CAST(JSON_VALUE(data, N'$."currency"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "currency"
        , ISNULL(CAST(JSON_VALUE(data, N'$."BankAccount"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "BankAccount"
        , ISNULL(CAST(JSON_VALUE(data, N'$."CashFlow"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "CashFlow"
        , ISNULL(CAST(JSON_VALUE(data, N'$."Analytics"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Analytics"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Amount"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Amount.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Amount.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInBalance"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInBalance.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInBalance.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInAccounting"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInAccounting.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInAccounting.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Bank';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Bank] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Bank] ON [dbo].[Register.Accumulation.Bank](
      date,company,calculated,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.Balance]
    WITH SCHEMABINDING
    AS
    SELECT
      id, ISNULL(parent, '00000000-0000-0000-0000-000000000000') parent, date, document, company, kind, calculated
        , ISNULL(CAST(JSON_VALUE(data, N'$.exchangeRate') AS NUMERIC(15,10)), 1) exchangeRate
        , ISNULL(CAST(JSON_VALUE(data, N'$."Department"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Department"
        , ISNULL(CAST(JSON_VALUE(data, N'$."Balance"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Balance"
        , ISNULL(CAST(JSON_VALUE(data, N'$."Analytics"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Analytics"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Amount"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Amount.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Amount.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Balance';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Balance] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Balance] ON [dbo].[Register.Accumulation.Balance](
      date,company,calculated,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.Cash]
    WITH SCHEMABINDING
    AS
    SELECT
      id, ISNULL(parent, '00000000-0000-0000-0000-000000000000') parent, date, document, company, kind, calculated
        , ISNULL(CAST(JSON_VALUE(data, N'$.exchangeRate') AS NUMERIC(15,10)), 1) exchangeRate
        , ISNULL(CAST(JSON_VALUE(data, N'$."currency"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "currency"
        , ISNULL(CAST(JSON_VALUE(data, N'$."CashRegister"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "CashRegister"
        , ISNULL(CAST(JSON_VALUE(data, N'$."CashFlow"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "CashFlow"
        , ISNULL(CAST(JSON_VALUE(data, N'$."Analytics"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Analytics"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Amount"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Amount.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Amount.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInBalance"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInBalance.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInBalance.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInAccounting"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInAccounting.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInAccounting.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Cash';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Cash] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Cash] ON [dbo].[Register.Accumulation.Cash](
      date,company,calculated,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.Cash.Transit]
    WITH SCHEMABINDING
    AS
    SELECT
      id, ISNULL(parent, '00000000-0000-0000-0000-000000000000') parent, date, document, company, kind, calculated
        , ISNULL(CAST(JSON_VALUE(data, N'$.exchangeRate') AS NUMERIC(15,10)), 1) exchangeRate
        , ISNULL(CAST(JSON_VALUE(data, N'$."currency"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "currency"
        , ISNULL(CAST(JSON_VALUE(data, N'$."Sender"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Sender"
        , ISNULL(CAST(JSON_VALUE(data, N'$."Recipient"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Recipient"
        , ISNULL(CAST(JSON_VALUE(data, N'$."CashFlow"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "CashFlow"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Amount"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Amount.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Amount.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInBalance"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInBalance.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInBalance.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInAccounting"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInAccounting.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInAccounting.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Cash.Transit';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Cash.Transit] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Cash.Transit] ON [dbo].[Register.Accumulation.Cash.Transit](
      date,company,calculated,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.Inventory]
    WITH SCHEMABINDING
    AS
    SELECT
      id, ISNULL(parent, '00000000-0000-0000-0000-000000000000') parent, date, document, company, kind, calculated
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
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Cost') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Cost"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Cost') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Cost.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Cost') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Cost.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Qty"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Qty.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Qty.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Inventory';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Inventory] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Inventory] ON [dbo].[Register.Accumulation.Inventory](
      date,company,calculated,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.Loan]
    WITH SCHEMABINDING
    AS
    SELECT
      id, ISNULL(parent, '00000000-0000-0000-0000-000000000000') parent, date, document, company, kind, calculated
        , ISNULL(CAST(JSON_VALUE(data, N'$.exchangeRate') AS NUMERIC(15,10)), 1) exchangeRate
        , ISNULL(CAST(JSON_VALUE(data, N'$."Loan"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Loan"
        , ISNULL(CAST(JSON_VALUE(data, N'$."Counterpartie"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Counterpartie"
        , ISNULL(CAST(JSON_VALUE(data, N'$."CashFlow"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "CashFlow"
        , ISNULL(CAST(JSON_VALUE(data, N'$."currency"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "currency"
        , ISNULL(JSON_VALUE(data, '$.PaymentKind'), '') "PaymentKind" 

        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Amount"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Amount.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Amount.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInBalance"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInBalance.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInBalance.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInAccounting"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInAccounting.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInAccounting.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountToPay"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountToPay.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountToPay.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountIsPaid"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountIsPaid.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountIsPaid.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Loan';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Loan] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Loan] ON [dbo].[Register.Accumulation.Loan](
      date,company,calculated,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.PL]
    WITH SCHEMABINDING
    AS
    SELECT
      id, ISNULL(parent, '00000000-0000-0000-0000-000000000000') parent, date, document, company, kind, calculated
        , ISNULL(CAST(JSON_VALUE(data, N'$.exchangeRate') AS NUMERIC(15,10)), 1) exchangeRate
        , ISNULL(CAST(JSON_VALUE(data, N'$."Department"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Department"
        , ISNULL(CAST(JSON_VALUE(data, N'$."PL"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "PL"
        , ISNULL(CAST(JSON_VALUE(data, N'$."Analytics"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Analytics"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Amount"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Amount.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Amount.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.PL';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.PL] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.PL] ON [dbo].[Register.Accumulation.PL](
      date,company,calculated,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.Sales]
    WITH SCHEMABINDING
    AS
    SELECT
      id, ISNULL(parent, '00000000-0000-0000-0000-000000000000') parent, date, document, company, kind, calculated
        , ISNULL(CAST(JSON_VALUE(data, N'$.exchangeRate') AS NUMERIC(15,10)), 1) exchangeRate
        , ISNULL(CAST(JSON_VALUE(data, N'$."currency"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "currency"
        , ISNULL(CAST(JSON_VALUE(data, N'$."Department"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Department"
        , ISNULL(CAST(JSON_VALUE(data, N'$."Customer"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Customer"
        , ISNULL(CAST(JSON_VALUE(data, N'$."Product"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Product"
        , ISNULL(CAST(JSON_VALUE(data, N'$."Manager"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Manager"
        , ISNULL(CAST(JSON_VALUE(data, N'$."AO"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "AO"
        , ISNULL(CAST(JSON_VALUE(data, N'$."Storehouse"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Storehouse"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Cost') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Cost"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Cost') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Cost.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Cost') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Cost.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Qty"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Qty.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Qty.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Amount"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Amount.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Amount.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Discount') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Discount"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Discount') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Discount.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Discount') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Discount.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Tax') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Tax"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Tax') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Tax.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Tax') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Tax.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInDoc') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInDoc"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInDoc') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInDoc.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInDoc') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInDoc.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInAR') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInAR"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInAR') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInAR.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInAR') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInAR.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Sales';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Sales] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Sales] ON [dbo].[Register.Accumulation.Sales](
      date,company,calculated,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.Depreciation]
    WITH SCHEMABINDING
    AS
    SELECT
      id, ISNULL(parent, '00000000-0000-0000-0000-000000000000') parent, date, document, company, kind, calculated
        , ISNULL(CAST(JSON_VALUE(data, N'$.exchangeRate') AS NUMERIC(15,10)), 1) exchangeRate
        , ISNULL(JSON_VALUE(data, '$.BusinessOperation'), '') "BusinessOperation" 

        , ISNULL(CAST(JSON_VALUE(data, N'$."currency"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "currency"
        , ISNULL(CAST(JSON_VALUE(data, N'$."Department"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "Department"
        , ISNULL(CAST(JSON_VALUE(data, N'$."OE"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "OE"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Amount"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Amount.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Amount.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInBalance"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInBalance.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInBalance.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInAccounting"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInAccounting.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInAccounting.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Depreciation';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Depreciation] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Depreciation] ON [dbo].[Register.Accumulation.Depreciation](
      date,company,calculated,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.CashToPay]
    WITH SCHEMABINDING
    AS
    SELECT
      id, ISNULL(parent, '00000000-0000-0000-0000-000000000000') parent, date, document, company, kind, calculated
        , ISNULL(CAST(JSON_VALUE(data, N'$.exchangeRate') AS NUMERIC(15,10)), 1) exchangeRate
        , ISNULL(CAST(JSON_VALUE(data, N'$."currency"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "currency"
        , ISNULL(CAST(JSON_VALUE(data, N'$."CashFlow"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "CashFlow"
        , ISNULL(CAST(JSON_VALUE(data, N'$."CashRequest"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "CashRequest"
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
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Amount"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Amount.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Amount.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.CashToPay';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.CashToPay] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.CashToPay] ON [dbo].[Register.Accumulation.CashToPay](
      date,company,calculated,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.BudgetItemTurnover]
    WITH SCHEMABINDING
    AS
    SELECT
      id, ISNULL(parent, '00000000-0000-0000-0000-000000000000') parent, date, document, company, kind, calculated
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
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Amount"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Amount.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Amount.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInScenatio') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInScenatio"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInScenatio') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInScenatio.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInScenatio') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInScenatio.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInCurrency') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInCurrency"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInCurrency') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInCurrency.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInCurrency') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInCurrency.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInAccounting"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInAccounting.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInAccounting.Out"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Qty"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Qty.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Qty.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.BudgetItemTurnover';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.BudgetItemTurnover] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.BudgetItemTurnover] ON [dbo].[Register.Accumulation.BudgetItemTurnover](
      date,company,calculated,id
    )
    GO
    