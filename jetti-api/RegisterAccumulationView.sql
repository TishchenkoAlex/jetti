
    
------------------------------ BEGIN Register.Accumulation.AccountablePersons ------------------------------

    CREATE OR ALTER VIEW [Register.Accumulation.AccountablePersons]
    AS
      SELECT
        r.id, r.owner, r.parent, CAST(r.date AS DATE) date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, currency, Employee, CashFlow
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
      , d.[AmountToPay] * IIF(r.kind = 1, 1, -1) [AmountToPay], d.[AmountToPay] * IIF(r.kind = 1, 1, null) [AmountToPay.In], d.[AmountToPay] * IIF(r.kind = 1, null, 1) [AmountToPay.Out]
      , d.[AmountIsPaid] * IIF(r.kind = 1, 1, -1) [AmountIsPaid], d.[AmountIsPaid] * IIF(r.kind = 1, 1, null) [AmountIsPaid.In], d.[AmountIsPaid] * IIF(r.kind = 1, null, 1) [AmountIsPaid.Out]
        FROM [dbo].Accumulation r
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
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.AccountablePersons] TO JETTI;
    GO
    
------------------------------ END Register.Accumulation.AccountablePersons ------------------------------

------------------------------ BEGIN Register.Accumulation.PaymentBatch ------------------------------

    CREATE OR ALTER VIEW [Register.Accumulation.PaymentBatch]
    AS
      SELECT
        r.id, r.owner, r.parent, CAST(r.date AS DATE) date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, PaymentsKind, Counterpartie, ProductPackage, Product, Currency, PayDay
      , d.[Qty] * IIF(r.kind = 1, 1, -1) [Qty], d.[Qty] * IIF(r.kind = 1, 1, null) [Qty.In], d.[Qty] * IIF(r.kind = 1, null, 1) [Qty.Out]
      , d.[Price] * IIF(r.kind = 1, 1, -1) [Price], d.[Price] * IIF(r.kind = 1, 1, null) [Price.In], d.[Price] * IIF(r.kind = 1, null, 1) [Price.Out]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out], batch
        FROM [dbo].Accumulation r
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
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.PaymentBatch] TO JETTI;
    GO
    
------------------------------ END Register.Accumulation.PaymentBatch ------------------------------

------------------------------ BEGIN Register.Accumulation.Investment.Analytics ------------------------------

    CREATE OR ALTER VIEW [Register.Accumulation.Investment.Analytics]
    AS
      SELECT
        r.id, r.owner, r.parent, CAST(r.date AS DATE) date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, Department, SourceTransaction, CreditTransaction, OperationType, Investor, CompanyProduct, Product
      , d.[Qty] * IIF(r.kind = 1, 1, -1) [Qty], d.[Qty] * IIF(r.kind = 1, 1, null) [Qty.In], d.[Qty] * IIF(r.kind = 1, null, 1) [Qty.Out], CurrencyProduct
      , d.[AmountProduct] * IIF(r.kind = 1, 1, -1) [AmountProduct], d.[AmountProduct] * IIF(r.kind = 1, 1, null) [AmountProduct.In], d.[AmountProduct] * IIF(r.kind = 1, null, 1) [AmountProduct.Out], PaymentSource, CurrencySource
      , d.[AmountSource] * IIF(r.kind = 1, 1, -1) [AmountSource], d.[AmountSource] * IIF(r.kind = 1, 1, null) [AmountSource.In], d.[AmountSource] * IIF(r.kind = 1, null, 1) [AmountSource.Out], CompanyLoan, Loan, CurrencyLoan
      , d.[AmountLoan] * IIF(r.kind = 1, 1, -1) [AmountLoan], d.[AmountLoan] * IIF(r.kind = 1, 1, null) [AmountLoan.In], d.[AmountLoan] * IIF(r.kind = 1, null, 1) [AmountLoan.Out]
        FROM [dbo].Accumulation r
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
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Investment.Analytics] TO JETTI;
    GO
    
------------------------------ END Register.Accumulation.Investment.Analytics ------------------------------

