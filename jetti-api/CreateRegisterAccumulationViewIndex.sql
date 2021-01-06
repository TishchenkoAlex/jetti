
    
    RAISERROR('Register.Accumulation.AccountablePersons start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.AccountablePersons.v] WITH SCHEMABINDING AS
    SELECT [id], [kind], [parent], CAST(date AS DATE) [date], [document], [company], [calculated]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) [currency]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Employee"')) [Employee]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashFlow"')) [CashFlow]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1) [Amount]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1,  null) [Amount.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null,  1) [Amount.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, -1) [AmountInBalance]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1,  null) [AmountInBalance.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, null,  1) [AmountInBalance.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, -1) [AmountInAccounting]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1,  null) [AmountInAccounting.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, null,  1) [AmountInAccounting.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountToPay"')) * IIF(kind = 1, 1, -1) [AmountToPay]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountToPay"')) * IIF(kind = 1, 1,  null) [AmountToPay.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountToPay"')) * IIF(kind = 1, null,  1) [AmountToPay.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountIsPaid"')) * IIF(kind = 1, 1, -1) [AmountIsPaid]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountIsPaid"')) * IIF(kind = 1, 1,  null) [AmountIsPaid.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountIsPaid"')) * IIF(kind = 1, null,  1) [AmountIsPaid.Out]
      FROM dbo.[Accumulation] WHERE [type] = N'Register.Accumulation.AccountablePersons';
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.AccountablePersons.id] ON [Register.Accumulation.AccountablePersons.v]([id]);
    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.AccountablePersons] ON [Register.Accumulation.AccountablePersons.v]([id], [kind], [parent], [date], [document], [company], [calculated], [currency], [Employee], [CashFlow], [Amount], [Amount.In], [Amount.Out], [AmountInBalance], [AmountInBalance.In], [AmountInBalance.Out], [AmountInAccounting], [AmountInAccounting.In], [AmountInAccounting.Out], [AmountToPay], [AmountToPay.In], [AmountToPay.Out], [AmountIsPaid], [AmountIsPaid.In], [AmountIsPaid.Out]);
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.AccountablePersons] AS SELECT * FROM [Register.Accumulation.AccountablePersons.v] WITH (NOEXPAND);
    GO
    GRANT SELECT, DELETE ON [Register.Accumulation.AccountablePersons] TO JETTI;
    GO
    RAISERROR('Register.Accumulation.AccountablePersons finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.PaymentBatch start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.PaymentBatch.v] WITH SCHEMABINDING AS
    SELECT [id], [kind], [parent], CAST(date AS DATE) [date], [document], [company], [calculated]
        , TRY_CONVERT(VARCHAR(64), JSON_VALUE(data, '$."PaymentsKind"')) [PaymentsKind]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Counterpartie"')) [Counterpartie]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."ProductPackage"')) [ProductPackage]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Product"')) [Product]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Currency"')) [Currency]
        , TRY_CONVERT(DATE, JSON_VALUE(data, N'$."PayDay"'),127) [PayDay]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Qty"')) * IIF(kind = 1, 1, -1) [Qty]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Qty"')) * IIF(kind = 1, 1,  null) [Qty.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Qty"')) * IIF(kind = 1, null,  1) [Qty.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Price"')) * IIF(kind = 1, 1, -1) [Price]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Price"')) * IIF(kind = 1, 1,  null) [Price.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Price"')) * IIF(kind = 1, null,  1) [Price.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1) [Amount]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1,  null) [Amount.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null,  1) [Amount.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, -1) [AmountInBalance]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1,  null) [AmountInBalance.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, null,  1) [AmountInBalance.Out]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."batch"')) [batch]
      FROM dbo.[Accumulation] WHERE [type] = N'Register.Accumulation.PaymentBatch';
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.PaymentBatch.id] ON [Register.Accumulation.PaymentBatch.v]([id]);
    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.PaymentBatch] ON [Register.Accumulation.PaymentBatch.v]([id], [kind], [parent], [date], [document], [company], [calculated], [PaymentsKind], [Counterpartie], [ProductPackage], [Product], [Currency], [PayDay], [Qty], [Qty.In], [Qty.Out], [Price], [Price.In], [Price.Out], [Amount], [Amount.In], [Amount.Out], [AmountInBalance], [AmountInBalance.In], [AmountInBalance.Out], [batch]);
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.PaymentBatch] AS SELECT * FROM [Register.Accumulation.PaymentBatch.v] WITH (NOEXPAND);
    GO
    GRANT SELECT, DELETE ON [Register.Accumulation.PaymentBatch] TO JETTI;
    GO
    RAISERROR('Register.Accumulation.PaymentBatch finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Investment.Analytics start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Investment.Analytics.v] WITH SCHEMABINDING AS
    SELECT [id], [kind], [parent], CAST(date AS DATE) [date], [document], [company], [calculated]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) [Department]
        , TRY_CONVERT(VARCHAR(64), JSON_VALUE(data, '$."SourceTransaction"')) [SourceTransaction]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CreditTransaction"')) [CreditTransaction]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."OperationType"')) [OperationType]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Investor"')) [Investor]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CompanyProduct"')) [CompanyProduct]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Product"')) [Product]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Qty"')) * IIF(kind = 1, 1, -1) [Qty]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Qty"')) * IIF(kind = 1, 1,  null) [Qty.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Qty"')) * IIF(kind = 1, null,  1) [Qty.Out]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CurrencyProduct"')) [CurrencyProduct]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountProduct"')) * IIF(kind = 1, 1, -1) [AmountProduct]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountProduct"')) * IIF(kind = 1, 1,  null) [AmountProduct.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountProduct"')) * IIF(kind = 1, null,  1) [AmountProduct.Out]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."PaymentSource"')) [PaymentSource]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CurrencySource"')) [CurrencySource]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountSource"')) * IIF(kind = 1, 1, -1) [AmountSource]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountSource"')) * IIF(kind = 1, 1,  null) [AmountSource.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountSource"')) * IIF(kind = 1, null,  1) [AmountSource.Out]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CompanyLoan"')) [CompanyLoan]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Loan"')) [Loan]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CurrencyLoan"')) [CurrencyLoan]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountLoan"')) * IIF(kind = 1, 1, -1) [AmountLoan]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountLoan"')) * IIF(kind = 1, 1,  null) [AmountLoan.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountLoan"')) * IIF(kind = 1, null,  1) [AmountLoan.Out]
      FROM dbo.[Accumulation] WHERE [type] = N'Register.Accumulation.Investment.Analytics';
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Investment.Analytics.id] ON [Register.Accumulation.Investment.Analytics.v]([id]);
    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.Investment.Analytics] ON [Register.Accumulation.Investment.Analytics.v]([id], [kind], [parent], [date], [document], [company], [calculated], [Department], [SourceTransaction], [CreditTransaction], [OperationType], [Investor], [CompanyProduct], [Product], [Qty], [Qty.In], [Qty.Out], [CurrencyProduct], [AmountProduct], [AmountProduct.In], [AmountProduct.Out], [PaymentSource], [CurrencySource], [AmountSource], [AmountSource.In], [AmountSource.Out], [CompanyLoan], [Loan], [CurrencyLoan], [AmountLoan], [AmountLoan.In], [AmountLoan.Out]);
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Investment.Analytics] AS SELECT * FROM [Register.Accumulation.Investment.Analytics.v] WITH (NOEXPAND);
    GO
    GRANT SELECT, DELETE ON [Register.Accumulation.Investment.Analytics] TO JETTI;
    GO
    RAISERROR('Register.Accumulation.Investment.Analytics finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.OrderPayment start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.OrderPayment.v] WITH SCHEMABINDING AS
    SELECT [id], [kind], [parent], CAST(date AS DATE) [date], [document], [company], [calculated]
        , TRY_CONVERT(NVARCHAR(128), JSON_VALUE(data, '$."PaymantKind"')) [PaymantKind]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Customer"')) [Customer]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BankAccount"')) [BankAccount]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashRegister"')) [CashRegister]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."AcquiringTerminal"')) [AcquiringTerminal]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) [currency]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) [Department]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."CashShift"')) * IIF(kind = 1, 1, -1) [CashShift]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."CashShift"')) * IIF(kind = 1, 1,  null) [CashShift.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."CashShift"')) * IIF(kind = 1, null,  1) [CashShift.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1) [Amount]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1,  null) [Amount.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null,  1) [Amount.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, -1) [AmountInBalance]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1,  null) [AmountInBalance.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, null,  1) [AmountInBalance.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, -1) [AmountInAccounting]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1,  null) [AmountInAccounting.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, null,  1) [AmountInAccounting.Out]
      FROM dbo.[Accumulation] WHERE [type] = N'Register.Accumulation.OrderPayment';
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.OrderPayment.id] ON [Register.Accumulation.OrderPayment.v]([id]);
    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.OrderPayment] ON [Register.Accumulation.OrderPayment.v]([id], [kind], [parent], [date], [document], [company], [calculated], [PaymantKind], [Customer], [BankAccount], [CashRegister], [AcquiringTerminal], [currency], [Department], [CashShift], [CashShift.In], [CashShift.Out], [Amount], [Amount.In], [Amount.Out], [AmountInBalance], [AmountInBalance.In], [AmountInBalance.Out], [AmountInAccounting], [AmountInAccounting.In], [AmountInAccounting.Out]);
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.OrderPayment] AS SELECT * FROM [Register.Accumulation.OrderPayment.v] WITH (NOEXPAND);
    GO
    GRANT SELECT, DELETE ON [Register.Accumulation.OrderPayment] TO JETTI;
    GO
    RAISERROR('Register.Accumulation.OrderPayment finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.AP start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.AP.v] WITH SCHEMABINDING AS
    SELECT [id], [kind], [parent], CAST(date AS DATE) [date], [document], [company], [calculated]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) [currency]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) [Department]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."AO"')) [AO]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Supplier"')) [Supplier]
        , TRY_CONVERT(DATE, JSON_VALUE(data, N'$."PayDay"'),127) [PayDay]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1) [Amount]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1,  null) [Amount.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null,  1) [Amount.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, -1) [AmountInBalance]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1,  null) [AmountInBalance.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, null,  1) [AmountInBalance.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, -1) [AmountInAccounting]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1,  null) [AmountInAccounting.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, null,  1) [AmountInAccounting.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountToPay"')) * IIF(kind = 1, 1, -1) [AmountToPay]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountToPay"')) * IIF(kind = 1, 1,  null) [AmountToPay.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountToPay"')) * IIF(kind = 1, null,  1) [AmountToPay.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountIsPaid"')) * IIF(kind = 1, 1, -1) [AmountIsPaid]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountIsPaid"')) * IIF(kind = 1, 1,  null) [AmountIsPaid.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountIsPaid"')) * IIF(kind = 1, null,  1) [AmountIsPaid.Out]
      FROM dbo.[Accumulation] WHERE [type] = N'Register.Accumulation.AP';
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.AP.id] ON [Register.Accumulation.AP.v]([id]);
    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.AP] ON [Register.Accumulation.AP.v]([id], [kind], [parent], [date], [document], [company], [calculated], [currency], [Department], [AO], [Supplier], [PayDay], [Amount], [Amount.In], [Amount.Out], [AmountInBalance], [AmountInBalance.In], [AmountInBalance.Out], [AmountInAccounting], [AmountInAccounting.In], [AmountInAccounting.Out], [AmountToPay], [AmountToPay.In], [AmountToPay.Out], [AmountIsPaid], [AmountIsPaid.In], [AmountIsPaid.Out]);
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.AP] AS SELECT * FROM [Register.Accumulation.AP.v] WITH (NOEXPAND);
    GO
    GRANT SELECT, DELETE ON [Register.Accumulation.AP] TO JETTI;
    GO
    RAISERROR('Register.Accumulation.AP finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.AR start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.AR.v] WITH SCHEMABINDING AS
    SELECT [id], [kind], [parent], CAST(date AS DATE) [date], [document], [company], [calculated]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) [currency]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) [Department]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."AO"')) [AO]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Customer"')) [Customer]
        , TRY_CONVERT(DATE, JSON_VALUE(data, N'$."PayDay"'),127) [PayDay]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AR"')) * IIF(kind = 1, 1, -1) [AR]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AR"')) * IIF(kind = 1, 1,  null) [AR.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AR"')) * IIF(kind = 1, null,  1) [AR.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, -1) [AmountInBalance]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1,  null) [AmountInBalance.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, null,  1) [AmountInBalance.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, -1) [AmountInAccounting]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1,  null) [AmountInAccounting.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, null,  1) [AmountInAccounting.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountToPay"')) * IIF(kind = 1, 1, -1) [AmountToPay]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountToPay"')) * IIF(kind = 1, 1,  null) [AmountToPay.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountToPay"')) * IIF(kind = 1, null,  1) [AmountToPay.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountIsPaid"')) * IIF(kind = 1, 1, -1) [AmountIsPaid]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountIsPaid"')) * IIF(kind = 1, 1,  null) [AmountIsPaid.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountIsPaid"')) * IIF(kind = 1, null,  1) [AmountIsPaid.Out]
      FROM dbo.[Accumulation] WHERE [type] = N'Register.Accumulation.AR';
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.AR.id] ON [Register.Accumulation.AR.v]([id]);
    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.AR] ON [Register.Accumulation.AR.v]([id], [kind], [parent], [date], [document], [company], [calculated], [currency], [Department], [AO], [Customer], [PayDay], [AR], [AR.In], [AR.Out], [AmountInBalance], [AmountInBalance.In], [AmountInBalance.Out], [AmountInAccounting], [AmountInAccounting.In], [AmountInAccounting.Out], [AmountToPay], [AmountToPay.In], [AmountToPay.Out], [AmountIsPaid], [AmountIsPaid.In], [AmountIsPaid.Out]);
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.AR] AS SELECT * FROM [Register.Accumulation.AR.v] WITH (NOEXPAND);
    GO
    GRANT SELECT, DELETE ON [Register.Accumulation.AR] TO JETTI;
    GO
    RAISERROR('Register.Accumulation.AR finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Bank start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Bank.v] WITH SCHEMABINDING AS
    SELECT [id], [kind], [parent], CAST(date AS DATE) [date], [document], [company], [calculated]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) [currency]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BankAccount"')) [BankAccount]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashFlow"')) [CashFlow]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"')) [Analytics]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1) [Amount]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1,  null) [Amount.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null,  1) [Amount.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, -1) [AmountInBalance]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1,  null) [AmountInBalance.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, null,  1) [AmountInBalance.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, -1) [AmountInAccounting]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1,  null) [AmountInAccounting.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, null,  1) [AmountInAccounting.Out]
      FROM dbo.[Accumulation] WHERE [type] = N'Register.Accumulation.Bank';
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Bank.id] ON [Register.Accumulation.Bank.v]([id]);
    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.Bank] ON [Register.Accumulation.Bank.v]([id], [kind], [parent], [date], [document], [company], [calculated], [currency], [BankAccount], [CashFlow], [Analytics], [Amount], [Amount.In], [Amount.Out], [AmountInBalance], [AmountInBalance.In], [AmountInBalance.Out], [AmountInAccounting], [AmountInAccounting.In], [AmountInAccounting.Out]);
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Bank] AS SELECT * FROM [Register.Accumulation.Bank.v] WITH (NOEXPAND);
    GO
    GRANT SELECT, DELETE ON [Register.Accumulation.Bank] TO JETTI;
    GO
    RAISERROR('Register.Accumulation.Bank finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Balance start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Balance.v] WITH SCHEMABINDING AS
    SELECT [id], [kind], [parent], CAST(date AS DATE) [date], [document], [company], [calculated]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) [Department]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Balance"')) [Balance]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"')) [Analytics]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1) [Amount]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1,  null) [Amount.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null,  1) [Amount.Out]
        , TRY_CONVERT(NVARCHAR(128), JSON_VALUE(data, '$."Info"')) [Info]
      FROM dbo.[Accumulation] WHERE [type] = N'Register.Accumulation.Balance';
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Balance.id] ON [Register.Accumulation.Balance.v]([id]);
    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.Balance] ON [Register.Accumulation.Balance.v]([id], [kind], [parent], [date], [document], [company], [calculated], [Department], [Balance], [Analytics], [Amount], [Amount.In], [Amount.Out], [Info]);
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Balance] AS SELECT * FROM [Register.Accumulation.Balance.v] WITH (NOEXPAND);
    GO
    GRANT SELECT, DELETE ON [Register.Accumulation.Balance] TO JETTI;
    GO
    RAISERROR('Register.Accumulation.Balance finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Balance.RC start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Balance.RC.v] WITH SCHEMABINDING AS
    SELECT [id], [kind], [parent], CAST(date AS DATE) [date], [document], [company], [calculated]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."ResponsibilityCenter"')) [ResponsibilityCenter]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) [Department]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Balance"')) [Balance]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"')) [Analytics]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics2"')) [Analytics2]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Currency"')) [Currency]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1) [Amount]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1,  null) [Amount.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null,  1) [Amount.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountRC"')) * IIF(kind = 1, 1, -1) [AmountRC]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountRC"')) * IIF(kind = 1, 1,  null) [AmountRC.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountRC"')) * IIF(kind = 1, null,  1) [AmountRC.Out]
        , TRY_CONVERT(NVARCHAR(128), JSON_VALUE(data, '$."Info"')) [Info]
      FROM dbo.[Accumulation] WHERE [type] = N'Register.Accumulation.Balance.RC';
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Balance.RC.id] ON [Register.Accumulation.Balance.RC.v]([id]);
    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.Balance.RC] ON [Register.Accumulation.Balance.RC.v]([id], [kind], [parent], [date], [document], [company], [calculated], [ResponsibilityCenter], [Department], [Balance], [Analytics], [Analytics2], [Currency], [Amount], [Amount.In], [Amount.Out], [AmountRC], [AmountRC.In], [AmountRC.Out], [Info]);
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Balance.RC] AS SELECT * FROM [Register.Accumulation.Balance.RC.v] WITH (NOEXPAND);
    GO
    GRANT SELECT, DELETE ON [Register.Accumulation.Balance.RC] TO JETTI;
    GO
    RAISERROR('Register.Accumulation.Balance.RC finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Balance.Report start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Balance.Report.v] WITH SCHEMABINDING AS
    SELECT [id], [kind], [parent], CAST(date AS DATE) [date], [document], [company], [calculated]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) [currency]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) [Department]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Balance"')) [Balance]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"')) [Analytics]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1) [Amount]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1,  null) [Amount.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null,  1) [Amount.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, -1) [AmountInBalance]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1,  null) [AmountInBalance.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, null,  1) [AmountInBalance.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, -1) [AmountInAccounting]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1,  null) [AmountInAccounting.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, null,  1) [AmountInAccounting.Out]
        , TRY_CONVERT(NVARCHAR(128), JSON_VALUE(data, '$."Info"')) [Info]
      FROM dbo.[Accumulation] WHERE [type] = N'Register.Accumulation.Balance.Report';
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Balance.Report.id] ON [Register.Accumulation.Balance.Report.v]([id]);
    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.Balance.Report] ON [Register.Accumulation.Balance.Report.v]([id], [kind], [parent], [date], [document], [company], [calculated], [currency], [Department], [Balance], [Analytics], [Amount], [Amount.In], [Amount.Out], [AmountInBalance], [AmountInBalance.In], [AmountInBalance.Out], [AmountInAccounting], [AmountInAccounting.In], [AmountInAccounting.Out], [Info]);
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Balance.Report] AS SELECT * FROM [Register.Accumulation.Balance.Report.v] WITH (NOEXPAND);
    GO
    GRANT SELECT, DELETE ON [Register.Accumulation.Balance.Report] TO JETTI;
    GO
    RAISERROR('Register.Accumulation.Balance.Report finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Cash start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Cash.v] WITH SCHEMABINDING AS
    SELECT [id], [kind], [parent], CAST(date AS DATE) [date], [document], [company], [calculated]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) [currency]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashRegister"')) [CashRegister]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashFlow"')) [CashFlow]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"')) [Analytics]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1) [Amount]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1,  null) [Amount.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null,  1) [Amount.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, -1) [AmountInBalance]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1,  null) [AmountInBalance.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, null,  1) [AmountInBalance.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, -1) [AmountInAccounting]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1,  null) [AmountInAccounting.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, null,  1) [AmountInAccounting.Out]
      FROM dbo.[Accumulation] WHERE [type] = N'Register.Accumulation.Cash';
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Cash.id] ON [Register.Accumulation.Cash.v]([id]);
    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.Cash] ON [Register.Accumulation.Cash.v]([id], [kind], [parent], [date], [document], [company], [calculated], [currency], [CashRegister], [CashFlow], [Analytics], [Amount], [Amount.In], [Amount.Out], [AmountInBalance], [AmountInBalance.In], [AmountInBalance.Out], [AmountInAccounting], [AmountInAccounting.In], [AmountInAccounting.Out]);
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Cash] AS SELECT * FROM [Register.Accumulation.Cash.v] WITH (NOEXPAND);
    GO
    GRANT SELECT, DELETE ON [Register.Accumulation.Cash] TO JETTI;
    GO
    RAISERROR('Register.Accumulation.Cash finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Cash.Transit start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Cash.Transit.v] WITH SCHEMABINDING AS
    SELECT [id], [kind], [parent], CAST(date AS DATE) [date], [document], [company], [calculated]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CompanyRecipient"')) [CompanyRecipient]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) [currency]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Sender"')) [Sender]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Recipient"')) [Recipient]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashFlow"')) [CashFlow]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1) [Amount]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1,  null) [Amount.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null,  1) [Amount.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, -1) [AmountInBalance]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1,  null) [AmountInBalance.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, null,  1) [AmountInBalance.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, -1) [AmountInAccounting]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1,  null) [AmountInAccounting.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, null,  1) [AmountInAccounting.Out]
      FROM dbo.[Accumulation] WHERE [type] = N'Register.Accumulation.Cash.Transit';
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Cash.Transit.id] ON [Register.Accumulation.Cash.Transit.v]([id]);
    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.Cash.Transit] ON [Register.Accumulation.Cash.Transit.v]([id], [kind], [parent], [date], [document], [company], [calculated], [CompanyRecipient], [currency], [Sender], [Recipient], [CashFlow], [Amount], [Amount.In], [Amount.Out], [AmountInBalance], [AmountInBalance.In], [AmountInBalance.Out], [AmountInAccounting], [AmountInAccounting.In], [AmountInAccounting.Out]);
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Cash.Transit] AS SELECT * FROM [Register.Accumulation.Cash.Transit.v] WITH (NOEXPAND);
    GO
    GRANT SELECT, DELETE ON [Register.Accumulation.Cash.Transit] TO JETTI;
    GO
    RAISERROR('Register.Accumulation.Cash.Transit finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.EmployeeTimekeeping start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.EmployeeTimekeeping.v] WITH SCHEMABINDING AS
    SELECT [id], [kind], [parent], CAST(date AS DATE) [date], [document], [company], [calculated]
        , TRY_CONVERT(BIT, JSON_VALUE(data, N'$."isActive"')) [isActive]
        , TRY_CONVERT(DATE, JSON_VALUE(data, N'$."PeriodMonth"'),127) [PeriodMonth]
        , TRY_CONVERT(VARCHAR(64), JSON_VALUE(data, '$."KindTimekeeping"')) [KindTimekeeping]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Employee"')) [Employee]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Person"')) [Person]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."StaffingTable"')) [StaffingTable]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Days"')) * IIF(kind = 1, 1, -1) [Days]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Days"')) * IIF(kind = 1, 1,  null) [Days.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Days"')) * IIF(kind = 1, null,  1) [Days.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Hours"')) * IIF(kind = 1, 1, -1) [Hours]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Hours"')) * IIF(kind = 1, 1,  null) [Hours.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Hours"')) * IIF(kind = 1, null,  1) [Hours.Out]
      FROM dbo.[Accumulation] WHERE [type] = N'Register.Accumulation.EmployeeTimekeeping';
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.EmployeeTimekeeping.id] ON [Register.Accumulation.EmployeeTimekeeping.v]([id]);
    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.EmployeeTimekeeping] ON [Register.Accumulation.EmployeeTimekeeping.v]([id], [kind], [parent], [date], [document], [company], [calculated], [isActive], [PeriodMonth], [KindTimekeeping], [Employee], [Person], [StaffingTable], [Days], [Days.In], [Days.Out], [Hours], [Hours.In], [Hours.Out]);
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.EmployeeTimekeeping] AS SELECT * FROM [Register.Accumulation.EmployeeTimekeeping.v] WITH (NOEXPAND);
    GO
    GRANT SELECT, DELETE ON [Register.Accumulation.EmployeeTimekeeping] TO JETTI;
    GO
    RAISERROR('Register.Accumulation.EmployeeTimekeeping finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Inventory start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Inventory.v] WITH SCHEMABINDING AS
    SELECT [id], [kind], [parent], CAST(date AS DATE) [date], [document], [company], [calculated]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."OperationType"')) [OperationType]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Expense"')) [Expense]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."ExpenseAnalytics"')) [ExpenseAnalytics]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Income"')) [Income]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."IncomeAnalytics"')) [IncomeAnalytics]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BalanceIn"')) [BalanceIn]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BalanceInAnalytics"')) [BalanceInAnalytics]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BalanceOut"')) [BalanceOut]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BalanceOutAnalytics"')) [BalanceOutAnalytics]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Storehouse"')) [Storehouse]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."SKU"')) [SKU]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."batch"')) [batch]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) [Department]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Cost"')) * IIF(kind = 1, 1, -1) [Cost]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Cost"')) * IIF(kind = 1, 1,  null) [Cost.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Cost"')) * IIF(kind = 1, null,  1) [Cost.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Qty"')) * IIF(kind = 1, 1, -1) [Qty]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Qty"')) * IIF(kind = 1, 1,  null) [Qty.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Qty"')) * IIF(kind = 1, null,  1) [Qty.Out]
      FROM dbo.[Accumulation] WHERE [type] = N'Register.Accumulation.Inventory';
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Inventory.id] ON [Register.Accumulation.Inventory.v]([id]);
    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.Inventory] ON [Register.Accumulation.Inventory.v]([id], [kind], [parent], [date], [document], [company], [calculated], [OperationType], [Expense], [ExpenseAnalytics], [Income], [IncomeAnalytics], [BalanceIn], [BalanceInAnalytics], [BalanceOut], [BalanceOutAnalytics], [Storehouse], [SKU], [batch], [Department], [Cost], [Cost.In], [Cost.Out], [Qty], [Qty.In], [Qty.Out]);
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Inventory] AS SELECT * FROM [Register.Accumulation.Inventory.v] WITH (NOEXPAND);
    GO
    GRANT SELECT, DELETE ON [Register.Accumulation.Inventory] TO JETTI;
    GO
    RAISERROR('Register.Accumulation.Inventory finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Loan start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Loan.v] WITH SCHEMABINDING AS
    SELECT [id], [kind], [parent], CAST(date AS DATE) [date], [document], [company], [calculated]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Loan"')) [Loan]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Counterpartie"')) [Counterpartie]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashFlow"')) [CashFlow]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) [currency]
        , TRY_CONVERT(VARCHAR(64), JSON_VALUE(data, '$."PaymentKind"')) [PaymentKind]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1) [Amount]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1,  null) [Amount.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null,  1) [Amount.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, -1) [AmountInBalance]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1,  null) [AmountInBalance.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, null,  1) [AmountInBalance.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, -1) [AmountInAccounting]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1,  null) [AmountInAccounting.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, null,  1) [AmountInAccounting.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountToPay"')) * IIF(kind = 1, 1, -1) [AmountToPay]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountToPay"')) * IIF(kind = 1, 1,  null) [AmountToPay.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountToPay"')) * IIF(kind = 1, null,  1) [AmountToPay.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountIsPaid"')) * IIF(kind = 1, 1, -1) [AmountIsPaid]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountIsPaid"')) * IIF(kind = 1, 1,  null) [AmountIsPaid.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountIsPaid"')) * IIF(kind = 1, null,  1) [AmountIsPaid.Out]
      FROM dbo.[Accumulation] WHERE [type] = N'Register.Accumulation.Loan';
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Loan.id] ON [Register.Accumulation.Loan.v]([id]);
    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.Loan] ON [Register.Accumulation.Loan.v]([id], [kind], [parent], [date], [document], [company], [calculated], [Loan], [Counterpartie], [CashFlow], [currency], [PaymentKind], [Amount], [Amount.In], [Amount.Out], [AmountInBalance], [AmountInBalance.In], [AmountInBalance.Out], [AmountInAccounting], [AmountInAccounting.In], [AmountInAccounting.Out], [AmountToPay], [AmountToPay.In], [AmountToPay.Out], [AmountIsPaid], [AmountIsPaid.In], [AmountIsPaid.Out]);
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Loan] AS SELECT * FROM [Register.Accumulation.Loan.v] WITH (NOEXPAND);
    GO
    GRANT SELECT, DELETE ON [Register.Accumulation.Loan] TO JETTI;
    GO
    RAISERROR('Register.Accumulation.Loan finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.PL start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.PL.v] WITH SCHEMABINDING AS
    SELECT [id], [kind], [parent], CAST(date AS DATE) [date], [document], [company], [calculated]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) [Department]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."PL"')) [PL]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"')) [Analytics]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics2"')) [Analytics2]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1) [Amount]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1,  null) [Amount.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null,  1) [Amount.Out]
        , TRY_CONVERT(NVARCHAR(128), JSON_VALUE(data, '$."Info"')) [Info]
      FROM dbo.[Accumulation] WHERE [type] = N'Register.Accumulation.PL';
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.PL.id] ON [Register.Accumulation.PL.v]([id]);
    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.PL] ON [Register.Accumulation.PL.v]([id], [kind], [parent], [date], [document], [company], [calculated], [Department], [PL], [Analytics], [Analytics2], [Amount], [Amount.In], [Amount.Out], [Info]);
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.PL] AS SELECT * FROM [Register.Accumulation.PL.v] WITH (NOEXPAND);
    GO
    GRANT SELECT, DELETE ON [Register.Accumulation.PL] TO JETTI;
    GO
    RAISERROR('Register.Accumulation.PL finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.PL.RC start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.PL.RC.v] WITH SCHEMABINDING AS
    SELECT [id], [kind], [parent], CAST(date AS DATE) [date], [document], [company], [calculated]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."ResponsibilityCenter"')) [ResponsibilityCenter]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) [Department]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."PL"')) [PL]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"')) [Analytics]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics2"')) [Analytics2]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Currency"')) [Currency]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1) [Amount]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1,  null) [Amount.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null,  1) [Amount.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountRC"')) * IIF(kind = 1, 1, -1) [AmountRC]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountRC"')) * IIF(kind = 1, 1,  null) [AmountRC.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountRC"')) * IIF(kind = 1, null,  1) [AmountRC.Out]
        , TRY_CONVERT(NVARCHAR(128), JSON_VALUE(data, '$."Info"')) [Info]
      FROM dbo.[Accumulation] WHERE [type] = N'Register.Accumulation.PL.RC';
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.PL.RC.id] ON [Register.Accumulation.PL.RC.v]([id]);
    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.PL.RC] ON [Register.Accumulation.PL.RC.v]([id], [kind], [parent], [date], [document], [company], [calculated], [ResponsibilityCenter], [Department], [PL], [Analytics], [Analytics2], [Currency], [Amount], [Amount.In], [Amount.Out], [AmountRC], [AmountRC.In], [AmountRC.Out], [Info]);
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.PL.RC] AS SELECT * FROM [Register.Accumulation.PL.RC.v] WITH (NOEXPAND);
    GO
    GRANT SELECT, DELETE ON [Register.Accumulation.PL.RC] TO JETTI;
    GO
    RAISERROR('Register.Accumulation.PL.RC finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Sales start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Sales.v] WITH SCHEMABINDING AS
    SELECT [id], [kind], [parent], CAST(date AS DATE) [date], [document], [company], [calculated]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) [currency]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) [Department]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Customer"')) [Customer]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Product"')) [Product]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytic"')) [Analytic]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Manager"')) [Manager]
        , TRY_CONVERT(VARCHAR(64), JSON_VALUE(data, '$."DeliveryType"')) [DeliveryType]
        , TRY_CONVERT(NVARCHAR(128), JSON_VALUE(data, '$."OrderSource"')) [OrderSource]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."RetailClient"')) [RetailClient]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."AO"')) [AO]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Storehouse"')) [Storehouse]
        , TRY_CONVERT(DATETIME, JSON_VALUE(data, N'$."OpenTime"'),127) [OpenTime]
        , TRY_CONVERT(DATETIME, JSON_VALUE(data, N'$."PrintTime"'),127) [PrintTime]
        , TRY_CONVERT(DATETIME, JSON_VALUE(data, N'$."DeliverTime"'),127) [DeliverTime]
        , TRY_CONVERT(DATETIME, JSON_VALUE(data, N'$."BillTime"'),127) [BillTime]
        , TRY_CONVERT(DATETIME, JSON_VALUE(data, N'$."CloseTime"'),127) [CloseTime]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."CashShift"')) * IIF(kind = 1, 1, -1) [CashShift]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."CashShift"')) * IIF(kind = 1, 1,  null) [CashShift.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."CashShift"')) * IIF(kind = 1, null,  1) [CashShift.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Cost"')) * IIF(kind = 1, 1, -1) [Cost]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Cost"')) * IIF(kind = 1, 1,  null) [Cost.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Cost"')) * IIF(kind = 1, null,  1) [Cost.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Qty"')) * IIF(kind = 1, 1, -1) [Qty]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Qty"')) * IIF(kind = 1, 1,  null) [Qty.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Qty"')) * IIF(kind = 1, null,  1) [Qty.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1) [Amount]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1,  null) [Amount.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null,  1) [Amount.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Discount"')) * IIF(kind = 1, 1, -1) [Discount]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Discount"')) * IIF(kind = 1, 1,  null) [Discount.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Discount"')) * IIF(kind = 1, null,  1) [Discount.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Tax"')) * IIF(kind = 1, 1, -1) [Tax]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Tax"')) * IIF(kind = 1, 1,  null) [Tax.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Tax"')) * IIF(kind = 1, null,  1) [Tax.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInDoc"')) * IIF(kind = 1, 1, -1) [AmountInDoc]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInDoc"')) * IIF(kind = 1, 1,  null) [AmountInDoc.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInDoc"')) * IIF(kind = 1, null,  1) [AmountInDoc.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAR"')) * IIF(kind = 1, 1, -1) [AmountInAR]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAR"')) * IIF(kind = 1, 1,  null) [AmountInAR.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAR"')) * IIF(kind = 1, null,  1) [AmountInAR.Out]
      FROM dbo.[Accumulation] WHERE [type] = N'Register.Accumulation.Sales';
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Sales.id] ON [Register.Accumulation.Sales.v]([id]);
    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.Sales] ON [Register.Accumulation.Sales.v]([id], [kind], [parent], [date], [document], [company], [calculated], [currency], [Department], [Customer], [Product], [Analytic], [Manager], [DeliveryType], [OrderSource], [RetailClient], [AO], [Storehouse], [OpenTime], [PrintTime], [DeliverTime], [BillTime], [CloseTime], [CashShift], [CashShift.In], [CashShift.Out], [Cost], [Cost.In], [Cost.Out], [Qty], [Qty.In], [Qty.Out], [Amount], [Amount.In], [Amount.Out], [Discount], [Discount.In], [Discount.Out], [Tax], [Tax.In], [Tax.Out], [AmountInDoc], [AmountInDoc.In], [AmountInDoc.Out], [AmountInAR], [AmountInAR.In], [AmountInAR.Out]);
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Sales] AS SELECT * FROM [Register.Accumulation.Sales.v] WITH (NOEXPAND);
    GO
    GRANT SELECT, DELETE ON [Register.Accumulation.Sales] TO JETTI;
    GO
    RAISERROR('Register.Accumulation.Sales finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Salary start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Salary.v] WITH SCHEMABINDING AS
    SELECT [id], [kind], [parent], CAST(date AS DATE) [date], [document], [company], [calculated]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) [currency]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."KorrCompany"')) [KorrCompany]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) [Department]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Person"')) [Person]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Employee"')) [Employee]
        , TRY_CONVERT(VARCHAR(64), JSON_VALUE(data, '$."SalaryKind"')) [SalaryKind]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"')) [Analytics]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."PL"')) [PL]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."PLAnalytics"')) [PLAnalytics]
        , TRY_CONVERT(VARCHAR(64), JSON_VALUE(data, '$."Status"')) [Status]
        , TRY_CONVERT(BIT, JSON_VALUE(data, N'$."IsPortal"')) [IsPortal]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1) [Amount]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1,  null) [Amount.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null,  1) [Amount.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, -1) [AmountInBalance]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1,  null) [AmountInBalance.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, null,  1) [AmountInBalance.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, -1) [AmountInAccounting]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1,  null) [AmountInAccounting.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, null,  1) [AmountInAccounting.Out]
      FROM dbo.[Accumulation] WHERE [type] = N'Register.Accumulation.Salary';
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Salary.id] ON [Register.Accumulation.Salary.v]([id]);
    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.Salary] ON [Register.Accumulation.Salary.v]([id], [kind], [parent], [date], [document], [company], [calculated], [currency], [KorrCompany], [Department], [Person], [Employee], [SalaryKind], [Analytics], [PL], [PLAnalytics], [Status], [IsPortal], [Amount], [Amount.In], [Amount.Out], [AmountInBalance], [AmountInBalance.In], [AmountInBalance.Out], [AmountInAccounting], [AmountInAccounting.In], [AmountInAccounting.Out]);
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Salary] AS SELECT * FROM [Register.Accumulation.Salary.v] WITH (NOEXPAND);
    GO
    GRANT SELECT, DELETE ON [Register.Accumulation.Salary] TO JETTI;
    GO
    RAISERROR('Register.Accumulation.Salary finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Depreciation start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Depreciation.v] WITH SCHEMABINDING AS
    SELECT [id], [kind], [parent], CAST(date AS DATE) [date], [document], [company], [calculated]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."OperationType"')) [OperationType]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) [currency]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) [Department]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."ResponsiblePerson"')) [ResponsiblePerson]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."OE"')) [OE]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1) [Amount]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1,  null) [Amount.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null,  1) [Amount.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, -1) [AmountInBalance]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1,  null) [AmountInBalance.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, null,  1) [AmountInBalance.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, -1) [AmountInAccounting]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1,  null) [AmountInAccounting.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, null,  1) [AmountInAccounting.Out]
      FROM dbo.[Accumulation] WHERE [type] = N'Register.Accumulation.Depreciation';
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Depreciation.id] ON [Register.Accumulation.Depreciation.v]([id]);
    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.Depreciation] ON [Register.Accumulation.Depreciation.v]([id], [kind], [parent], [date], [document], [company], [calculated], [OperationType], [currency], [Department], [ResponsiblePerson], [OE], [Amount], [Amount.In], [Amount.Out], [AmountInBalance], [AmountInBalance.In], [AmountInBalance.Out], [AmountInAccounting], [AmountInAccounting.In], [AmountInAccounting.Out]);
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Depreciation] AS SELECT * FROM [Register.Accumulation.Depreciation.v] WITH (NOEXPAND);
    GO
    GRANT SELECT, DELETE ON [Register.Accumulation.Depreciation] TO JETTI;
    GO
    RAISERROR('Register.Accumulation.Depreciation finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.CashToPay start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.CashToPay.v] WITH SCHEMABINDING AS
    SELECT [id], [kind], [parent], CAST(date AS DATE) [date], [document], [company], [calculated]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) [currency]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashFlow"')) [CashFlow]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashRequest"')) [CashRequest]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Contract"')) [Contract]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BankAccountPerson"')) [BankAccountPerson]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) [Department]
        , TRY_CONVERT(NVARCHAR(128), JSON_VALUE(data, '$."OperationType"')) [OperationType]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Loan"')) [Loan]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashOrBank"')) [CashOrBank]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashRecipient"')) [CashRecipient]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."ExpenseOrBalance"')) [ExpenseOrBalance]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."ExpenseAnalytics"')) [ExpenseAnalytics]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BalanceAnalytics"')) [BalanceAnalytics]
        , TRY_CONVERT(DATE, JSON_VALUE(data, N'$."PayDay"'),127) [PayDay]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1) [Amount]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1,  null) [Amount.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null,  1) [Amount.Out]
      FROM dbo.[Accumulation] WHERE [type] = N'Register.Accumulation.CashToPay';
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.CashToPay.id] ON [Register.Accumulation.CashToPay.v]([id]);
    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.CashToPay] ON [Register.Accumulation.CashToPay.v]([id], [kind], [parent], [date], [document], [company], [calculated], [currency], [CashFlow], [CashRequest], [Contract], [BankAccountPerson], [Department], [OperationType], [Loan], [CashOrBank], [CashRecipient], [ExpenseOrBalance], [ExpenseAnalytics], [BalanceAnalytics], [PayDay], [Amount], [Amount.In], [Amount.Out]);
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.CashToPay] AS SELECT * FROM [Register.Accumulation.CashToPay.v] WITH (NOEXPAND);
    GO
    GRANT SELECT, DELETE ON [Register.Accumulation.CashToPay] TO JETTI;
    GO
    RAISERROR('Register.Accumulation.CashToPay finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.BudgetItemTurnover start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.BudgetItemTurnover.v] WITH SCHEMABINDING AS
    SELECT [id], [kind], [parent], CAST(date AS DATE) [date], [document], [company], [calculated]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) [Department]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Scenario"')) [Scenario]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BudgetItem"')) [BudgetItem]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Anatitic1"')) [Anatitic1]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Anatitic2"')) [Anatitic2]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Anatitic3"')) [Anatitic3]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Anatitic4"')) [Anatitic4]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Anatitic5"')) [Anatitic5]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) [currency]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1) [Amount]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1,  null) [Amount.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null,  1) [Amount.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInScenatio"')) * IIF(kind = 1, 1, -1) [AmountInScenatio]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInScenatio"')) * IIF(kind = 1, 1,  null) [AmountInScenatio.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInScenatio"')) * IIF(kind = 1, null,  1) [AmountInScenatio.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInCurrency"')) * IIF(kind = 1, 1, -1) [AmountInCurrency]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInCurrency"')) * IIF(kind = 1, 1,  null) [AmountInCurrency.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInCurrency"')) * IIF(kind = 1, null,  1) [AmountInCurrency.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, -1) [AmountInAccounting]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1,  null) [AmountInAccounting.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, null,  1) [AmountInAccounting.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Qty"')) * IIF(kind = 1, 1, -1) [Qty]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Qty"')) * IIF(kind = 1, 1,  null) [Qty.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Qty"')) * IIF(kind = 1, null,  1) [Qty.Out]
      FROM dbo.[Accumulation] WHERE [type] = N'Register.Accumulation.BudgetItemTurnover';
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.BudgetItemTurnover.id] ON [Register.Accumulation.BudgetItemTurnover.v]([id]);
    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.BudgetItemTurnover] ON [Register.Accumulation.BudgetItemTurnover.v]([id], [kind], [parent], [date], [document], [company], [calculated], [Department], [Scenario], [BudgetItem], [Anatitic1], [Anatitic2], [Anatitic3], [Anatitic4], [Anatitic5], [currency], [Amount], [Amount.In], [Amount.Out], [AmountInScenatio], [AmountInScenatio.In], [AmountInScenatio.Out], [AmountInCurrency], [AmountInCurrency.In], [AmountInCurrency.Out], [AmountInAccounting], [AmountInAccounting.In], [AmountInAccounting.Out], [Qty], [Qty.In], [Qty.Out]);
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.BudgetItemTurnover] AS SELECT * FROM [Register.Accumulation.BudgetItemTurnover.v] WITH (NOEXPAND);
    GO
    GRANT SELECT, DELETE ON [Register.Accumulation.BudgetItemTurnover] TO JETTI;
    GO
    RAISERROR('Register.Accumulation.BudgetItemTurnover finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Intercompany start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Intercompany.v] WITH SCHEMABINDING AS
    SELECT [id], [kind], [parent], CAST(date AS DATE) [date], [document], [company], [calculated]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Intercompany"')) [Intercompany]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."LegalCompanySender"')) [LegalCompanySender]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."LegalCompanyRecipient"')) [LegalCompanyRecipient]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Contract"')) [Contract]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."OperationType"')) [OperationType]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"')) [Analytics]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) [currency]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1) [Amount]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1,  null) [Amount.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null,  1) [Amount.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, -1) [AmountInBalance]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1,  null) [AmountInBalance.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, null,  1) [AmountInBalance.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, -1) [AmountInAccounting]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1,  null) [AmountInAccounting.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, null,  1) [AmountInAccounting.Out]
      FROM dbo.[Accumulation] WHERE [type] = N'Register.Accumulation.Intercompany';
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Intercompany.id] ON [Register.Accumulation.Intercompany.v]([id]);
    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.Intercompany] ON [Register.Accumulation.Intercompany.v]([id], [kind], [parent], [date], [document], [company], [calculated], [Intercompany], [LegalCompanySender], [LegalCompanyRecipient], [Contract], [OperationType], [Analytics], [currency], [Amount], [Amount.In], [Amount.Out], [AmountInBalance], [AmountInBalance.In], [AmountInBalance.Out], [AmountInAccounting], [AmountInAccounting.In], [AmountInAccounting.Out]);
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Intercompany] AS SELECT * FROM [Register.Accumulation.Intercompany.v] WITH (NOEXPAND);
    GO
    GRANT SELECT, DELETE ON [Register.Accumulation.Intercompany] TO JETTI;
    GO
    RAISERROR('Register.Accumulation.Intercompany finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.Acquiring start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Acquiring.v] WITH SCHEMABINDING AS
    SELECT [id], [kind], [parent], CAST(date AS DATE) [date], [document], [company], [calculated]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."AcquiringTerminal"')) [AcquiringTerminal]
        , TRY_CONVERT(NVARCHAR(128), JSON_VALUE(data, '$."AcquiringTerminalCode1"')) [AcquiringTerminalCode1]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."OperationType"')) [OperationType]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) [Department]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashFlow"')) [CashFlow]
        , TRY_CONVERT(NVARCHAR(128), JSON_VALUE(data, '$."PaymantCard"')) [PaymantCard]
        , TRY_CONVERT(DATE, JSON_VALUE(data, N'$."PayDay"'),127) [PayDay]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) [currency]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1) [Amount]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1,  null) [Amount.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null,  1) [Amount.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, -1) [AmountInBalance]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1,  null) [AmountInBalance.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, null,  1) [AmountInBalance.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountOperation"')) * IIF(kind = 1, 1, -1) [AmountOperation]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountOperation"')) * IIF(kind = 1, 1,  null) [AmountOperation.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountOperation"')) * IIF(kind = 1, null,  1) [AmountOperation.Out]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountPaid"')) * IIF(kind = 1, 1, -1) [AmountPaid]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountPaid"')) * IIF(kind = 1, 1,  null) [AmountPaid.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountPaid"')) * IIF(kind = 1, null,  1) [AmountPaid.Out]
        , TRY_CONVERT(DATE, JSON_VALUE(data, N'$."DateOperation"'),127) [DateOperation]
        , TRY_CONVERT(DATE, JSON_VALUE(data, N'$."DatePaid"'),127) [DatePaid]
        , TRY_CONVERT(NVARCHAR(128), JSON_VALUE(data, '$."AuthorizationCode"')) [AuthorizationCode]
      FROM dbo.[Accumulation] WHERE [type] = N'Register.Accumulation.Acquiring';
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Acquiring.id] ON [Register.Accumulation.Acquiring.v]([id]);
    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.Acquiring] ON [Register.Accumulation.Acquiring.v]([id], [kind], [parent], [date], [document], [company], [calculated], [AcquiringTerminal], [AcquiringTerminalCode1], [OperationType], [Department], [CashFlow], [PaymantCard], [PayDay], [currency], [Amount], [Amount.In], [Amount.Out], [AmountInBalance], [AmountInBalance.In], [AmountInBalance.Out], [AmountOperation], [AmountOperation.In], [AmountOperation.Out], [AmountPaid], [AmountPaid.In], [AmountPaid.Out], [DateOperation], [DatePaid], [AuthorizationCode]);
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.Acquiring] AS SELECT * FROM [Register.Accumulation.Acquiring.v] WITH (NOEXPAND);
    GO
    GRANT SELECT, DELETE ON [Register.Accumulation.Acquiring] TO JETTI;
    GO
    RAISERROR('Register.Accumulation.Acquiring finish', 0 ,1) WITH NOWAIT;
    GO
    
    RAISERROR('Register.Accumulation.StaffingTable start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.StaffingTable.v] WITH SCHEMABINDING AS
    SELECT [id], [kind], [parent], CAST(date AS DATE) [date], [document], [company], [calculated]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) [Department]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."DepartmentCompany"')) [DepartmentCompany]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."StaffingTablePosition"')) [StaffingTablePosition]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Employee"')) [Employee]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Person"')) [Person]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."SalaryRate"')) * IIF(kind = 1, 1, -1) [SalaryRate]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."SalaryRate"')) * IIF(kind = 1, 1,  null) [SalaryRate.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."SalaryRate"')) * IIF(kind = 1, null,  1) [SalaryRate.Out]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."SalaryAnalytic"')) [SalaryAnalytic]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) [currency]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1) [Amount]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1,  null) [Amount.In]
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null,  1) [Amount.Out]
      FROM dbo.[Accumulation] WHERE [type] = N'Register.Accumulation.StaffingTable';
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.StaffingTable.id] ON [Register.Accumulation.StaffingTable.v]([id]);
    CREATE NONCLUSTERED COLUMNSTORE INDEX [Register.Accumulation.StaffingTable] ON [Register.Accumulation.StaffingTable.v]([id], [kind], [parent], [date], [document], [company], [calculated], [Department], [DepartmentCompany], [StaffingTablePosition], [Employee], [Person], [SalaryRate], [SalaryRate.In], [SalaryRate.Out], [SalaryAnalytic], [currency], [Amount], [Amount.In], [Amount.Out]);
    GO
    CREATE OR ALTER VIEW [Register.Accumulation.StaffingTable] AS SELECT * FROM [Register.Accumulation.StaffingTable.v] WITH (NOEXPAND);
    GO
    GRANT SELECT, DELETE ON [Register.Accumulation.StaffingTable] TO JETTI;
    GO
    RAISERROR('Register.Accumulation.StaffingTable finish', 0 ,1) WITH NOWAIT;
    GO
    
    