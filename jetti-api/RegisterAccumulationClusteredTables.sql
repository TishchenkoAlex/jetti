
    DROP INDEX IF EXISTS [Documents.parent] ON [dbo].[Documents];
    CREATE UNIQUE NONCLUSTERED INDEX [Documents.parent] ON [dbo].[Documents]([parent], [id]);
    
------------------------------ BEGIN Register.Accumulation.AccountablePersons ------------------------------

    RAISERROR('Register.Accumulation.AccountablePersons start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER TRIGGER [Register.Accumulation.AccountablePersons.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      DECLARE @COUNT_D BIGINT = (SELECT COUNT(*) FROM deleted WHERE type = N'Register.Accumulation.AccountablePersons');
      IF (@COUNT_D) > 0 DELETE FROM [Register.Accumulation.AccountablePersons] WHERE id IN (SELECT id FROM deleted);
      IF (@COUNT_D) = 1 DELETE FROM [Register.Accumulation.AccountablePersons] WHERE id = (SELECT id FROM deleted);
      DECLARE @COUNT_I BIGINT = (SELECT COUNT(*) FROM inserted WHERE type = N'Register.Accumulation.AccountablePersons');
      IF (@COUNT_D) = 0 RETURN;

      INSERT INTO [Register.Accumulation.AccountablePersons]
      SELECT
        r.id, r.parent, r.date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, [currency], [Employee], [CashFlow]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
      , d.[AmountToPay] * IIF(r.kind = 1, 1, -1) [AmountToPay], d.[AmountToPay] * IIF(r.kind = 1, 1, null) [AmountToPay.In], d.[AmountToPay] * IIF(r.kind = 1, null, 1) [AmountToPay.Out]
      , d.[AmountIsPaid] * IIF(r.kind = 1, 1, -1) [AmountIsPaid], d.[AmountIsPaid] * IIF(r.kind = 1, 1, null) [AmountIsPaid.In], d.[AmountIsPaid] * IIF(r.kind = 1, null, 1) [AmountIsPaid.Out]
        FROM inserted r
        CROSS APPLY OPENJSON (data, N'$')
        WITH (
          exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [currency] UNIQUEIDENTIFIER N'$.currency'
        , [Employee] UNIQUEIDENTIFIER N'$.Employee'
        , [CashFlow] UNIQUEIDENTIFIER N'$.CashFlow'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
        , [AmountToPay] MONEY N'$.AmountToPay'
        , [AmountIsPaid] MONEY N'$.AmountIsPaid'
        ) AS d
        WHERE r.type = N'Register.Accumulation.AccountablePersons';
    END
    GO
    
------------------------------ END Register.Accumulation.AccountablePersons ------------------------------

------------------------------ BEGIN Register.Accumulation.PaymentBatch ------------------------------

    RAISERROR('Register.Accumulation.PaymentBatch start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER TRIGGER [Register.Accumulation.PaymentBatch.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      DECLARE @COUNT_D BIGINT = (SELECT COUNT(*) FROM deleted WHERE type = N'Register.Accumulation.PaymentBatch');
      IF (@COUNT_D) > 0 DELETE FROM [Register.Accumulation.PaymentBatch] WHERE id IN (SELECT id FROM deleted);
      IF (@COUNT_D) = 1 DELETE FROM [Register.Accumulation.PaymentBatch] WHERE id = (SELECT id FROM deleted);
      DECLARE @COUNT_I BIGINT = (SELECT COUNT(*) FROM inserted WHERE type = N'Register.Accumulation.PaymentBatch');
      IF (@COUNT_D) = 0 RETURN;

      INSERT INTO [Register.Accumulation.PaymentBatch]
      SELECT
        r.id, r.parent, r.date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, [PaymentsKind], [Counterpartie], [ProductPackage], [Product], [Currency], [PayDay]
      , d.[Qty] * IIF(r.kind = 1, 1, -1) [Qty], d.[Qty] * IIF(r.kind = 1, 1, null) [Qty.In], d.[Qty] * IIF(r.kind = 1, null, 1) [Qty.Out]
      , d.[Price] * IIF(r.kind = 1, 1, -1) [Price], d.[Price] * IIF(r.kind = 1, 1, null) [Price.In], d.[Price] * IIF(r.kind = 1, null, 1) [Price.Out]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out], [batch]
        FROM inserted r
        CROSS APPLY OPENJSON (data, N'$')
        WITH (
          exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [PaymentsKind] NVARCHAR(250) N'$.PaymentsKind'
        , [Counterpartie] UNIQUEIDENTIFIER N'$.Counterpartie'
        , [ProductPackage] UNIQUEIDENTIFIER N'$.ProductPackage'
        , [Product] UNIQUEIDENTIFIER N'$.Product'
        , [Currency] UNIQUEIDENTIFIER N'$.Currency'
        , [PayDay] DATE N'$.PayDay'
        , [Qty] MONEY N'$.Qty'
        , [Price] MONEY N'$.Price'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [batch] UNIQUEIDENTIFIER N'$.batch'
        ) AS d
        WHERE r.type = N'Register.Accumulation.PaymentBatch';
    END
    GO
    
------------------------------ END Register.Accumulation.PaymentBatch ------------------------------

------------------------------ BEGIN Register.Accumulation.Investment.Analytics ------------------------------

    RAISERROR('Register.Accumulation.Investment.Analytics start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER TRIGGER [Register.Accumulation.Investment.Analytics.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      DECLARE @COUNT_D BIGINT = (SELECT COUNT(*) FROM deleted WHERE type = N'Register.Accumulation.Investment.Analytics');
      IF (@COUNT_D) > 0 DELETE FROM [Register.Accumulation.Investment.Analytics] WHERE id IN (SELECT id FROM deleted);
      IF (@COUNT_D) = 1 DELETE FROM [Register.Accumulation.Investment.Analytics] WHERE id = (SELECT id FROM deleted);
      DECLARE @COUNT_I BIGINT = (SELECT COUNT(*) FROM inserted WHERE type = N'Register.Accumulation.Investment.Analytics');
      IF (@COUNT_D) = 0 RETURN;

      INSERT INTO [Register.Accumulation.Investment.Analytics]
      SELECT
        r.id, r.parent, r.date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, [Department], [SourceTransaction], [CreditTransaction], [OperationType], [Investor], [CompanyProduct], [Product]
      , d.[Qty] * IIF(r.kind = 1, 1, -1) [Qty], d.[Qty] * IIF(r.kind = 1, 1, null) [Qty.In], d.[Qty] * IIF(r.kind = 1, null, 1) [Qty.Out], [CurrencyProduct]
      , d.[AmountProduct] * IIF(r.kind = 1, 1, -1) [AmountProduct], d.[AmountProduct] * IIF(r.kind = 1, 1, null) [AmountProduct.In], d.[AmountProduct] * IIF(r.kind = 1, null, 1) [AmountProduct.Out], [PaymentSource], [CurrencySource]
      , d.[AmountSource] * IIF(r.kind = 1, 1, -1) [AmountSource], d.[AmountSource] * IIF(r.kind = 1, 1, null) [AmountSource.In], d.[AmountSource] * IIF(r.kind = 1, null, 1) [AmountSource.Out], [CompanyLoan], [Loan], [CurrencyLoan]
      , d.[AmountLoan] * IIF(r.kind = 1, 1, -1) [AmountLoan], d.[AmountLoan] * IIF(r.kind = 1, 1, null) [AmountLoan.In], d.[AmountLoan] * IIF(r.kind = 1, null, 1) [AmountLoan.Out]
        FROM inserted r
        CROSS APPLY OPENJSON (data, N'$')
        WITH (
          exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [Department] UNIQUEIDENTIFIER N'$.Department'
        , [SourceTransaction] NVARCHAR(250) N'$.SourceTransaction'
        , [CreditTransaction] UNIQUEIDENTIFIER N'$.CreditTransaction'
        , [OperationType] UNIQUEIDENTIFIER N'$.OperationType'
        , [Investor] UNIQUEIDENTIFIER N'$.Investor'
        , [CompanyProduct] UNIQUEIDENTIFIER N'$.CompanyProduct'
        , [Product] UNIQUEIDENTIFIER N'$.Product'
        , [Qty] MONEY N'$.Qty'
        , [CurrencyProduct] UNIQUEIDENTIFIER N'$.CurrencyProduct'
        , [AmountProduct] MONEY N'$.AmountProduct'
        , [PaymentSource] UNIQUEIDENTIFIER N'$.PaymentSource'
        , [CurrencySource] UNIQUEIDENTIFIER N'$.CurrencySource'
        , [AmountSource] MONEY N'$.AmountSource'
        , [CompanyLoan] UNIQUEIDENTIFIER N'$.CompanyLoan'
        , [Loan] UNIQUEIDENTIFIER N'$.Loan'
        , [CurrencyLoan] UNIQUEIDENTIFIER N'$.CurrencyLoan'
        , [AmountLoan] MONEY N'$.AmountLoan'
        ) AS d
        WHERE r.type = N'Register.Accumulation.Investment.Analytics';
    END
    GO
    
------------------------------ END Register.Accumulation.Investment.Analytics ------------------------------

------------------------------ BEGIN Register.Accumulation.OrderPayment ------------------------------

    RAISERROR('Register.Accumulation.OrderPayment start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER TRIGGER [Register.Accumulation.OrderPayment.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      DECLARE @COUNT_D BIGINT = (SELECT COUNT(*) FROM deleted WHERE type = N'Register.Accumulation.OrderPayment');
      IF (@COUNT_D) > 0 DELETE FROM [Register.Accumulation.OrderPayment] WHERE id IN (SELECT id FROM deleted);
      IF (@COUNT_D) = 1 DELETE FROM [Register.Accumulation.OrderPayment] WHERE id = (SELECT id FROM deleted);
      DECLARE @COUNT_I BIGINT = (SELECT COUNT(*) FROM inserted WHERE type = N'Register.Accumulation.OrderPayment');
      IF (@COUNT_D) = 0 RETURN;

      INSERT INTO [Register.Accumulation.OrderPayment]
      SELECT
        r.id, r.parent, r.date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, [PaymantKind], [Customer], [BankAccount], [CashRegister], [AcquiringTerminal], [currency], [Department]
      , d.[CashShift] * IIF(r.kind = 1, 1, -1) [CashShift], d.[CashShift] * IIF(r.kind = 1, 1, null) [CashShift.In], d.[CashShift] * IIF(r.kind = 1, null, 1) [CashShift.Out]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
        FROM inserted r
        CROSS APPLY OPENJSON (data, N'$')
        WITH (
          exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [PaymantKind] NVARCHAR(250) N'$.PaymantKind'
        , [Customer] UNIQUEIDENTIFIER N'$.Customer'
        , [BankAccount] UNIQUEIDENTIFIER N'$.BankAccount'
        , [CashRegister] UNIQUEIDENTIFIER N'$.CashRegister'
        , [AcquiringTerminal] UNIQUEIDENTIFIER N'$.AcquiringTerminal'
        , [currency] UNIQUEIDENTIFIER N'$.currency'
        , [Department] UNIQUEIDENTIFIER N'$.Department'
        , [CashShift] MONEY N'$.CashShift'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
        ) AS d
        WHERE r.type = N'Register.Accumulation.OrderPayment';
    END
    GO
    
------------------------------ END Register.Accumulation.OrderPayment ------------------------------

------------------------------ BEGIN Register.Accumulation.AP ------------------------------

    RAISERROR('Register.Accumulation.AP start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER TRIGGER [Register.Accumulation.AP.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      DECLARE @COUNT_D BIGINT = (SELECT COUNT(*) FROM deleted WHERE type = N'Register.Accumulation.AP');
      IF (@COUNT_D) > 0 DELETE FROM [Register.Accumulation.AP] WHERE id IN (SELECT id FROM deleted);
      IF (@COUNT_D) = 1 DELETE FROM [Register.Accumulation.AP] WHERE id = (SELECT id FROM deleted);
      DECLARE @COUNT_I BIGINT = (SELECT COUNT(*) FROM inserted WHERE type = N'Register.Accumulation.AP');
      IF (@COUNT_D) = 0 RETURN;

      INSERT INTO [Register.Accumulation.AP]
      SELECT
        r.id, r.parent, r.date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, [currency], [Department], [AO], [Supplier], [PayDay]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
      , d.[AmountToPay] * IIF(r.kind = 1, 1, -1) [AmountToPay], d.[AmountToPay] * IIF(r.kind = 1, 1, null) [AmountToPay.In], d.[AmountToPay] * IIF(r.kind = 1, null, 1) [AmountToPay.Out]
      , d.[AmountIsPaid] * IIF(r.kind = 1, 1, -1) [AmountIsPaid], d.[AmountIsPaid] * IIF(r.kind = 1, 1, null) [AmountIsPaid.In], d.[AmountIsPaid] * IIF(r.kind = 1, null, 1) [AmountIsPaid.Out]
        FROM inserted r
        CROSS APPLY OPENJSON (data, N'$')
        WITH (
          exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [currency] UNIQUEIDENTIFIER N'$.currency'
        , [Department] UNIQUEIDENTIFIER N'$.Department'
        , [AO] UNIQUEIDENTIFIER N'$.AO'
        , [Supplier] UNIQUEIDENTIFIER N'$.Supplier'
        , [PayDay] DATE N'$.PayDay'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
        , [AmountToPay] MONEY N'$.AmountToPay'
        , [AmountIsPaid] MONEY N'$.AmountIsPaid'
        ) AS d
        WHERE r.type = N'Register.Accumulation.AP';
    END
    GO
    
------------------------------ END Register.Accumulation.AP ------------------------------

------------------------------ BEGIN Register.Accumulation.AR ------------------------------

    RAISERROR('Register.Accumulation.AR start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER TRIGGER [Register.Accumulation.AR.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      DECLARE @COUNT_D BIGINT = (SELECT COUNT(*) FROM deleted WHERE type = N'Register.Accumulation.AR');
      IF (@COUNT_D) > 0 DELETE FROM [Register.Accumulation.AR] WHERE id IN (SELECT id FROM deleted);
      IF (@COUNT_D) = 1 DELETE FROM [Register.Accumulation.AR] WHERE id = (SELECT id FROM deleted);
      DECLARE @COUNT_I BIGINT = (SELECT COUNT(*) FROM inserted WHERE type = N'Register.Accumulation.AR');
      IF (@COUNT_D) = 0 RETURN;

      INSERT INTO [Register.Accumulation.AR]
      SELECT
        r.id, r.parent, r.date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, [currency], [Department], [AO], [Customer], [PayDay]
      , d.[AR] * IIF(r.kind = 1, 1, -1) [AR], d.[AR] * IIF(r.kind = 1, 1, null) [AR.In], d.[AR] * IIF(r.kind = 1, null, 1) [AR.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
      , d.[AmountToPay] * IIF(r.kind = 1, 1, -1) [AmountToPay], d.[AmountToPay] * IIF(r.kind = 1, 1, null) [AmountToPay.In], d.[AmountToPay] * IIF(r.kind = 1, null, 1) [AmountToPay.Out]
      , d.[AmountIsPaid] * IIF(r.kind = 1, 1, -1) [AmountIsPaid], d.[AmountIsPaid] * IIF(r.kind = 1, 1, null) [AmountIsPaid.In], d.[AmountIsPaid] * IIF(r.kind = 1, null, 1) [AmountIsPaid.Out]
        FROM inserted r
        CROSS APPLY OPENJSON (data, N'$')
        WITH (
          exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [currency] UNIQUEIDENTIFIER N'$.currency'
        , [Department] UNIQUEIDENTIFIER N'$.Department'
        , [AO] UNIQUEIDENTIFIER N'$.AO'
        , [Customer] UNIQUEIDENTIFIER N'$.Customer'
        , [PayDay] DATE N'$.PayDay'
        , [AR] MONEY N'$.AR'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
        , [AmountToPay] MONEY N'$.AmountToPay'
        , [AmountIsPaid] MONEY N'$.AmountIsPaid'
        ) AS d
        WHERE r.type = N'Register.Accumulation.AR';
    END
    GO
    
------------------------------ END Register.Accumulation.AR ------------------------------

------------------------------ BEGIN Register.Accumulation.Bank ------------------------------

    RAISERROR('Register.Accumulation.Bank start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER TRIGGER [Register.Accumulation.Bank.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      DECLARE @COUNT_D BIGINT = (SELECT COUNT(*) FROM deleted WHERE type = N'Register.Accumulation.Bank');
      IF (@COUNT_D) > 0 DELETE FROM [Register.Accumulation.Bank] WHERE id IN (SELECT id FROM deleted);
      IF (@COUNT_D) = 1 DELETE FROM [Register.Accumulation.Bank] WHERE id = (SELECT id FROM deleted);
      DECLARE @COUNT_I BIGINT = (SELECT COUNT(*) FROM inserted WHERE type = N'Register.Accumulation.Bank');
      IF (@COUNT_D) = 0 RETURN;

      INSERT INTO [Register.Accumulation.Bank]
      SELECT
        r.id, r.parent, r.date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, [currency], [BankAccount], [CashFlow], [Analytics]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
        FROM inserted r
        CROSS APPLY OPENJSON (data, N'$')
        WITH (
          exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [currency] UNIQUEIDENTIFIER N'$.currency'
        , [BankAccount] UNIQUEIDENTIFIER N'$.BankAccount'
        , [CashFlow] UNIQUEIDENTIFIER N'$.CashFlow'
        , [Analytics] UNIQUEIDENTIFIER N'$.Analytics'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
        ) AS d
        WHERE r.type = N'Register.Accumulation.Bank';
    END
    GO
    
------------------------------ END Register.Accumulation.Bank ------------------------------

------------------------------ BEGIN Register.Accumulation.Balance ------------------------------

    RAISERROR('Register.Accumulation.Balance start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER TRIGGER [Register.Accumulation.Balance.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      DECLARE @COUNT_D BIGINT = (SELECT COUNT(*) FROM deleted WHERE type = N'Register.Accumulation.Balance');
      IF (@COUNT_D) > 0 DELETE FROM [Register.Accumulation.Balance] WHERE id IN (SELECT id FROM deleted);
      IF (@COUNT_D) = 1 DELETE FROM [Register.Accumulation.Balance] WHERE id = (SELECT id FROM deleted);
      DECLARE @COUNT_I BIGINT = (SELECT COUNT(*) FROM inserted WHERE type = N'Register.Accumulation.Balance');
      IF (@COUNT_D) = 0 RETURN;

      INSERT INTO [Register.Accumulation.Balance]
      SELECT
        r.id, r.parent, r.date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, [Department], [Balance], [Analytics]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out], [Info]
        FROM inserted r
        CROSS APPLY OPENJSON (data, N'$')
        WITH (
          exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [Department] UNIQUEIDENTIFIER N'$.Department'
        , [Balance] UNIQUEIDENTIFIER N'$.Balance'
        , [Analytics] UNIQUEIDENTIFIER N'$.Analytics'
        , [Amount] MONEY N'$.Amount'
        , [Info] NVARCHAR(250) N'$.Info'
        ) AS d
        WHERE r.type = N'Register.Accumulation.Balance';
    END
    GO
    
------------------------------ END Register.Accumulation.Balance ------------------------------

------------------------------ BEGIN Register.Accumulation.Balance.RC ------------------------------

    RAISERROR('Register.Accumulation.Balance.RC start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER TRIGGER [Register.Accumulation.Balance.RC.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      DECLARE @COUNT_D BIGINT = (SELECT COUNT(*) FROM deleted WHERE type = N'Register.Accumulation.Balance.RC');
      IF (@COUNT_D) > 0 DELETE FROM [Register.Accumulation.Balance.RC] WHERE id IN (SELECT id FROM deleted);
      IF (@COUNT_D) = 1 DELETE FROM [Register.Accumulation.Balance.RC] WHERE id = (SELECT id FROM deleted);
      DECLARE @COUNT_I BIGINT = (SELECT COUNT(*) FROM inserted WHERE type = N'Register.Accumulation.Balance.RC');
      IF (@COUNT_D) = 0 RETURN;

      INSERT INTO [Register.Accumulation.Balance.RC]
      SELECT
        r.id, r.parent, r.date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, [ResponsibilityCenter], [Department], [Balance], [Analytics], [Analytics2], [Currency]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountRC] * IIF(r.kind = 1, 1, -1) [AmountRC], d.[AmountRC] * IIF(r.kind = 1, 1, null) [AmountRC.In], d.[AmountRC] * IIF(r.kind = 1, null, 1) [AmountRC.Out], [Info]
        FROM inserted r
        CROSS APPLY OPENJSON (data, N'$')
        WITH (
          exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [ResponsibilityCenter] UNIQUEIDENTIFIER N'$.ResponsibilityCenter'
        , [Department] UNIQUEIDENTIFIER N'$.Department'
        , [Balance] UNIQUEIDENTIFIER N'$.Balance'
        , [Analytics] UNIQUEIDENTIFIER N'$.Analytics'
        , [Analytics2] UNIQUEIDENTIFIER N'$.Analytics2'
        , [Currency] UNIQUEIDENTIFIER N'$.Currency'
        , [Amount] MONEY N'$.Amount'
        , [AmountRC] MONEY N'$.AmountRC'
        , [Info] NVARCHAR(250) N'$.Info'
        ) AS d
        WHERE r.type = N'Register.Accumulation.Balance.RC';
    END
    GO
    
------------------------------ END Register.Accumulation.Balance.RC ------------------------------

------------------------------ BEGIN Register.Accumulation.Balance.Report ------------------------------

    RAISERROR('Register.Accumulation.Balance.Report start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER TRIGGER [Register.Accumulation.Balance.Report.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      DECLARE @COUNT_D BIGINT = (SELECT COUNT(*) FROM deleted WHERE type = N'Register.Accumulation.Balance.Report');
      IF (@COUNT_D) > 0 DELETE FROM [Register.Accumulation.Balance.Report] WHERE id IN (SELECT id FROM deleted);
      IF (@COUNT_D) = 1 DELETE FROM [Register.Accumulation.Balance.Report] WHERE id = (SELECT id FROM deleted);
      DECLARE @COUNT_I BIGINT = (SELECT COUNT(*) FROM inserted WHERE type = N'Register.Accumulation.Balance.Report');
      IF (@COUNT_D) = 0 RETURN;

      INSERT INTO [Register.Accumulation.Balance.Report]
      SELECT
        r.id, r.parent, r.date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, [currency], [Department], [Balance], [Analytics]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out], [Info]
        FROM inserted r
        CROSS APPLY OPENJSON (data, N'$')
        WITH (
          exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [currency] UNIQUEIDENTIFIER N'$.currency'
        , [Department] UNIQUEIDENTIFIER N'$.Department'
        , [Balance] UNIQUEIDENTIFIER N'$.Balance'
        , [Analytics] UNIQUEIDENTIFIER N'$.Analytics'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
        , [Info] NVARCHAR(250) N'$.Info'
        ) AS d
        WHERE r.type = N'Register.Accumulation.Balance.Report';
    END
    GO
    
------------------------------ END Register.Accumulation.Balance.Report ------------------------------

------------------------------ BEGIN Register.Accumulation.Cash ------------------------------

    RAISERROR('Register.Accumulation.Cash start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER TRIGGER [Register.Accumulation.Cash.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      DECLARE @COUNT_D BIGINT = (SELECT COUNT(*) FROM deleted WHERE type = N'Register.Accumulation.Cash');
      IF (@COUNT_D) > 0 DELETE FROM [Register.Accumulation.Cash] WHERE id IN (SELECT id FROM deleted);
      IF (@COUNT_D) = 1 DELETE FROM [Register.Accumulation.Cash] WHERE id = (SELECT id FROM deleted);
      DECLARE @COUNT_I BIGINT = (SELECT COUNT(*) FROM inserted WHERE type = N'Register.Accumulation.Cash');
      IF (@COUNT_D) = 0 RETURN;

      INSERT INTO [Register.Accumulation.Cash]
      SELECT
        r.id, r.parent, r.date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, [currency], [CashRegister], [CashFlow], [Analytics]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
        FROM inserted r
        CROSS APPLY OPENJSON (data, N'$')
        WITH (
          exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [currency] UNIQUEIDENTIFIER N'$.currency'
        , [CashRegister] UNIQUEIDENTIFIER N'$.CashRegister'
        , [CashFlow] UNIQUEIDENTIFIER N'$.CashFlow'
        , [Analytics] UNIQUEIDENTIFIER N'$.Analytics'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
        ) AS d
        WHERE r.type = N'Register.Accumulation.Cash';
    END
    GO
    
------------------------------ END Register.Accumulation.Cash ------------------------------

------------------------------ BEGIN Register.Accumulation.Cash.Transit ------------------------------

    RAISERROR('Register.Accumulation.Cash.Transit start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER TRIGGER [Register.Accumulation.Cash.Transit.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      DECLARE @COUNT_D BIGINT = (SELECT COUNT(*) FROM deleted WHERE type = N'Register.Accumulation.Cash.Transit');
      IF (@COUNT_D) > 0 DELETE FROM [Register.Accumulation.Cash.Transit] WHERE id IN (SELECT id FROM deleted);
      IF (@COUNT_D) = 1 DELETE FROM [Register.Accumulation.Cash.Transit] WHERE id = (SELECT id FROM deleted);
      DECLARE @COUNT_I BIGINT = (SELECT COUNT(*) FROM inserted WHERE type = N'Register.Accumulation.Cash.Transit');
      IF (@COUNT_D) = 0 RETURN;

      INSERT INTO [Register.Accumulation.Cash.Transit]
      SELECT
        r.id, r.parent, r.date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, [CompanyRecipient], [currency], [Sender], [Recipient], [CashFlow]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
        FROM inserted r
        CROSS APPLY OPENJSON (data, N'$')
        WITH (
          exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [CompanyRecipient] UNIQUEIDENTIFIER N'$.CompanyRecipient'
        , [currency] UNIQUEIDENTIFIER N'$.currency'
        , [Sender] UNIQUEIDENTIFIER N'$.Sender'
        , [Recipient] UNIQUEIDENTIFIER N'$.Recipient'
        , [CashFlow] UNIQUEIDENTIFIER N'$.CashFlow'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
        ) AS d
        WHERE r.type = N'Register.Accumulation.Cash.Transit';
    END
    GO
    
------------------------------ END Register.Accumulation.Cash.Transit ------------------------------

------------------------------ BEGIN Register.Accumulation.EmployeeTimekeeping ------------------------------

    RAISERROR('Register.Accumulation.EmployeeTimekeeping start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER TRIGGER [Register.Accumulation.EmployeeTimekeeping.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      DECLARE @COUNT_D BIGINT = (SELECT COUNT(*) FROM deleted WHERE type = N'Register.Accumulation.EmployeeTimekeeping');
      IF (@COUNT_D) > 0 DELETE FROM [Register.Accumulation.EmployeeTimekeeping] WHERE id IN (SELECT id FROM deleted);
      IF (@COUNT_D) = 1 DELETE FROM [Register.Accumulation.EmployeeTimekeeping] WHERE id = (SELECT id FROM deleted);
      DECLARE @COUNT_I BIGINT = (SELECT COUNT(*) FROM inserted WHERE type = N'Register.Accumulation.EmployeeTimekeeping');
      IF (@COUNT_D) = 0 RETURN;

      INSERT INTO [Register.Accumulation.EmployeeTimekeeping]
      SELECT
        r.id, r.parent, r.date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, [isActive], [PeriodMonth], [KindTimekeeping], [Employee], [Person], [StaffingTable]
      , d.[Days] * IIF(r.kind = 1, 1, -1) [Days], d.[Days] * IIF(r.kind = 1, 1, null) [Days.In], d.[Days] * IIF(r.kind = 1, null, 1) [Days.Out]
      , d.[Hours] * IIF(r.kind = 1, 1, -1) [Hours], d.[Hours] * IIF(r.kind = 1, 1, null) [Hours.In], d.[Hours] * IIF(r.kind = 1, null, 1) [Hours.Out]
        FROM inserted r
        CROSS APPLY OPENJSON (data, N'$')
        WITH (
          exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [isActive] BIT N'$.isActive'
        , [PeriodMonth] DATE N'$.PeriodMonth'
        , [KindTimekeeping] NVARCHAR(250) N'$.KindTimekeeping'
        , [Employee] UNIQUEIDENTIFIER N'$.Employee'
        , [Person] UNIQUEIDENTIFIER N'$.Person'
        , [StaffingTable] UNIQUEIDENTIFIER N'$.StaffingTable'
        , [Days] MONEY N'$.Days'
        , [Hours] MONEY N'$.Hours'
        ) AS d
        WHERE r.type = N'Register.Accumulation.EmployeeTimekeeping';
    END
    GO
    
------------------------------ END Register.Accumulation.EmployeeTimekeeping ------------------------------

------------------------------ BEGIN Register.Accumulation.Inventory ------------------------------

    RAISERROR('Register.Accumulation.Inventory start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER TRIGGER [Register.Accumulation.Inventory.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      DECLARE @COUNT_D BIGINT = (SELECT COUNT(*) FROM deleted WHERE type = N'Register.Accumulation.Inventory');
      IF (@COUNT_D) > 0 DELETE FROM [Register.Accumulation.Inventory] WHERE id IN (SELECT id FROM deleted);
      IF (@COUNT_D) = 1 DELETE FROM [Register.Accumulation.Inventory] WHERE id = (SELECT id FROM deleted);
      DECLARE @COUNT_I BIGINT = (SELECT COUNT(*) FROM inserted WHERE type = N'Register.Accumulation.Inventory');
      IF (@COUNT_D) = 0 RETURN;

      INSERT INTO [Register.Accumulation.Inventory]
      SELECT
        r.id, r.parent, r.date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, [OperationType], [Expense], [ExpenseAnalytics], [Income], [IncomeAnalytics], [BalanceIn], [BalanceInAnalytics], [BalanceOut], [BalanceOutAnalytics], [Storehouse], [SKU], [batch], [Department]
      , d.[Cost] * IIF(r.kind = 1, 1, -1) [Cost], d.[Cost] * IIF(r.kind = 1, 1, null) [Cost.In], d.[Cost] * IIF(r.kind = 1, null, 1) [Cost.Out]
      , d.[Qty] * IIF(r.kind = 1, 1, -1) [Qty], d.[Qty] * IIF(r.kind = 1, 1, null) [Qty.In], d.[Qty] * IIF(r.kind = 1, null, 1) [Qty.Out]
        FROM inserted r
        CROSS APPLY OPENJSON (data, N'$')
        WITH (
          exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [OperationType] UNIQUEIDENTIFIER N'$.OperationType'
        , [Expense] UNIQUEIDENTIFIER N'$.Expense'
        , [ExpenseAnalytics] UNIQUEIDENTIFIER N'$.ExpenseAnalytics'
        , [Income] UNIQUEIDENTIFIER N'$.Income'
        , [IncomeAnalytics] UNIQUEIDENTIFIER N'$.IncomeAnalytics'
        , [BalanceIn] UNIQUEIDENTIFIER N'$.BalanceIn'
        , [BalanceInAnalytics] UNIQUEIDENTIFIER N'$.BalanceInAnalytics'
        , [BalanceOut] UNIQUEIDENTIFIER N'$.BalanceOut'
        , [BalanceOutAnalytics] UNIQUEIDENTIFIER N'$.BalanceOutAnalytics'
        , [Storehouse] UNIQUEIDENTIFIER N'$.Storehouse'
        , [SKU] UNIQUEIDENTIFIER N'$.SKU'
        , [batch] UNIQUEIDENTIFIER N'$.batch'
        , [Department] UNIQUEIDENTIFIER N'$.Department'
        , [Cost] MONEY N'$.Cost'
        , [Qty] MONEY N'$.Qty'
        ) AS d
        WHERE r.type = N'Register.Accumulation.Inventory';
    END
    GO
    
------------------------------ END Register.Accumulation.Inventory ------------------------------

------------------------------ BEGIN Register.Accumulation.Loan ------------------------------

    RAISERROR('Register.Accumulation.Loan start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER TRIGGER [Register.Accumulation.Loan.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      DECLARE @COUNT_D BIGINT = (SELECT COUNT(*) FROM deleted WHERE type = N'Register.Accumulation.Loan');
      IF (@COUNT_D) > 0 DELETE FROM [Register.Accumulation.Loan] WHERE id IN (SELECT id FROM deleted);
      IF (@COUNT_D) = 1 DELETE FROM [Register.Accumulation.Loan] WHERE id = (SELECT id FROM deleted);
      DECLARE @COUNT_I BIGINT = (SELECT COUNT(*) FROM inserted WHERE type = N'Register.Accumulation.Loan');
      IF (@COUNT_D) = 0 RETURN;

      INSERT INTO [Register.Accumulation.Loan]
      SELECT
        r.id, r.parent, r.date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, [Loan], [Counterpartie], [CashFlow], [currency], [PaymentKind]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
      , d.[AmountToPay] * IIF(r.kind = 1, 1, -1) [AmountToPay], d.[AmountToPay] * IIF(r.kind = 1, 1, null) [AmountToPay.In], d.[AmountToPay] * IIF(r.kind = 1, null, 1) [AmountToPay.Out]
      , d.[AmountIsPaid] * IIF(r.kind = 1, 1, -1) [AmountIsPaid], d.[AmountIsPaid] * IIF(r.kind = 1, 1, null) [AmountIsPaid.In], d.[AmountIsPaid] * IIF(r.kind = 1, null, 1) [AmountIsPaid.Out]
        FROM inserted r
        CROSS APPLY OPENJSON (data, N'$')
        WITH (
          exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [Loan] UNIQUEIDENTIFIER N'$.Loan'
        , [Counterpartie] UNIQUEIDENTIFIER N'$.Counterpartie'
        , [CashFlow] UNIQUEIDENTIFIER N'$.CashFlow'
        , [currency] UNIQUEIDENTIFIER N'$.currency'
        , [PaymentKind] NVARCHAR(250) N'$.PaymentKind'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
        , [AmountToPay] MONEY N'$.AmountToPay'
        , [AmountIsPaid] MONEY N'$.AmountIsPaid'
        ) AS d
        WHERE r.type = N'Register.Accumulation.Loan';
    END
    GO
    
------------------------------ END Register.Accumulation.Loan ------------------------------

------------------------------ BEGIN Register.Accumulation.PL ------------------------------

    RAISERROR('Register.Accumulation.PL start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER TRIGGER [Register.Accumulation.PL.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      DECLARE @COUNT_D BIGINT = (SELECT COUNT(*) FROM deleted WHERE type = N'Register.Accumulation.PL');
      IF (@COUNT_D) > 0 DELETE FROM [Register.Accumulation.PL] WHERE id IN (SELECT id FROM deleted);
      IF (@COUNT_D) = 1 DELETE FROM [Register.Accumulation.PL] WHERE id = (SELECT id FROM deleted);
      DECLARE @COUNT_I BIGINT = (SELECT COUNT(*) FROM inserted WHERE type = N'Register.Accumulation.PL');
      IF (@COUNT_D) = 0 RETURN;

      INSERT INTO [Register.Accumulation.PL]
      SELECT
        r.id, r.parent, r.date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, [Department], [PL], [Analytics], [Analytics2]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out], [Info]
        FROM inserted r
        CROSS APPLY OPENJSON (data, N'$')
        WITH (
          exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [Department] UNIQUEIDENTIFIER N'$.Department'
        , [PL] UNIQUEIDENTIFIER N'$.PL'
        , [Analytics] UNIQUEIDENTIFIER N'$.Analytics'
        , [Analytics2] UNIQUEIDENTIFIER N'$.Analytics2'
        , [Amount] MONEY N'$.Amount'
        , [Info] NVARCHAR(250) N'$.Info'
        ) AS d
        WHERE r.type = N'Register.Accumulation.PL';
    END
    GO
    
------------------------------ END Register.Accumulation.PL ------------------------------

------------------------------ BEGIN Register.Accumulation.PL.RC ------------------------------

    RAISERROR('Register.Accumulation.PL.RC start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER TRIGGER [Register.Accumulation.PL.RC.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      DECLARE @COUNT_D BIGINT = (SELECT COUNT(*) FROM deleted WHERE type = N'Register.Accumulation.PL.RC');
      IF (@COUNT_D) > 0 DELETE FROM [Register.Accumulation.PL.RC] WHERE id IN (SELECT id FROM deleted);
      IF (@COUNT_D) = 1 DELETE FROM [Register.Accumulation.PL.RC] WHERE id = (SELECT id FROM deleted);
      DECLARE @COUNT_I BIGINT = (SELECT COUNT(*) FROM inserted WHERE type = N'Register.Accumulation.PL.RC');
      IF (@COUNT_D) = 0 RETURN;

      INSERT INTO [Register.Accumulation.PL.RC]
      SELECT
        r.id, r.parent, r.date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, [ResponsibilityCenter], [Department], [PL], [Analytics], [Analytics2], [Currency]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountRC] * IIF(r.kind = 1, 1, -1) [AmountRC], d.[AmountRC] * IIF(r.kind = 1, 1, null) [AmountRC.In], d.[AmountRC] * IIF(r.kind = 1, null, 1) [AmountRC.Out], [Info]
        FROM inserted r
        CROSS APPLY OPENJSON (data, N'$')
        WITH (
          exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [ResponsibilityCenter] UNIQUEIDENTIFIER N'$.ResponsibilityCenter'
        , [Department] UNIQUEIDENTIFIER N'$.Department'
        , [PL] UNIQUEIDENTIFIER N'$.PL'
        , [Analytics] UNIQUEIDENTIFIER N'$.Analytics'
        , [Analytics2] UNIQUEIDENTIFIER N'$.Analytics2'
        , [Currency] UNIQUEIDENTIFIER N'$.Currency'
        , [Amount] MONEY N'$.Amount'
        , [AmountRC] MONEY N'$.AmountRC'
        , [Info] NVARCHAR(250) N'$.Info'
        ) AS d
        WHERE r.type = N'Register.Accumulation.PL.RC';
    END
    GO
    
------------------------------ END Register.Accumulation.PL.RC ------------------------------

------------------------------ BEGIN Register.Accumulation.Sales ------------------------------

    RAISERROR('Register.Accumulation.Sales start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER TRIGGER [Register.Accumulation.Sales.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      DECLARE @COUNT_D BIGINT = (SELECT COUNT(*) FROM deleted WHERE type = N'Register.Accumulation.Sales');
      IF (@COUNT_D) > 0 DELETE FROM [Register.Accumulation.Sales] WHERE id IN (SELECT id FROM deleted);
      IF (@COUNT_D) = 1 DELETE FROM [Register.Accumulation.Sales] WHERE id = (SELECT id FROM deleted);
      DECLARE @COUNT_I BIGINT = (SELECT COUNT(*) FROM inserted WHERE type = N'Register.Accumulation.Sales');
      IF (@COUNT_D) = 0 RETURN;

      INSERT INTO [Register.Accumulation.Sales]
      SELECT
        r.id, r.parent, r.date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, [currency], [Department], [Customer], [Product], [Analytic], [Manager], [DeliveryType], [OrderSource], [RetailClient], [AO], [Storehouse], [OpenTime], [PrintTime], [DeliverTime], [BillTime], [CloseTime]
      , d.[CashShift] * IIF(r.kind = 1, 1, -1) [CashShift], d.[CashShift] * IIF(r.kind = 1, 1, null) [CashShift.In], d.[CashShift] * IIF(r.kind = 1, null, 1) [CashShift.Out]
      , d.[Cost] * IIF(r.kind = 1, 1, -1) [Cost], d.[Cost] * IIF(r.kind = 1, 1, null) [Cost.In], d.[Cost] * IIF(r.kind = 1, null, 1) [Cost.Out]
      , d.[Qty] * IIF(r.kind = 1, 1, -1) [Qty], d.[Qty] * IIF(r.kind = 1, 1, null) [Qty.In], d.[Qty] * IIF(r.kind = 1, null, 1) [Qty.Out]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[Discount] * IIF(r.kind = 1, 1, -1) [Discount], d.[Discount] * IIF(r.kind = 1, 1, null) [Discount.In], d.[Discount] * IIF(r.kind = 1, null, 1) [Discount.Out]
      , d.[Tax] * IIF(r.kind = 1, 1, -1) [Tax], d.[Tax] * IIF(r.kind = 1, 1, null) [Tax.In], d.[Tax] * IIF(r.kind = 1, null, 1) [Tax.Out]
      , d.[AmountInDoc] * IIF(r.kind = 1, 1, -1) [AmountInDoc], d.[AmountInDoc] * IIF(r.kind = 1, 1, null) [AmountInDoc.In], d.[AmountInDoc] * IIF(r.kind = 1, null, 1) [AmountInDoc.Out]
      , d.[AmountInAR] * IIF(r.kind = 1, 1, -1) [AmountInAR], d.[AmountInAR] * IIF(r.kind = 1, 1, null) [AmountInAR.In], d.[AmountInAR] * IIF(r.kind = 1, null, 1) [AmountInAR.Out]
        FROM inserted r
        CROSS APPLY OPENJSON (data, N'$')
        WITH (
          exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [currency] UNIQUEIDENTIFIER N'$.currency'
        , [Department] UNIQUEIDENTIFIER N'$.Department'
        , [Customer] UNIQUEIDENTIFIER N'$.Customer'
        , [Product] UNIQUEIDENTIFIER N'$.Product'
        , [Analytic] UNIQUEIDENTIFIER N'$.Analytic'
        , [Manager] UNIQUEIDENTIFIER N'$.Manager'
        , [DeliveryType] NVARCHAR(250) N'$.DeliveryType'
        , [OrderSource] NVARCHAR(250) N'$.OrderSource'
        , [RetailClient] UNIQUEIDENTIFIER N'$.RetailClient'
        , [AO] UNIQUEIDENTIFIER N'$.AO'
        , [Storehouse] UNIQUEIDENTIFIER N'$.Storehouse'
        , [OpenTime] DATETIME N'$.OpenTime'
        , [PrintTime] DATETIME N'$.PrintTime'
        , [DeliverTime] DATETIME N'$.DeliverTime'
        , [BillTime] DATETIME N'$.BillTime'
        , [CloseTime] DATETIME N'$.CloseTime'
        , [CashShift] MONEY N'$.CashShift'
        , [Cost] MONEY N'$.Cost'
        , [Qty] MONEY N'$.Qty'
        , [Amount] MONEY N'$.Amount'
        , [Discount] MONEY N'$.Discount'
        , [Tax] MONEY N'$.Tax'
        , [AmountInDoc] MONEY N'$.AmountInDoc'
        , [AmountInAR] MONEY N'$.AmountInAR'
        ) AS d
        WHERE r.type = N'Register.Accumulation.Sales';
    END
    GO
    
------------------------------ END Register.Accumulation.Sales ------------------------------

------------------------------ BEGIN Register.Accumulation.Salary ------------------------------

    RAISERROR('Register.Accumulation.Salary start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER TRIGGER [Register.Accumulation.Salary.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      DECLARE @COUNT_D BIGINT = (SELECT COUNT(*) FROM deleted WHERE type = N'Register.Accumulation.Salary');
      IF (@COUNT_D) > 0 DELETE FROM [Register.Accumulation.Salary] WHERE id IN (SELECT id FROM deleted);
      IF (@COUNT_D) = 1 DELETE FROM [Register.Accumulation.Salary] WHERE id = (SELECT id FROM deleted);
      DECLARE @COUNT_I BIGINT = (SELECT COUNT(*) FROM inserted WHERE type = N'Register.Accumulation.Salary');
      IF (@COUNT_D) = 0 RETURN;

      INSERT INTO [Register.Accumulation.Salary]
      SELECT
        r.id, r.parent, r.date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, [currency], [KorrCompany], [Department], [Person], [Employee], [SalaryKind], [Analytics], [PL], [PLAnalytics], [Status], [IsPortal]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
        FROM inserted r
        CROSS APPLY OPENJSON (data, N'$')
        WITH (
          exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [currency] UNIQUEIDENTIFIER N'$.currency'
        , [KorrCompany] UNIQUEIDENTIFIER N'$.KorrCompany'
        , [Department] UNIQUEIDENTIFIER N'$.Department'
        , [Person] UNIQUEIDENTIFIER N'$.Person'
        , [Employee] UNIQUEIDENTIFIER N'$.Employee'
        , [SalaryKind] NVARCHAR(250) N'$.SalaryKind'
        , [Analytics] UNIQUEIDENTIFIER N'$.Analytics'
        , [PL] UNIQUEIDENTIFIER N'$.PL'
        , [PLAnalytics] UNIQUEIDENTIFIER N'$.PLAnalytics'
        , [Status] NVARCHAR(250) N'$.Status'
        , [IsPortal] BIT N'$.IsPortal'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
        ) AS d
        WHERE r.type = N'Register.Accumulation.Salary';
    END
    GO
    
------------------------------ END Register.Accumulation.Salary ------------------------------

------------------------------ BEGIN Register.Accumulation.Depreciation ------------------------------

    RAISERROR('Register.Accumulation.Depreciation start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER TRIGGER [Register.Accumulation.Depreciation.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      DECLARE @COUNT_D BIGINT = (SELECT COUNT(*) FROM deleted WHERE type = N'Register.Accumulation.Depreciation');
      IF (@COUNT_D) > 0 DELETE FROM [Register.Accumulation.Depreciation] WHERE id IN (SELECT id FROM deleted);
      IF (@COUNT_D) = 1 DELETE FROM [Register.Accumulation.Depreciation] WHERE id = (SELECT id FROM deleted);
      DECLARE @COUNT_I BIGINT = (SELECT COUNT(*) FROM inserted WHERE type = N'Register.Accumulation.Depreciation');
      IF (@COUNT_D) = 0 RETURN;

      INSERT INTO [Register.Accumulation.Depreciation]
      SELECT
        r.id, r.parent, r.date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, [OperationType], [currency], [Department], [ResponsiblePerson], [OE]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
        FROM inserted r
        CROSS APPLY OPENJSON (data, N'$')
        WITH (
          exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [OperationType] UNIQUEIDENTIFIER N'$.OperationType'
        , [currency] UNIQUEIDENTIFIER N'$.currency'
        , [Department] UNIQUEIDENTIFIER N'$.Department'
        , [ResponsiblePerson] UNIQUEIDENTIFIER N'$.ResponsiblePerson'
        , [OE] UNIQUEIDENTIFIER N'$.OE'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
        ) AS d
        WHERE r.type = N'Register.Accumulation.Depreciation';
    END
    GO
    
------------------------------ END Register.Accumulation.Depreciation ------------------------------

------------------------------ BEGIN Register.Accumulation.CashToPay ------------------------------

    RAISERROR('Register.Accumulation.CashToPay start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER TRIGGER [Register.Accumulation.CashToPay.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      DECLARE @COUNT_D BIGINT = (SELECT COUNT(*) FROM deleted WHERE type = N'Register.Accumulation.CashToPay');
      IF (@COUNT_D) > 0 DELETE FROM [Register.Accumulation.CashToPay] WHERE id IN (SELECT id FROM deleted);
      IF (@COUNT_D) = 1 DELETE FROM [Register.Accumulation.CashToPay] WHERE id = (SELECT id FROM deleted);
      DECLARE @COUNT_I BIGINT = (SELECT COUNT(*) FROM inserted WHERE type = N'Register.Accumulation.CashToPay');
      IF (@COUNT_D) = 0 RETURN;

      INSERT INTO [Register.Accumulation.CashToPay]
      SELECT
        r.id, r.parent, r.date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, [currency], [CashFlow], [CashRequest], [Contract], [BankAccountPerson], [Department], [OperationType], [Loan], [CashOrBank], [CashRecipient], [ExpenseOrBalance], [ExpenseAnalytics], [BalanceAnalytics], [PayDay]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
        FROM inserted r
        CROSS APPLY OPENJSON (data, N'$')
        WITH (
          exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [currency] UNIQUEIDENTIFIER N'$.currency'
        , [CashFlow] UNIQUEIDENTIFIER N'$.CashFlow'
        , [CashRequest] UNIQUEIDENTIFIER N'$.CashRequest'
        , [Contract] UNIQUEIDENTIFIER N'$.Contract'
        , [BankAccountPerson] UNIQUEIDENTIFIER N'$.BankAccountPerson'
        , [Department] UNIQUEIDENTIFIER N'$.Department'
        , [OperationType] NVARCHAR(250) N'$.OperationType'
        , [Loan] UNIQUEIDENTIFIER N'$.Loan'
        , [CashOrBank] UNIQUEIDENTIFIER N'$.CashOrBank'
        , [CashRecipient] UNIQUEIDENTIFIER N'$.CashRecipient'
        , [ExpenseOrBalance] UNIQUEIDENTIFIER N'$.ExpenseOrBalance'
        , [ExpenseAnalytics] UNIQUEIDENTIFIER N'$.ExpenseAnalytics'
        , [BalanceAnalytics] UNIQUEIDENTIFIER N'$.BalanceAnalytics'
        , [PayDay] DATE N'$.PayDay'
        , [Amount] MONEY N'$.Amount'
        ) AS d
        WHERE r.type = N'Register.Accumulation.CashToPay';
    END
    GO
    
------------------------------ END Register.Accumulation.CashToPay ------------------------------

------------------------------ BEGIN Register.Accumulation.BudgetItemTurnover ------------------------------

    RAISERROR('Register.Accumulation.BudgetItemTurnover start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER TRIGGER [Register.Accumulation.BudgetItemTurnover.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      DECLARE @COUNT_D BIGINT = (SELECT COUNT(*) FROM deleted WHERE type = N'Register.Accumulation.BudgetItemTurnover');
      IF (@COUNT_D) > 0 DELETE FROM [Register.Accumulation.BudgetItemTurnover] WHERE id IN (SELECT id FROM deleted);
      IF (@COUNT_D) = 1 DELETE FROM [Register.Accumulation.BudgetItemTurnover] WHERE id = (SELECT id FROM deleted);
      DECLARE @COUNT_I BIGINT = (SELECT COUNT(*) FROM inserted WHERE type = N'Register.Accumulation.BudgetItemTurnover');
      IF (@COUNT_D) = 0 RETURN;

      INSERT INTO [Register.Accumulation.BudgetItemTurnover]
      SELECT
        r.id, r.parent, r.date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, [Department], [Scenario], [BudgetItem], [Anatitic1], [Anatitic2], [Anatitic3], [Anatitic4], [Anatitic5], [currency]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInScenatio] * IIF(r.kind = 1, 1, -1) [AmountInScenatio], d.[AmountInScenatio] * IIF(r.kind = 1, 1, null) [AmountInScenatio.In], d.[AmountInScenatio] * IIF(r.kind = 1, null, 1) [AmountInScenatio.Out]
      , d.[AmountInCurrency] * IIF(r.kind = 1, 1, -1) [AmountInCurrency], d.[AmountInCurrency] * IIF(r.kind = 1, 1, null) [AmountInCurrency.In], d.[AmountInCurrency] * IIF(r.kind = 1, null, 1) [AmountInCurrency.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
      , d.[Qty] * IIF(r.kind = 1, 1, -1) [Qty], d.[Qty] * IIF(r.kind = 1, 1, null) [Qty.In], d.[Qty] * IIF(r.kind = 1, null, 1) [Qty.Out]
        FROM inserted r
        CROSS APPLY OPENJSON (data, N'$')
        WITH (
          exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [Department] UNIQUEIDENTIFIER N'$.Department'
        , [Scenario] UNIQUEIDENTIFIER N'$.Scenario'
        , [BudgetItem] UNIQUEIDENTIFIER N'$.BudgetItem'
        , [Anatitic1] UNIQUEIDENTIFIER N'$.Anatitic1'
        , [Anatitic2] UNIQUEIDENTIFIER N'$.Anatitic2'
        , [Anatitic3] UNIQUEIDENTIFIER N'$.Anatitic3'
        , [Anatitic4] UNIQUEIDENTIFIER N'$.Anatitic4'
        , [Anatitic5] UNIQUEIDENTIFIER N'$.Anatitic5'
        , [currency] UNIQUEIDENTIFIER N'$.currency'
        , [Amount] MONEY N'$.Amount'
        , [AmountInScenatio] MONEY N'$.AmountInScenatio'
        , [AmountInCurrency] MONEY N'$.AmountInCurrency'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
        , [Qty] MONEY N'$.Qty'
        ) AS d
        WHERE r.type = N'Register.Accumulation.BudgetItemTurnover';
    END
    GO
    
------------------------------ END Register.Accumulation.BudgetItemTurnover ------------------------------

------------------------------ BEGIN Register.Accumulation.Intercompany ------------------------------

    RAISERROR('Register.Accumulation.Intercompany start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER TRIGGER [Register.Accumulation.Intercompany.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      DECLARE @COUNT_D BIGINT = (SELECT COUNT(*) FROM deleted WHERE type = N'Register.Accumulation.Intercompany');
      IF (@COUNT_D) > 0 DELETE FROM [Register.Accumulation.Intercompany] WHERE id IN (SELECT id FROM deleted);
      IF (@COUNT_D) = 1 DELETE FROM [Register.Accumulation.Intercompany] WHERE id = (SELECT id FROM deleted);
      DECLARE @COUNT_I BIGINT = (SELECT COUNT(*) FROM inserted WHERE type = N'Register.Accumulation.Intercompany');
      IF (@COUNT_D) = 0 RETURN;

      INSERT INTO [Register.Accumulation.Intercompany]
      SELECT
        r.id, r.parent, r.date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, [Intercompany], [LegalCompanySender], [LegalCompanyRecipient], [Contract], [OperationType], [Analytics], [currency]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
        FROM inserted r
        CROSS APPLY OPENJSON (data, N'$')
        WITH (
          exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [Intercompany] UNIQUEIDENTIFIER N'$.Intercompany'
        , [LegalCompanySender] UNIQUEIDENTIFIER N'$.LegalCompanySender'
        , [LegalCompanyRecipient] UNIQUEIDENTIFIER N'$.LegalCompanyRecipient'
        , [Contract] UNIQUEIDENTIFIER N'$.Contract'
        , [OperationType] UNIQUEIDENTIFIER N'$.OperationType'
        , [Analytics] UNIQUEIDENTIFIER N'$.Analytics'
        , [currency] UNIQUEIDENTIFIER N'$.currency'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
        ) AS d
        WHERE r.type = N'Register.Accumulation.Intercompany';
    END
    GO
    
------------------------------ END Register.Accumulation.Intercompany ------------------------------

------------------------------ BEGIN Register.Accumulation.Acquiring ------------------------------

    RAISERROR('Register.Accumulation.Acquiring start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER TRIGGER [Register.Accumulation.Acquiring.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      DECLARE @COUNT_D BIGINT = (SELECT COUNT(*) FROM deleted WHERE type = N'Register.Accumulation.Acquiring');
      IF (@COUNT_D) > 0 DELETE FROM [Register.Accumulation.Acquiring] WHERE id IN (SELECT id FROM deleted);
      IF (@COUNT_D) = 1 DELETE FROM [Register.Accumulation.Acquiring] WHERE id = (SELECT id FROM deleted);
      DECLARE @COUNT_I BIGINT = (SELECT COUNT(*) FROM inserted WHERE type = N'Register.Accumulation.Acquiring');
      IF (@COUNT_D) = 0 RETURN;

      INSERT INTO [Register.Accumulation.Acquiring]
      SELECT
        r.id, r.parent, r.date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, [AcquiringTerminal], [AcquiringTerminalCode1], [OperationType], [Department], [CashFlow], [PaymantCard], [PayDay], [currency]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountOperation] * IIF(r.kind = 1, 1, -1) [AmountOperation], d.[AmountOperation] * IIF(r.kind = 1, 1, null) [AmountOperation.In], d.[AmountOperation] * IIF(r.kind = 1, null, 1) [AmountOperation.Out]
      , d.[AmountPaid] * IIF(r.kind = 1, 1, -1) [AmountPaid], d.[AmountPaid] * IIF(r.kind = 1, 1, null) [AmountPaid.In], d.[AmountPaid] * IIF(r.kind = 1, null, 1) [AmountPaid.Out], [DateOperation], [DatePaid], [AuthorizationCode]
        FROM inserted r
        CROSS APPLY OPENJSON (data, N'$')
        WITH (
          exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [AcquiringTerminal] UNIQUEIDENTIFIER N'$.AcquiringTerminal'
        , [AcquiringTerminalCode1] NVARCHAR(250) N'$.AcquiringTerminalCode1'
        , [OperationType] UNIQUEIDENTIFIER N'$.OperationType'
        , [Department] UNIQUEIDENTIFIER N'$.Department'
        , [CashFlow] UNIQUEIDENTIFIER N'$.CashFlow'
        , [PaymantCard] NVARCHAR(250) N'$.PaymantCard'
        , [PayDay] DATE N'$.PayDay'
        , [currency] UNIQUEIDENTIFIER N'$.currency'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountOperation] MONEY N'$.AmountOperation'
        , [AmountPaid] MONEY N'$.AmountPaid'
        , [DateOperation] DATE N'$.DateOperation'
        , [DatePaid] DATE N'$.DatePaid'
        , [AuthorizationCode] NVARCHAR(250) N'$.AuthorizationCode'
        ) AS d
        WHERE r.type = N'Register.Accumulation.Acquiring';
    END
    GO
    
------------------------------ END Register.Accumulation.Acquiring ------------------------------

------------------------------ BEGIN Register.Accumulation.StaffingTable ------------------------------

    RAISERROR('Register.Accumulation.StaffingTable start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER TRIGGER [Register.Accumulation.StaffingTable.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      DECLARE @COUNT_D BIGINT = (SELECT COUNT(*) FROM deleted WHERE type = N'Register.Accumulation.StaffingTable');
      IF (@COUNT_D) > 0 DELETE FROM [Register.Accumulation.StaffingTable] WHERE id IN (SELECT id FROM deleted);
      IF (@COUNT_D) = 1 DELETE FROM [Register.Accumulation.StaffingTable] WHERE id = (SELECT id FROM deleted);
      DECLARE @COUNT_I BIGINT = (SELECT COUNT(*) FROM inserted WHERE type = N'Register.Accumulation.StaffingTable');
      IF (@COUNT_D) = 0 RETURN;

      INSERT INTO [Register.Accumulation.StaffingTable]
      SELECT
        r.id, r.parent, r.date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, [Department], [DepartmentCompany], [StaffingTablePosition], [Employee], [Person]
      , d.[SalaryRate] * IIF(r.kind = 1, 1, -1) [SalaryRate], d.[SalaryRate] * IIF(r.kind = 1, 1, null) [SalaryRate.In], d.[SalaryRate] * IIF(r.kind = 1, null, 1) [SalaryRate.Out], [SalaryAnalytic], [currency]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
        FROM inserted r
        CROSS APPLY OPENJSON (data, N'$')
        WITH (
          exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [Department] UNIQUEIDENTIFIER N'$.Department'
        , [DepartmentCompany] UNIQUEIDENTIFIER N'$.DepartmentCompany'
        , [StaffingTablePosition] UNIQUEIDENTIFIER N'$.StaffingTablePosition'
        , [Employee] UNIQUEIDENTIFIER N'$.Employee'
        , [Person] UNIQUEIDENTIFIER N'$.Person'
        , [SalaryRate] MONEY N'$.SalaryRate'
        , [SalaryAnalytic] UNIQUEIDENTIFIER N'$.SalaryAnalytic'
        , [currency] UNIQUEIDENTIFIER N'$.currency'
        , [Amount] MONEY N'$.Amount'
        ) AS d
        WHERE r.type = N'Register.Accumulation.StaffingTable';
    END
    GO
    
------------------------------ END Register.Accumulation.StaffingTable ------------------------------

    