------------------------------ BEGIN Register.Accumulation.OrderPayment ------------------------------

    CREATE OR ALTER VIEW [Register.Accumulation.OrderPayment]
    AS
      SELECT
        r.id, r.owner, r.parent, CAST(r.date AS DATE) date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, PaymantKind, Customer, BankAccount, CashRegister, AcquiringTerminal, currency, Department
      , d.[CashShift] * IIF(r.kind = 1, 1, -1) [CashShift], d.[CashShift] * IIF(r.kind = 1, 1, null) [CashShift.In], d.[CashShift] * IIF(r.kind = 1, null, 1) [CashShift.Out]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
        FROM [dbo].Accumulation r
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
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.OrderPayment] TO JETTI;
    GO
    
------------------------------ END Register.Accumulation.OrderPayment ------------------------------

------------------------------ BEGIN Register.Accumulation.AP ------------------------------

    CREATE OR ALTER VIEW [Register.Accumulation.AP]
    AS
      SELECT
        r.id, r.owner, r.parent, CAST(r.date AS DATE) date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, currency, Department, AO, Supplier, PayDay
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
      , d.[AmountToPay] * IIF(r.kind = 1, 1, -1) [AmountToPay], d.[AmountToPay] * IIF(r.kind = 1, 1, null) [AmountToPay.In], d.[AmountToPay] * IIF(r.kind = 1, null, 1) [AmountToPay.Out]
      , d.[AmountIsPaid] * IIF(r.kind = 1, 1, -1) [AmountIsPaid], d.[AmountIsPaid] * IIF(r.kind = 1, 1, null) [AmountIsPaid.In], d.[AmountIsPaid] * IIF(r.kind = 1, null, 1) [AmountIsPaid.Out]
        FROM [dbo].Accumulation r
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
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.AP] TO JETTI;
    GO
    
------------------------------ END Register.Accumulation.AP ------------------------------

------------------------------ BEGIN Register.Accumulation.AR ------------------------------

    CREATE OR ALTER VIEW [Register.Accumulation.AR]
    AS
      SELECT
        r.id, r.owner, r.parent, CAST(r.date AS DATE) date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, currency, Department, AO, Customer, PayDay
      , d.[AR] * IIF(r.kind = 1, 1, -1) [AR], d.[AR] * IIF(r.kind = 1, 1, null) [AR.In], d.[AR] * IIF(r.kind = 1, null, 1) [AR.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
      , d.[AmountToPay] * IIF(r.kind = 1, 1, -1) [AmountToPay], d.[AmountToPay] * IIF(r.kind = 1, 1, null) [AmountToPay.In], d.[AmountToPay] * IIF(r.kind = 1, null, 1) [AmountToPay.Out]
      , d.[AmountIsPaid] * IIF(r.kind = 1, 1, -1) [AmountIsPaid], d.[AmountIsPaid] * IIF(r.kind = 1, 1, null) [AmountIsPaid.In], d.[AmountIsPaid] * IIF(r.kind = 1, null, 1) [AmountIsPaid.Out]
        FROM [dbo].Accumulation r
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
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.AR] TO JETTI;
    GO
    
------------------------------ END Register.Accumulation.AR ------------------------------

------------------------------ BEGIN Register.Accumulation.Bank ------------------------------

    CREATE OR ALTER VIEW [Register.Accumulation.Bank]
    AS
      SELECT
        r.id, r.owner, r.parent, CAST(r.date AS DATE) date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, currency, BankAccount, CashFlow, Analytics
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
        FROM [dbo].Accumulation r
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
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Bank] TO JETTI;
    GO
    
------------------------------ END Register.Accumulation.Bank ------------------------------

------------------------------ BEGIN Register.Accumulation.Balance ------------------------------

    CREATE OR ALTER VIEW [Register.Accumulation.Balance]
    AS
      SELECT
        r.id, r.owner, r.parent, CAST(r.date AS DATE) date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, Department, Balance, Analytics
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out], Info
        FROM [dbo].Accumulation r
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
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Balance] TO JETTI;
    GO
    
