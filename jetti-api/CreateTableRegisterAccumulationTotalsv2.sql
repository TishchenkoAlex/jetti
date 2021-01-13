

      RAISERROR('Register.Accumulation.AccountablePersons start', 0 ,1) WITH NOWAIT;
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.AccountablePersons.TO.v] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , [currency]
        , [Employee]
        , [CashFlow]
        , SUM(ISNULL([Amount], 0)) [Amount]
        , SUM(ISNULL([Amount.In], 0)) [Amount.In]
        , SUM(ISNULL([Amount.Out], 0)) [Amount.Out]
        , SUM(ISNULL([AmountInBalance], 0)) [AmountInBalance]
        , SUM(ISNULL([AmountInBalance.In], 0)) [AmountInBalance.In]
        , SUM(ISNULL([AmountInBalance.Out], 0)) [AmountInBalance.Out]
        , SUM(ISNULL([AmountInAccounting], 0)) [AmountInAccounting]
        , SUM(ISNULL([AmountInAccounting.In], 0)) [AmountInAccounting.In]
        , SUM(ISNULL([AmountInAccounting.Out], 0)) [AmountInAccounting.Out]
        , SUM(ISNULL([AmountToPay], 0)) [AmountToPay]
        , SUM(ISNULL([AmountToPay.In], 0)) [AmountToPay.In]
        , SUM(ISNULL([AmountToPay.Out], 0)) [AmountToPay.Out]
        , SUM(ISNULL([AmountIsPaid], 0)) [AmountIsPaid]
        , SUM(ISNULL([AmountIsPaid.In], 0)) [AmountIsPaid.In]
        , SUM(ISNULL([AmountIsPaid.Out], 0)) [AmountIsPaid.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.AccountablePersons]
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , [currency]
        , [Employee]
        , [CashFlow]
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.AccountablePersons.TO] ON [dbo].[Register.Accumulation.AccountablePersons.TO.v] (
          [date],
          [company]
        , [currency]
        , [Employee]
        , [CashFlow]);
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.AccountablePersons.TO] AS SELECT * FROM [dbo].[Register.Accumulation.AccountablePersons.TO.v] WITH (NOEXPAND);
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.AccountablePersons.TO] TO jetti;
      GO
      RAISERROR('Register.Accumulation.AccountablePersons end', 0 ,1) WITH NOWAIT;
      GO

      RAISERROR('Register.Accumulation.PaymentBatch start', 0 ,1) WITH NOWAIT;
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.PaymentBatch.TO.v] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , [PaymentsKind]
        , [Counterpartie]
        , [ProductPackage]
        , [Product]
        , [Currency]
        , SUM(ISNULL([Qty], 0)) [Qty]
        , SUM(ISNULL([Qty.In], 0)) [Qty.In]
        , SUM(ISNULL([Qty.Out], 0)) [Qty.Out]
        , SUM(ISNULL([Price], 0)) [Price]
        , SUM(ISNULL([Price.In], 0)) [Price.In]
        , SUM(ISNULL([Price.Out], 0)) [Price.Out]
        , SUM(ISNULL([Amount], 0)) [Amount]
        , SUM(ISNULL([Amount.In], 0)) [Amount.In]
        , SUM(ISNULL([Amount.Out], 0)) [Amount.Out]
        , SUM(ISNULL([AmountInBalance], 0)) [AmountInBalance]
        , SUM(ISNULL([AmountInBalance.In], 0)) [AmountInBalance.In]
        , SUM(ISNULL([AmountInBalance.Out], 0)) [AmountInBalance.Out]
        , [batch]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.PaymentBatch]
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , [PaymentsKind]
        , [Counterpartie]
        , [ProductPackage]
        , [Product]
        , [Currency]
        , [batch]
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.PaymentBatch.TO] ON [dbo].[Register.Accumulation.PaymentBatch.TO.v] (
          [date],
          [company]
        , [PaymentsKind]
        , [Counterpartie]
        , [ProductPackage]
        , [Product]
        , [Currency]
        , [batch]);
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.PaymentBatch.TO] AS SELECT * FROM [dbo].[Register.Accumulation.PaymentBatch.TO.v] WITH (NOEXPAND);
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.PaymentBatch.TO] TO jetti;
      GO
      RAISERROR('Register.Accumulation.PaymentBatch end', 0 ,1) WITH NOWAIT;
      GO

      RAISERROR('Register.Accumulation.Investment.Analytics start', 0 ,1) WITH NOWAIT;
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Investment.Analytics.TO.v] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , [SourceTransaction]
        , [CreditTransaction]
        , [OperationType]
        , [Investor]
        , [CompanyProduct]
        , [Product]
        , SUM(ISNULL([Qty], 0)) [Qty]
        , SUM(ISNULL([Qty.In], 0)) [Qty.In]
        , SUM(ISNULL([Qty.Out], 0)) [Qty.Out]
        , [CurrencyProduct]
        , SUM(ISNULL([AmountProduct], 0)) [AmountProduct]
        , SUM(ISNULL([AmountProduct.In], 0)) [AmountProduct.In]
        , SUM(ISNULL([AmountProduct.Out], 0)) [AmountProduct.Out]
        , [PaymentSource]
        , [CurrencySource]
        , SUM(ISNULL([AmountSource], 0)) [AmountSource]
        , SUM(ISNULL([AmountSource.In], 0)) [AmountSource.In]
        , SUM(ISNULL([AmountSource.Out], 0)) [AmountSource.Out]
        , [CompanyLoan]
        , [Loan]
        , [CurrencyLoan]
        , SUM(ISNULL([AmountLoan], 0)) [AmountLoan]
        , SUM(ISNULL([AmountLoan.In], 0)) [AmountLoan.In]
        , SUM(ISNULL([AmountLoan.Out], 0)) [AmountLoan.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.Investment.Analytics]
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , [SourceTransaction]
        , [CreditTransaction]
        , [OperationType]
        , [Investor]
        , [CompanyProduct]
        , [Product]
        , [CurrencyProduct]
        , [PaymentSource]
        , [CurrencySource]
        , [CompanyLoan]
        , [Loan]
        , [CurrencyLoan]
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Investment.Analytics.TO] ON [dbo].[Register.Accumulation.Investment.Analytics.TO.v] (
          [date],
          [company]
        , [SourceTransaction]
        , [CreditTransaction]
        , [OperationType]
        , [Investor]
        , [CompanyProduct]
        , [Product]
        , [CurrencyProduct]
        , [PaymentSource]
        , [CurrencySource]
        , [CompanyLoan]
        , [Loan]
        , [CurrencyLoan]);
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Investment.Analytics.TO] AS SELECT * FROM [dbo].[Register.Accumulation.Investment.Analytics.TO.v] WITH (NOEXPAND);
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.Investment.Analytics.TO] TO jetti;
      GO
      RAISERROR('Register.Accumulation.Investment.Analytics end', 0 ,1) WITH NOWAIT;
      GO

      RAISERROR('Register.Accumulation.OrderPayment start', 0 ,1) WITH NOWAIT;
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.OrderPayment.TO.v] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , [PaymantKind]
        , [Customer]
        , [BankAccount]
        , [CashRegister]
        , [AcquiringTerminal]
        , [currency]
        , [Department]
        , SUM(ISNULL([Amount], 0)) [Amount]
        , SUM(ISNULL([Amount.In], 0)) [Amount.In]
        , SUM(ISNULL([Amount.Out], 0)) [Amount.Out]
        , SUM(ISNULL([AmountInBalance], 0)) [AmountInBalance]
        , SUM(ISNULL([AmountInBalance.In], 0)) [AmountInBalance.In]
        , SUM(ISNULL([AmountInBalance.Out], 0)) [AmountInBalance.Out]
        , SUM(ISNULL([AmountInAccounting], 0)) [AmountInAccounting]
        , SUM(ISNULL([AmountInAccounting.In], 0)) [AmountInAccounting.In]
        , SUM(ISNULL([AmountInAccounting.Out], 0)) [AmountInAccounting.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.OrderPayment]
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , [PaymantKind]
        , [Customer]
        , [BankAccount]
        , [CashRegister]
        , [AcquiringTerminal]
        , [currency]
        , [Department]
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.OrderPayment.TO] ON [dbo].[Register.Accumulation.OrderPayment.TO.v] (
          [date],
          [company]
        , [PaymantKind]
        , [Customer]
        , [BankAccount]
        , [CashRegister]
        , [AcquiringTerminal]
        , [currency]
        , [Department]);
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.OrderPayment.TO] AS SELECT * FROM [dbo].[Register.Accumulation.OrderPayment.TO.v] WITH (NOEXPAND);
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.OrderPayment.TO] TO jetti;
      GO
      RAISERROR('Register.Accumulation.OrderPayment end', 0 ,1) WITH NOWAIT;
      GO

      RAISERROR('Register.Accumulation.AP start', 0 ,1) WITH NOWAIT;
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.AP.TO.v] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , [currency]
        , [AO]
        , [Supplier]
        , SUM(ISNULL([Amount], 0)) [Amount]
        , SUM(ISNULL([Amount.In], 0)) [Amount.In]
        , SUM(ISNULL([Amount.Out], 0)) [Amount.Out]
        , SUM(ISNULL([AmountInBalance], 0)) [AmountInBalance]
        , SUM(ISNULL([AmountInBalance.In], 0)) [AmountInBalance.In]
        , SUM(ISNULL([AmountInBalance.Out], 0)) [AmountInBalance.Out]
        , SUM(ISNULL([AmountInAccounting], 0)) [AmountInAccounting]
        , SUM(ISNULL([AmountInAccounting.In], 0)) [AmountInAccounting.In]
        , SUM(ISNULL([AmountInAccounting.Out], 0)) [AmountInAccounting.Out]
        , SUM(ISNULL([AmountToPay], 0)) [AmountToPay]
        , SUM(ISNULL([AmountToPay.In], 0)) [AmountToPay.In]
        , SUM(ISNULL([AmountToPay.Out], 0)) [AmountToPay.Out]
        , SUM(ISNULL([AmountIsPaid], 0)) [AmountIsPaid]
        , SUM(ISNULL([AmountIsPaid.In], 0)) [AmountIsPaid.In]
        , SUM(ISNULL([AmountIsPaid.Out], 0)) [AmountIsPaid.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.AP]
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , [currency]
        , [AO]
        , [Supplier]
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.AP.TO] ON [dbo].[Register.Accumulation.AP.TO.v] (
          [date],
          [company]
        , [currency]
        , [AO]
        , [Supplier]);
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.AP.TO] AS SELECT * FROM [dbo].[Register.Accumulation.AP.TO.v] WITH (NOEXPAND);
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.AP.TO] TO jetti;
      GO
      RAISERROR('Register.Accumulation.AP end', 0 ,1) WITH NOWAIT;
      GO

      RAISERROR('Register.Accumulation.AR start', 0 ,1) WITH NOWAIT;
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.AR.TO.v] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , [currency]
        , [AO]
        , [Customer]
        , SUM(ISNULL([AR], 0)) [AR]
        , SUM(ISNULL([AR.In], 0)) [AR.In]
        , SUM(ISNULL([AR.Out], 0)) [AR.Out]
        , SUM(ISNULL([AmountInBalance], 0)) [AmountInBalance]
        , SUM(ISNULL([AmountInBalance.In], 0)) [AmountInBalance.In]
        , SUM(ISNULL([AmountInBalance.Out], 0)) [AmountInBalance.Out]
        , SUM(ISNULL([AmountInAccounting], 0)) [AmountInAccounting]
        , SUM(ISNULL([AmountInAccounting.In], 0)) [AmountInAccounting.In]
        , SUM(ISNULL([AmountInAccounting.Out], 0)) [AmountInAccounting.Out]
        , SUM(ISNULL([AmountToPay], 0)) [AmountToPay]
        , SUM(ISNULL([AmountToPay.In], 0)) [AmountToPay.In]
        , SUM(ISNULL([AmountToPay.Out], 0)) [AmountToPay.Out]
        , SUM(ISNULL([AmountIsPaid], 0)) [AmountIsPaid]
        , SUM(ISNULL([AmountIsPaid.In], 0)) [AmountIsPaid.In]
        , SUM(ISNULL([AmountIsPaid.Out], 0)) [AmountIsPaid.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.AR]
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , [currency]
        , [AO]
        , [Customer]
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.AR.TO] ON [dbo].[Register.Accumulation.AR.TO.v] (
          [date],
          [company]
        , [currency]
        , [AO]
        , [Customer]);
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.AR.TO] AS SELECT * FROM [dbo].[Register.Accumulation.AR.TO.v] WITH (NOEXPAND);
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.AR.TO] TO jetti;
      GO
      RAISERROR('Register.Accumulation.AR end', 0 ,1) WITH NOWAIT;
      GO

      RAISERROR('Register.Accumulation.Bank start', 0 ,1) WITH NOWAIT;
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Bank.TO.v] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , [currency]
        , [BankAccount]
        , [CashFlow]
        , [Analytics]
        , SUM(ISNULL([Amount], 0)) [Amount]
        , SUM(ISNULL([Amount.In], 0)) [Amount.In]
        , SUM(ISNULL([Amount.Out], 0)) [Amount.Out]
        , SUM(ISNULL([AmountInBalance], 0)) [AmountInBalance]
        , SUM(ISNULL([AmountInBalance.In], 0)) [AmountInBalance.In]
        , SUM(ISNULL([AmountInBalance.Out], 0)) [AmountInBalance.Out]
        , SUM(ISNULL([AmountInAccounting], 0)) [AmountInAccounting]
        , SUM(ISNULL([AmountInAccounting.In], 0)) [AmountInAccounting.In]
        , SUM(ISNULL([AmountInAccounting.Out], 0)) [AmountInAccounting.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.Bank]
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , [currency]
        , [BankAccount]
        , [CashFlow]
        , [Analytics]
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Bank.TO] ON [dbo].[Register.Accumulation.Bank.TO.v] (
          [date],
          [company]
        , [currency]
        , [BankAccount]
        , [CashFlow]
        , [Analytics]);
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Bank.TO] AS SELECT * FROM [dbo].[Register.Accumulation.Bank.TO.v] WITH (NOEXPAND);
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.Bank.TO] TO jetti;
      GO
      RAISERROR('Register.Accumulation.Bank end', 0 ,1) WITH NOWAIT;
      GO

      RAISERROR('Register.Accumulation.Balance start', 0 ,1) WITH NOWAIT;
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Balance.TO.v] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , [Balance]
        , [Analytics]
        , SUM(ISNULL([Amount], 0)) [Amount]
        , SUM(ISNULL([Amount.In], 0)) [Amount.In]
        , SUM(ISNULL([Amount.Out], 0)) [Amount.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.Balance]
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , [Balance]
        , [Analytics]
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Balance.TO] ON [dbo].[Register.Accumulation.Balance.TO.v] (
          [date],
          [company]
        , [Balance]
        , [Analytics]);
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Balance.TO] AS SELECT * FROM [dbo].[Register.Accumulation.Balance.TO.v] WITH (NOEXPAND);
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.Balance.TO] TO jetti;
      GO
      RAISERROR('Register.Accumulation.Balance end', 0 ,1) WITH NOWAIT;
      GO

      RAISERROR('Register.Accumulation.Balance.RC start', 0 ,1) WITH NOWAIT;
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Balance.RC.TO.v] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , [ResponsibilityCenter]
        , [Department]
        , [Balance]
        , [Analytics]
        , [Analytics2]
        , [Currency]
        , SUM(ISNULL([Amount], 0)) [Amount]
        , SUM(ISNULL([Amount.In], 0)) [Amount.In]
        , SUM(ISNULL([Amount.Out], 0)) [Amount.Out]
        , SUM(ISNULL([AmountRC], 0)) [AmountRC]
        , SUM(ISNULL([AmountRC.In], 0)) [AmountRC.In]
        , SUM(ISNULL([AmountRC.Out], 0)) [AmountRC.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.Balance.RC]
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , [ResponsibilityCenter]
        , [Department]
        , [Balance]
        , [Analytics]
        , [Analytics2]
        , [Currency]
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Balance.RC.TO] ON [dbo].[Register.Accumulation.Balance.RC.TO.v] (
          [date],
          [company]
        , [ResponsibilityCenter]
        , [Department]
        , [Balance]
        , [Analytics]
        , [Analytics2]
        , [Currency]);
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Balance.RC.TO] AS SELECT * FROM [dbo].[Register.Accumulation.Balance.RC.TO.v] WITH (NOEXPAND);
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.Balance.RC.TO] TO jetti;
      GO
      RAISERROR('Register.Accumulation.Balance.RC end', 0 ,1) WITH NOWAIT;
      GO

      RAISERROR('Register.Accumulation.Balance.Report start', 0 ,1) WITH NOWAIT;
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Balance.Report.TO.v] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , [currency]
        , [Balance]
        , [Analytics]
        , SUM(ISNULL([Amount], 0)) [Amount]
        , SUM(ISNULL([Amount.In], 0)) [Amount.In]
        , SUM(ISNULL([Amount.Out], 0)) [Amount.Out]
        , SUM(ISNULL([AmountInBalance], 0)) [AmountInBalance]
        , SUM(ISNULL([AmountInBalance.In], 0)) [AmountInBalance.In]
        , SUM(ISNULL([AmountInBalance.Out], 0)) [AmountInBalance.Out]
        , SUM(ISNULL([AmountInAccounting], 0)) [AmountInAccounting]
        , SUM(ISNULL([AmountInAccounting.In], 0)) [AmountInAccounting.In]
        , SUM(ISNULL([AmountInAccounting.Out], 0)) [AmountInAccounting.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.Balance.Report]
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , [currency]
        , [Balance]
        , [Analytics]
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Balance.Report.TO] ON [dbo].[Register.Accumulation.Balance.Report.TO.v] (
          [date],
          [company]
        , [currency]
        , [Balance]
        , [Analytics]);
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Balance.Report.TO] AS SELECT * FROM [dbo].[Register.Accumulation.Balance.Report.TO.v] WITH (NOEXPAND);
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.Balance.Report.TO] TO jetti;
      GO
      RAISERROR('Register.Accumulation.Balance.Report end', 0 ,1) WITH NOWAIT;
      GO

      RAISERROR('Register.Accumulation.Cash start', 0 ,1) WITH NOWAIT;
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Cash.TO.v] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , [currency]
        , [CashRegister]
        , [CashFlow]
        , [Analytics]
        , SUM(ISNULL([Amount], 0)) [Amount]
        , SUM(ISNULL([Amount.In], 0)) [Amount.In]
        , SUM(ISNULL([Amount.Out], 0)) [Amount.Out]
        , SUM(ISNULL([AmountInBalance], 0)) [AmountInBalance]
        , SUM(ISNULL([AmountInBalance.In], 0)) [AmountInBalance.In]
        , SUM(ISNULL([AmountInBalance.Out], 0)) [AmountInBalance.Out]
        , SUM(ISNULL([AmountInAccounting], 0)) [AmountInAccounting]
        , SUM(ISNULL([AmountInAccounting.In], 0)) [AmountInAccounting.In]
        , SUM(ISNULL([AmountInAccounting.Out], 0)) [AmountInAccounting.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.Cash]
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , [currency]
        , [CashRegister]
        , [CashFlow]
        , [Analytics]
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Cash.TO] ON [dbo].[Register.Accumulation.Cash.TO.v] (
          [date],
          [company]
        , [currency]
        , [CashRegister]
        , [CashFlow]
        , [Analytics]);
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Cash.TO] AS SELECT * FROM [dbo].[Register.Accumulation.Cash.TO.v] WITH (NOEXPAND);
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.Cash.TO] TO jetti;
      GO
      RAISERROR('Register.Accumulation.Cash end', 0 ,1) WITH NOWAIT;
      GO

      RAISERROR('Register.Accumulation.Cash.Transit start', 0 ,1) WITH NOWAIT;
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Cash.Transit.TO.v] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , [CompanyRecipient]
        , [currency]
        , [Sender]
        , [Recipient]
        , [CashFlow]
        , SUM(ISNULL([Amount], 0)) [Amount]
        , SUM(ISNULL([Amount.In], 0)) [Amount.In]
        , SUM(ISNULL([Amount.Out], 0)) [Amount.Out]
        , SUM(ISNULL([AmountInBalance], 0)) [AmountInBalance]
        , SUM(ISNULL([AmountInBalance.In], 0)) [AmountInBalance.In]
        , SUM(ISNULL([AmountInBalance.Out], 0)) [AmountInBalance.Out]
        , SUM(ISNULL([AmountInAccounting], 0)) [AmountInAccounting]
        , SUM(ISNULL([AmountInAccounting.In], 0)) [AmountInAccounting.In]
        , SUM(ISNULL([AmountInAccounting.Out], 0)) [AmountInAccounting.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.Cash.Transit]
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , [CompanyRecipient]
        , [currency]
        , [Sender]
        , [Recipient]
        , [CashFlow]
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Cash.Transit.TO] ON [dbo].[Register.Accumulation.Cash.Transit.TO.v] (
          [date],
          [company]
        , [CompanyRecipient]
        , [currency]
        , [Sender]
        , [Recipient]
        , [CashFlow]);
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Cash.Transit.TO] AS SELECT * FROM [dbo].[Register.Accumulation.Cash.Transit.TO.v] WITH (NOEXPAND);
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.Cash.Transit.TO] TO jetti;
      GO
      RAISERROR('Register.Accumulation.Cash.Transit end', 0 ,1) WITH NOWAIT;
      GO

      RAISERROR('Register.Accumulation.EmployeeTimekeeping start', 0 ,1) WITH NOWAIT;
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.EmployeeTimekeeping.TO.v] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , [isActive]
        , [PeriodMonth]
        , [KindTimekeeping]
        , [Employee]
        , [Person]
        , [StaffingTable]
        , SUM(ISNULL([Days], 0)) [Days]
        , SUM(ISNULL([Days.In], 0)) [Days.In]
        , SUM(ISNULL([Days.Out], 0)) [Days.Out]
        , SUM(ISNULL([Hours], 0)) [Hours]
        , SUM(ISNULL([Hours.In], 0)) [Hours.In]
        , SUM(ISNULL([Hours.Out], 0)) [Hours.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.EmployeeTimekeeping]
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , [isActive]
        , [PeriodMonth]
        , [KindTimekeeping]
        , [Employee]
        , [Person]
        , [StaffingTable]
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.EmployeeTimekeeping.TO] ON [dbo].[Register.Accumulation.EmployeeTimekeeping.TO.v] (
          [date],
          [company]
        , [isActive]
        , [PeriodMonth]
        , [KindTimekeeping]
        , [Employee]
        , [Person]
        , [StaffingTable]);
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.EmployeeTimekeeping.TO] AS SELECT * FROM [dbo].[Register.Accumulation.EmployeeTimekeeping.TO.v] WITH (NOEXPAND);
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.EmployeeTimekeeping.TO] TO jetti;
      GO
      RAISERROR('Register.Accumulation.EmployeeTimekeeping end', 0 ,1) WITH NOWAIT;
      GO

      RAISERROR('Register.Accumulation.Inventory start', 0 ,1) WITH NOWAIT;
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Inventory.TO.v] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , [Storehouse]
        , [SKU]
        , SUM(ISNULL([Cost], 0)) [Cost]
        , SUM(ISNULL([Cost.In], 0)) [Cost.In]
        , SUM(ISNULL([Cost.Out], 0)) [Cost.Out]
        , SUM(ISNULL([Qty], 0)) [Qty]
        , SUM(ISNULL([Qty.In], 0)) [Qty.In]
        , SUM(ISNULL([Qty.Out], 0)) [Qty.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.Inventory]
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , [Storehouse]
        , [SKU]
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Inventory.TO] ON [dbo].[Register.Accumulation.Inventory.TO.v] (
          [date],
          [company]
        , [Storehouse]
        , [SKU]);
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Inventory.TO] AS SELECT * FROM [dbo].[Register.Accumulation.Inventory.TO.v] WITH (NOEXPAND);
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.Inventory.TO] TO jetti;
      GO
      RAISERROR('Register.Accumulation.Inventory end', 0 ,1) WITH NOWAIT;
      GO

      RAISERROR('Register.Accumulation.Loan start', 0 ,1) WITH NOWAIT;
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Loan.TO.v] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , [Loan]
        , [Counterpartie]
        , [CashFlow]
        , [currency]
        , SUM(ISNULL([Amount], 0)) [Amount]
        , SUM(ISNULL([Amount.In], 0)) [Amount.In]
        , SUM(ISNULL([Amount.Out], 0)) [Amount.Out]
        , SUM(ISNULL([AmountInBalance], 0)) [AmountInBalance]
        , SUM(ISNULL([AmountInBalance.In], 0)) [AmountInBalance.In]
        , SUM(ISNULL([AmountInBalance.Out], 0)) [AmountInBalance.Out]
        , SUM(ISNULL([AmountInAccounting], 0)) [AmountInAccounting]
        , SUM(ISNULL([AmountInAccounting.In], 0)) [AmountInAccounting.In]
        , SUM(ISNULL([AmountInAccounting.Out], 0)) [AmountInAccounting.Out]
        , SUM(ISNULL([AmountToPay], 0)) [AmountToPay]
        , SUM(ISNULL([AmountToPay.In], 0)) [AmountToPay.In]
        , SUM(ISNULL([AmountToPay.Out], 0)) [AmountToPay.Out]
        , SUM(ISNULL([AmountIsPaid], 0)) [AmountIsPaid]
        , SUM(ISNULL([AmountIsPaid.In], 0)) [AmountIsPaid.In]
        , SUM(ISNULL([AmountIsPaid.Out], 0)) [AmountIsPaid.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.Loan]
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , [Loan]
        , [Counterpartie]
        , [CashFlow]
        , [currency]
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Loan.TO] ON [dbo].[Register.Accumulation.Loan.TO.v] (
          [date],
          [company]
        , [Loan]
        , [Counterpartie]
        , [CashFlow]
        , [currency]);
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Loan.TO] AS SELECT * FROM [dbo].[Register.Accumulation.Loan.TO.v] WITH (NOEXPAND);
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.Loan.TO] TO jetti;
      GO
      RAISERROR('Register.Accumulation.Loan end', 0 ,1) WITH NOWAIT;
      GO

      RAISERROR('Register.Accumulation.PL start', 0 ,1) WITH NOWAIT;
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.PL.TO.v] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , [Department]
        , [PL]
        , [Analytics]
        , [Analytics2]
        , SUM(ISNULL([Amount], 0)) [Amount]
        , SUM(ISNULL([Amount.In], 0)) [Amount.In]
        , SUM(ISNULL([Amount.Out], 0)) [Amount.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.PL]
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , [Department]
        , [PL]
        , [Analytics]
        , [Analytics2]
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.PL.TO] ON [dbo].[Register.Accumulation.PL.TO.v] (
          [date],
          [company]
        , [Department]
        , [PL]
        , [Analytics]
        , [Analytics2]);
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.PL.TO] AS SELECT * FROM [dbo].[Register.Accumulation.PL.TO.v] WITH (NOEXPAND);
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.PL.TO] TO jetti;
      GO
      RAISERROR('Register.Accumulation.PL end', 0 ,1) WITH NOWAIT;
      GO

      RAISERROR('Register.Accumulation.PL.RC start', 0 ,1) WITH NOWAIT;
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.PL.RC.TO.v] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , [ResponsibilityCenter]
        , [Department]
        , [PL]
        , [Analytics]
        , [Analytics2]
        , [Currency]
        , SUM(ISNULL([Amount], 0)) [Amount]
        , SUM(ISNULL([Amount.In], 0)) [Amount.In]
        , SUM(ISNULL([Amount.Out], 0)) [Amount.Out]
        , SUM(ISNULL([AmountRC], 0)) [AmountRC]
        , SUM(ISNULL([AmountRC.In], 0)) [AmountRC.In]
        , SUM(ISNULL([AmountRC.Out], 0)) [AmountRC.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.PL.RC]
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , [ResponsibilityCenter]
        , [Department]
        , [PL]
        , [Analytics]
        , [Analytics2]
        , [Currency]
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.PL.RC.TO] ON [dbo].[Register.Accumulation.PL.RC.TO.v] (
          [date],
          [company]
        , [ResponsibilityCenter]
        , [Department]
        , [PL]
        , [Analytics]
        , [Analytics2]
        , [Currency]);
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.PL.RC.TO] AS SELECT * FROM [dbo].[Register.Accumulation.PL.RC.TO.v] WITH (NOEXPAND);
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.PL.RC.TO] TO jetti;
      GO
      RAISERROR('Register.Accumulation.PL.RC end', 0 ,1) WITH NOWAIT;
      GO

      RAISERROR('Register.Accumulation.Sales start', 0 ,1) WITH NOWAIT;
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Sales.TO.v] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , [currency]
        , [Department]
        , [Customer]
        , [Product]
        , [Analytic]
        , [Manager]
        , [Storehouse]
        , SUM(ISNULL([Cost], 0)) [Cost]
        , SUM(ISNULL([Cost.In], 0)) [Cost.In]
        , SUM(ISNULL([Cost.Out], 0)) [Cost.Out]
        , SUM(ISNULL([Qty], 0)) [Qty]
        , SUM(ISNULL([Qty.In], 0)) [Qty.In]
        , SUM(ISNULL([Qty.Out], 0)) [Qty.Out]
        , SUM(ISNULL([Amount], 0)) [Amount]
        , SUM(ISNULL([Amount.In], 0)) [Amount.In]
        , SUM(ISNULL([Amount.Out], 0)) [Amount.Out]
        , SUM(ISNULL([Discount], 0)) [Discount]
        , SUM(ISNULL([Discount.In], 0)) [Discount.In]
        , SUM(ISNULL([Discount.Out], 0)) [Discount.Out]
        , SUM(ISNULL([Tax], 0)) [Tax]
        , SUM(ISNULL([Tax.In], 0)) [Tax.In]
        , SUM(ISNULL([Tax.Out], 0)) [Tax.Out]
        , SUM(ISNULL([AmountInDoc], 0)) [AmountInDoc]
        , SUM(ISNULL([AmountInDoc.In], 0)) [AmountInDoc.In]
        , SUM(ISNULL([AmountInDoc.Out], 0)) [AmountInDoc.Out]
        , SUM(ISNULL([AmountInAR], 0)) [AmountInAR]
        , SUM(ISNULL([AmountInAR.In], 0)) [AmountInAR.In]
        , SUM(ISNULL([AmountInAR.Out], 0)) [AmountInAR.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.Sales]
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , [currency]
        , [Department]
        , [Customer]
        , [Product]
        , [Analytic]
        , [Manager]
        , [Storehouse]
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Sales.TO] ON [dbo].[Register.Accumulation.Sales.TO.v] (
          [date],
          [company]
        , [currency]
        , [Department]
        , [Customer]
        , [Product]
        , [Analytic]
        , [Manager]
        , [Storehouse]);
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Sales.TO] AS SELECT * FROM [dbo].[Register.Accumulation.Sales.TO.v] WITH (NOEXPAND);
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.Sales.TO] TO jetti;
      GO
      RAISERROR('Register.Accumulation.Sales end', 0 ,1) WITH NOWAIT;
      GO

      RAISERROR('Register.Accumulation.Salary start', 0 ,1) WITH NOWAIT;
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Salary.TO.v] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , [currency]
        , [KorrCompany]
        , [Department]
        , [Person]
        , [Employee]
        , [SalaryKind]
        , [Analytics]
        , [PL]
        , [PLAnalytics]
        , [Status]
        , SUM(ISNULL([Amount], 0)) [Amount]
        , SUM(ISNULL([Amount.In], 0)) [Amount.In]
        , SUM(ISNULL([Amount.Out], 0)) [Amount.Out]
        , SUM(ISNULL([AmountInBalance], 0)) [AmountInBalance]
        , SUM(ISNULL([AmountInBalance.In], 0)) [AmountInBalance.In]
        , SUM(ISNULL([AmountInBalance.Out], 0)) [AmountInBalance.Out]
        , SUM(ISNULL([AmountInAccounting], 0)) [AmountInAccounting]
        , SUM(ISNULL([AmountInAccounting.In], 0)) [AmountInAccounting.In]
        , SUM(ISNULL([AmountInAccounting.Out], 0)) [AmountInAccounting.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.Salary]
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , [currency]
        , [KorrCompany]
        , [Department]
        , [Person]
        , [Employee]
        , [SalaryKind]
        , [Analytics]
        , [PL]
        , [PLAnalytics]
        , [Status]
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Salary.TO] ON [dbo].[Register.Accumulation.Salary.TO.v] (
          [date],
          [company]
        , [currency]
        , [KorrCompany]
        , [Department]
        , [Person]
        , [Employee]
        , [SalaryKind]
        , [Analytics]
        , [PL]
        , [PLAnalytics]
        , [Status]);
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Salary.TO] AS SELECT * FROM [dbo].[Register.Accumulation.Salary.TO.v] WITH (NOEXPAND);
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.Salary.TO] TO jetti;
      GO
      RAISERROR('Register.Accumulation.Salary end', 0 ,1) WITH NOWAIT;
      GO

      RAISERROR('Register.Accumulation.Depreciation start', 0 ,1) WITH NOWAIT;
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Depreciation.TO.v] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , [OperationType]
        , [currency]
        , [Department]
        , [ResponsiblePerson]
        , SUM(ISNULL([Amount], 0)) [Amount]
        , SUM(ISNULL([Amount.In], 0)) [Amount.In]
        , SUM(ISNULL([Amount.Out], 0)) [Amount.Out]
        , SUM(ISNULL([AmountInBalance], 0)) [AmountInBalance]
        , SUM(ISNULL([AmountInBalance.In], 0)) [AmountInBalance.In]
        , SUM(ISNULL([AmountInBalance.Out], 0)) [AmountInBalance.Out]
        , SUM(ISNULL([AmountInAccounting], 0)) [AmountInAccounting]
        , SUM(ISNULL([AmountInAccounting.In], 0)) [AmountInAccounting.In]
        , SUM(ISNULL([AmountInAccounting.Out], 0)) [AmountInAccounting.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.Depreciation]
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , [OperationType]
        , [currency]
        , [Department]
        , [ResponsiblePerson]
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Depreciation.TO] ON [dbo].[Register.Accumulation.Depreciation.TO.v] (
          [date],
          [company]
        , [OperationType]
        , [currency]
        , [Department]
        , [ResponsiblePerson]);
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Depreciation.TO] AS SELECT * FROM [dbo].[Register.Accumulation.Depreciation.TO.v] WITH (NOEXPAND);
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.Depreciation.TO] TO jetti;
      GO
      RAISERROR('Register.Accumulation.Depreciation end', 0 ,1) WITH NOWAIT;
      GO

      RAISERROR('Register.Accumulation.CashToPay start', 0 ,1) WITH NOWAIT;
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.CashToPay.TO.v] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , [currency]
        , [CashFlow]
        , [CashRequest]
        , [Contract]
        , [BankAccountPerson]
        , [Department]
        , [OperationType]
        , [Loan]
        , [CashOrBank]
        , [CashRecipient]
        , [ExpenseOrBalance]
        , [ExpenseAnalytics]
        , [BalanceAnalytics]
        , SUM(ISNULL([Amount], 0)) [Amount]
        , SUM(ISNULL([Amount.In], 0)) [Amount.In]
        , SUM(ISNULL([Amount.Out], 0)) [Amount.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.CashToPay]
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , [currency]
        , [CashFlow]
        , [CashRequest]
        , [Contract]
        , [BankAccountPerson]
        , [Department]
        , [OperationType]
        , [Loan]
        , [CashOrBank]
        , [CashRecipient]
        , [ExpenseOrBalance]
        , [ExpenseAnalytics]
        , [BalanceAnalytics]
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.CashToPay.TO] ON [dbo].[Register.Accumulation.CashToPay.TO.v] (
          [date],
          [company]
        , [currency]
        , [CashFlow]
        , [CashRequest]
        , [Contract]
        , [BankAccountPerson]
        , [Department]
        , [OperationType]
        , [Loan]
        , [CashOrBank]
        , [CashRecipient]
        , [ExpenseOrBalance]
        , [ExpenseAnalytics]
        , [BalanceAnalytics]);
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.CashToPay.TO] AS SELECT * FROM [dbo].[Register.Accumulation.CashToPay.TO.v] WITH (NOEXPAND);
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.CashToPay.TO] TO jetti;
      GO
      RAISERROR('Register.Accumulation.CashToPay end', 0 ,1) WITH NOWAIT;
      GO

      RAISERROR('Register.Accumulation.BudgetItemTurnover start', 0 ,1) WITH NOWAIT;
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.BudgetItemTurnover.TO.v] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , [Department]
        , [Scenario]
        , [BudgetItem]
        , [currency]
        , SUM(ISNULL([Amount], 0)) [Amount]
        , SUM(ISNULL([Amount.In], 0)) [Amount.In]
        , SUM(ISNULL([Amount.Out], 0)) [Amount.Out]
        , SUM(ISNULL([AmountInScenatio], 0)) [AmountInScenatio]
        , SUM(ISNULL([AmountInScenatio.In], 0)) [AmountInScenatio.In]
        , SUM(ISNULL([AmountInScenatio.Out], 0)) [AmountInScenatio.Out]
        , SUM(ISNULL([AmountInCurrency], 0)) [AmountInCurrency]
        , SUM(ISNULL([AmountInCurrency.In], 0)) [AmountInCurrency.In]
        , SUM(ISNULL([AmountInCurrency.Out], 0)) [AmountInCurrency.Out]
        , SUM(ISNULL([AmountInAccounting], 0)) [AmountInAccounting]
        , SUM(ISNULL([AmountInAccounting.In], 0)) [AmountInAccounting.In]
        , SUM(ISNULL([AmountInAccounting.Out], 0)) [AmountInAccounting.Out]
        , SUM(ISNULL([Qty], 0)) [Qty]
        , SUM(ISNULL([Qty.In], 0)) [Qty.In]
        , SUM(ISNULL([Qty.Out], 0)) [Qty.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.BudgetItemTurnover]
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , [Department]
        , [Scenario]
        , [BudgetItem]
        , [currency]
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.BudgetItemTurnover.TO] ON [dbo].[Register.Accumulation.BudgetItemTurnover.TO.v] (
          [date],
          [company]
        , [Department]
        , [Scenario]
        , [BudgetItem]
        , [currency]);
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.BudgetItemTurnover.TO] AS SELECT * FROM [dbo].[Register.Accumulation.BudgetItemTurnover.TO.v] WITH (NOEXPAND);
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.BudgetItemTurnover.TO] TO jetti;
      GO
      RAISERROR('Register.Accumulation.BudgetItemTurnover end', 0 ,1) WITH NOWAIT;
      GO

      RAISERROR('Register.Accumulation.Intercompany start', 0 ,1) WITH NOWAIT;
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Intercompany.TO.v] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , [Intercompany]
        , [LegalCompanySender]
        , [LegalCompanyRecipient]
        , SUM(ISNULL([Amount], 0)) [Amount]
        , SUM(ISNULL([Amount.In], 0)) [Amount.In]
        , SUM(ISNULL([Amount.Out], 0)) [Amount.Out]
        , SUM(ISNULL([AmountInBalance], 0)) [AmountInBalance]
        , SUM(ISNULL([AmountInBalance.In], 0)) [AmountInBalance.In]
        , SUM(ISNULL([AmountInBalance.Out], 0)) [AmountInBalance.Out]
        , SUM(ISNULL([AmountInAccounting], 0)) [AmountInAccounting]
        , SUM(ISNULL([AmountInAccounting.In], 0)) [AmountInAccounting.In]
        , SUM(ISNULL([AmountInAccounting.Out], 0)) [AmountInAccounting.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.Intercompany]
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , [Intercompany]
        , [LegalCompanySender]
        , [LegalCompanyRecipient]
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Intercompany.TO] ON [dbo].[Register.Accumulation.Intercompany.TO.v] (
          [date],
          [company]
        , [Intercompany]
        , [LegalCompanySender]
        , [LegalCompanyRecipient]);
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Intercompany.TO] AS SELECT * FROM [dbo].[Register.Accumulation.Intercompany.TO.v] WITH (NOEXPAND);
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.Intercompany.TO] TO jetti;
      GO
      RAISERROR('Register.Accumulation.Intercompany end', 0 ,1) WITH NOWAIT;
      GO

      RAISERROR('Register.Accumulation.Acquiring start', 0 ,1) WITH NOWAIT;
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Acquiring.TO.v] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , [AcquiringTerminal]
        , [OperationType]
        , [Department]
        , [CashFlow]
        , [currency]
        , SUM(ISNULL([Amount], 0)) [Amount]
        , SUM(ISNULL([Amount.In], 0)) [Amount.In]
        , SUM(ISNULL([Amount.Out], 0)) [Amount.Out]
        , SUM(ISNULL([AmountInBalance], 0)) [AmountInBalance]
        , SUM(ISNULL([AmountInBalance.In], 0)) [AmountInBalance.In]
        , SUM(ISNULL([AmountInBalance.Out], 0)) [AmountInBalance.Out]
        , SUM(ISNULL([AmountOperation], 0)) [AmountOperation]
        , SUM(ISNULL([AmountOperation.In], 0)) [AmountOperation.In]
        , SUM(ISNULL([AmountOperation.Out], 0)) [AmountOperation.Out]
        , SUM(ISNULL([AmountPaid], 0)) [AmountPaid]
        , SUM(ISNULL([AmountPaid.In], 0)) [AmountPaid.In]
        , SUM(ISNULL([AmountPaid.Out], 0)) [AmountPaid.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.Acquiring]
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , [AcquiringTerminal]
        , [OperationType]
        , [Department]
        , [CashFlow]
        , [currency]
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Acquiring.TO] ON [dbo].[Register.Accumulation.Acquiring.TO.v] (
          [date],
          [company]
        , [AcquiringTerminal]
        , [OperationType]
        , [Department]
        , [CashFlow]
        , [currency]);
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Acquiring.TO] AS SELECT * FROM [dbo].[Register.Accumulation.Acquiring.TO.v] WITH (NOEXPAND);
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.Acquiring.TO] TO jetti;
      GO
      RAISERROR('Register.Accumulation.Acquiring end', 0 ,1) WITH NOWAIT;
      GO

      RAISERROR('Register.Accumulation.StaffingTable start', 0 ,1) WITH NOWAIT;
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.StaffingTable.TO.v] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , [Department]
        , [DepartmentCompany]
        , [StaffingTablePosition]
        , [Employee]
        , [Person]
        , SUM(ISNULL([SalaryRate], 0)) [SalaryRate]
        , SUM(ISNULL([SalaryRate.In], 0)) [SalaryRate.In]
        , SUM(ISNULL([SalaryRate.Out], 0)) [SalaryRate.Out]
        , [SalaryAnalytic]
        , [currency]
        , SUM(ISNULL([Amount], 0)) [Amount]
        , SUM(ISNULL([Amount.In], 0)) [Amount.In]
        , SUM(ISNULL([Amount.Out], 0)) [Amount.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.StaffingTable]
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , [Department]
        , [DepartmentCompany]
        , [StaffingTablePosition]
        , [Employee]
        , [Person]
        , [SalaryAnalytic]
        , [currency]
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.StaffingTable.TO] ON [dbo].[Register.Accumulation.StaffingTable.TO.v] (
          [date],
          [company]
        , [Department]
        , [DepartmentCompany]
        , [StaffingTablePosition]
        , [Employee]
        , [Person]
        , [SalaryAnalytic]
        , [currency]);
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.StaffingTable.TO] AS SELECT * FROM [dbo].[Register.Accumulation.StaffingTable.TO.v] WITH (NOEXPAND);
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.StaffingTable.TO] TO jetti;
      GO
      RAISERROR('Register.Accumulation.StaffingTable end', 0 ,1) WITH NOWAIT;
      GO