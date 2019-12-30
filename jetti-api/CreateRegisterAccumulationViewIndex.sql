
    
    CREATE OR ALTER VIEW [Register.Accumulation.AccountablePersons]
    WITH SCHEMABINDING
    AS
    SELECT
      id, ISNULL(parent, '00000000-0000-0000-0000-000000000000') parent, date, document, company, kind, calculated
        , ISNULL(TRY_CONVERT(NUMERIC(15,10), JSON_VALUE(data, N'$.exchangeRate')), 1) exchangeRate
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')), '00000000-0000-0000-0000-000000000000') "currency"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Employee"')), '00000000-0000-0000-0000-000000000000') "Employee"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashFlow"')), '00000000-0000-0000-0000-000000000000') "CashFlow"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Amount"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Amount.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Amount.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInBalance"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInBalance.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInBalance.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInAccounting"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInAccounting.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInAccounting.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountToPay')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountToPay"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountToPay')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountToPay.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountToPay')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountToPay.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountIsPaid')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountIsPaid"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountIsPaid')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountIsPaid.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountIsPaid')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountIsPaid.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.AccountablePersons';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.AccountablePersons] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.AccountablePersons] ON [dbo].[Register.Accumulation.AccountablePersons](
      company,date,calculated,id
    ) --ON [ps_ByMonth]([date])
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.AP]
    WITH SCHEMABINDING
    AS
    SELECT
      id, ISNULL(parent, '00000000-0000-0000-0000-000000000000') parent, date, document, company, kind, calculated
        , ISNULL(TRY_CONVERT(NUMERIC(15,10), JSON_VALUE(data, N'$.exchangeRate')), 1) exchangeRate
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')), '00000000-0000-0000-0000-000000000000') "currency"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')), '00000000-0000-0000-0000-000000000000') "Department"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."AO"')), '00000000-0000-0000-0000-000000000000') "AO"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Supplier"')), '00000000-0000-0000-0000-000000000000') "Supplier"
        , ISNULL(TRY_CONVERT(DATE,JSON_VALUE(data, N'$.PayDay'),127), TRY_CONVERT(DATE, '1970-01-01', 102)) "PayDay"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Amount"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Amount.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Amount.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInBalance"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInBalance.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInBalance.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInAccounting"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInAccounting.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInAccounting.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountToPay')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountToPay"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountToPay')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountToPay.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountToPay')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountToPay.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountIsPaid')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountIsPaid"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountIsPaid')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountIsPaid.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountIsPaid')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountIsPaid.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.AP';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.AP] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.AP] ON [dbo].[Register.Accumulation.AP](
      company,date,calculated,id
    ) --ON [ps_ByMonth]([date])
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.AR]
    WITH SCHEMABINDING
    AS
    SELECT
      id, ISNULL(parent, '00000000-0000-0000-0000-000000000000') parent, date, document, company, kind, calculated
        , ISNULL(TRY_CONVERT(NUMERIC(15,10), JSON_VALUE(data, N'$.exchangeRate')), 1) exchangeRate
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')), '00000000-0000-0000-0000-000000000000') "currency"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')), '00000000-0000-0000-0000-000000000000') "Department"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."AO"')), '00000000-0000-0000-0000-000000000000') "AO"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Customer"')), '00000000-0000-0000-0000-000000000000') "Customer"
        , ISNULL(TRY_CONVERT(DATE,JSON_VALUE(data, N'$.PayDay'),127), TRY_CONVERT(DATE, '1970-01-01', 102)) "PayDay"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AR')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AR"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AR')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AR.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AR')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AR.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInBalance"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInBalance.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInBalance.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInAccounting"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInAccounting.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInAccounting.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountToPay')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountToPay"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountToPay')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountToPay.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountToPay')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountToPay.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountIsPaid')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountIsPaid"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountIsPaid')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountIsPaid.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountIsPaid')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountIsPaid.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.AR';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.AR] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.AR] ON [dbo].[Register.Accumulation.AR](
      company,date,calculated,id
    ) --ON [ps_ByMonth]([date])
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.Bank]
    WITH SCHEMABINDING
    AS
    SELECT
      id, ISNULL(parent, '00000000-0000-0000-0000-000000000000') parent, date, document, company, kind, calculated
        , ISNULL(TRY_CONVERT(NUMERIC(15,10), JSON_VALUE(data, N'$.exchangeRate')), 1) exchangeRate
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')), '00000000-0000-0000-0000-000000000000') "currency"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BankAccount"')), '00000000-0000-0000-0000-000000000000') "BankAccount"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashFlow"')), '00000000-0000-0000-0000-000000000000') "CashFlow"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"')), '00000000-0000-0000-0000-000000000000') "Analytics"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Amount"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Amount.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Amount.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInBalance"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInBalance.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInBalance.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInAccounting"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInAccounting.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInAccounting.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Bank';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Bank] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Bank] ON [dbo].[Register.Accumulation.Bank](
      company,date,calculated,id
    ) --ON [ps_ByMonth]([date])
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.Balance]
    WITH SCHEMABINDING
    AS
    SELECT
      id, ISNULL(parent, '00000000-0000-0000-0000-000000000000') parent, date, document, company, kind, calculated
        , ISNULL(TRY_CONVERT(NUMERIC(15,10), JSON_VALUE(data, N'$.exchangeRate')), 1) exchangeRate
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')), '00000000-0000-0000-0000-000000000000') "Department"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Balance"')), '00000000-0000-0000-0000-000000000000') "Balance"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"')), '00000000-0000-0000-0000-000000000000') "Analytics"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Amount"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Amount.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Amount.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Balance';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Balance] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Balance] ON [dbo].[Register.Accumulation.Balance](
      company,date,calculated,id
    ) --ON [ps_ByMonth]([date])
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.Cash]
    WITH SCHEMABINDING
    AS
    SELECT
      id, ISNULL(parent, '00000000-0000-0000-0000-000000000000') parent, date, document, company, kind, calculated
        , ISNULL(TRY_CONVERT(NUMERIC(15,10), JSON_VALUE(data, N'$.exchangeRate')), 1) exchangeRate
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')), '00000000-0000-0000-0000-000000000000') "currency"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashRegister"')), '00000000-0000-0000-0000-000000000000') "CashRegister"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashFlow"')), '00000000-0000-0000-0000-000000000000') "CashFlow"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"')), '00000000-0000-0000-0000-000000000000') "Analytics"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Amount"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Amount.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Amount.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInBalance"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInBalance.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInBalance.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInAccounting"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInAccounting.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInAccounting.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Cash';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Cash] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Cash] ON [dbo].[Register.Accumulation.Cash](
      company,date,calculated,id
    ) --ON [ps_ByMonth]([date])
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.Cash.Transit]
    WITH SCHEMABINDING
    AS
    SELECT
      id, ISNULL(parent, '00000000-0000-0000-0000-000000000000') parent, date, document, company, kind, calculated
        , ISNULL(TRY_CONVERT(NUMERIC(15,10), JSON_VALUE(data, N'$.exchangeRate')), 1) exchangeRate
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')), '00000000-0000-0000-0000-000000000000') "currency"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Sender"')), '00000000-0000-0000-0000-000000000000') "Sender"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Recipient"')), '00000000-0000-0000-0000-000000000000') "Recipient"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashFlow"')), '00000000-0000-0000-0000-000000000000') "CashFlow"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Amount"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Amount.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Amount.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInBalance"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInBalance.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInBalance.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInAccounting"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInAccounting.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInAccounting.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Cash.Transit';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Cash.Transit] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Cash.Transit] ON [dbo].[Register.Accumulation.Cash.Transit](
      company,date,calculated,id
    ) --ON [ps_ByMonth]([date])
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.Inventory]
    WITH SCHEMABINDING
    AS
    SELECT
      id, ISNULL(parent, '00000000-0000-0000-0000-000000000000') parent, date, document, company, kind, calculated
        , ISNULL(TRY_CONVERT(NUMERIC(15,10), JSON_VALUE(data, N'$.exchangeRate')), 1) exchangeRate
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."OperationType"')), '00000000-0000-0000-0000-000000000000') "OperationType"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Expense"')), '00000000-0000-0000-0000-000000000000') "Expense"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."ExpenseAnalytics"')), '00000000-0000-0000-0000-000000000000') "ExpenseAnalytics"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Income"')), '00000000-0000-0000-0000-000000000000') "Income"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."IncomeAnalytics"')), '00000000-0000-0000-0000-000000000000') "IncomeAnalytics"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BalanceIn"')), '00000000-0000-0000-0000-000000000000') "BalanceIn"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BalanceInAnalytics"')), '00000000-0000-0000-0000-000000000000') "BalanceInAnalytics"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BalanceOut"')), '00000000-0000-0000-0000-000000000000') "BalanceOut"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BalanceOutAnalytics"')), '00000000-0000-0000-0000-000000000000') "BalanceOutAnalytics"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Storehouse"')), '00000000-0000-0000-0000-000000000000') "Storehouse"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."SKU"')), '00000000-0000-0000-0000-000000000000') "SKU"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."batch"')), '00000000-0000-0000-0000-000000000000') "batch"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')), '00000000-0000-0000-0000-000000000000') "Department"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Cost')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Cost"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Cost')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Cost.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Cost')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Cost.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Qty')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Qty"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Qty')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Qty.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Qty')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Qty.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Inventory';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Inventory] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Inventory] ON [dbo].[Register.Accumulation.Inventory](
      company,date,calculated,id
    ) --ON [ps_ByMonth]([date])
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.Loan]
    WITH SCHEMABINDING
    AS
    SELECT
      id, ISNULL(parent, '00000000-0000-0000-0000-000000000000') parent, date, document, company, kind, calculated
        , ISNULL(TRY_CONVERT(NUMERIC(15,10), JSON_VALUE(data, N'$.exchangeRate')), 1) exchangeRate
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Loan"')), '00000000-0000-0000-0000-000000000000') "Loan"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Counterpartie"')), '00000000-0000-0000-0000-000000000000') "Counterpartie"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashFlow"')), '00000000-0000-0000-0000-000000000000') "CashFlow"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')), '00000000-0000-0000-0000-000000000000') "currency"
        , ISNULL(JSON_VALUE(data, '$.PaymentKind'), '') "PaymentKind" 

        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Amount"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Amount.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Amount.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInBalance"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInBalance.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInBalance.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInAccounting"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInAccounting.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInAccounting.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountToPay')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountToPay"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountToPay')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountToPay.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountToPay')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountToPay.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountIsPaid')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountIsPaid"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountIsPaid')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountIsPaid.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountIsPaid')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountIsPaid.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Loan';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Loan] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Loan] ON [dbo].[Register.Accumulation.Loan](
      company,date,calculated,id
    ) --ON [ps_ByMonth]([date])
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.PL]
    WITH SCHEMABINDING
    AS
    SELECT
      id, ISNULL(parent, '00000000-0000-0000-0000-000000000000') parent, date, document, company, kind, calculated
        , ISNULL(TRY_CONVERT(NUMERIC(15,10), JSON_VALUE(data, N'$.exchangeRate')), 1) exchangeRate
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')), '00000000-0000-0000-0000-000000000000') "Department"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."PL"')), '00000000-0000-0000-0000-000000000000') "PL"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"')), '00000000-0000-0000-0000-000000000000') "Analytics"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Amount"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Amount.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Amount.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.PL';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.PL] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.PL] ON [dbo].[Register.Accumulation.PL](
      company,date,calculated,id
    ) --ON [ps_ByMonth]([date])
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.Sales]
    WITH SCHEMABINDING
    AS
    SELECT
      id, ISNULL(parent, '00000000-0000-0000-0000-000000000000') parent, date, document, company, kind, calculated
        , ISNULL(TRY_CONVERT(NUMERIC(15,10), JSON_VALUE(data, N'$.exchangeRate')), 1) exchangeRate
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')), '00000000-0000-0000-0000-000000000000') "currency"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')), '00000000-0000-0000-0000-000000000000') "Department"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Customer"')), '00000000-0000-0000-0000-000000000000') "Customer"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Product"')), '00000000-0000-0000-0000-000000000000') "Product"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Manager"')), '00000000-0000-0000-0000-000000000000') "Manager"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."AO"')), '00000000-0000-0000-0000-000000000000') "AO"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Storehouse"')), '00000000-0000-0000-0000-000000000000') "Storehouse"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Cost')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Cost"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Cost')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Cost.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Cost')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Cost.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Qty')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Qty"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Qty')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Qty.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Qty')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Qty.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Amount"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Amount.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Amount.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Discount')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Discount"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Discount')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Discount.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Discount')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Discount.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Tax')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Tax"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Tax')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Tax.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Tax')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Tax.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInDoc')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInDoc"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInDoc')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInDoc.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInDoc')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInDoc.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAR')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInAR"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAR')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInAR.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAR')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInAR.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Sales';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Sales] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Sales] ON [dbo].[Register.Accumulation.Sales](
      company,date,calculated,id
    ) --ON [ps_ByMonth]([date])
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.Depreciation]
    WITH SCHEMABINDING
    AS
    SELECT
      id, ISNULL(parent, '00000000-0000-0000-0000-000000000000') parent, date, document, company, kind, calculated
        , ISNULL(TRY_CONVERT(NUMERIC(15,10), JSON_VALUE(data, N'$.exchangeRate')), 1) exchangeRate
        , ISNULL(JSON_VALUE(data, '$.BusinessOperation'), '') "BusinessOperation" 

        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')), '00000000-0000-0000-0000-000000000000') "currency"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')), '00000000-0000-0000-0000-000000000000') "Department"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."OE"')), '00000000-0000-0000-0000-000000000000') "OE"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Amount"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Amount.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Amount.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInBalance"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInBalance.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInBalance')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInBalance.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInAccounting"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInAccounting.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInAccounting.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.Depreciation';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Depreciation] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Depreciation] ON [dbo].[Register.Accumulation.Depreciation](
      company,date,calculated,id
    ) --ON [ps_ByMonth]([date])
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.CashToPay]
    WITH SCHEMABINDING
    AS
    SELECT
      id, ISNULL(parent, '00000000-0000-0000-0000-000000000000') parent, date, document, company, kind, calculated
        , ISNULL(TRY_CONVERT(NUMERIC(15,10), JSON_VALUE(data, N'$.exchangeRate')), 1) exchangeRate
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')), '00000000-0000-0000-0000-000000000000') "currency"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashFlow"')), '00000000-0000-0000-0000-000000000000') "CashFlow"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashRequest"')), '00000000-0000-0000-0000-000000000000') "CashRequest"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Contract"')), '00000000-0000-0000-0000-000000000000') "Contract"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')), '00000000-0000-0000-0000-000000000000') "Department"
        , ISNULL(JSON_VALUE(data, '$.OperationType'), '') "OperationType" 

        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Loan"')), '00000000-0000-0000-0000-000000000000') "Loan"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashOrBank"')), '00000000-0000-0000-0000-000000000000') "CashOrBank"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashRecipient"')), '00000000-0000-0000-0000-000000000000') "CashRecipient"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."ExpenseOrBalance"')), '00000000-0000-0000-0000-000000000000') "ExpenseOrBalance"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."ExpenseAnalytics"')), '00000000-0000-0000-0000-000000000000') "ExpenseAnalytics"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BalanceAnalytics"')), '00000000-0000-0000-0000-000000000000') "BalanceAnalytics"
        , ISNULL(TRY_CONVERT(DATE,JSON_VALUE(data, N'$.PayDay'),127), TRY_CONVERT(DATE, '1970-01-01', 102)) "PayDay"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Amount"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Amount.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Amount.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.CashToPay';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.CashToPay] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.CashToPay] ON [dbo].[Register.Accumulation.CashToPay](
      company,date,calculated,id
    ) --ON [ps_ByMonth]([date])
    GO
    
    CREATE OR ALTER VIEW [Register.Accumulation.BudgetItemTurnover]
    WITH SCHEMABINDING
    AS
    SELECT
      id, ISNULL(parent, '00000000-0000-0000-0000-000000000000') parent, date, document, company, kind, calculated
        , ISNULL(TRY_CONVERT(NUMERIC(15,10), JSON_VALUE(data, N'$.exchangeRate')), 1) exchangeRate
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')), '00000000-0000-0000-0000-000000000000') "Department"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Scenario"')), '00000000-0000-0000-0000-000000000000') "Scenario"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BudgetItem"')), '00000000-0000-0000-0000-000000000000') "BudgetItem"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Anatitic1"')), '00000000-0000-0000-0000-000000000000') "Anatitic1"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Anatitic2"')), '00000000-0000-0000-0000-000000000000') "Anatitic2"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Anatitic3"')), '00000000-0000-0000-0000-000000000000') "Anatitic3"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Anatitic4"')), '00000000-0000-0000-0000-000000000000') "Anatitic4"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Anatitic5"')), '00000000-0000-0000-0000-000000000000') "Anatitic5"
        , ISNULL(TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')), '00000000-0000-0000-0000-000000000000') "currency"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Amount"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Amount.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Amount.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInScenatio')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInScenatio"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInScenatio')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInScenatio.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInScenatio')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInScenatio.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInCurrency')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInCurrency"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInCurrency')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInCurrency.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInCurrency')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInCurrency.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "AmountInAccounting"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "AmountInAccounting.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountInAccounting')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "AmountInAccounting.Out"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Qty')) * IIF(kind = 1, 1, -1) AS MONEY), 0) "Qty"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Qty')) * IIF(kind = 1, 1, 0) AS MONEY), 0) "Qty.In"
        , ISNULL(CAST(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Qty')) * IIF(kind = 1, 0, 1) AS MONEY), 0) "Qty.Out"
      FROM dbo.[Accumulation] WHERE type = N'Register.Accumulation.BudgetItemTurnover';
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.BudgetItemTurnover] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.BudgetItemTurnover] ON [dbo].[Register.Accumulation.BudgetItemTurnover](
      company,date,calculated,id
    ) --ON [ps_ByMonth]([date])
    GO
    
    CREATE UNIQUE NONCLUSTERED INDEX [id.Register.Accumulation.Inventory] ON [dbo].[Register.Accumulation.Inventory]([id])
    GO
    EXEC [rpt].[CreateIndexReportHelper]
    GO
    