------------------------------ END Register.Accumulation.Balance ------------------------------

------------------------------ BEGIN Register.Accumulation.Balance.RC ------------------------------

    CREATE OR ALTER VIEW [Register.Accumulation.Balance.RC]
    AS
      SELECT
        r.id, r.owner, r.parent, CAST(r.date AS DATE) date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, ResponsibilityCenter, Department, Balance, Analytics, Analytics2, Currency
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountRC] * IIF(r.kind = 1, 1, -1) [AmountRC], d.[AmountRC] * IIF(r.kind = 1, 1, null) [AmountRC.In], d.[AmountRC] * IIF(r.kind = 1, null, 1) [AmountRC.Out], Info
        FROM [dbo].Accumulation r
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
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Balance.RC] TO JETTI;
    GO
    
------------------------------ END Register.Accumulation.Balance.RC ------------------------------

------------------------------ BEGIN Register.Accumulation.Balance.Report ------------------------------

    CREATE OR ALTER VIEW [Register.Accumulation.Balance.Report]
    AS
      SELECT
        r.id, r.owner, r.parent, CAST(r.date AS DATE) date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, currency, Department, Balance, Analytics
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out], Info
        FROM [dbo].Accumulation r
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
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Balance.Report] TO JETTI;
    GO
    
------------------------------ END Register.Accumulation.Balance.Report ------------------------------

------------------------------ BEGIN Register.Accumulation.Cash ------------------------------

    CREATE OR ALTER VIEW [Register.Accumulation.Cash]
    AS
      SELECT
        r.id, r.owner, r.parent, CAST(r.date AS DATE) date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, currency, CashRegister, CashFlow, Analytics
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
        FROM [dbo].Accumulation r
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
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Cash] TO JETTI;
    GO
    
------------------------------ END Register.Accumulation.Cash ------------------------------

------------------------------ BEGIN Register.Accumulation.Cash.Transit ------------------------------

    CREATE OR ALTER VIEW [Register.Accumulation.Cash.Transit]
    AS
      SELECT
        r.id, r.owner, r.parent, CAST(r.date AS DATE) date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, CompanyRecipient, currency, Sender, Recipient, CashFlow
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
        FROM [dbo].Accumulation r
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
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Cash.Transit] TO JETTI;
    GO
    
------------------------------ END Register.Accumulation.Cash.Transit ------------------------------

------------------------------ BEGIN Register.Accumulation.EmployeeTimekeeping ------------------------------

    CREATE OR ALTER VIEW [Register.Accumulation.EmployeeTimekeeping]
    AS
      SELECT
        r.id, r.owner, r.parent, CAST(r.date AS DATE) date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, isActive, PeriodMonth, KindTimekeeping, Employee, Person, StaffingTable
      , d.[Days] * IIF(r.kind = 1, 1, -1) [Days], d.[Days] * IIF(r.kind = 1, 1, null) [Days.In], d.[Days] * IIF(r.kind = 1, null, 1) [Days.Out]
      , d.[Hours] * IIF(r.kind = 1, 1, -1) [Hours], d.[Hours] * IIF(r.kind = 1, 1, null) [Hours.In], d.[Hours] * IIF(r.kind = 1, null, 1) [Hours.Out]
        FROM [dbo].Accumulation r
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
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.EmployeeTimekeeping] TO JETTI;
    GO
    
------------------------------ END Register.Accumulation.EmployeeTimekeeping ------------------------------

------------------------------ BEGIN Register.Accumulation.Inventory ------------------------------

    CREATE OR ALTER VIEW [Register.Accumulation.Inventory]
    AS
      SELECT
        r.id, r.owner, r.parent, CAST(r.date AS DATE) date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, OperationType, Expense, ExpenseAnalytics, Income, IncomeAnalytics, BalanceIn, BalanceInAnalytics, BalanceOut, BalanceOutAnalytics, Storehouse, SKU, batch, Department
      , d.[Cost] * IIF(r.kind = 1, 1, -1) [Cost], d.[Cost] * IIF(r.kind = 1, 1, null) [Cost.In], d.[Cost] * IIF(r.kind = 1, null, 1) [Cost.Out]
      , d.[Qty] * IIF(r.kind = 1, 1, -1) [Qty], d.[Qty] * IIF(r.kind = 1, 1, null) [Qty.In], d.[Qty] * IIF(r.kind = 1, null, 1) [Qty.Out]
        FROM [dbo].Accumulation r
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
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Inventory] TO JETTI;
    GO
    
