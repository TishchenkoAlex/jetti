

      RAISERROR('Register.Accumulation.AccountablePersons start', 0 ,1) WITH NOWAIT;
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.AccountablePersons.TO.v] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) AS [currency]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Employee"')) AS [Employee]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashFlow"')) AS [CashFlow]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, -1), 0)) [AmountInBalance]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, null), 0)) [AmountInBalance.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, null, 1), 0)) [AmountInBalance.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, -1), 0)) [AmountInAccounting]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, null), 0)) [AmountInAccounting.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, null, 1), 0)) [AmountInAccounting.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountToPay"')) * IIF(kind = 1, 1, -1), 0)) [AmountToPay]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountToPay"')) * IIF(kind = 1, 1, null), 0)) [AmountToPay.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountToPay"')) * IIF(kind = 1, null, 1), 0)) [AmountToPay.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountIsPaid"')) * IIF(kind = 1, 1, -1), 0)) [AmountIsPaid]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountIsPaid"')) * IIF(kind = 1, 1, null), 0)) [AmountIsPaid.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountIsPaid"')) * IIF(kind = 1, null, 1), 0)) [AmountIsPaid.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.AccountablePersons'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Employee"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashFlow"'))
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.AccountablePersons.TO] ON [dbo].[Register.Accumulation.AccountablePersons.TO.v] ([date], [company], [currency], [Employee], [CashFlow]);
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
        , TRY_CONVERT(VARCHAR(64), JSON_VALUE(data, N'$."PaymentsKind"')) AS [PaymentsKind]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Counterpartie"')) AS [Counterpartie]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."ProductPackage"')) AS [ProductPackage]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Product"')) AS [Product]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Currency"')) AS [Currency]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Qty"')) * IIF(kind = 1, 1, -1), 0)) [Qty]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Qty"')) * IIF(kind = 1, 1, null), 0)) [Qty.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Qty"')) * IIF(kind = 1, null, 1), 0)) [Qty.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Price"')) * IIF(kind = 1, 1, -1), 0)) [Price]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Price"')) * IIF(kind = 1, 1, null), 0)) [Price.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Price"')) * IIF(kind = 1, null, 1), 0)) [Price.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, -1), 0)) [AmountInBalance]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, null), 0)) [AmountInBalance.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, null, 1), 0)) [AmountInBalance.Out]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."batch"')) AS [batch]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.PaymentBatch'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , TRY_CONVERT(VARCHAR(64), JSON_VALUE(data, N'$."PaymentsKind"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Counterpartie"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."ProductPackage"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Product"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Currency"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."batch"'))
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.PaymentBatch.TO] ON [dbo].[Register.Accumulation.PaymentBatch.TO.v] ([date], [company], [PaymentsKind], [Counterpartie], [ProductPackage], [Product], [Currency], [batch]);
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
        , TRY_CONVERT(VARCHAR(64), JSON_VALUE(data, N'$."SourceTransaction"')) AS [SourceTransaction]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CreditTransaction"')) AS [CreditTransaction]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."OperationType"')) AS [OperationType]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Investor"')) AS [Investor]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CompanyProduct"')) AS [CompanyProduct]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Product"')) AS [Product]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Qty"')) * IIF(kind = 1, 1, -1), 0)) [Qty]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Qty"')) * IIF(kind = 1, 1, null), 0)) [Qty.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Qty"')) * IIF(kind = 1, null, 1), 0)) [Qty.Out]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CurrencyProduct"')) AS [CurrencyProduct]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountProduct"')) * IIF(kind = 1, 1, -1), 0)) [AmountProduct]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountProduct"')) * IIF(kind = 1, 1, null), 0)) [AmountProduct.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountProduct"')) * IIF(kind = 1, null, 1), 0)) [AmountProduct.Out]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."PaymentSource"')) AS [PaymentSource]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CurrencySource"')) AS [CurrencySource]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountSource"')) * IIF(kind = 1, 1, -1), 0)) [AmountSource]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountSource"')) * IIF(kind = 1, 1, null), 0)) [AmountSource.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountSource"')) * IIF(kind = 1, null, 1), 0)) [AmountSource.Out]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CompanyLoan"')) AS [CompanyLoan]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Loan"')) AS [Loan]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CurrencyLoan"')) AS [CurrencyLoan]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountLoan"')) * IIF(kind = 1, 1, -1), 0)) [AmountLoan]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountLoan"')) * IIF(kind = 1, 1, null), 0)) [AmountLoan.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountLoan"')) * IIF(kind = 1, null, 1), 0)) [AmountLoan.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.Investment.Analytics'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , TRY_CONVERT(VARCHAR(64), JSON_VALUE(data, N'$."SourceTransaction"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CreditTransaction"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."OperationType"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Investor"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CompanyProduct"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Product"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CurrencyProduct"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."PaymentSource"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CurrencySource"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CompanyLoan"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Loan"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CurrencyLoan"'))
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Investment.Analytics.TO] ON [dbo].[Register.Accumulation.Investment.Analytics.TO.v] ([date], [company], [SourceTransaction], [CreditTransaction], [OperationType], [Investor], [CompanyProduct], [Product], [CurrencyProduct], [PaymentSource], [CurrencySource], [CompanyLoan], [Loan], [CurrencyLoan]);
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
        , TRY_CONVERT(VARCHAR(64), JSON_VALUE(data, N'$."PaymantKind"')) AS [PaymantKind]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Customer"')) AS [Customer]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BankAccount"')) AS [BankAccount]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashRegister"')) AS [CashRegister]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."AcquiringTerminal"')) AS [AcquiringTerminal]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) AS [currency]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) AS [Department]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, -1), 0)) [AmountInBalance]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, null), 0)) [AmountInBalance.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, null, 1), 0)) [AmountInBalance.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, -1), 0)) [AmountInAccounting]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, null), 0)) [AmountInAccounting.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, null, 1), 0)) [AmountInAccounting.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.OrderPayment'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , TRY_CONVERT(VARCHAR(64), JSON_VALUE(data, N'$."PaymantKind"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Customer"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BankAccount"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashRegister"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."AcquiringTerminal"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"'))
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.OrderPayment.TO] ON [dbo].[Register.Accumulation.OrderPayment.TO.v] ([date], [company], [PaymantKind], [Customer], [BankAccount], [CashRegister], [AcquiringTerminal], [currency], [Department]);
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
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) AS [currency]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."AO"')) AS [AO]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Supplier"')) AS [Supplier]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, -1), 0)) [AmountInBalance]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, null), 0)) [AmountInBalance.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, null, 1), 0)) [AmountInBalance.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, -1), 0)) [AmountInAccounting]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, null), 0)) [AmountInAccounting.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, null, 1), 0)) [AmountInAccounting.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountToPay"')) * IIF(kind = 1, 1, -1), 0)) [AmountToPay]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountToPay"')) * IIF(kind = 1, 1, null), 0)) [AmountToPay.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountToPay"')) * IIF(kind = 1, null, 1), 0)) [AmountToPay.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountIsPaid"')) * IIF(kind = 1, 1, -1), 0)) [AmountIsPaid]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountIsPaid"')) * IIF(kind = 1, 1, null), 0)) [AmountIsPaid.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountIsPaid"')) * IIF(kind = 1, null, 1), 0)) [AmountIsPaid.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.AP'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."AO"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Supplier"'))
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.AP.TO] ON [dbo].[Register.Accumulation.AP.TO.v] ([date], [company], [currency], [AO], [Supplier]);
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
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) AS [currency]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."AO"')) AS [AO]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Customer"')) AS [Customer]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AR"')) * IIF(kind = 1, 1, -1), 0)) [AR]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AR"')) * IIF(kind = 1, 1, null), 0)) [AR.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AR"')) * IIF(kind = 1, null, 1), 0)) [AR.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, -1), 0)) [AmountInBalance]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, null), 0)) [AmountInBalance.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, null, 1), 0)) [AmountInBalance.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, -1), 0)) [AmountInAccounting]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, null), 0)) [AmountInAccounting.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, null, 1), 0)) [AmountInAccounting.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountToPay"')) * IIF(kind = 1, 1, -1), 0)) [AmountToPay]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountToPay"')) * IIF(kind = 1, 1, null), 0)) [AmountToPay.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountToPay"')) * IIF(kind = 1, null, 1), 0)) [AmountToPay.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountIsPaid"')) * IIF(kind = 1, 1, -1), 0)) [AmountIsPaid]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountIsPaid"')) * IIF(kind = 1, 1, null), 0)) [AmountIsPaid.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountIsPaid"')) * IIF(kind = 1, null, 1), 0)) [AmountIsPaid.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.AR'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."AO"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Customer"'))
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.AR.TO] ON [dbo].[Register.Accumulation.AR.TO.v] ([date], [company], [currency], [AO], [Customer]);
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
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) AS [currency]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BankAccount"')) AS [BankAccount]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashFlow"')) AS [CashFlow]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"')) AS [Analytics]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, -1), 0)) [AmountInBalance]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, null), 0)) [AmountInBalance.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, null, 1), 0)) [AmountInBalance.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, -1), 0)) [AmountInAccounting]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, null), 0)) [AmountInAccounting.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, null, 1), 0)) [AmountInAccounting.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.Bank'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BankAccount"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashFlow"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"'))
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Bank.TO] ON [dbo].[Register.Accumulation.Bank.TO.v] ([date], [company], [currency], [BankAccount], [CashFlow], [Analytics]);
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
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Balance"')) AS [Balance]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"')) AS [Analytics]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.Balance'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Balance"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"'))
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Balance.TO] ON [dbo].[Register.Accumulation.Balance.TO.v] ([date], [company], [Balance], [Analytics]);
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
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."ResponsibilityCenter"')) AS [ResponsibilityCenter]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) AS [Department]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Balance"')) AS [Balance]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"')) AS [Analytics]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics2"')) AS [Analytics2]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Currency"')) AS [Currency]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountRC"')) * IIF(kind = 1, 1, -1), 0)) [AmountRC]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountRC"')) * IIF(kind = 1, 1, null), 0)) [AmountRC.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountRC"')) * IIF(kind = 1, null, 1), 0)) [AmountRC.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.Balance.RC'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."ResponsibilityCenter"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Balance"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics2"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Currency"'))
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Balance.RC.TO] ON [dbo].[Register.Accumulation.Balance.RC.TO.v] ([date], [company], [ResponsibilityCenter], [Department], [Balance], [Analytics], [Analytics2], [Currency]);
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
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) AS [currency]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Balance"')) AS [Balance]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"')) AS [Analytics]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, -1), 0)) [AmountInBalance]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, null), 0)) [AmountInBalance.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, null, 1), 0)) [AmountInBalance.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, -1), 0)) [AmountInAccounting]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, null), 0)) [AmountInAccounting.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, null, 1), 0)) [AmountInAccounting.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.Balance.Report'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Balance"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"'))
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Balance.Report.TO] ON [dbo].[Register.Accumulation.Balance.Report.TO.v] ([date], [company], [currency], [Balance], [Analytics]);
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
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) AS [currency]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashRegister"')) AS [CashRegister]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashFlow"')) AS [CashFlow]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"')) AS [Analytics]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, -1), 0)) [AmountInBalance]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, null), 0)) [AmountInBalance.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, null, 1), 0)) [AmountInBalance.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, -1), 0)) [AmountInAccounting]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, null), 0)) [AmountInAccounting.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, null, 1), 0)) [AmountInAccounting.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.Cash'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashRegister"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashFlow"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"'))
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Cash.TO] ON [dbo].[Register.Accumulation.Cash.TO.v] ([date], [company], [currency], [CashRegister], [CashFlow], [Analytics]);
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
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CompanyRecipient"')) AS [CompanyRecipient]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) AS [currency]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Sender"')) AS [Sender]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Recipient"')) AS [Recipient]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashFlow"')) AS [CashFlow]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, -1), 0)) [AmountInBalance]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, null), 0)) [AmountInBalance.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, null, 1), 0)) [AmountInBalance.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, -1), 0)) [AmountInAccounting]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, null), 0)) [AmountInAccounting.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, null, 1), 0)) [AmountInAccounting.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.Cash.Transit'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CompanyRecipient"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Sender"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Recipient"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashFlow"'))
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Cash.Transit.TO] ON [dbo].[Register.Accumulation.Cash.Transit.TO.v] ([date], [company], [CompanyRecipient], [currency], [Sender], [Recipient], [CashFlow]);
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
        , TRY_CONVERT(BIT, JSON_VALUE(data, N'$."isActive"')) AS [isActive]
        , TRY_CONVERT(VARCHAR(64), JSON_VALUE(data, N'$."PeriodMonth"')) AS [PeriodMonth]
        , TRY_CONVERT(VARCHAR(64), JSON_VALUE(data, N'$."KindTimekeeping"')) AS [KindTimekeeping]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Employee"')) AS [Employee]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Person"')) AS [Person]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."StaffingTable"')) AS [StaffingTable]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Days"')) * IIF(kind = 1, 1, -1), 0)) [Days]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Days"')) * IIF(kind = 1, 1, null), 0)) [Days.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Days"')) * IIF(kind = 1, null, 1), 0)) [Days.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Hours"')) * IIF(kind = 1, 1, -1), 0)) [Hours]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Hours"')) * IIF(kind = 1, 1, null), 0)) [Hours.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Hours"')) * IIF(kind = 1, null, 1), 0)) [Hours.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.EmployeeTimekeeping'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , TRY_CONVERT(BIT, JSON_VALUE(data, N'$."isActive"'))
        , TRY_CONVERT(VARCHAR(64), JSON_VALUE(data, N'$."PeriodMonth"'))
        , TRY_CONVERT(VARCHAR(64), JSON_VALUE(data, N'$."KindTimekeeping"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Employee"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Person"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."StaffingTable"'))
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.EmployeeTimekeeping.TO] ON [dbo].[Register.Accumulation.EmployeeTimekeeping.TO.v] ([date], [company], [isActive], [PeriodMonth], [KindTimekeeping], [Employee], [Person], [StaffingTable]);
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
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Storehouse"')) AS [Storehouse]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."SKU"')) AS [SKU]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Cost"')) * IIF(kind = 1, 1, -1), 0)) [Cost]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Cost"')) * IIF(kind = 1, 1, null), 0)) [Cost.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Cost"')) * IIF(kind = 1, null, 1), 0)) [Cost.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Qty"')) * IIF(kind = 1, 1, -1), 0)) [Qty]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Qty"')) * IIF(kind = 1, 1, null), 0)) [Qty.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Qty"')) * IIF(kind = 1, null, 1), 0)) [Qty.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.Inventory'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Storehouse"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."SKU"'))
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Inventory.TO] ON [dbo].[Register.Accumulation.Inventory.TO.v] ([date], [company], [Storehouse], [SKU]);
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
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Loan"')) AS [Loan]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Counterpartie"')) AS [Counterpartie]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashFlow"')) AS [CashFlow]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) AS [currency]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, -1), 0)) [AmountInBalance]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, null), 0)) [AmountInBalance.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, null, 1), 0)) [AmountInBalance.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, -1), 0)) [AmountInAccounting]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, null), 0)) [AmountInAccounting.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, null, 1), 0)) [AmountInAccounting.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountToPay"')) * IIF(kind = 1, 1, -1), 0)) [AmountToPay]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountToPay"')) * IIF(kind = 1, 1, null), 0)) [AmountToPay.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountToPay"')) * IIF(kind = 1, null, 1), 0)) [AmountToPay.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountIsPaid"')) * IIF(kind = 1, 1, -1), 0)) [AmountIsPaid]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountIsPaid"')) * IIF(kind = 1, 1, null), 0)) [AmountIsPaid.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountIsPaid"')) * IIF(kind = 1, null, 1), 0)) [AmountIsPaid.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.Loan'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Loan"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Counterpartie"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashFlow"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"'))
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Loan.TO] ON [dbo].[Register.Accumulation.Loan.TO.v] ([date], [company], [Loan], [Counterpartie], [CashFlow], [currency]);
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
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) AS [Department]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."PL"')) AS [PL]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"')) AS [Analytics]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics2"')) AS [Analytics2]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.PL'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."PL"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics2"'))
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.PL.TO] ON [dbo].[Register.Accumulation.PL.TO.v] ([date], [company], [Department], [PL], [Analytics], [Analytics2]);
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
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."ResponsibilityCenter"')) AS [ResponsibilityCenter]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) AS [Department]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."PL"')) AS [PL]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"')) AS [Analytics]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics2"')) AS [Analytics2]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Currency"')) AS [Currency]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountRC"')) * IIF(kind = 1, 1, -1), 0)) [AmountRC]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountRC"')) * IIF(kind = 1, 1, null), 0)) [AmountRC.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountRC"')) * IIF(kind = 1, null, 1), 0)) [AmountRC.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.PL.RC'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."ResponsibilityCenter"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."PL"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics2"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Currency"'))
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.PL.RC.TO] ON [dbo].[Register.Accumulation.PL.RC.TO.v] ([date], [company], [ResponsibilityCenter], [Department], [PL], [Analytics], [Analytics2], [Currency]);
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
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) AS [currency]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) AS [Department]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Customer"')) AS [Customer]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Product"')) AS [Product]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytic"')) AS [Analytic]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Manager"')) AS [Manager]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Storehouse"')) AS [Storehouse]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Cost"')) * IIF(kind = 1, 1, -1), 0)) [Cost]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Cost"')) * IIF(kind = 1, 1, null), 0)) [Cost.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Cost"')) * IIF(kind = 1, null, 1), 0)) [Cost.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Qty"')) * IIF(kind = 1, 1, -1), 0)) [Qty]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Qty"')) * IIF(kind = 1, 1, null), 0)) [Qty.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Qty"')) * IIF(kind = 1, null, 1), 0)) [Qty.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Discount"')) * IIF(kind = 1, 1, -1), 0)) [Discount]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Discount"')) * IIF(kind = 1, 1, null), 0)) [Discount.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Discount"')) * IIF(kind = 1, null, 1), 0)) [Discount.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Tax"')) * IIF(kind = 1, 1, -1), 0)) [Tax]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Tax"')) * IIF(kind = 1, 1, null), 0)) [Tax.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Tax"')) * IIF(kind = 1, null, 1), 0)) [Tax.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInDoc"')) * IIF(kind = 1, 1, -1), 0)) [AmountInDoc]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInDoc"')) * IIF(kind = 1, 1, null), 0)) [AmountInDoc.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInDoc"')) * IIF(kind = 1, null, 1), 0)) [AmountInDoc.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAR"')) * IIF(kind = 1, 1, -1), 0)) [AmountInAR]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAR"')) * IIF(kind = 1, 1, null), 0)) [AmountInAR.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAR"')) * IIF(kind = 1, null, 1), 0)) [AmountInAR.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.Sales'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Customer"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Product"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytic"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Manager"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Storehouse"'))
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Sales.TO] ON [dbo].[Register.Accumulation.Sales.TO.v] ([date], [company], [currency], [Department], [Customer], [Product], [Analytic], [Manager], [Storehouse]);
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
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) AS [currency]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."KorrCompany"')) AS [KorrCompany]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) AS [Department]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Person"')) AS [Person]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Employee"')) AS [Employee]
        , TRY_CONVERT(VARCHAR(64), JSON_VALUE(data, N'$."SalaryKind"')) AS [SalaryKind]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"')) AS [Analytics]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."PL"')) AS [PL]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."PLAnalytics"')) AS [PLAnalytics]
        , TRY_CONVERT(VARCHAR(64), JSON_VALUE(data, N'$."Status"')) AS [Status]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, -1), 0)) [AmountInBalance]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, null), 0)) [AmountInBalance.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, null, 1), 0)) [AmountInBalance.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, -1), 0)) [AmountInAccounting]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, null), 0)) [AmountInAccounting.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, null, 1), 0)) [AmountInAccounting.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.Salary'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."KorrCompany"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Person"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Employee"'))
        , TRY_CONVERT(VARCHAR(64), JSON_VALUE(data, N'$."SalaryKind"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Analytics"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."PL"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."PLAnalytics"'))
        , TRY_CONVERT(VARCHAR(64), JSON_VALUE(data, N'$."Status"'))
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Salary.TO] ON [dbo].[Register.Accumulation.Salary.TO.v] ([date], [company], [currency], [KorrCompany], [Department], [Person], [Employee], [SalaryKind], [Analytics], [PL], [PLAnalytics], [Status]);
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
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."OperationType"')) AS [OperationType]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) AS [currency]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) AS [Department]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."ResponsiblePerson"')) AS [ResponsiblePerson]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, -1), 0)) [AmountInBalance]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, null), 0)) [AmountInBalance.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, null, 1), 0)) [AmountInBalance.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, -1), 0)) [AmountInAccounting]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, null), 0)) [AmountInAccounting.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, null, 1), 0)) [AmountInAccounting.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.Depreciation'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."OperationType"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."ResponsiblePerson"'))
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Depreciation.TO] ON [dbo].[Register.Accumulation.Depreciation.TO.v] ([date], [company], [OperationType], [currency], [Department], [ResponsiblePerson]);
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
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) AS [currency]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashFlow"')) AS [CashFlow]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashRequest"')) AS [CashRequest]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Contract"')) AS [Contract]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BankAccountPerson"')) AS [BankAccountPerson]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) AS [Department]
        , TRY_CONVERT(VARCHAR(64), JSON_VALUE(data, N'$."OperationType"')) AS [OperationType]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Loan"')) AS [Loan]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashOrBank"')) AS [CashOrBank]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashRecipient"')) AS [CashRecipient]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."ExpenseOrBalance"')) AS [ExpenseOrBalance]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."ExpenseAnalytics"')) AS [ExpenseAnalytics]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BalanceAnalytics"')) AS [BalanceAnalytics]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.CashToPay'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashFlow"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashRequest"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Contract"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BankAccountPerson"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"'))
        , TRY_CONVERT(VARCHAR(64), JSON_VALUE(data, N'$."OperationType"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Loan"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashOrBank"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashRecipient"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."ExpenseOrBalance"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."ExpenseAnalytics"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BalanceAnalytics"'))
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.CashToPay.TO] ON [dbo].[Register.Accumulation.CashToPay.TO.v] ([date], [company], [currency], [CashFlow], [CashRequest], [Contract], [BankAccountPerson], [Department], [OperationType], [Loan], [CashOrBank], [CashRecipient], [ExpenseOrBalance], [ExpenseAnalytics], [BalanceAnalytics]);
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
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) AS [Department]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Scenario"')) AS [Scenario]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BudgetItem"')) AS [BudgetItem]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) AS [currency]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInScenatio"')) * IIF(kind = 1, 1, -1), 0)) [AmountInScenatio]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInScenatio"')) * IIF(kind = 1, 1, null), 0)) [AmountInScenatio.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInScenatio"')) * IIF(kind = 1, null, 1), 0)) [AmountInScenatio.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInCurrency"')) * IIF(kind = 1, 1, -1), 0)) [AmountInCurrency]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInCurrency"')) * IIF(kind = 1, 1, null), 0)) [AmountInCurrency.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInCurrency"')) * IIF(kind = 1, null, 1), 0)) [AmountInCurrency.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, -1), 0)) [AmountInAccounting]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, null), 0)) [AmountInAccounting.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, null, 1), 0)) [AmountInAccounting.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Qty"')) * IIF(kind = 1, 1, -1), 0)) [Qty]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Qty"')) * IIF(kind = 1, 1, null), 0)) [Qty.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Qty"')) * IIF(kind = 1, null, 1), 0)) [Qty.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.BudgetItemTurnover'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Scenario"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BudgetItem"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"'))
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.BudgetItemTurnover.TO] ON [dbo].[Register.Accumulation.BudgetItemTurnover.TO.v] ([date], [company], [Department], [Scenario], [BudgetItem], [currency]);
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
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Intercompany"')) AS [Intercompany]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."LegalCompanySender"')) AS [LegalCompanySender]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."LegalCompanyRecipient"')) AS [LegalCompanyRecipient]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, -1), 0)) [AmountInBalance]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, null), 0)) [AmountInBalance.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, null, 1), 0)) [AmountInBalance.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, -1), 0)) [AmountInAccounting]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, 1, null), 0)) [AmountInAccounting.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInAccounting"')) * IIF(kind = 1, null, 1), 0)) [AmountInAccounting.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.Intercompany'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Intercompany"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."LegalCompanySender"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."LegalCompanyRecipient"'))
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Intercompany.TO] ON [dbo].[Register.Accumulation.Intercompany.TO.v] ([date], [company], [Intercompany], [LegalCompanySender], [LegalCompanyRecipient]);
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
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."AcquiringTerminal"')) AS [AcquiringTerminal]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."OperationType"')) AS [OperationType]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) AS [Department]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashFlow"')) AS [CashFlow]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) AS [currency]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, -1), 0)) [AmountInBalance]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, 1, null), 0)) [AmountInBalance.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountInBalance"')) * IIF(kind = 1, null, 1), 0)) [AmountInBalance.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountOperation"')) * IIF(kind = 1, 1, -1), 0)) [AmountOperation]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountOperation"')) * IIF(kind = 1, 1, null), 0)) [AmountOperation.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountOperation"')) * IIF(kind = 1, null, 1), 0)) [AmountOperation.Out]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountPaid"')) * IIF(kind = 1, 1, -1), 0)) [AmountPaid]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountPaid"')) * IIF(kind = 1, 1, null), 0)) [AmountPaid.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."AmountPaid"')) * IIF(kind = 1, null, 1), 0)) [AmountPaid.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.Acquiring'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."AcquiringTerminal"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."OperationType"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."CashFlow"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"'))
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Acquiring.TO] ON [dbo].[Register.Accumulation.Acquiring.TO.v] ([date], [company], [AcquiringTerminal], [OperationType], [Department], [CashFlow], [currency]);
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
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) AS [Department]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."DepartmentCompany"')) AS [DepartmentCompany]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."StaffingTablePosition"')) AS [StaffingTablePosition]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Employee"')) AS [Employee]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Person"')) AS [Person]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."SalaryRate"')) * IIF(kind = 1, 1, -1), 0)) [SalaryRate]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."SalaryRate"')) * IIF(kind = 1, 1, null), 0)) [SalaryRate.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."SalaryRate"')) * IIF(kind = 1, null, 1), 0)) [SalaryRate.Out]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."SalaryAnalytic"')) AS [SalaryAnalytic]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) AS [currency]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(data, N'$."Amount"')) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.StaffingTable'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."DepartmentCompany"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."StaffingTablePosition"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Employee"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Person"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."SalaryAnalytic"'))
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"'))
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.StaffingTable.TO] ON [dbo].[Register.Accumulation.StaffingTable.TO.v] ([date], [company], [Department], [DepartmentCompany], [StaffingTablePosition], [Employee], [Person], [SalaryAnalytic], [currency]);
      GO
      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.StaffingTable.TO] AS SELECT * FROM [dbo].[Register.Accumulation.StaffingTable.TO.v] WITH (NOEXPAND);
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.StaffingTable.TO] TO jetti;
      GO
      RAISERROR('Register.Accumulation.StaffingTable end', 0 ,1) WITH NOWAIT;
      GO