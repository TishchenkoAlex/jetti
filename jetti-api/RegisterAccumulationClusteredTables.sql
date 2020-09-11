
    DROP INDEX IF EXISTS [Documents.parent] ON [dbo].[Documents];
    CREATE UNIQUE NONCLUSTERED INDEX [Documents.parent] ON [dbo].[Documents]([parent], [id]);

    
    RAISERROR('Register.Accumulation.AccountablePersons start', 0 ,1) WITH NOWAIT;
    GO

    DROP TABLE IF EXISTS [Register.Accumulation.AccountablePersons];
    SELECT
      r.id, r.parent, CAST(r.date AS DATE) date, CAST(r.document AS CHAR(36)) document, CAST(r.company AS CHAR(36)) company, r.kind, r.calculated,
      d.exchangeRate, [currency], [Employee], [CashFlow]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
      , d.[AmountToPay] * IIF(r.kind = 1, 1, -1) [AmountToPay], d.[AmountToPay] * IIF(r.kind = 1, 1, null) [AmountToPay.In], d.[AmountToPay] * IIF(r.kind = 1, null, 1) [AmountToPay.Out]
      , d.[AmountIsPaid] * IIF(r.kind = 1, 1, -1) [AmountIsPaid], d.[AmountIsPaid] * IIF(r.kind = 1, 1, null) [AmountIsPaid.In], d.[AmountIsPaid] * IIF(r.kind = 1, null, 1) [AmountIsPaid.Out]
    INTO [Register.Accumulation.AccountablePersons]
    FROM [Accumulation] r
    CROSS APPLY OPENJSON (data, N'$')
    WITH (
      exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [currency] CHAR(36) N'$.currency'
        , [Employee] CHAR(36) N'$.Employee'
        , [CashFlow] CHAR(36) N'$.CashFlow'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
        , [AmountToPay] MONEY N'$.AmountToPay'
        , [AmountIsPaid] MONEY N'$.AmountIsPaid'
    ) AS d
    WHERE r.type = N'Register.Accumulation.AccountablePersons';
    GO

    CREATE OR ALTER TRIGGER [Register.Accumulation.AccountablePersons.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      IF (SELECT COUNT(*) FROM deleted) > 0 DELETE FROM [Register.Accumulation.AccountablePersons] WHERE id IN (SELECT id FROM deleted);
      IF (SELECT COUNT(*) FROM inserted) = 0 RETURN;
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
        , [currency] CHAR(36) N'$.currency'
        , [Employee] CHAR(36) N'$.Employee'
        , [CashFlow] CHAR(36) N'$.CashFlow'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
        , [AmountToPay] MONEY N'$.AmountToPay'
        , [AmountIsPaid] MONEY N'$.AmountIsPaid'
        ) AS d
        WHERE r.type = N'Register.Accumulation.AccountablePersons';
    END
    GO

    GRANT SELECT,INSERT,DELETE ON [Register.Accumulation.AccountablePersons] TO JETTI;
    GO

    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.AccountablePersons] ON [Register.Accumulation.AccountablePersons] (
      id, parent, date, document, company, kind, calculated, exchangeRate, [currency], [Employee], [CashFlow], [Amount], [AmountInBalance], [AmountInAccounting], [AmountToPay], [AmountIsPaid]) WITH (MAXDOP=4);
    ALTER TABLE [Register.Accumulation.AccountablePersons] ADD CONSTRAINT [PK_Register.Accumulation.AccountablePersons] PRIMARY KEY NONCLUSTERED (id) WITH (MAXDOP=4);

    RAISERROR('Register.Accumulation.AccountablePersons finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.PaymentBatch start', 0 ,1) WITH NOWAIT;
    GO

    DROP TABLE IF EXISTS [Register.Accumulation.PaymentBatch];
    SELECT
      r.id, r.parent, CAST(r.date AS DATE) date, CAST(r.document AS CHAR(36)) document, CAST(r.company AS CHAR(36)) company, r.kind, r.calculated,
      d.exchangeRate, [PaymentsKind], [Counterpartie], [ProductPackage], [Product], [Currency], [PayDay]
      , d.[Qty] * IIF(r.kind = 1, 1, -1) [Qty], d.[Qty] * IIF(r.kind = 1, 1, null) [Qty.In], d.[Qty] * IIF(r.kind = 1, null, 1) [Qty.Out]
      , d.[Price] * IIF(r.kind = 1, 1, -1) [Price], d.[Price] * IIF(r.kind = 1, 1, null) [Price.In], d.[Price] * IIF(r.kind = 1, null, 1) [Price.Out]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out], [batch]
    INTO [Register.Accumulation.PaymentBatch]
    FROM [Accumulation] r
    CROSS APPLY OPENJSON (data, N'$')
    WITH (
      exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [PaymentsKind] NVARCHAR(250) N'$.PaymentsKind'
        , [Counterpartie] CHAR(36) N'$.Counterpartie'
        , [ProductPackage] CHAR(36) N'$.ProductPackage'
        , [Product] CHAR(36) N'$.Product'
        , [Currency] CHAR(36) N'$.Currency'
        , [PayDay] DATE N'$.PayDay'
        , [Qty] MONEY N'$.Qty'
        , [Price] MONEY N'$.Price'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [batch] CHAR(36) N'$.batch'
    ) AS d
    WHERE r.type = N'Register.Accumulation.PaymentBatch';
    GO

    CREATE OR ALTER TRIGGER [Register.Accumulation.PaymentBatch.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      IF (SELECT COUNT(*) FROM deleted) > 0 DELETE FROM [Register.Accumulation.PaymentBatch] WHERE id IN (SELECT id FROM deleted);
      IF (SELECT COUNT(*) FROM inserted) = 0 RETURN;
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
        , [Counterpartie] CHAR(36) N'$.Counterpartie'
        , [ProductPackage] CHAR(36) N'$.ProductPackage'
        , [Product] CHAR(36) N'$.Product'
        , [Currency] CHAR(36) N'$.Currency'
        , [PayDay] DATE N'$.PayDay'
        , [Qty] MONEY N'$.Qty'
        , [Price] MONEY N'$.Price'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [batch] CHAR(36) N'$.batch'
        ) AS d
        WHERE r.type = N'Register.Accumulation.PaymentBatch';
    END
    GO

    GRANT SELECT,INSERT,DELETE ON [Register.Accumulation.PaymentBatch] TO JETTI;
    GO

    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.PaymentBatch] ON [Register.Accumulation.PaymentBatch] (
      id, parent, date, document, company, kind, calculated, exchangeRate, [PaymentsKind], [Counterpartie], [ProductPackage], [Product], [Currency], [PayDay], [Qty], [Price], [Amount], [AmountInBalance], [batch]) WITH (MAXDOP=4);
    ALTER TABLE [Register.Accumulation.PaymentBatch] ADD CONSTRAINT [PK_Register.Accumulation.PaymentBatch] PRIMARY KEY NONCLUSTERED (id) WITH (MAXDOP=4);

    RAISERROR('Register.Accumulation.PaymentBatch finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.OrderPayment start', 0 ,1) WITH NOWAIT;
    GO

    DROP TABLE IF EXISTS [Register.Accumulation.OrderPayment];
    SELECT
      r.id, r.parent, CAST(r.date AS DATE) date, CAST(r.document AS CHAR(36)) document, CAST(r.company AS CHAR(36)) company, r.kind, r.calculated,
      d.exchangeRate, [PaymantKind], [Customer], [BankAccount], [CashRegister], [AcquiringTerminal], [currency], [Department]
      , d.[CashShift] * IIF(r.kind = 1, 1, -1) [CashShift], d.[CashShift] * IIF(r.kind = 1, 1, null) [CashShift.In], d.[CashShift] * IIF(r.kind = 1, null, 1) [CashShift.Out]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
    INTO [Register.Accumulation.OrderPayment]
    FROM [Accumulation] r
    CROSS APPLY OPENJSON (data, N'$')
    WITH (
      exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [PaymantKind] NVARCHAR(250) N'$.PaymantKind'
        , [Customer] CHAR(36) N'$.Customer'
        , [BankAccount] CHAR(36) N'$.BankAccount'
        , [CashRegister] CHAR(36) N'$.CashRegister'
        , [AcquiringTerminal] CHAR(36) N'$.AcquiringTerminal'
        , [currency] CHAR(36) N'$.currency'
        , [Department] CHAR(36) N'$.Department'
        , [CashShift] MONEY N'$.CashShift'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
    ) AS d
    WHERE r.type = N'Register.Accumulation.OrderPayment';
    GO

    CREATE OR ALTER TRIGGER [Register.Accumulation.OrderPayment.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      IF (SELECT COUNT(*) FROM deleted) > 0 DELETE FROM [Register.Accumulation.OrderPayment] WHERE id IN (SELECT id FROM deleted);
      IF (SELECT COUNT(*) FROM inserted) = 0 RETURN;
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
        , [Customer] CHAR(36) N'$.Customer'
        , [BankAccount] CHAR(36) N'$.BankAccount'
        , [CashRegister] CHAR(36) N'$.CashRegister'
        , [AcquiringTerminal] CHAR(36) N'$.AcquiringTerminal'
        , [currency] CHAR(36) N'$.currency'
        , [Department] CHAR(36) N'$.Department'
        , [CashShift] MONEY N'$.CashShift'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
        ) AS d
        WHERE r.type = N'Register.Accumulation.OrderPayment';
    END
    GO

    GRANT SELECT,INSERT,DELETE ON [Register.Accumulation.OrderPayment] TO JETTI;
    GO

    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.OrderPayment] ON [Register.Accumulation.OrderPayment] (
      id, parent, date, document, company, kind, calculated, exchangeRate, [PaymantKind], [Customer], [BankAccount], [CashRegister], [AcquiringTerminal], [currency], [Department], [CashShift], [Amount], [AmountInBalance], [AmountInAccounting]) WITH (MAXDOP=4);
    ALTER TABLE [Register.Accumulation.OrderPayment] ADD CONSTRAINT [PK_Register.Accumulation.OrderPayment] PRIMARY KEY NONCLUSTERED (id) WITH (MAXDOP=4);

    RAISERROR('Register.Accumulation.OrderPayment finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.AP start', 0 ,1) WITH NOWAIT;
    GO

    DROP TABLE IF EXISTS [Register.Accumulation.AP];
    SELECT
      r.id, r.parent, CAST(r.date AS DATE) date, CAST(r.document AS CHAR(36)) document, CAST(r.company AS CHAR(36)) company, r.kind, r.calculated,
      d.exchangeRate, [currency], [Department], [AO], [Supplier], [PayDay]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
      , d.[AmountToPay] * IIF(r.kind = 1, 1, -1) [AmountToPay], d.[AmountToPay] * IIF(r.kind = 1, 1, null) [AmountToPay.In], d.[AmountToPay] * IIF(r.kind = 1, null, 1) [AmountToPay.Out]
      , d.[AmountIsPaid] * IIF(r.kind = 1, 1, -1) [AmountIsPaid], d.[AmountIsPaid] * IIF(r.kind = 1, 1, null) [AmountIsPaid.In], d.[AmountIsPaid] * IIF(r.kind = 1, null, 1) [AmountIsPaid.Out]
    INTO [Register.Accumulation.AP]
    FROM [Accumulation] r
    CROSS APPLY OPENJSON (data, N'$')
    WITH (
      exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [currency] CHAR(36) N'$.currency'
        , [Department] CHAR(36) N'$.Department'
        , [AO] CHAR(36) N'$.AO'
        , [Supplier] CHAR(36) N'$.Supplier'
        , [PayDay] DATE N'$.PayDay'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
        , [AmountToPay] MONEY N'$.AmountToPay'
        , [AmountIsPaid] MONEY N'$.AmountIsPaid'
    ) AS d
    WHERE r.type = N'Register.Accumulation.AP';
    GO

    CREATE OR ALTER TRIGGER [Register.Accumulation.AP.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      IF (SELECT COUNT(*) FROM deleted) > 0 DELETE FROM [Register.Accumulation.AP] WHERE id IN (SELECT id FROM deleted);
      IF (SELECT COUNT(*) FROM inserted) = 0 RETURN;
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
        , [currency] CHAR(36) N'$.currency'
        , [Department] CHAR(36) N'$.Department'
        , [AO] CHAR(36) N'$.AO'
        , [Supplier] CHAR(36) N'$.Supplier'
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

    GRANT SELECT,INSERT,DELETE ON [Register.Accumulation.AP] TO JETTI;
    GO

    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.AP] ON [Register.Accumulation.AP] (
      id, parent, date, document, company, kind, calculated, exchangeRate, [currency], [Department], [AO], [Supplier], [PayDay], [Amount], [AmountInBalance], [AmountInAccounting], [AmountToPay], [AmountIsPaid]) WITH (MAXDOP=4);
    ALTER TABLE [Register.Accumulation.AP] ADD CONSTRAINT [PK_Register.Accumulation.AP] PRIMARY KEY NONCLUSTERED (id) WITH (MAXDOP=4);

    RAISERROR('Register.Accumulation.AP finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.AR start', 0 ,1) WITH NOWAIT;
    GO

    DROP TABLE IF EXISTS [Register.Accumulation.AR];
    SELECT
      r.id, r.parent, CAST(r.date AS DATE) date, CAST(r.document AS CHAR(36)) document, CAST(r.company AS CHAR(36)) company, r.kind, r.calculated,
      d.exchangeRate, [currency], [Department], [AO], [Customer], [PayDay]
      , d.[AR] * IIF(r.kind = 1, 1, -1) [AR], d.[AR] * IIF(r.kind = 1, 1, null) [AR.In], d.[AR] * IIF(r.kind = 1, null, 1) [AR.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
      , d.[AmountToPay] * IIF(r.kind = 1, 1, -1) [AmountToPay], d.[AmountToPay] * IIF(r.kind = 1, 1, null) [AmountToPay.In], d.[AmountToPay] * IIF(r.kind = 1, null, 1) [AmountToPay.Out]
      , d.[AmountIsPaid] * IIF(r.kind = 1, 1, -1) [AmountIsPaid], d.[AmountIsPaid] * IIF(r.kind = 1, 1, null) [AmountIsPaid.In], d.[AmountIsPaid] * IIF(r.kind = 1, null, 1) [AmountIsPaid.Out]
    INTO [Register.Accumulation.AR]
    FROM [Accumulation] r
    CROSS APPLY OPENJSON (data, N'$')
    WITH (
      exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [currency] CHAR(36) N'$.currency'
        , [Department] CHAR(36) N'$.Department'
        , [AO] CHAR(36) N'$.AO'
        , [Customer] CHAR(36) N'$.Customer'
        , [PayDay] DATE N'$.PayDay'
        , [AR] MONEY N'$.AR'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
        , [AmountToPay] MONEY N'$.AmountToPay'
        , [AmountIsPaid] MONEY N'$.AmountIsPaid'
    ) AS d
    WHERE r.type = N'Register.Accumulation.AR';
    GO

    CREATE OR ALTER TRIGGER [Register.Accumulation.AR.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      IF (SELECT COUNT(*) FROM deleted) > 0 DELETE FROM [Register.Accumulation.AR] WHERE id IN (SELECT id FROM deleted);
      IF (SELECT COUNT(*) FROM inserted) = 0 RETURN;
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
        , [currency] CHAR(36) N'$.currency'
        , [Department] CHAR(36) N'$.Department'
        , [AO] CHAR(36) N'$.AO'
        , [Customer] CHAR(36) N'$.Customer'
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

    GRANT SELECT,INSERT,DELETE ON [Register.Accumulation.AR] TO JETTI;
    GO

    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.AR] ON [Register.Accumulation.AR] (
      id, parent, date, document, company, kind, calculated, exchangeRate, [currency], [Department], [AO], [Customer], [PayDay], [AR], [AmountInBalance], [AmountInAccounting], [AmountToPay], [AmountIsPaid]) WITH (MAXDOP=4);
    ALTER TABLE [Register.Accumulation.AR] ADD CONSTRAINT [PK_Register.Accumulation.AR] PRIMARY KEY NONCLUSTERED (id) WITH (MAXDOP=4);

    RAISERROR('Register.Accumulation.AR finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Bank start', 0 ,1) WITH NOWAIT;
    GO

    DROP TABLE IF EXISTS [Register.Accumulation.Bank];
    SELECT
      r.id, r.parent, CAST(r.date AS DATE) date, CAST(r.document AS CHAR(36)) document, CAST(r.company AS CHAR(36)) company, r.kind, r.calculated,
      d.exchangeRate, [currency], [BankAccount], [CashFlow], [Analytics]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
    INTO [Register.Accumulation.Bank]
    FROM [Accumulation] r
    CROSS APPLY OPENJSON (data, N'$')
    WITH (
      exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [currency] CHAR(36) N'$.currency'
        , [BankAccount] CHAR(36) N'$.BankAccount'
        , [CashFlow] CHAR(36) N'$.CashFlow'
        , [Analytics] CHAR(36) N'$.Analytics'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
    ) AS d
    WHERE r.type = N'Register.Accumulation.Bank';
    GO

    CREATE OR ALTER TRIGGER [Register.Accumulation.Bank.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      IF (SELECT COUNT(*) FROM deleted) > 0 DELETE FROM [Register.Accumulation.Bank] WHERE id IN (SELECT id FROM deleted);
      IF (SELECT COUNT(*) FROM inserted) = 0 RETURN;
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
        , [currency] CHAR(36) N'$.currency'
        , [BankAccount] CHAR(36) N'$.BankAccount'
        , [CashFlow] CHAR(36) N'$.CashFlow'
        , [Analytics] CHAR(36) N'$.Analytics'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
        ) AS d
        WHERE r.type = N'Register.Accumulation.Bank';
    END
    GO

    GRANT SELECT,INSERT,DELETE ON [Register.Accumulation.Bank] TO JETTI;
    GO

    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.Bank] ON [Register.Accumulation.Bank] (
      id, parent, date, document, company, kind, calculated, exchangeRate, [currency], [BankAccount], [CashFlow], [Analytics], [Amount], [AmountInBalance], [AmountInAccounting]) WITH (MAXDOP=4);
    ALTER TABLE [Register.Accumulation.Bank] ADD CONSTRAINT [PK_Register.Accumulation.Bank] PRIMARY KEY NONCLUSTERED (id) WITH (MAXDOP=4);

    RAISERROR('Register.Accumulation.Bank finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Balance start', 0 ,1) WITH NOWAIT;
    GO

    DROP TABLE IF EXISTS [Register.Accumulation.Balance];
    SELECT
      r.id, r.parent, CAST(r.date AS DATE) date, CAST(r.document AS CHAR(36)) document, CAST(r.company AS CHAR(36)) company, r.kind, r.calculated,
      d.exchangeRate, [Department], [Balance], [Analytics]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out], [Info]
    INTO [Register.Accumulation.Balance]
    FROM [Accumulation] r
    CROSS APPLY OPENJSON (data, N'$')
    WITH (
      exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [Department] CHAR(36) N'$.Department'
        , [Balance] CHAR(36) N'$.Balance'
        , [Analytics] CHAR(36) N'$.Analytics'
        , [Amount] MONEY N'$.Amount'
        , [Info] NVARCHAR(250) N'$.Info'
    ) AS d
    WHERE r.type = N'Register.Accumulation.Balance';
    GO

    CREATE OR ALTER TRIGGER [Register.Accumulation.Balance.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      IF (SELECT COUNT(*) FROM deleted) > 0 DELETE FROM [Register.Accumulation.Balance] WHERE id IN (SELECT id FROM deleted);
      IF (SELECT COUNT(*) FROM inserted) = 0 RETURN;
      INSERT INTO [Register.Accumulation.Balance]
      SELECT
        r.id, r.parent, r.date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, [Department], [Balance], [Analytics]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out], [Info]
        FROM inserted r
        CROSS APPLY OPENJSON (data, N'$')
        WITH (
          exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [Department] CHAR(36) N'$.Department'
        , [Balance] CHAR(36) N'$.Balance'
        , [Analytics] CHAR(36) N'$.Analytics'
        , [Amount] MONEY N'$.Amount'
        , [Info] NVARCHAR(250) N'$.Info'
        ) AS d
        WHERE r.type = N'Register.Accumulation.Balance';
    END
    GO

    GRANT SELECT,INSERT,DELETE ON [Register.Accumulation.Balance] TO JETTI;
    GO

    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.Balance] ON [Register.Accumulation.Balance] (
      id, parent, date, document, company, kind, calculated, exchangeRate, [Department], [Balance], [Analytics], [Amount], [Info]) WITH (MAXDOP=4);
    ALTER TABLE [Register.Accumulation.Balance] ADD CONSTRAINT [PK_Register.Accumulation.Balance] PRIMARY KEY NONCLUSTERED (id) WITH (MAXDOP=4);

    RAISERROR('Register.Accumulation.Balance finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Balance.RC start', 0 ,1) WITH NOWAIT;
    GO

    DROP TABLE IF EXISTS [Register.Accumulation.Balance.RC];
    SELECT
      r.id, r.parent, CAST(r.date AS DATE) date, CAST(r.document AS CHAR(36)) document, CAST(r.company AS CHAR(36)) company, r.kind, r.calculated,
      d.exchangeRate, [ResponsibilityCenter], [Department], [Balance], [Analytics], [Analytics2], [Currency]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountRC] * IIF(r.kind = 1, 1, -1) [AmountRC], d.[AmountRC] * IIF(r.kind = 1, 1, null) [AmountRC.In], d.[AmountRC] * IIF(r.kind = 1, null, 1) [AmountRC.Out], [Info]
    INTO [Register.Accumulation.Balance.RC]
    FROM [Accumulation] r
    CROSS APPLY OPENJSON (data, N'$')
    WITH (
      exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [ResponsibilityCenter] CHAR(36) N'$.ResponsibilityCenter'
        , [Department] CHAR(36) N'$.Department'
        , [Balance] CHAR(36) N'$.Balance'
        , [Analytics] CHAR(36) N'$.Analytics'
        , [Analytics2] CHAR(36) N'$.Analytics2'
        , [Currency] CHAR(36) N'$.Currency'
        , [Amount] MONEY N'$.Amount'
        , [AmountRC] MONEY N'$.AmountRC'
        , [Info] NVARCHAR(250) N'$.Info'
    ) AS d
    WHERE r.type = N'Register.Accumulation.Balance.RC';
    GO

    CREATE OR ALTER TRIGGER [Register.Accumulation.Balance.RC.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      IF (SELECT COUNT(*) FROM deleted) > 0 DELETE FROM [Register.Accumulation.Balance.RC] WHERE id IN (SELECT id FROM deleted);
      IF (SELECT COUNT(*) FROM inserted) = 0 RETURN;
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
        , [ResponsibilityCenter] CHAR(36) N'$.ResponsibilityCenter'
        , [Department] CHAR(36) N'$.Department'
        , [Balance] CHAR(36) N'$.Balance'
        , [Analytics] CHAR(36) N'$.Analytics'
        , [Analytics2] CHAR(36) N'$.Analytics2'
        , [Currency] CHAR(36) N'$.Currency'
        , [Amount] MONEY N'$.Amount'
        , [AmountRC] MONEY N'$.AmountRC'
        , [Info] NVARCHAR(250) N'$.Info'
        ) AS d
        WHERE r.type = N'Register.Accumulation.Balance.RC';
    END
    GO

    GRANT SELECT,INSERT,DELETE ON [Register.Accumulation.Balance.RC] TO JETTI;
    GO

    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.Balance.RC] ON [Register.Accumulation.Balance.RC] (
      id, parent, date, document, company, kind, calculated, exchangeRate, [ResponsibilityCenter], [Department], [Balance], [Analytics], [Analytics2], [Currency], [Amount], [AmountRC], [Info]) WITH (MAXDOP=4);
    ALTER TABLE [Register.Accumulation.Balance.RC] ADD CONSTRAINT [PK_Register.Accumulation.Balance.RC] PRIMARY KEY NONCLUSTERED (id) WITH (MAXDOP=4);

    RAISERROR('Register.Accumulation.Balance.RC finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Balance.Report start', 0 ,1) WITH NOWAIT;
    GO

    DROP TABLE IF EXISTS [Register.Accumulation.Balance.Report];
    SELECT
      r.id, r.parent, CAST(r.date AS DATE) date, CAST(r.document AS CHAR(36)) document, CAST(r.company AS CHAR(36)) company, r.kind, r.calculated,
      d.exchangeRate, [currency], [Department], [Balance], [Analytics]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out], [Info]
    INTO [Register.Accumulation.Balance.Report]
    FROM [Accumulation] r
    CROSS APPLY OPENJSON (data, N'$')
    WITH (
      exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [currency] CHAR(36) N'$.currency'
        , [Department] CHAR(36) N'$.Department'
        , [Balance] CHAR(36) N'$.Balance'
        , [Analytics] CHAR(36) N'$.Analytics'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
        , [Info] NVARCHAR(250) N'$.Info'
    ) AS d
    WHERE r.type = N'Register.Accumulation.Balance.Report';
    GO

    CREATE OR ALTER TRIGGER [Register.Accumulation.Balance.Report.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      IF (SELECT COUNT(*) FROM deleted) > 0 DELETE FROM [Register.Accumulation.Balance.Report] WHERE id IN (SELECT id FROM deleted);
      IF (SELECT COUNT(*) FROM inserted) = 0 RETURN;
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
        , [currency] CHAR(36) N'$.currency'
        , [Department] CHAR(36) N'$.Department'
        , [Balance] CHAR(36) N'$.Balance'
        , [Analytics] CHAR(36) N'$.Analytics'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
        , [Info] NVARCHAR(250) N'$.Info'
        ) AS d
        WHERE r.type = N'Register.Accumulation.Balance.Report';
    END
    GO

    GRANT SELECT,INSERT,DELETE ON [Register.Accumulation.Balance.Report] TO JETTI;
    GO

    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.Balance.Report] ON [Register.Accumulation.Balance.Report] (
      id, parent, date, document, company, kind, calculated, exchangeRate, [currency], [Department], [Balance], [Analytics], [Amount], [AmountInBalance], [AmountInAccounting], [Info]) WITH (MAXDOP=4);
    ALTER TABLE [Register.Accumulation.Balance.Report] ADD CONSTRAINT [PK_Register.Accumulation.Balance.Report] PRIMARY KEY NONCLUSTERED (id) WITH (MAXDOP=4);

    RAISERROR('Register.Accumulation.Balance.Report finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Cash start', 0 ,1) WITH NOWAIT;
    GO

    DROP TABLE IF EXISTS [Register.Accumulation.Cash];
    SELECT
      r.id, r.parent, CAST(r.date AS DATE) date, CAST(r.document AS CHAR(36)) document, CAST(r.company AS CHAR(36)) company, r.kind, r.calculated,
      d.exchangeRate, [currency], [CashRegister], [CashFlow], [Analytics]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
    INTO [Register.Accumulation.Cash]
    FROM [Accumulation] r
    CROSS APPLY OPENJSON (data, N'$')
    WITH (
      exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [currency] CHAR(36) N'$.currency'
        , [CashRegister] CHAR(36) N'$.CashRegister'
        , [CashFlow] CHAR(36) N'$.CashFlow'
        , [Analytics] CHAR(36) N'$.Analytics'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
    ) AS d
    WHERE r.type = N'Register.Accumulation.Cash';
    GO

    CREATE OR ALTER TRIGGER [Register.Accumulation.Cash.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      IF (SELECT COUNT(*) FROM deleted) > 0 DELETE FROM [Register.Accumulation.Cash] WHERE id IN (SELECT id FROM deleted);
      IF (SELECT COUNT(*) FROM inserted) = 0 RETURN;
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
        , [currency] CHAR(36) N'$.currency'
        , [CashRegister] CHAR(36) N'$.CashRegister'
        , [CashFlow] CHAR(36) N'$.CashFlow'
        , [Analytics] CHAR(36) N'$.Analytics'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
        ) AS d
        WHERE r.type = N'Register.Accumulation.Cash';
    END
    GO

    GRANT SELECT,INSERT,DELETE ON [Register.Accumulation.Cash] TO JETTI;
    GO

    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.Cash] ON [Register.Accumulation.Cash] (
      id, parent, date, document, company, kind, calculated, exchangeRate, [currency], [CashRegister], [CashFlow], [Analytics], [Amount], [AmountInBalance], [AmountInAccounting]) WITH (MAXDOP=4);
    ALTER TABLE [Register.Accumulation.Cash] ADD CONSTRAINT [PK_Register.Accumulation.Cash] PRIMARY KEY NONCLUSTERED (id) WITH (MAXDOP=4);

    RAISERROR('Register.Accumulation.Cash finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Cash.Transit start', 0 ,1) WITH NOWAIT;
    GO

    DROP TABLE IF EXISTS [Register.Accumulation.Cash.Transit];
    SELECT
      r.id, r.parent, CAST(r.date AS DATE) date, CAST(r.document AS CHAR(36)) document, CAST(r.company AS CHAR(36)) company, r.kind, r.calculated,
      d.exchangeRate, [CompanyRecipient], [currency], [Sender], [Recipient], [CashFlow]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
    INTO [Register.Accumulation.Cash.Transit]
    FROM [Accumulation] r
    CROSS APPLY OPENJSON (data, N'$')
    WITH (
      exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [CompanyRecipient] CHAR(36) N'$.CompanyRecipient'
        , [currency] CHAR(36) N'$.currency'
        , [Sender] CHAR(36) N'$.Sender'
        , [Recipient] CHAR(36) N'$.Recipient'
        , [CashFlow] CHAR(36) N'$.CashFlow'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
    ) AS d
    WHERE r.type = N'Register.Accumulation.Cash.Transit';
    GO

    CREATE OR ALTER TRIGGER [Register.Accumulation.Cash.Transit.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      IF (SELECT COUNT(*) FROM deleted) > 0 DELETE FROM [Register.Accumulation.Cash.Transit] WHERE id IN (SELECT id FROM deleted);
      IF (SELECT COUNT(*) FROM inserted) = 0 RETURN;
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
        , [CompanyRecipient] CHAR(36) N'$.CompanyRecipient'
        , [currency] CHAR(36) N'$.currency'
        , [Sender] CHAR(36) N'$.Sender'
        , [Recipient] CHAR(36) N'$.Recipient'
        , [CashFlow] CHAR(36) N'$.CashFlow'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
        ) AS d
        WHERE r.type = N'Register.Accumulation.Cash.Transit';
    END
    GO

    GRANT SELECT,INSERT,DELETE ON [Register.Accumulation.Cash.Transit] TO JETTI;
    GO

    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.Cash.Transit] ON [Register.Accumulation.Cash.Transit] (
      id, parent, date, document, company, kind, calculated, exchangeRate, [CompanyRecipient], [currency], [Sender], [Recipient], [CashFlow], [Amount], [AmountInBalance], [AmountInAccounting]) WITH (MAXDOP=4);
    ALTER TABLE [Register.Accumulation.Cash.Transit] ADD CONSTRAINT [PK_Register.Accumulation.Cash.Transit] PRIMARY KEY NONCLUSTERED (id) WITH (MAXDOP=4);

    RAISERROR('Register.Accumulation.Cash.Transit finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Inventory start', 0 ,1) WITH NOWAIT;
    GO

    DROP TABLE IF EXISTS [Register.Accumulation.Inventory];
    SELECT
      r.id, r.parent, CAST(r.date AS DATE) date, CAST(r.document AS CHAR(36)) document, CAST(r.company AS CHAR(36)) company, r.kind, r.calculated,
      d.exchangeRate, [OperationType], [Expense], [ExpenseAnalytics], [Income], [IncomeAnalytics], [BalanceIn], [BalanceInAnalytics], [BalanceOut], [BalanceOutAnalytics], [Storehouse], [SKU], [batch], [Department]
      , d.[Cost] * IIF(r.kind = 1, 1, -1) [Cost], d.[Cost] * IIF(r.kind = 1, 1, null) [Cost.In], d.[Cost] * IIF(r.kind = 1, null, 1) [Cost.Out]
      , d.[Qty] * IIF(r.kind = 1, 1, -1) [Qty], d.[Qty] * IIF(r.kind = 1, 1, null) [Qty.In], d.[Qty] * IIF(r.kind = 1, null, 1) [Qty.Out]
    INTO [Register.Accumulation.Inventory]
    FROM [Accumulation] r
    CROSS APPLY OPENJSON (data, N'$')
    WITH (
      exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [OperationType] CHAR(36) N'$.OperationType'
        , [Expense] CHAR(36) N'$.Expense'
        , [ExpenseAnalytics] CHAR(36) N'$.ExpenseAnalytics'
        , [Income] CHAR(36) N'$.Income'
        , [IncomeAnalytics] CHAR(36) N'$.IncomeAnalytics'
        , [BalanceIn] CHAR(36) N'$.BalanceIn'
        , [BalanceInAnalytics] CHAR(36) N'$.BalanceInAnalytics'
        , [BalanceOut] CHAR(36) N'$.BalanceOut'
        , [BalanceOutAnalytics] CHAR(36) N'$.BalanceOutAnalytics'
        , [Storehouse] CHAR(36) N'$.Storehouse'
        , [SKU] CHAR(36) N'$.SKU'
        , [batch] CHAR(36) N'$.batch'
        , [Department] CHAR(36) N'$.Department'
        , [Cost] MONEY N'$.Cost'
        , [Qty] MONEY N'$.Qty'
    ) AS d
    WHERE r.type = N'Register.Accumulation.Inventory';
    GO

    CREATE OR ALTER TRIGGER [Register.Accumulation.Inventory.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      IF (SELECT COUNT(*) FROM deleted) > 0 DELETE FROM [Register.Accumulation.Inventory] WHERE id IN (SELECT id FROM deleted);
      IF (SELECT COUNT(*) FROM inserted) = 0 RETURN;
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
        , [OperationType] CHAR(36) N'$.OperationType'
        , [Expense] CHAR(36) N'$.Expense'
        , [ExpenseAnalytics] CHAR(36) N'$.ExpenseAnalytics'
        , [Income] CHAR(36) N'$.Income'
        , [IncomeAnalytics] CHAR(36) N'$.IncomeAnalytics'
        , [BalanceIn] CHAR(36) N'$.BalanceIn'
        , [BalanceInAnalytics] CHAR(36) N'$.BalanceInAnalytics'
        , [BalanceOut] CHAR(36) N'$.BalanceOut'
        , [BalanceOutAnalytics] CHAR(36) N'$.BalanceOutAnalytics'
        , [Storehouse] CHAR(36) N'$.Storehouse'
        , [SKU] CHAR(36) N'$.SKU'
        , [batch] CHAR(36) N'$.batch'
        , [Department] CHAR(36) N'$.Department'
        , [Cost] MONEY N'$.Cost'
        , [Qty] MONEY N'$.Qty'
        ) AS d
        WHERE r.type = N'Register.Accumulation.Inventory';
    END
    GO

    GRANT SELECT,INSERT,DELETE ON [Register.Accumulation.Inventory] TO JETTI;
    GO

    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.Inventory] ON [Register.Accumulation.Inventory] (
      id, parent, date, document, company, kind, calculated, exchangeRate, [OperationType], [Expense], [ExpenseAnalytics], [Income], [IncomeAnalytics], [BalanceIn], [BalanceInAnalytics], [BalanceOut], [BalanceOutAnalytics], [Storehouse], [SKU], [batch], [Department], [Cost], [Qty]) WITH (MAXDOP=4);
    ALTER TABLE [Register.Accumulation.Inventory] ADD CONSTRAINT [PK_Register.Accumulation.Inventory] PRIMARY KEY NONCLUSTERED (id) WITH (MAXDOP=4);

    RAISERROR('Register.Accumulation.Inventory finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Loan start', 0 ,1) WITH NOWAIT;
    GO

    DROP TABLE IF EXISTS [Register.Accumulation.Loan];
    SELECT
      r.id, r.parent, CAST(r.date AS DATE) date, CAST(r.document AS CHAR(36)) document, CAST(r.company AS CHAR(36)) company, r.kind, r.calculated,
      d.exchangeRate, [Loan], [Counterpartie], [CashFlow], [currency], [PaymentKind]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
      , d.[AmountToPay] * IIF(r.kind = 1, 1, -1) [AmountToPay], d.[AmountToPay] * IIF(r.kind = 1, 1, null) [AmountToPay.In], d.[AmountToPay] * IIF(r.kind = 1, null, 1) [AmountToPay.Out]
      , d.[AmountIsPaid] * IIF(r.kind = 1, 1, -1) [AmountIsPaid], d.[AmountIsPaid] * IIF(r.kind = 1, 1, null) [AmountIsPaid.In], d.[AmountIsPaid] * IIF(r.kind = 1, null, 1) [AmountIsPaid.Out]
    INTO [Register.Accumulation.Loan]
    FROM [Accumulation] r
    CROSS APPLY OPENJSON (data, N'$')
    WITH (
      exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [Loan] CHAR(36) N'$.Loan'
        , [Counterpartie] CHAR(36) N'$.Counterpartie'
        , [CashFlow] CHAR(36) N'$.CashFlow'
        , [currency] CHAR(36) N'$.currency'
        , [PaymentKind] NVARCHAR(250) N'$.PaymentKind'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
        , [AmountToPay] MONEY N'$.AmountToPay'
        , [AmountIsPaid] MONEY N'$.AmountIsPaid'
    ) AS d
    WHERE r.type = N'Register.Accumulation.Loan';
    GO

    CREATE OR ALTER TRIGGER [Register.Accumulation.Loan.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      IF (SELECT COUNT(*) FROM deleted) > 0 DELETE FROM [Register.Accumulation.Loan] WHERE id IN (SELECT id FROM deleted);
      IF (SELECT COUNT(*) FROM inserted) = 0 RETURN;
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
        , [Loan] CHAR(36) N'$.Loan'
        , [Counterpartie] CHAR(36) N'$.Counterpartie'
        , [CashFlow] CHAR(36) N'$.CashFlow'
        , [currency] CHAR(36) N'$.currency'
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

    GRANT SELECT,INSERT,DELETE ON [Register.Accumulation.Loan] TO JETTI;
    GO

    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.Loan] ON [Register.Accumulation.Loan] (
      id, parent, date, document, company, kind, calculated, exchangeRate, [Loan], [Counterpartie], [CashFlow], [currency], [PaymentKind], [Amount], [AmountInBalance], [AmountInAccounting], [AmountToPay], [AmountIsPaid]) WITH (MAXDOP=4);
    ALTER TABLE [Register.Accumulation.Loan] ADD CONSTRAINT [PK_Register.Accumulation.Loan] PRIMARY KEY NONCLUSTERED (id) WITH (MAXDOP=4);

    RAISERROR('Register.Accumulation.Loan finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.PL start', 0 ,1) WITH NOWAIT;
    GO

    DROP TABLE IF EXISTS [Register.Accumulation.PL];
    SELECT
      r.id, r.parent, CAST(r.date AS DATE) date, CAST(r.document AS CHAR(36)) document, CAST(r.company AS CHAR(36)) company, r.kind, r.calculated,
      d.exchangeRate, [Department], [PL], [Analytics], [Analytics2]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out], [Info]
    INTO [Register.Accumulation.PL]
    FROM [Accumulation] r
    CROSS APPLY OPENJSON (data, N'$')
    WITH (
      exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [Department] CHAR(36) N'$.Department'
        , [PL] CHAR(36) N'$.PL'
        , [Analytics] CHAR(36) N'$.Analytics'
        , [Analytics2] CHAR(36) N'$.Analytics2'
        , [Amount] MONEY N'$.Amount'
        , [Info] NVARCHAR(250) N'$.Info'
    ) AS d
    WHERE r.type = N'Register.Accumulation.PL';
    GO

    CREATE OR ALTER TRIGGER [Register.Accumulation.PL.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      IF (SELECT COUNT(*) FROM deleted) > 0 DELETE FROM [Register.Accumulation.PL] WHERE id IN (SELECT id FROM deleted);
      IF (SELECT COUNT(*) FROM inserted) = 0 RETURN;
      INSERT INTO [Register.Accumulation.PL]
      SELECT
        r.id, r.parent, r.date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, [Department], [PL], [Analytics], [Analytics2]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out], [Info]
        FROM inserted r
        CROSS APPLY OPENJSON (data, N'$')
        WITH (
          exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [Department] CHAR(36) N'$.Department'
        , [PL] CHAR(36) N'$.PL'
        , [Analytics] CHAR(36) N'$.Analytics'
        , [Analytics2] CHAR(36) N'$.Analytics2'
        , [Amount] MONEY N'$.Amount'
        , [Info] NVARCHAR(250) N'$.Info'
        ) AS d
        WHERE r.type = N'Register.Accumulation.PL';
    END
    GO

    GRANT SELECT,INSERT,DELETE ON [Register.Accumulation.PL] TO JETTI;
    GO

    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.PL] ON [Register.Accumulation.PL] (
      id, parent, date, document, company, kind, calculated, exchangeRate, [Department], [PL], [Analytics], [Analytics2], [Amount], [Info]) WITH (MAXDOP=4);
    ALTER TABLE [Register.Accumulation.PL] ADD CONSTRAINT [PK_Register.Accumulation.PL] PRIMARY KEY NONCLUSTERED (id) WITH (MAXDOP=4);

    RAISERROR('Register.Accumulation.PL finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.PL.RC start', 0 ,1) WITH NOWAIT;
    GO

    DROP TABLE IF EXISTS [Register.Accumulation.PL.RC];
    SELECT
      r.id, r.parent, CAST(r.date AS DATE) date, CAST(r.document AS CHAR(36)) document, CAST(r.company AS CHAR(36)) company, r.kind, r.calculated,
      d.exchangeRate, [ResponsibilityCenter], [Department], [PL], [Analytics], [Analytics2], [Currency]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountRC] * IIF(r.kind = 1, 1, -1) [AmountRC], d.[AmountRC] * IIF(r.kind = 1, 1, null) [AmountRC.In], d.[AmountRC] * IIF(r.kind = 1, null, 1) [AmountRC.Out], [Info]
    INTO [Register.Accumulation.PL.RC]
    FROM [Accumulation] r
    CROSS APPLY OPENJSON (data, N'$')
    WITH (
      exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [ResponsibilityCenter] CHAR(36) N'$.ResponsibilityCenter'
        , [Department] CHAR(36) N'$.Department'
        , [PL] CHAR(36) N'$.PL'
        , [Analytics] CHAR(36) N'$.Analytics'
        , [Analytics2] CHAR(36) N'$.Analytics2'
        , [Currency] CHAR(36) N'$.Currency'
        , [Amount] MONEY N'$.Amount'
        , [AmountRC] MONEY N'$.AmountRC'
        , [Info] NVARCHAR(250) N'$.Info'
    ) AS d
    WHERE r.type = N'Register.Accumulation.PL.RC';
    GO

    CREATE OR ALTER TRIGGER [Register.Accumulation.PL.RC.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      IF (SELECT COUNT(*) FROM deleted) > 0 DELETE FROM [Register.Accumulation.PL.RC] WHERE id IN (SELECT id FROM deleted);
      IF (SELECT COUNT(*) FROM inserted) = 0 RETURN;
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
        , [ResponsibilityCenter] CHAR(36) N'$.ResponsibilityCenter'
        , [Department] CHAR(36) N'$.Department'
        , [PL] CHAR(36) N'$.PL'
        , [Analytics] CHAR(36) N'$.Analytics'
        , [Analytics2] CHAR(36) N'$.Analytics2'
        , [Currency] CHAR(36) N'$.Currency'
        , [Amount] MONEY N'$.Amount'
        , [AmountRC] MONEY N'$.AmountRC'
        , [Info] NVARCHAR(250) N'$.Info'
        ) AS d
        WHERE r.type = N'Register.Accumulation.PL.RC';
    END
    GO

    GRANT SELECT,INSERT,DELETE ON [Register.Accumulation.PL.RC] TO JETTI;
    GO

    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.PL.RC] ON [Register.Accumulation.PL.RC] (
      id, parent, date, document, company, kind, calculated, exchangeRate, [ResponsibilityCenter], [Department], [PL], [Analytics], [Analytics2], [Currency], [Amount], [AmountRC], [Info]) WITH (MAXDOP=4);
    ALTER TABLE [Register.Accumulation.PL.RC] ADD CONSTRAINT [PK_Register.Accumulation.PL.RC] PRIMARY KEY NONCLUSTERED (id) WITH (MAXDOP=4);

    RAISERROR('Register.Accumulation.PL.RC finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Sales start', 0 ,1) WITH NOWAIT;
    GO

    DROP TABLE IF EXISTS [Register.Accumulation.Sales];
    SELECT
      r.id, r.parent, CAST(r.date AS DATE) date, CAST(r.document AS CHAR(36)) document, CAST(r.company AS CHAR(36)) company, r.kind, r.calculated,
      d.exchangeRate, [currency], [Department], [Customer], [Product], [Analytic], [Manager], [DeliveryType], [OrderSource], [RetailClient], [AO], [Storehouse], [OpenTime], [PrintTime], [DeliverTime], [BillTime], [CloseTime]
      , d.[CashShift] * IIF(r.kind = 1, 1, -1) [CashShift], d.[CashShift] * IIF(r.kind = 1, 1, null) [CashShift.In], d.[CashShift] * IIF(r.kind = 1, null, 1) [CashShift.Out]
      , d.[Cost] * IIF(r.kind = 1, 1, -1) [Cost], d.[Cost] * IIF(r.kind = 1, 1, null) [Cost.In], d.[Cost] * IIF(r.kind = 1, null, 1) [Cost.Out]
      , d.[Qty] * IIF(r.kind = 1, 1, -1) [Qty], d.[Qty] * IIF(r.kind = 1, 1, null) [Qty.In], d.[Qty] * IIF(r.kind = 1, null, 1) [Qty.Out]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[Discount] * IIF(r.kind = 1, 1, -1) [Discount], d.[Discount] * IIF(r.kind = 1, 1, null) [Discount.In], d.[Discount] * IIF(r.kind = 1, null, 1) [Discount.Out]
      , d.[Tax] * IIF(r.kind = 1, 1, -1) [Tax], d.[Tax] * IIF(r.kind = 1, 1, null) [Tax.In], d.[Tax] * IIF(r.kind = 1, null, 1) [Tax.Out]
      , d.[AmountInDoc] * IIF(r.kind = 1, 1, -1) [AmountInDoc], d.[AmountInDoc] * IIF(r.kind = 1, 1, null) [AmountInDoc.In], d.[AmountInDoc] * IIF(r.kind = 1, null, 1) [AmountInDoc.Out]
      , d.[AmountInAR] * IIF(r.kind = 1, 1, -1) [AmountInAR], d.[AmountInAR] * IIF(r.kind = 1, 1, null) [AmountInAR.In], d.[AmountInAR] * IIF(r.kind = 1, null, 1) [AmountInAR.Out]
    INTO [Register.Accumulation.Sales]
    FROM [Accumulation] r
    CROSS APPLY OPENJSON (data, N'$')
    WITH (
      exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [currency] CHAR(36) N'$.currency'
        , [Department] CHAR(36) N'$.Department'
        , [Customer] CHAR(36) N'$.Customer'
        , [Product] CHAR(36) N'$.Product'
        , [Analytic] CHAR(36) N'$.Analytic'
        , [Manager] CHAR(36) N'$.Manager'
        , [DeliveryType] NVARCHAR(250) N'$.DeliveryType'
        , [OrderSource] NVARCHAR(250) N'$.OrderSource'
        , [RetailClient] CHAR(36) N'$.RetailClient'
        , [AO] CHAR(36) N'$.AO'
        , [Storehouse] CHAR(36) N'$.Storehouse'
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
    GO

    CREATE OR ALTER TRIGGER [Register.Accumulation.Sales.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      IF (SELECT COUNT(*) FROM deleted) > 0 DELETE FROM [Register.Accumulation.Sales] WHERE id IN (SELECT id FROM deleted);
      IF (SELECT COUNT(*) FROM inserted) = 0 RETURN;
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
        , [currency] CHAR(36) N'$.currency'
        , [Department] CHAR(36) N'$.Department'
        , [Customer] CHAR(36) N'$.Customer'
        , [Product] CHAR(36) N'$.Product'
        , [Analytic] CHAR(36) N'$.Analytic'
        , [Manager] CHAR(36) N'$.Manager'
        , [DeliveryType] NVARCHAR(250) N'$.DeliveryType'
        , [OrderSource] NVARCHAR(250) N'$.OrderSource'
        , [RetailClient] CHAR(36) N'$.RetailClient'
        , [AO] CHAR(36) N'$.AO'
        , [Storehouse] CHAR(36) N'$.Storehouse'
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

    GRANT SELECT,INSERT,DELETE ON [Register.Accumulation.Sales] TO JETTI;
    GO

    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.Sales] ON [Register.Accumulation.Sales] (
      id, parent, date, document, company, kind, calculated, exchangeRate, [currency], [Department], [Customer], [Product], [Analytic], [Manager], [DeliveryType], [OrderSource], [RetailClient], [AO], [Storehouse], [OpenTime], [PrintTime], [DeliverTime], [BillTime], [CloseTime], [CashShift], [Cost], [Qty], [Amount], [Discount], [Tax], [AmountInDoc], [AmountInAR]) WITH (MAXDOP=4);
    ALTER TABLE [Register.Accumulation.Sales] ADD CONSTRAINT [PK_Register.Accumulation.Sales] PRIMARY KEY NONCLUSTERED (id) WITH (MAXDOP=4);

    RAISERROR('Register.Accumulation.Sales finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Salary start', 0 ,1) WITH NOWAIT;
    GO

    DROP TABLE IF EXISTS [Register.Accumulation.Salary];
    SELECT
      r.id, r.parent, CAST(r.date AS DATE) date, CAST(r.document AS CHAR(36)) document, CAST(r.company AS CHAR(36)) company, r.kind, r.calculated,
      d.exchangeRate, [currency], [KorrCompany], [Department], [Person], [Employee], [SalaryKind], [Analytics], [PL], [PLAnalytics], [Status], [IsPortal]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
    INTO [Register.Accumulation.Salary]
    FROM [Accumulation] r
    CROSS APPLY OPENJSON (data, N'$')
    WITH (
      exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [currency] CHAR(36) N'$.currency'
        , [KorrCompany] CHAR(36) N'$.KorrCompany'
        , [Department] CHAR(36) N'$.Department'
        , [Person] CHAR(36) N'$.Person'
        , [Employee] CHAR(36) N'$.Employee'
        , [SalaryKind] NVARCHAR(250) N'$.SalaryKind'
        , [Analytics] CHAR(36) N'$.Analytics'
        , [PL] CHAR(36) N'$.PL'
        , [PLAnalytics] CHAR(36) N'$.PLAnalytics'
        , [Status] NVARCHAR(250) N'$.Status'
        , [IsPortal] BIT N'$.IsPortal'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
    ) AS d
    WHERE r.type = N'Register.Accumulation.Salary';
    GO

    CREATE OR ALTER TRIGGER [Register.Accumulation.Salary.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      IF (SELECT COUNT(*) FROM deleted) > 0 DELETE FROM [Register.Accumulation.Salary] WHERE id IN (SELECT id FROM deleted);
      IF (SELECT COUNT(*) FROM inserted) = 0 RETURN;
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
        , [currency] CHAR(36) N'$.currency'
        , [KorrCompany] CHAR(36) N'$.KorrCompany'
        , [Department] CHAR(36) N'$.Department'
        , [Person] CHAR(36) N'$.Person'
        , [Employee] CHAR(36) N'$.Employee'
        , [SalaryKind] NVARCHAR(250) N'$.SalaryKind'
        , [Analytics] CHAR(36) N'$.Analytics'
        , [PL] CHAR(36) N'$.PL'
        , [PLAnalytics] CHAR(36) N'$.PLAnalytics'
        , [Status] NVARCHAR(250) N'$.Status'
        , [IsPortal] BIT N'$.IsPortal'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
        ) AS d
        WHERE r.type = N'Register.Accumulation.Salary';
    END
    GO

    GRANT SELECT,INSERT,DELETE ON [Register.Accumulation.Salary] TO JETTI;
    GO

    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.Salary] ON [Register.Accumulation.Salary] (
      id, parent, date, document, company, kind, calculated, exchangeRate, [currency], [KorrCompany], [Department], [Person], [Employee], [SalaryKind], [Analytics], [PL], [PLAnalytics], [Status], [IsPortal], [Amount], [AmountInBalance], [AmountInAccounting]) WITH (MAXDOP=4);
    ALTER TABLE [Register.Accumulation.Salary] ADD CONSTRAINT [PK_Register.Accumulation.Salary] PRIMARY KEY NONCLUSTERED (id) WITH (MAXDOP=4);

    RAISERROR('Register.Accumulation.Salary finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Depreciation start', 0 ,1) WITH NOWAIT;
    GO

    DROP TABLE IF EXISTS [Register.Accumulation.Depreciation];
    SELECT
      r.id, r.parent, CAST(r.date AS DATE) date, CAST(r.document AS CHAR(36)) document, CAST(r.company AS CHAR(36)) company, r.kind, r.calculated,
      d.exchangeRate, [OperationType], [currency], [Department], [OE]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
    INTO [Register.Accumulation.Depreciation]
    FROM [Accumulation] r
    CROSS APPLY OPENJSON (data, N'$')
    WITH (
      exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [OperationType] CHAR(36) N'$.OperationType'
        , [currency] CHAR(36) N'$.currency'
        , [Department] CHAR(36) N'$.Department'
        , [OE] CHAR(36) N'$.OE'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
    ) AS d
    WHERE r.type = N'Register.Accumulation.Depreciation';
    GO

    CREATE OR ALTER TRIGGER [Register.Accumulation.Depreciation.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      IF (SELECT COUNT(*) FROM deleted) > 0 DELETE FROM [Register.Accumulation.Depreciation] WHERE id IN (SELECT id FROM deleted);
      IF (SELECT COUNT(*) FROM inserted) = 0 RETURN;
      INSERT INTO [Register.Accumulation.Depreciation]
      SELECT
        r.id, r.parent, r.date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, [OperationType], [currency], [Department], [OE]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
        FROM inserted r
        CROSS APPLY OPENJSON (data, N'$')
        WITH (
          exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [OperationType] CHAR(36) N'$.OperationType'
        , [currency] CHAR(36) N'$.currency'
        , [Department] CHAR(36) N'$.Department'
        , [OE] CHAR(36) N'$.OE'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
        ) AS d
        WHERE r.type = N'Register.Accumulation.Depreciation';
    END
    GO

    GRANT SELECT,INSERT,DELETE ON [Register.Accumulation.Depreciation] TO JETTI;
    GO

    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.Depreciation] ON [Register.Accumulation.Depreciation] (
      id, parent, date, document, company, kind, calculated, exchangeRate, [OperationType], [currency], [Department], [OE], [Amount], [AmountInBalance], [AmountInAccounting]) WITH (MAXDOP=4);
    ALTER TABLE [Register.Accumulation.Depreciation] ADD CONSTRAINT [PK_Register.Accumulation.Depreciation] PRIMARY KEY NONCLUSTERED (id) WITH (MAXDOP=4);

    RAISERROR('Register.Accumulation.Depreciation finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.CashToPay start', 0 ,1) WITH NOWAIT;
    GO

    DROP TABLE IF EXISTS [Register.Accumulation.CashToPay];
    SELECT
      r.id, r.parent, CAST(r.date AS DATE) date, CAST(r.document AS CHAR(36)) document, CAST(r.company AS CHAR(36)) company, r.kind, r.calculated,
      d.exchangeRate, [currency], [CashFlow], [CashRequest], [Contract], [BankAccountPerson], [Department], [OperationType], [Loan], [CashOrBank], [CashRecipient], [ExpenseOrBalance], [ExpenseAnalytics], [BalanceAnalytics], [PayDay]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
    INTO [Register.Accumulation.CashToPay]
    FROM [Accumulation] r
    CROSS APPLY OPENJSON (data, N'$')
    WITH (
      exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [currency] CHAR(36) N'$.currency'
        , [CashFlow] CHAR(36) N'$.CashFlow'
        , [CashRequest] CHAR(36) N'$.CashRequest'
        , [Contract] CHAR(36) N'$.Contract'
        , [BankAccountPerson] CHAR(36) N'$.BankAccountPerson'
        , [Department] CHAR(36) N'$.Department'
        , [OperationType] NVARCHAR(250) N'$.OperationType'
        , [Loan] CHAR(36) N'$.Loan'
        , [CashOrBank] CHAR(36) N'$.CashOrBank'
        , [CashRecipient] CHAR(36) N'$.CashRecipient'
        , [ExpenseOrBalance] CHAR(36) N'$.ExpenseOrBalance'
        , [ExpenseAnalytics] CHAR(36) N'$.ExpenseAnalytics'
        , [BalanceAnalytics] CHAR(36) N'$.BalanceAnalytics'
        , [PayDay] DATE N'$.PayDay'
        , [Amount] MONEY N'$.Amount'
    ) AS d
    WHERE r.type = N'Register.Accumulation.CashToPay';
    GO

    CREATE OR ALTER TRIGGER [Register.Accumulation.CashToPay.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      IF (SELECT COUNT(*) FROM deleted) > 0 DELETE FROM [Register.Accumulation.CashToPay] WHERE id IN (SELECT id FROM deleted);
      IF (SELECT COUNT(*) FROM inserted) = 0 RETURN;
      INSERT INTO [Register.Accumulation.CashToPay]
      SELECT
        r.id, r.parent, r.date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, [currency], [CashFlow], [CashRequest], [Contract], [BankAccountPerson], [Department], [OperationType], [Loan], [CashOrBank], [CashRecipient], [ExpenseOrBalance], [ExpenseAnalytics], [BalanceAnalytics], [PayDay]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
        FROM inserted r
        CROSS APPLY OPENJSON (data, N'$')
        WITH (
          exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [currency] CHAR(36) N'$.currency'
        , [CashFlow] CHAR(36) N'$.CashFlow'
        , [CashRequest] CHAR(36) N'$.CashRequest'
        , [Contract] CHAR(36) N'$.Contract'
        , [BankAccountPerson] CHAR(36) N'$.BankAccountPerson'
        , [Department] CHAR(36) N'$.Department'
        , [OperationType] NVARCHAR(250) N'$.OperationType'
        , [Loan] CHAR(36) N'$.Loan'
        , [CashOrBank] CHAR(36) N'$.CashOrBank'
        , [CashRecipient] CHAR(36) N'$.CashRecipient'
        , [ExpenseOrBalance] CHAR(36) N'$.ExpenseOrBalance'
        , [ExpenseAnalytics] CHAR(36) N'$.ExpenseAnalytics'
        , [BalanceAnalytics] CHAR(36) N'$.BalanceAnalytics'
        , [PayDay] DATE N'$.PayDay'
        , [Amount] MONEY N'$.Amount'
        ) AS d
        WHERE r.type = N'Register.Accumulation.CashToPay';
    END
    GO

    GRANT SELECT,INSERT,DELETE ON [Register.Accumulation.CashToPay] TO JETTI;
    GO

    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.CashToPay] ON [Register.Accumulation.CashToPay] (
      id, parent, date, document, company, kind, calculated, exchangeRate, [currency], [CashFlow], [CashRequest], [Contract], [BankAccountPerson], [Department], [OperationType], [Loan], [CashOrBank], [CashRecipient], [ExpenseOrBalance], [ExpenseAnalytics], [BalanceAnalytics], [PayDay], [Amount]) WITH (MAXDOP=4);
    ALTER TABLE [Register.Accumulation.CashToPay] ADD CONSTRAINT [PK_Register.Accumulation.CashToPay] PRIMARY KEY NONCLUSTERED (id) WITH (MAXDOP=4);

    RAISERROR('Register.Accumulation.CashToPay finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.BudgetItemTurnover start', 0 ,1) WITH NOWAIT;
    GO

    DROP TABLE IF EXISTS [Register.Accumulation.BudgetItemTurnover];
    SELECT
      r.id, r.parent, CAST(r.date AS DATE) date, CAST(r.document AS CHAR(36)) document, CAST(r.company AS CHAR(36)) company, r.kind, r.calculated,
      d.exchangeRate, [Department], [Scenario], [BudgetItem], [Anatitic1], [Anatitic2], [Anatitic3], [Anatitic4], [Anatitic5], [currency]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInScenatio] * IIF(r.kind = 1, 1, -1) [AmountInScenatio], d.[AmountInScenatio] * IIF(r.kind = 1, 1, null) [AmountInScenatio.In], d.[AmountInScenatio] * IIF(r.kind = 1, null, 1) [AmountInScenatio.Out]
      , d.[AmountInCurrency] * IIF(r.kind = 1, 1, -1) [AmountInCurrency], d.[AmountInCurrency] * IIF(r.kind = 1, 1, null) [AmountInCurrency.In], d.[AmountInCurrency] * IIF(r.kind = 1, null, 1) [AmountInCurrency.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
      , d.[Qty] * IIF(r.kind = 1, 1, -1) [Qty], d.[Qty] * IIF(r.kind = 1, 1, null) [Qty.In], d.[Qty] * IIF(r.kind = 1, null, 1) [Qty.Out]
    INTO [Register.Accumulation.BudgetItemTurnover]
    FROM [Accumulation] r
    CROSS APPLY OPENJSON (data, N'$')
    WITH (
      exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [Department] CHAR(36) N'$.Department'
        , [Scenario] CHAR(36) N'$.Scenario'
        , [BudgetItem] CHAR(36) N'$.BudgetItem'
        , [Anatitic1] CHAR(36) N'$.Anatitic1'
        , [Anatitic2] CHAR(36) N'$.Anatitic2'
        , [Anatitic3] CHAR(36) N'$.Anatitic3'
        , [Anatitic4] CHAR(36) N'$.Anatitic4'
        , [Anatitic5] CHAR(36) N'$.Anatitic5'
        , [currency] CHAR(36) N'$.currency'
        , [Amount] MONEY N'$.Amount'
        , [AmountInScenatio] MONEY N'$.AmountInScenatio'
        , [AmountInCurrency] MONEY N'$.AmountInCurrency'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
        , [Qty] MONEY N'$.Qty'
    ) AS d
    WHERE r.type = N'Register.Accumulation.BudgetItemTurnover';
    GO

    CREATE OR ALTER TRIGGER [Register.Accumulation.BudgetItemTurnover.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      IF (SELECT COUNT(*) FROM deleted) > 0 DELETE FROM [Register.Accumulation.BudgetItemTurnover] WHERE id IN (SELECT id FROM deleted);
      IF (SELECT COUNT(*) FROM inserted) = 0 RETURN;
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
        , [Department] CHAR(36) N'$.Department'
        , [Scenario] CHAR(36) N'$.Scenario'
        , [BudgetItem] CHAR(36) N'$.BudgetItem'
        , [Anatitic1] CHAR(36) N'$.Anatitic1'
        , [Anatitic2] CHAR(36) N'$.Anatitic2'
        , [Anatitic3] CHAR(36) N'$.Anatitic3'
        , [Anatitic4] CHAR(36) N'$.Anatitic4'
        , [Anatitic5] CHAR(36) N'$.Anatitic5'
        , [currency] CHAR(36) N'$.currency'
        , [Amount] MONEY N'$.Amount'
        , [AmountInScenatio] MONEY N'$.AmountInScenatio'
        , [AmountInCurrency] MONEY N'$.AmountInCurrency'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
        , [Qty] MONEY N'$.Qty'
        ) AS d
        WHERE r.type = N'Register.Accumulation.BudgetItemTurnover';
    END
    GO

    GRANT SELECT,INSERT,DELETE ON [Register.Accumulation.BudgetItemTurnover] TO JETTI;
    GO

    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.BudgetItemTurnover] ON [Register.Accumulation.BudgetItemTurnover] (
      id, parent, date, document, company, kind, calculated, exchangeRate, [Department], [Scenario], [BudgetItem], [Anatitic1], [Anatitic2], [Anatitic3], [Anatitic4], [Anatitic5], [currency], [Amount], [AmountInScenatio], [AmountInCurrency], [AmountInAccounting], [Qty]) WITH (MAXDOP=4);
    ALTER TABLE [Register.Accumulation.BudgetItemTurnover] ADD CONSTRAINT [PK_Register.Accumulation.BudgetItemTurnover] PRIMARY KEY NONCLUSTERED (id) WITH (MAXDOP=4);

    RAISERROR('Register.Accumulation.BudgetItemTurnover finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Intercompany start', 0 ,1) WITH NOWAIT;
    GO

    DROP TABLE IF EXISTS [Register.Accumulation.Intercompany];
    SELECT
      r.id, r.parent, CAST(r.date AS DATE) date, CAST(r.document AS CHAR(36)) document, CAST(r.company AS CHAR(36)) company, r.kind, r.calculated,
      d.exchangeRate, [Intercompany], [LegalCompanySender], [LegalCompanyRecipient], [Contract], [OperationType], [Analytics], [currency]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
    INTO [Register.Accumulation.Intercompany]
    FROM [Accumulation] r
    CROSS APPLY OPENJSON (data, N'$')
    WITH (
      exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [Intercompany] CHAR(36) N'$.Intercompany'
        , [LegalCompanySender] CHAR(36) N'$.LegalCompanySender'
        , [LegalCompanyRecipient] CHAR(36) N'$.LegalCompanyRecipient'
        , [Contract] CHAR(36) N'$.Contract'
        , [OperationType] CHAR(36) N'$.OperationType'
        , [Analytics] CHAR(36) N'$.Analytics'
        , [currency] CHAR(36) N'$.currency'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
    ) AS d
    WHERE r.type = N'Register.Accumulation.Intercompany';
    GO

    CREATE OR ALTER TRIGGER [Register.Accumulation.Intercompany.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      IF (SELECT COUNT(*) FROM deleted) > 0 DELETE FROM [Register.Accumulation.Intercompany] WHERE id IN (SELECT id FROM deleted);
      IF (SELECT COUNT(*) FROM inserted) = 0 RETURN;
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
        , [Intercompany] CHAR(36) N'$.Intercompany'
        , [LegalCompanySender] CHAR(36) N'$.LegalCompanySender'
        , [LegalCompanyRecipient] CHAR(36) N'$.LegalCompanyRecipient'
        , [Contract] CHAR(36) N'$.Contract'
        , [OperationType] CHAR(36) N'$.OperationType'
        , [Analytics] CHAR(36) N'$.Analytics'
        , [currency] CHAR(36) N'$.currency'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountInAccounting] MONEY N'$.AmountInAccounting'
        ) AS d
        WHERE r.type = N'Register.Accumulation.Intercompany';
    END
    GO

    GRANT SELECT,INSERT,DELETE ON [Register.Accumulation.Intercompany] TO JETTI;
    GO

    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.Intercompany] ON [Register.Accumulation.Intercompany] (
      id, parent, date, document, company, kind, calculated, exchangeRate, [Intercompany], [LegalCompanySender], [LegalCompanyRecipient], [Contract], [OperationType], [Analytics], [currency], [Amount], [AmountInBalance], [AmountInAccounting]) WITH (MAXDOP=4);
    ALTER TABLE [Register.Accumulation.Intercompany] ADD CONSTRAINT [PK_Register.Accumulation.Intercompany] PRIMARY KEY NONCLUSTERED (id) WITH (MAXDOP=4);

    RAISERROR('Register.Accumulation.Intercompany finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Acquiring start', 0 ,1) WITH NOWAIT;
    GO

    DROP TABLE IF EXISTS [Register.Accumulation.Acquiring];
    SELECT
      r.id, r.parent, CAST(r.date AS DATE) date, CAST(r.document AS CHAR(36)) document, CAST(r.company AS CHAR(36)) company, r.kind, r.calculated,
      d.exchangeRate, [AcquiringTerminal], [AcquiringTerminalCode1], [OperationType], [Department], [CashFlow], [PaymantCard], [PayDay], [currency]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountOperation] * IIF(r.kind = 1, 1, -1) [AmountOperation], d.[AmountOperation] * IIF(r.kind = 1, 1, null) [AmountOperation.In], d.[AmountOperation] * IIF(r.kind = 1, null, 1) [AmountOperation.Out]
      , d.[AmountPaid] * IIF(r.kind = 1, 1, -1) [AmountPaid], d.[AmountPaid] * IIF(r.kind = 1, 1, null) [AmountPaid.In], d.[AmountPaid] * IIF(r.kind = 1, null, 1) [AmountPaid.Out], [DateOperation], [DatePaid], [AuthorizationCode]
    INTO [Register.Accumulation.Acquiring]
    FROM [Accumulation] r
    CROSS APPLY OPENJSON (data, N'$')
    WITH (
      exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [AcquiringTerminal] CHAR(36) N'$.AcquiringTerminal'
        , [AcquiringTerminalCode1] NVARCHAR(250) N'$.AcquiringTerminalCode1'
        , [OperationType] CHAR(36) N'$.OperationType'
        , [Department] CHAR(36) N'$.Department'
        , [CashFlow] CHAR(36) N'$.CashFlow'
        , [PaymantCard] NVARCHAR(250) N'$.PaymantCard'
        , [PayDay] DATE N'$.PayDay'
        , [currency] CHAR(36) N'$.currency'
        , [Amount] MONEY N'$.Amount'
        , [AmountInBalance] MONEY N'$.AmountInBalance'
        , [AmountOperation] MONEY N'$.AmountOperation'
        , [AmountPaid] MONEY N'$.AmountPaid'
        , [DateOperation] DATE N'$.DateOperation'
        , [DatePaid] DATE N'$.DatePaid'
        , [AuthorizationCode] NVARCHAR(250) N'$.AuthorizationCode'
    ) AS d
    WHERE r.type = N'Register.Accumulation.Acquiring';
    GO

    CREATE OR ALTER TRIGGER [Register.Accumulation.Acquiring.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      IF (SELECT COUNT(*) FROM deleted) > 0 DELETE FROM [Register.Accumulation.Acquiring] WHERE id IN (SELECT id FROM deleted);
      IF (SELECT COUNT(*) FROM inserted) = 0 RETURN;
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
        , [AcquiringTerminal] CHAR(36) N'$.AcquiringTerminal'
        , [AcquiringTerminalCode1] NVARCHAR(250) N'$.AcquiringTerminalCode1'
        , [OperationType] CHAR(36) N'$.OperationType'
        , [Department] CHAR(36) N'$.Department'
        , [CashFlow] CHAR(36) N'$.CashFlow'
        , [PaymantCard] NVARCHAR(250) N'$.PaymantCard'
        , [PayDay] DATE N'$.PayDay'
        , [currency] CHAR(36) N'$.currency'
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

    GRANT SELECT,INSERT,DELETE ON [Register.Accumulation.Acquiring] TO JETTI;
    GO

    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.Acquiring] ON [Register.Accumulation.Acquiring] (
      id, parent, date, document, company, kind, calculated, exchangeRate, [AcquiringTerminal], [AcquiringTerminalCode1], [OperationType], [Department], [CashFlow], [PaymantCard], [PayDay], [currency], [Amount], [AmountInBalance], [AmountOperation], [AmountPaid], [DateOperation], [DatePaid], [AuthorizationCode]) WITH (MAXDOP=4);
    ALTER TABLE [Register.Accumulation.Acquiring] ADD CONSTRAINT [PK_Register.Accumulation.Acquiring] PRIMARY KEY NONCLUSTERED (id) WITH (MAXDOP=4);

    RAISERROR('Register.Accumulation.Acquiring finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.StaffingTable start', 0 ,1) WITH NOWAIT;
    GO

    DROP TABLE IF EXISTS [Register.Accumulation.StaffingTable];
    SELECT
      r.id, r.parent, CAST(r.date AS DATE) date, CAST(r.document AS CHAR(36)) document, CAST(r.company AS CHAR(36)) company, r.kind, r.calculated,
      d.exchangeRate, [Department], [DepartmentCompany], [StaffingTablePosition], [Employee], [Person]
      , d.[SalaryRate] * IIF(r.kind = 1, 1, -1) [SalaryRate], d.[SalaryRate] * IIF(r.kind = 1, 1, null) [SalaryRate.In], d.[SalaryRate] * IIF(r.kind = 1, null, 1) [SalaryRate.Out], [SalaryAnalytic], [currency]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
    INTO [Register.Accumulation.StaffingTable]
    FROM [Accumulation] r
    CROSS APPLY OPENJSON (data, N'$')
    WITH (
      exchangeRate NUMERIC(15,10) N'$.exchangeRate'
        , [Department] CHAR(36) N'$.Department'
        , [DepartmentCompany] CHAR(36) N'$.DepartmentCompany'
        , [StaffingTablePosition] CHAR(36) N'$.StaffingTablePosition'
        , [Employee] CHAR(36) N'$.Employee'
        , [Person] CHAR(36) N'$.Person'
        , [SalaryRate] MONEY N'$.SalaryRate'
        , [SalaryAnalytic] CHAR(36) N'$.SalaryAnalytic'
        , [currency] CHAR(36) N'$.currency'
        , [Amount] MONEY N'$.Amount'
    ) AS d
    WHERE r.type = N'Register.Accumulation.StaffingTable';
    GO

    CREATE OR ALTER TRIGGER [Register.Accumulation.StaffingTable.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      IF (SELECT COUNT(*) FROM deleted) > 0 DELETE FROM [Register.Accumulation.StaffingTable] WHERE id IN (SELECT id FROM deleted);
      IF (SELECT COUNT(*) FROM inserted) = 0 RETURN;
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
        , [Department] CHAR(36) N'$.Department'
        , [DepartmentCompany] CHAR(36) N'$.DepartmentCompany'
        , [StaffingTablePosition] CHAR(36) N'$.StaffingTablePosition'
        , [Employee] CHAR(36) N'$.Employee'
        , [Person] CHAR(36) N'$.Person'
        , [SalaryRate] MONEY N'$.SalaryRate'
        , [SalaryAnalytic] CHAR(36) N'$.SalaryAnalytic'
        , [currency] CHAR(36) N'$.currency'
        , [Amount] MONEY N'$.Amount'
        ) AS d
        WHERE r.type = N'Register.Accumulation.StaffingTable';
    END
    GO

    GRANT SELECT,INSERT,DELETE ON [Register.Accumulation.StaffingTable] TO JETTI;
    GO

    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.StaffingTable] ON [Register.Accumulation.StaffingTable] (
      id, parent, date, document, company, kind, calculated, exchangeRate, [Department], [DepartmentCompany], [StaffingTablePosition], [Employee], [Person], [SalaryRate], [SalaryAnalytic], [currency], [Amount]) WITH (MAXDOP=4);
    ALTER TABLE [Register.Accumulation.StaffingTable] ADD CONSTRAINT [PK_Register.Accumulation.StaffingTable] PRIMARY KEY NONCLUSTERED (id) WITH (MAXDOP=4);

    RAISERROR('Register.Accumulation.StaffingTable finish', 0 ,1) WITH NOWAIT;
    GO
    
    