------------------------------ END Register.Accumulation.Inventory ------------------------------

------------------------------ BEGIN Register.Accumulation.Loan ------------------------------

    CREATE OR ALTER VIEW [Register.Accumulation.Loan]
    AS
      SELECT
        r.id, r.owner, r.parent, CAST(r.date AS DATE) date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, Loan, Counterpartie, CashFlow, currency, PaymentKind
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
      , d.[AmountToPay] * IIF(r.kind = 1, 1, -1) [AmountToPay], d.[AmountToPay] * IIF(r.kind = 1, 1, null) [AmountToPay.In], d.[AmountToPay] * IIF(r.kind = 1, null, 1) [AmountToPay.Out]
      , d.[AmountIsPaid] * IIF(r.kind = 1, 1, -1) [AmountIsPaid], d.[AmountIsPaid] * IIF(r.kind = 1, 1, null) [AmountIsPaid.In], d.[AmountIsPaid] * IIF(r.kind = 1, null, 1) [AmountIsPaid.Out]
        FROM [dbo].Accumulation r
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
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Loan] TO JETTI;
    GO
    
------------------------------ END Register.Accumulation.Loan ------------------------------

------------------------------ BEGIN Register.Accumulation.PL ------------------------------

    CREATE OR ALTER VIEW [Register.Accumulation.PL]
    AS
      SELECT
        r.id, r.owner, r.parent, CAST(r.date AS DATE) date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, Department, PL, Analytics, Analytics2
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out], Info
        FROM [dbo].Accumulation r
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
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.PL] TO JETTI;
    GO
    
------------------------------ END Register.Accumulation.PL ------------------------------

------------------------------ BEGIN Register.Accumulation.PL.RC ------------------------------

    CREATE OR ALTER VIEW [Register.Accumulation.PL.RC]
    AS
      SELECT
        r.id, r.owner, r.parent, CAST(r.date AS DATE) date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, ResponsibilityCenter, Department, PL, Analytics, Analytics2, Currency
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountRC] * IIF(r.kind = 1, 1, -1) [AmountRC], d.[AmountRC] * IIF(r.kind = 1, 1, null) [AmountRC.In], d.[AmountRC] * IIF(r.kind = 1, null, 1) [AmountRC.Out], Info
        FROM [dbo].Accumulation r
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
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.PL.RC] TO JETTI;
    GO
    
------------------------------ END Register.Accumulation.PL.RC ------------------------------

