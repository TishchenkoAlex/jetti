

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.AccountablePersons.TO] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , CAST(JSON_VALUE(data, N'$.currency') AS UNIQUEIDENTIFIER) AS [currency]
        , CAST(JSON_VALUE(data, N'$.Employee') AS UNIQUEIDENTIFIER) AS [Employee]
        , CAST(JSON_VALUE(data, N'$.CashFlow') AS UNIQUEIDENTIFIER) AS [CashFlow]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountInBalance]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountInBalance.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountInBalance.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountInAccounting]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountInAccounting.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountInAccounting.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountToPay]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountToPay.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountToPay.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountIsPaid]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountIsPaid.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountIsPaid.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.AccountablePersons'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , CAST(JSON_VALUE(data, N'$.currency') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Employee') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.CashFlow') AS UNIQUEIDENTIFIER)
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.AccountablePersons.TO] ON [dbo].[Register.Accumulation.AccountablePersons.TO] (
          [date]
        , [company]
        , [currency]
        , [Employee]
        , [CashFlow]
      )
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.AccountablePersons.TO] TO jetti;
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.PaymentBatch.TO] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , CAST(JSON_VALUE(data, N'$.Counterpartie') AS UNIQUEIDENTIFIER) AS [Counterpartie]
        , CAST(JSON_VALUE(data, N'$.ProductPackage') AS UNIQUEIDENTIFIER) AS [ProductPackage]
        , CAST(JSON_VALUE(data, N'$.Product') AS UNIQUEIDENTIFIER) AS [Product]
        , CAST(JSON_VALUE(data, N'$.Currency') AS UNIQUEIDENTIFIER) AS [Currency]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [Qty]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, 1, null), 0)) [Qty.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, null, 1), 0)) [Qty.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Price') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [Price]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Price') AS MONEY) * IIF(kind = 1, 1, null), 0)) [Price.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Price') AS MONEY) * IIF(kind = 1, null, 1), 0)) [Price.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountInBalance]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountInBalance.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountInBalance.Out]
        , CAST(JSON_VALUE(data, N'$.batch') AS UNIQUEIDENTIFIER) AS [batch]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.PaymentBatch'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , CAST(JSON_VALUE(data, N'$.Counterpartie') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.ProductPackage') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Product') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Currency') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.batch') AS UNIQUEIDENTIFIER)
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.PaymentBatch.TO] ON [dbo].[Register.Accumulation.PaymentBatch.TO] (
          [date]
        , [company]
        , [PaymentsKind]
        , [Counterpartie]
        , [ProductPackage]
        , [Product]
        , [Currency]
        , [batch]
      )
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.PaymentBatch.TO] TO jetti;
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.OrderPayment.TO] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , CAST(JSON_VALUE(data, N'$.PaymantKind') AS NVARCHAR(250)) AS [PaymantKind]
        , CAST(JSON_VALUE(data, N'$.Customer') AS UNIQUEIDENTIFIER) AS [Customer]
        , CAST(JSON_VALUE(data, N'$.BankAccount') AS UNIQUEIDENTIFIER) AS [BankAccount]
        , CAST(JSON_VALUE(data, N'$.CashRegister') AS UNIQUEIDENTIFIER) AS [CashRegister]
        , CAST(JSON_VALUE(data, N'$.AcquiringTerminal') AS UNIQUEIDENTIFIER) AS [AcquiringTerminal]
        , CAST(JSON_VALUE(data, N'$.currency') AS UNIQUEIDENTIFIER) AS [currency]
        , CAST(JSON_VALUE(data, N'$.Department') AS UNIQUEIDENTIFIER) AS [Department]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountInBalance]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountInBalance.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountInBalance.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountInAccounting]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountInAccounting.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountInAccounting.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.OrderPayment'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , CAST(JSON_VALUE(data, N'$.PaymantKind') AS NVARCHAR(250))
        , CAST(JSON_VALUE(data, N'$.Customer') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.BankAccount') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.CashRegister') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.AcquiringTerminal') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.currency') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Department') AS UNIQUEIDENTIFIER)
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.OrderPayment.TO] ON [dbo].[Register.Accumulation.OrderPayment.TO] (
          [date]
        , [company]
        , [PaymantKind]
        , [Customer]
        , [BankAccount]
        , [CashRegister]
        , [AcquiringTerminal]
        , [currency]
        , [Department]
      )
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.OrderPayment.TO] TO jetti;
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.AP.TO] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , CAST(JSON_VALUE(data, N'$.currency') AS UNIQUEIDENTIFIER) AS [currency]
        , CAST(JSON_VALUE(data, N'$.AO') AS UNIQUEIDENTIFIER) AS [AO]
        , CAST(JSON_VALUE(data, N'$.Supplier') AS UNIQUEIDENTIFIER) AS [Supplier]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountInBalance]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountInBalance.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountInBalance.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountInAccounting]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountInAccounting.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountInAccounting.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountToPay]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountToPay.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountToPay.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountIsPaid]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountIsPaid.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountIsPaid.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.AP'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , CAST(JSON_VALUE(data, N'$.currency') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.AO') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Supplier') AS UNIQUEIDENTIFIER)
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.AP.TO] ON [dbo].[Register.Accumulation.AP.TO] (
          [date]
        , [company]
        , [currency]
        , [AO]
        , [Supplier]
      )
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.AP.TO] TO jetti;
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.AR.TO] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , CAST(JSON_VALUE(data, N'$.currency') AS UNIQUEIDENTIFIER) AS [currency]
        , CAST(JSON_VALUE(data, N'$.AO') AS UNIQUEIDENTIFIER) AS [AO]
        , CAST(JSON_VALUE(data, N'$.Customer') AS UNIQUEIDENTIFIER) AS [Customer]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AR') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AR]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AR') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AR.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AR') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AR.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountInBalance]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountInBalance.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountInBalance.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountInAccounting]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountInAccounting.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountInAccounting.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountToPay]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountToPay.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountToPay.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountIsPaid]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountIsPaid.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountIsPaid.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.AR'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , CAST(JSON_VALUE(data, N'$.currency') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.AO') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Customer') AS UNIQUEIDENTIFIER)
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.AR.TO] ON [dbo].[Register.Accumulation.AR.TO] (
          [date]
        , [company]
        , [currency]
        , [AO]
        , [Customer]
      )
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.AR.TO] TO jetti;
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Bank.TO] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , CAST(JSON_VALUE(data, N'$.currency') AS UNIQUEIDENTIFIER) AS [currency]
        , CAST(JSON_VALUE(data, N'$.BankAccount') AS UNIQUEIDENTIFIER) AS [BankAccount]
        , CAST(JSON_VALUE(data, N'$.CashFlow') AS UNIQUEIDENTIFIER) AS [CashFlow]
        , CAST(JSON_VALUE(data, N'$.Analytics') AS UNIQUEIDENTIFIER) AS [Analytics]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountInBalance]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountInBalance.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountInBalance.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountInAccounting]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountInAccounting.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountInAccounting.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.Bank'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , CAST(JSON_VALUE(data, N'$.currency') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.BankAccount') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.CashFlow') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Analytics') AS UNIQUEIDENTIFIER)
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Bank.TO] ON [dbo].[Register.Accumulation.Bank.TO] (
          [date]
        , [company]
        , [currency]
        , [BankAccount]
        , [CashFlow]
        , [Analytics]
      )
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.Bank.TO] TO jetti;
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Balance.TO] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , CAST(JSON_VALUE(data, N'$.Balance') AS UNIQUEIDENTIFIER) AS [Balance]
        , CAST(JSON_VALUE(data, N'$.Analytics') AS UNIQUEIDENTIFIER) AS [Analytics]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.Balance'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , CAST(JSON_VALUE(data, N'$.Balance') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Analytics') AS UNIQUEIDENTIFIER)
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Balance.TO] ON [dbo].[Register.Accumulation.Balance.TO] (
          [date]
        , [company]
        , [Balance]
        , [Analytics]
      )
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.Balance.TO] TO jetti;
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Balance.RC.TO] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , CAST(JSON_VALUE(data, N'$.ResponsibilityCenter') AS UNIQUEIDENTIFIER) AS [ResponsibilityCenter]
        , CAST(JSON_VALUE(data, N'$.Department') AS UNIQUEIDENTIFIER) AS [Department]
        , CAST(JSON_VALUE(data, N'$.Balance') AS UNIQUEIDENTIFIER) AS [Balance]
        , CAST(JSON_VALUE(data, N'$.Analytics') AS UNIQUEIDENTIFIER) AS [Analytics]
        , CAST(JSON_VALUE(data, N'$.Analytics2') AS UNIQUEIDENTIFIER) AS [Analytics2]
        , CAST(JSON_VALUE(data, N'$.Currency') AS UNIQUEIDENTIFIER) AS [Currency]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountRC') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountRC]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountRC') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountRC.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountRC') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountRC.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.Balance.RC'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , CAST(JSON_VALUE(data, N'$.ResponsibilityCenter') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Department') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Balance') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Analytics') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Analytics2') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Currency') AS UNIQUEIDENTIFIER)
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Balance.RC.TO] ON [dbo].[Register.Accumulation.Balance.RC.TO] (
          [date]
        , [company]
        , [ResponsibilityCenter]
        , [Department]
        , [Balance]
        , [Analytics]
        , [Analytics2]
        , [Currency]
      )
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.Balance.RC.TO] TO jetti;
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Balance.Report.TO] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , CAST(JSON_VALUE(data, N'$.currency') AS UNIQUEIDENTIFIER) AS [currency]
        , CAST(JSON_VALUE(data, N'$.Balance') AS UNIQUEIDENTIFIER) AS [Balance]
        , CAST(JSON_VALUE(data, N'$.Analytics') AS UNIQUEIDENTIFIER) AS [Analytics]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountInBalance]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountInBalance.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountInBalance.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountInAccounting]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountInAccounting.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountInAccounting.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.Balance.Report'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , CAST(JSON_VALUE(data, N'$.currency') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Balance') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Analytics') AS UNIQUEIDENTIFIER)
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Balance.Report.TO] ON [dbo].[Register.Accumulation.Balance.Report.TO] (
          [date]
        , [company]
        , [currency]
        , [Balance]
        , [Analytics]
      )
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.Balance.Report.TO] TO jetti;
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Cash.TO] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , CAST(JSON_VALUE(data, N'$.currency') AS UNIQUEIDENTIFIER) AS [currency]
        , CAST(JSON_VALUE(data, N'$.CashRegister') AS UNIQUEIDENTIFIER) AS [CashRegister]
        , CAST(JSON_VALUE(data, N'$.CashFlow') AS UNIQUEIDENTIFIER) AS [CashFlow]
        , CAST(JSON_VALUE(data, N'$.Analytics') AS UNIQUEIDENTIFIER) AS [Analytics]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountInBalance]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountInBalance.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountInBalance.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountInAccounting]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountInAccounting.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountInAccounting.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.Cash'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , CAST(JSON_VALUE(data, N'$.currency') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.CashRegister') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.CashFlow') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Analytics') AS UNIQUEIDENTIFIER)
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Cash.TO] ON [dbo].[Register.Accumulation.Cash.TO] (
          [date]
        , [company]
        , [currency]
        , [CashRegister]
        , [CashFlow]
        , [Analytics]
      )
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.Cash.TO] TO jetti;
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Cash.Transit.TO] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , CAST(JSON_VALUE(data, N'$.CompanyRecipient') AS UNIQUEIDENTIFIER) AS [CompanyRecipient]
        , CAST(JSON_VALUE(data, N'$.currency') AS UNIQUEIDENTIFIER) AS [currency]
        , CAST(JSON_VALUE(data, N'$.Sender') AS UNIQUEIDENTIFIER) AS [Sender]
        , CAST(JSON_VALUE(data, N'$.Recipient') AS UNIQUEIDENTIFIER) AS [Recipient]
        , CAST(JSON_VALUE(data, N'$.CashFlow') AS UNIQUEIDENTIFIER) AS [CashFlow]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountInBalance]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountInBalance.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountInBalance.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountInAccounting]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountInAccounting.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountInAccounting.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.Cash.Transit'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , CAST(JSON_VALUE(data, N'$.CompanyRecipient') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.currency') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Sender') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Recipient') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.CashFlow') AS UNIQUEIDENTIFIER)
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Cash.Transit.TO] ON [dbo].[Register.Accumulation.Cash.Transit.TO] (
          [date]
        , [company]
        , [CompanyRecipient]
        , [currency]
        , [Sender]
        , [Recipient]
        , [CashFlow]
      )
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.Cash.Transit.TO] TO jetti;
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Inventory.TO] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , CAST(JSON_VALUE(data, N'$.Storehouse') AS UNIQUEIDENTIFIER) AS [Storehouse]
        , CAST(JSON_VALUE(data, N'$.SKU') AS UNIQUEIDENTIFIER) AS [SKU]
        , CAST(JSON_VALUE(data, N'$.batch') AS UNIQUEIDENTIFIER) AS [batch]
        , CAST(JSON_VALUE(data, N'$.Department') AS UNIQUEIDENTIFIER) AS [Department]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Cost') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [Cost]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Cost') AS MONEY) * IIF(kind = 1, 1, null), 0)) [Cost.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Cost') AS MONEY) * IIF(kind = 1, null, 1), 0)) [Cost.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [Qty]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, 1, null), 0)) [Qty.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, null, 1), 0)) [Qty.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.Inventory'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , CAST(JSON_VALUE(data, N'$.Storehouse') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.SKU') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.batch') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Department') AS UNIQUEIDENTIFIER)
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Inventory.TO] ON [dbo].[Register.Accumulation.Inventory.TO] (
          [date]
        , [company]
        , [Storehouse]
        , [SKU]
        , [batch]
        , [Department]
      )
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.Inventory.TO] TO jetti;
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Loan.TO] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , CAST(JSON_VALUE(data, N'$.Loan') AS UNIQUEIDENTIFIER) AS [Loan]
        , CAST(JSON_VALUE(data, N'$.Counterpartie') AS UNIQUEIDENTIFIER) AS [Counterpartie]
        , CAST(JSON_VALUE(data, N'$.CashFlow') AS UNIQUEIDENTIFIER) AS [CashFlow]
        , CAST(JSON_VALUE(data, N'$.currency') AS UNIQUEIDENTIFIER) AS [currency]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountInBalance]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountInBalance.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountInBalance.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountInAccounting]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountInAccounting.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountInAccounting.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountToPay]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountToPay.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountToPay') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountToPay.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountIsPaid]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountIsPaid.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountIsPaid') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountIsPaid.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.Loan'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , CAST(JSON_VALUE(data, N'$.Loan') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Counterpartie') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.CashFlow') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.currency') AS UNIQUEIDENTIFIER)
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Loan.TO] ON [dbo].[Register.Accumulation.Loan.TO] (
          [date]
        , [company]
        , [Loan]
        , [Counterpartie]
        , [CashFlow]
        , [currency]
      )
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.Loan.TO] TO jetti;
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.PL.TO] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , CAST(JSON_VALUE(data, N'$.Department') AS UNIQUEIDENTIFIER) AS [Department]
        , CAST(JSON_VALUE(data, N'$.PL') AS UNIQUEIDENTIFIER) AS [PL]
        , CAST(JSON_VALUE(data, N'$.Analytics') AS UNIQUEIDENTIFIER) AS [Analytics]
        , CAST(JSON_VALUE(data, N'$.Analytics2') AS UNIQUEIDENTIFIER) AS [Analytics2]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.PL'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , CAST(JSON_VALUE(data, N'$.Department') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.PL') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Analytics') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Analytics2') AS UNIQUEIDENTIFIER)
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.PL.TO] ON [dbo].[Register.Accumulation.PL.TO] (
          [date]
        , [company]
        , [Department]
        , [PL]
        , [Analytics]
        , [Analytics2]
      )
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.PL.TO] TO jetti;
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.PL.RC.TO] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , CAST(JSON_VALUE(data, N'$.ResponsibilityCenter') AS UNIQUEIDENTIFIER) AS [ResponsibilityCenter]
        , CAST(JSON_VALUE(data, N'$.Department') AS UNIQUEIDENTIFIER) AS [Department]
        , CAST(JSON_VALUE(data, N'$.PL') AS UNIQUEIDENTIFIER) AS [PL]
        , CAST(JSON_VALUE(data, N'$.Analytics') AS UNIQUEIDENTIFIER) AS [Analytics]
        , CAST(JSON_VALUE(data, N'$.Analytics2') AS UNIQUEIDENTIFIER) AS [Analytics2]
        , CAST(JSON_VALUE(data, N'$.Currency') AS UNIQUEIDENTIFIER) AS [Currency]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountRC') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountRC]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountRC') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountRC.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountRC') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountRC.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.PL.RC'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , CAST(JSON_VALUE(data, N'$.ResponsibilityCenter') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Department') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.PL') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Analytics') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Analytics2') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Currency') AS UNIQUEIDENTIFIER)
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.PL.RC.TO] ON [dbo].[Register.Accumulation.PL.RC.TO] (
          [date]
        , [company]
        , [ResponsibilityCenter]
        , [Department]
        , [PL]
        , [Analytics]
        , [Analytics2]
        , [Currency]
      )
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.PL.RC.TO] TO jetti;
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Sales.TO] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , CAST(JSON_VALUE(data, N'$.currency') AS UNIQUEIDENTIFIER) AS [currency]
        , CAST(JSON_VALUE(data, N'$.Department') AS UNIQUEIDENTIFIER) AS [Department]
        , CAST(JSON_VALUE(data, N'$.Customer') AS UNIQUEIDENTIFIER) AS [Customer]
        , CAST(JSON_VALUE(data, N'$.Product') AS UNIQUEIDENTIFIER) AS [Product]
        , CAST(JSON_VALUE(data, N'$.Analytic') AS UNIQUEIDENTIFIER) AS [Analytic]
        , CAST(JSON_VALUE(data, N'$.Manager') AS UNIQUEIDENTIFIER) AS [Manager]
        , CAST(JSON_VALUE(data, N'$.Storehouse') AS UNIQUEIDENTIFIER) AS [Storehouse]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Cost') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [Cost]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Cost') AS MONEY) * IIF(kind = 1, 1, null), 0)) [Cost.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Cost') AS MONEY) * IIF(kind = 1, null, 1), 0)) [Cost.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [Qty]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, 1, null), 0)) [Qty.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, null, 1), 0)) [Qty.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Discount') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [Discount]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Discount') AS MONEY) * IIF(kind = 1, 1, null), 0)) [Discount.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Discount') AS MONEY) * IIF(kind = 1, null, 1), 0)) [Discount.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Tax') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [Tax]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Tax') AS MONEY) * IIF(kind = 1, 1, null), 0)) [Tax.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Tax') AS MONEY) * IIF(kind = 1, null, 1), 0)) [Tax.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInDoc') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountInDoc]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInDoc') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountInDoc.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInDoc') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountInDoc.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAR') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountInAR]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAR') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountInAR.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAR') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountInAR.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.Sales'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , CAST(JSON_VALUE(data, N'$.currency') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Department') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Customer') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Product') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Analytic') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Manager') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Storehouse') AS UNIQUEIDENTIFIER)
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Sales.TO] ON [dbo].[Register.Accumulation.Sales.TO] (
          [date]
        , [company]
        , [currency]
        , [Department]
        , [Customer]
        , [Product]
        , [Analytic]
        , [Manager]
        , [Storehouse]
      )
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.Sales.TO] TO jetti;
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Salary.TO] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , CAST(JSON_VALUE(data, N'$.currency') AS UNIQUEIDENTIFIER) AS [currency]
        , CAST(JSON_VALUE(data, N'$.KorrCompany') AS UNIQUEIDENTIFIER) AS [KorrCompany]
        , CAST(JSON_VALUE(data, N'$.Person') AS UNIQUEIDENTIFIER) AS [Person]
        , CAST(JSON_VALUE(data, N'$.Employee') AS UNIQUEIDENTIFIER) AS [Employee]
        , CAST(JSON_VALUE(data, N'$.Analytics') AS UNIQUEIDENTIFIER) AS [Analytics]
        , CAST(JSON_VALUE(data, N'$.PL') AS UNIQUEIDENTIFIER) AS [PL]
        , CAST(JSON_VALUE(data, N'$.PLAnalytics') AS UNIQUEIDENTIFIER) AS [PLAnalytics]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountInBalance]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountInBalance.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountInBalance.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountInAccounting]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountInAccounting.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountInAccounting.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.Salary'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , CAST(JSON_VALUE(data, N'$.currency') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.KorrCompany') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Person') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Employee') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Analytics') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.PL') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.PLAnalytics') AS UNIQUEIDENTIFIER)
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Salary.TO] ON [dbo].[Register.Accumulation.Salary.TO] (
          [date]
        , [company]
        , [currency]
        , [KorrCompany]
        , [Person]
        , [Employee]
        , [Analytics]
        , [PL]
        , [PLAnalytics]
      )
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.Salary.TO] TO jetti;
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Depreciation.TO] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , CAST(JSON_VALUE(data, N'$.OperationType') AS UNIQUEIDENTIFIER) AS [OperationType]
        , CAST(JSON_VALUE(data, N'$.currency') AS UNIQUEIDENTIFIER) AS [currency]
        , CAST(JSON_VALUE(data, N'$.Department') AS UNIQUEIDENTIFIER) AS [Department]
        , CAST(JSON_VALUE(data, N'$.ResponsiblePerson') AS UNIQUEIDENTIFIER) AS [ResponsiblePerson]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountInBalance]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountInBalance.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountInBalance.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountInAccounting]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountInAccounting.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountInAccounting.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.Depreciation'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , CAST(JSON_VALUE(data, N'$.OperationType') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.currency') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Department') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.ResponsiblePerson') AS UNIQUEIDENTIFIER)
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Depreciation.TO] ON [dbo].[Register.Accumulation.Depreciation.TO] (
          [date]
        , [company]
        , [OperationType]
        , [currency]
        , [Department]
        , [ResponsiblePerson]
      )
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.Depreciation.TO] TO jetti;
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.CashToPay.TO] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , CAST(JSON_VALUE(data, N'$.currency') AS UNIQUEIDENTIFIER) AS [currency]
        , CAST(JSON_VALUE(data, N'$.CashFlow') AS UNIQUEIDENTIFIER) AS [CashFlow]
        , CAST(JSON_VALUE(data, N'$.CashRequest') AS UNIQUEIDENTIFIER) AS [CashRequest]
        , CAST(JSON_VALUE(data, N'$.Contract') AS UNIQUEIDENTIFIER) AS [Contract]
        , CAST(JSON_VALUE(data, N'$.BankAccountPerson') AS UNIQUEIDENTIFIER) AS [BankAccountPerson]
        , CAST(JSON_VALUE(data, N'$.Department') AS UNIQUEIDENTIFIER) AS [Department]
        , CAST(JSON_VALUE(data, N'$.OperationType') AS NVARCHAR(250)) AS [OperationType]
        , CAST(JSON_VALUE(data, N'$.Loan') AS UNIQUEIDENTIFIER) AS [Loan]
        , CAST(JSON_VALUE(data, N'$.CashOrBank') AS UNIQUEIDENTIFIER) AS [CashOrBank]
        , CAST(JSON_VALUE(data, N'$.CashRecipient') AS UNIQUEIDENTIFIER) AS [CashRecipient]
        , CAST(JSON_VALUE(data, N'$.ExpenseOrBalance') AS UNIQUEIDENTIFIER) AS [ExpenseOrBalance]
        , CAST(JSON_VALUE(data, N'$.ExpenseAnalytics') AS UNIQUEIDENTIFIER) AS [ExpenseAnalytics]
        , CAST(JSON_VALUE(data, N'$.BalanceAnalytics') AS UNIQUEIDENTIFIER) AS [BalanceAnalytics]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.CashToPay'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , CAST(JSON_VALUE(data, N'$.currency') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.CashFlow') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.CashRequest') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Contract') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.BankAccountPerson') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Department') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.OperationType') AS NVARCHAR(250))
        , CAST(JSON_VALUE(data, N'$.Loan') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.CashOrBank') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.CashRecipient') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.ExpenseOrBalance') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.ExpenseAnalytics') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.BalanceAnalytics') AS UNIQUEIDENTIFIER)
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.CashToPay.TO] ON [dbo].[Register.Accumulation.CashToPay.TO] (
          [date]
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
      )
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.CashToPay.TO] TO jetti;
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.BudgetItemTurnover.TO] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , CAST(JSON_VALUE(data, N'$.Department') AS UNIQUEIDENTIFIER) AS [Department]
        , CAST(JSON_VALUE(data, N'$.Scenario') AS UNIQUEIDENTIFIER) AS [Scenario]
        , CAST(JSON_VALUE(data, N'$.BudgetItem') AS UNIQUEIDENTIFIER) AS [BudgetItem]
        , CAST(JSON_VALUE(data, N'$.currency') AS UNIQUEIDENTIFIER) AS [currency]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInScenatio') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountInScenatio]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInScenatio') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountInScenatio.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInScenatio') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountInScenatio.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInCurrency') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountInCurrency]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInCurrency') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountInCurrency.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInCurrency') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountInCurrency.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountInAccounting]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountInAccounting.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountInAccounting.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [Qty]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, 1, null), 0)) [Qty.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, null, 1), 0)) [Qty.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.BudgetItemTurnover'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , CAST(JSON_VALUE(data, N'$.Department') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Scenario') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.BudgetItem') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.currency') AS UNIQUEIDENTIFIER)
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.BudgetItemTurnover.TO] ON [dbo].[Register.Accumulation.BudgetItemTurnover.TO] (
          [date]
        , [company]
        , [Department]
        , [Scenario]
        , [BudgetItem]
        , [currency]
      )
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.BudgetItemTurnover.TO] TO jetti;
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Intercompany.TO] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , CAST(JSON_VALUE(data, N'$.Intercompany') AS UNIQUEIDENTIFIER) AS [Intercompany]
        , CAST(JSON_VALUE(data, N'$.LegalCompanySender') AS UNIQUEIDENTIFIER) AS [LegalCompanySender]
        , CAST(JSON_VALUE(data, N'$.LegalCompanyRecipient') AS UNIQUEIDENTIFIER) AS [LegalCompanyRecipient]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountInBalance]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountInBalance.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountInBalance.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountInAccounting]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountInAccounting.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountInAccounting.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.Intercompany'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , CAST(JSON_VALUE(data, N'$.Intercompany') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.LegalCompanySender') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.LegalCompanyRecipient') AS UNIQUEIDENTIFIER)
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Intercompany.TO] ON [dbo].[Register.Accumulation.Intercompany.TO] (
          [date]
        , [company]
        , [Intercompany]
        , [LegalCompanySender]
        , [LegalCompanyRecipient]
      )
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.Intercompany.TO] TO jetti;
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Acquiring.TO] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , CAST(JSON_VALUE(data, N'$.AcquiringTerminal') AS UNIQUEIDENTIFIER) AS [AcquiringTerminal]
        , CAST(JSON_VALUE(data, N'$.OperationType') AS UNIQUEIDENTIFIER) AS [OperationType]
        , CAST(JSON_VALUE(data, N'$.Department') AS UNIQUEIDENTIFIER) AS [Department]
        , CAST(JSON_VALUE(data, N'$.CashFlow') AS UNIQUEIDENTIFIER) AS [CashFlow]
        , CAST(JSON_VALUE(data, N'$.currency') AS UNIQUEIDENTIFIER) AS [currency]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountInBalance]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountInBalance.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountInBalance.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountOperation') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountOperation]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountOperation') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountOperation.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountOperation') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountOperation.Out]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountPaid') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [AmountPaid]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountPaid') AS MONEY) * IIF(kind = 1, 1, null), 0)) [AmountPaid.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.AmountPaid') AS MONEY) * IIF(kind = 1, null, 1), 0)) [AmountPaid.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.Acquiring'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , CAST(JSON_VALUE(data, N'$.AcquiringTerminal') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.OperationType') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Department') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.CashFlow') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.currency') AS UNIQUEIDENTIFIER)
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Acquiring.TO] ON [dbo].[Register.Accumulation.Acquiring.TO] (
          [date]
        , [company]
        , [AcquiringTerminal]
        , [OperationType]
        , [Department]
        , [CashFlow]
        , [currency]
      )
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.Acquiring.TO] TO jetti;
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.StaffingTable.TO] WITH SCHEMABINDING AS
      SELECT
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE)) [date]
        , [company]
        , CAST(JSON_VALUE(data, N'$.Department') AS UNIQUEIDENTIFIER) AS [Department]
        , CAST(JSON_VALUE(data, N'$.DepartmentCompany') AS UNIQUEIDENTIFIER) AS [DepartmentCompany]
        , CAST(JSON_VALUE(data, N'$.StaffingTablePosition') AS UNIQUEIDENTIFIER) AS [StaffingTablePosition]
        , CAST(JSON_VALUE(data, N'$.Employee') AS UNIQUEIDENTIFIER) AS [Employee]
        , CAST(JSON_VALUE(data, N'$.Person') AS UNIQUEIDENTIFIER) AS [Person]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.SalaryRate') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [SalaryRate]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.SalaryRate') AS MONEY) * IIF(kind = 1, 1, null), 0)) [SalaryRate.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.SalaryRate') AS MONEY) * IIF(kind = 1, null, 1), 0)) [SalaryRate.Out]
        , CAST(JSON_VALUE(data, N'$.SalaryAnalytic') AS UNIQUEIDENTIFIER) AS [SalaryAnalytic]
        , CAST(JSON_VALUE(data, N'$.currency') AS UNIQUEIDENTIFIER) AS [currency]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1), 0)) [Amount]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, null), 0)) [Amount.In]
        , SUM(ISNULL(CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, null, 1), 0)) [Amount.Out]
        , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Accumulation] WHERE [type] = N'Register.Accumulation.StaffingTable'
      GROUP BY
          DATEADD(DAY, 1, CAST(EOMONTH([date], -1) AS DATE))
        , [company]
        , CAST(JSON_VALUE(data, N'$.Department') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.DepartmentCompany') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.StaffingTablePosition') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Employee') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.Person') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.SalaryAnalytic') AS UNIQUEIDENTIFIER)
        , CAST(JSON_VALUE(data, N'$.currency') AS UNIQUEIDENTIFIER)
      GO
      CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.StaffingTable.TO] ON [dbo].[Register.Accumulation.StaffingTable.TO] (
          [date]
        , [company]
        , [Department]
        , [DepartmentCompany]
        , [StaffingTablePosition]
        , [Employee]
        , [Person]
        , [SalaryAnalytic]
        , [currency]
      )
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.StaffingTable.TO] TO jetti;
      GO