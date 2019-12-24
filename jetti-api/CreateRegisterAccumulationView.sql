
    CREATE OR ALTER VIEW [Register.Accumulation.AccountablePersons]
    WITH SCHEMABINDING
    AS
    SELECT
      id, parent, date, document, company, kind, calculated
      , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS DECIMAL(15, 10)) exchangeRate
 
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

      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.AccountablePersons';
    GO

    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.AccountablePersons] ON [dbo].[Register.Accumulation.AccountablePersons](
      date,company,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.AP]
    WITH SCHEMABINDING
    AS
    SELECT
      id, parent, date, document, company, kind, calculated
      , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS DECIMAL(15, 10)) exchangeRate
 
        , CAST(ISNULL(JSON_VALUE(data, N'$."currency"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "currency"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Department"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Department"

        , CAST(ISNULL(JSON_VALUE(data, N'$."AO"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "AO"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Supplier"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Supplier"

        , CAST(ISNULL(JSON_VALUE(data, N'$.PayDay'), '1970-01-01T00:00:00.000Z') AS VARCHAR(20)) "PayDay" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Amount"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Amount.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Amount.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInBalance.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInBalance.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInAccounting.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInAccounting.Out" 

      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.AP';
    GO

    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.AP] ON [dbo].[Register.Accumulation.AP](
      date,company,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.AR]
    WITH SCHEMABINDING
    AS
    SELECT
      id, parent, date, document, company, kind, calculated
      , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS DECIMAL(15, 10)) exchangeRate
 
        , CAST(ISNULL(JSON_VALUE(data, N'$."currency"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "currency"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Department"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Department"

        , CAST(ISNULL(JSON_VALUE(data, N'$."AO"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "AO"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Customer"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Customer"

        , CAST(ISNULL(JSON_VALUE(data, N'$.PayDay'), '1970-01-01T00:00:00.000Z') AS VARCHAR(20)) "PayDay" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AR'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AR"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AR'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AR.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AR'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AR.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInBalance.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInBalance.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInAccounting.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInAccounting.Out" 

      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.AR';
    GO

    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.AR] ON [dbo].[Register.Accumulation.AR](
      date,company,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.Bank]
    WITH SCHEMABINDING
    AS
    SELECT
      id, parent, date, document, company, kind, calculated
      , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS DECIMAL(15, 10)) exchangeRate
 
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

      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Bank';
    GO

    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Bank] ON [dbo].[Register.Accumulation.Bank](
      date,company,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.Balance]
    WITH SCHEMABINDING
    AS
    SELECT
      id, parent, date, document, company, kind, calculated
      , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS DECIMAL(15, 10)) exchangeRate
 
        , CAST(ISNULL(JSON_VALUE(data, N'$."Department"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Department"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Balance"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Balance"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Analytics"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Analytics"

        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Amount"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Amount.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Amount.Out" 

      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Balance';
    GO

    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Balance] ON [dbo].[Register.Accumulation.Balance](
      date,company,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.Cash]
    WITH SCHEMABINDING
    AS
    SELECT
      id, parent, date, document, company, kind, calculated
      , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS DECIMAL(15, 10)) exchangeRate
 
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

      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Cash';
    GO

    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Cash] ON [dbo].[Register.Accumulation.Cash](
      date,company,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.Cash.Transit]
    WITH SCHEMABINDING
    AS
    SELECT
      id, parent, date, document, company, kind, calculated
      , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS DECIMAL(15, 10)) exchangeRate
 
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

      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Cash.Transit';
    GO

    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Cash.Transit] ON [dbo].[Register.Accumulation.Cash.Transit](
      date,company,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.Inventory]
    WITH SCHEMABINDING
    AS
    SELECT
      id, parent, date, document, company, kind, calculated
      , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS DECIMAL(15, 10)) exchangeRate
 
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

        , CAST(ISNULL(JSON_VALUE(data, N'$."Department"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Department"

        , CAST(ISNULL(JSON_VALUE(data, N'$.Cost'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Cost"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Cost'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Cost.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Cost'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Cost.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.Qty'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Qty"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Qty'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Qty.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Qty'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Qty.Out" 

      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Inventory';
    GO

    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Inventory] ON [dbo].[Register.Accumulation.Inventory](
      date,company,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.Loan]
    WITH SCHEMABINDING
    AS
    SELECT
      id, parent, date, document, company, kind, calculated
      , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS DECIMAL(15, 10)) exchangeRate
 
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

      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Loan';
    GO

    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Loan] ON [dbo].[Register.Accumulation.Loan](
      date,company,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.PL]
    WITH SCHEMABINDING
    AS
    SELECT
      id, parent, date, document, company, kind, calculated
      , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS DECIMAL(15, 10)) exchangeRate
 
        , CAST(ISNULL(JSON_VALUE(data, N'$."Department"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Department"

        , CAST(ISNULL(JSON_VALUE(data, N'$."PL"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "PL"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Analytics"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Analytics"

        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Amount"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Amount.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Amount.Out" 

      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.PL';
    GO

    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.PL] ON [dbo].[Register.Accumulation.PL](
      date,company,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.Sales]
    WITH SCHEMABINDING
    AS
    SELECT
      id, parent, date, document, company, kind, calculated
      , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS DECIMAL(15, 10)) exchangeRate
 
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

      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Sales';
    GO

    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Sales] ON [dbo].[Register.Accumulation.Sales](
      date,company,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.Depreciation]
    WITH SCHEMABINDING
    AS
    SELECT
      id, parent, date, document, company, kind, calculated
      , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS DECIMAL(15, 10)) exchangeRate
 
        , CAST(ISNULL(JSON_VALUE(data, '$.BusinessOperation'), '') AS NVARCHAR(150)) "BusinessOperation" 

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

      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Depreciation';
    GO

    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Depreciation] ON [dbo].[Register.Accumulation.Depreciation](
      date,company,id
    )
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.BudgetItemTurnover]
    WITH SCHEMABINDING
    AS
    SELECT
      id, parent, date, document, company, kind, calculated
      , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS DECIMAL(15, 10)) exchangeRate
 
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

      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.BudgetItemTurnover';
    GO

    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.BudgetItemTurnover] ON [dbo].[Register.Accumulation.BudgetItemTurnover](
      date,company,id
    )
    GO
    