------------------------------ BEGIN Register.Accumulation.Sales ------------------------------

    CREATE OR ALTER VIEW [Register.Accumulation.Sales]
    AS
      SELECT
        r.id, r.owner, r.parent, CAST(r.date AS DATE) date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, currency, Department, Customer, Product, Analytic, Manager, DeliveryType, OrderSource, RetailClient, AO, Storehouse, OpenTime, PrintTime, DeliverTime, BillTime, CloseTime
      , d.[CashShift] * IIF(r.kind = 1, 1, -1) [CashShift], d.[CashShift] * IIF(r.kind = 1, 1, null) [CashShift.In], d.[CashShift] * IIF(r.kind = 1, null, 1) [CashShift.Out]
      , d.[Cost] * IIF(r.kind = 1, 1, -1) [Cost], d.[Cost] * IIF(r.kind = 1, 1, null) [Cost.In], d.[Cost] * IIF(r.kind = 1, null, 1) [Cost.Out]
      , d.[Qty] * IIF(r.kind = 1, 1, -1) [Qty], d.[Qty] * IIF(r.kind = 1, 1, null) [Qty.In], d.[Qty] * IIF(r.kind = 1, null, 1) [Qty.Out]
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[Discount] * IIF(r.kind = 1, 1, -1) [Discount], d.[Discount] * IIF(r.kind = 1, 1, null) [Discount.In], d.[Discount] * IIF(r.kind = 1, null, 1) [Discount.Out]
      , d.[Tax] * IIF(r.kind = 1, 1, -1) [Tax], d.[Tax] * IIF(r.kind = 1, 1, null) [Tax.In], d.[Tax] * IIF(r.kind = 1, null, 1) [Tax.Out]
      , d.[AmountInDoc] * IIF(r.kind = 1, 1, -1) [AmountInDoc], d.[AmountInDoc] * IIF(r.kind = 1, 1, null) [AmountInDoc.In], d.[AmountInDoc] * IIF(r.kind = 1, null, 1) [AmountInDoc.Out]
      , d.[AmountInAR] * IIF(r.kind = 1, 1, -1) [AmountInAR], d.[AmountInAR] * IIF(r.kind = 1, 1, null) [AmountInAR.In], d.[AmountInAR] * IIF(r.kind = 1, null, 1) [AmountInAR.Out]
        FROM [dbo].Accumulation r
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
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Sales] TO JETTI;
    GO
    
------------------------------ END Register.Accumulation.Sales ------------------------------

------------------------------ BEGIN Register.Accumulation.Salary ------------------------------

    CREATE OR ALTER VIEW [Register.Accumulation.Salary]
    AS
      SELECT
        r.id, r.owner, r.parent, CAST(r.date AS DATE) date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, currency, KorrCompany, Department, Person, Employee, SalaryKind, Analytics, PL, PLAnalytics, Status, IsPortal
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
        FROM [dbo].Accumulation r
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
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Salary] TO JETTI;
    GO
    
------------------------------ END Register.Accumulation.Salary ------------------------------

------------------------------ BEGIN Register.Accumulation.Depreciation ------------------------------

    CREATE OR ALTER VIEW [Register.Accumulation.Depreciation]
    AS
      SELECT
        r.id, r.owner, r.parent, CAST(r.date AS DATE) date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, OperationType, currency, Department, ResponsiblePerson, OE
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
        FROM [dbo].Accumulation r
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
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Depreciation] TO JETTI;
    GO
    
------------------------------ END Register.Accumulation.Depreciation ------------------------------

------------------------------ BEGIN Register.Accumulation.CashToPay ------------------------------

    CREATE OR ALTER VIEW [Register.Accumulation.CashToPay]
    AS
      SELECT
        r.id, r.owner, r.parent, CAST(r.date AS DATE) date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, currency, CashFlow, CashRequest, Contract, BankAccountPerson, Department, OperationType, Loan, CashOrBank, CashRecipient, ExpenseOrBalance, ExpenseAnalytics, BalanceAnalytics, PayDay
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
        FROM [dbo].Accumulation r
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
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.CashToPay] TO JETTI;
    GO
    
------------------------------ END Register.Accumulation.CashToPay ------------------------------

------------------------------ BEGIN Register.Accumulation.BudgetItemTurnover ------------------------------

    CREATE OR ALTER VIEW [Register.Accumulation.BudgetItemTurnover]
    AS
      SELECT
        r.id, r.owner, r.parent, CAST(r.date AS DATE) date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, Department, Scenario, BudgetItem, Anatitic1, Anatitic2, Anatitic3, Anatitic4, Anatitic5, currency
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInScenatio] * IIF(r.kind = 1, 1, -1) [AmountInScenatio], d.[AmountInScenatio] * IIF(r.kind = 1, 1, null) [AmountInScenatio.In], d.[AmountInScenatio] * IIF(r.kind = 1, null, 1) [AmountInScenatio.Out]
      , d.[AmountInCurrency] * IIF(r.kind = 1, 1, -1) [AmountInCurrency], d.[AmountInCurrency] * IIF(r.kind = 1, 1, null) [AmountInCurrency.In], d.[AmountInCurrency] * IIF(r.kind = 1, null, 1) [AmountInCurrency.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
      , d.[Qty] * IIF(r.kind = 1, 1, -1) [Qty], d.[Qty] * IIF(r.kind = 1, 1, null) [Qty.In], d.[Qty] * IIF(r.kind = 1, null, 1) [Qty.Out]
        FROM [dbo].Accumulation r
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
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.BudgetItemTurnover] TO JETTI;
    GO
    
------------------------------ END Register.Accumulation.BudgetItemTurnover ------------------------------

------------------------------ BEGIN Register.Accumulation.Intercompany ------------------------------

    CREATE OR ALTER VIEW [Register.Accumulation.Intercompany]
    AS
      SELECT
        r.id, r.owner, r.parent, CAST(r.date AS DATE) date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, Intercompany, LegalCompanySender, LegalCompanyRecipient, Contract, OperationType, Analytics, currency
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountInAccounting] * IIF(r.kind = 1, 1, -1) [AmountInAccounting], d.[AmountInAccounting] * IIF(r.kind = 1, 1, null) [AmountInAccounting.In], d.[AmountInAccounting] * IIF(r.kind = 1, null, 1) [AmountInAccounting.Out]
        FROM [dbo].Accumulation r
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
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Intercompany] TO JETTI;
    GO
    
------------------------------ END Register.Accumulation.Intercompany ------------------------------

------------------------------ BEGIN Register.Accumulation.Acquiring ------------------------------

    CREATE OR ALTER VIEW [Register.Accumulation.Acquiring]
    AS
      SELECT
        r.id, r.owner, r.parent, CAST(r.date AS DATE) date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, AcquiringTerminal, AcquiringTerminalCode1, OperationType, Department, CashFlow, PaymantCard, PayDay, currency
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
      , d.[AmountInBalance] * IIF(r.kind = 1, 1, -1) [AmountInBalance], d.[AmountInBalance] * IIF(r.kind = 1, 1, null) [AmountInBalance.In], d.[AmountInBalance] * IIF(r.kind = 1, null, 1) [AmountInBalance.Out]
      , d.[AmountOperation] * IIF(r.kind = 1, 1, -1) [AmountOperation], d.[AmountOperation] * IIF(r.kind = 1, 1, null) [AmountOperation.In], d.[AmountOperation] * IIF(r.kind = 1, null, 1) [AmountOperation.Out]
      , d.[AmountPaid] * IIF(r.kind = 1, 1, -1) [AmountPaid], d.[AmountPaid] * IIF(r.kind = 1, 1, null) [AmountPaid.In], d.[AmountPaid] * IIF(r.kind = 1, null, 1) [AmountPaid.Out], DateOperation, DatePaid, AuthorizationCode
        FROM [dbo].Accumulation r
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
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.Acquiring] TO JETTI;
    GO
    
------------------------------ END Register.Accumulation.Acquiring ------------------------------

------------------------------ BEGIN Register.Accumulation.StaffingTable ------------------------------

    CREATE OR ALTER VIEW [Register.Accumulation.StaffingTable]
    AS
      SELECT
        r.id, r.owner, r.parent, CAST(r.date AS DATE) date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate, Department, DepartmentCompany, StaffingTablePosition, Employee, Person
      , d.[SalaryRate] * IIF(r.kind = 1, 1, -1) [SalaryRate], d.[SalaryRate] * IIF(r.kind = 1, 1, null) [SalaryRate.In], d.[SalaryRate] * IIF(r.kind = 1, null, 1) [SalaryRate.Out], SalaryAnalytic, currency
      , d.[Amount] * IIF(r.kind = 1, 1, -1) [Amount], d.[Amount] * IIF(r.kind = 1, 1, null) [Amount.In], d.[Amount] * IIF(r.kind = 1, null, 1) [Amount.Out]
        FROM [dbo].Accumulation r
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
    GO
    GRANT SELECT,DELETE ON [Register.Accumulation.StaffingTable] TO JETTI;
    GO
    
------------------------------ END Register.Accumulation.StaffingTable ------------------------------

    