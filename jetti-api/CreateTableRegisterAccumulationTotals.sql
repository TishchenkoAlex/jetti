

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.AccountablePersons.Totals]
      WITH SCHEMABINDING
      AS
        SELECT [company], [date], [currency], [Employee], [CashFlow]
        
        , SUM([Amount]) [Amount]
        , SUM([Amount.In]) [Amount.In]
        , SUM([Amount.Out]) [Amount.Out]
        , SUM([AmountInBalance]) [AmountInBalance]
        , SUM([AmountInBalance.In]) [AmountInBalance.In]
        , SUM([AmountInBalance.Out]) [AmountInBalance.Out]
        , SUM([AmountInAccounting]) [AmountInAccounting]
        , SUM([AmountInAccounting.In]) [AmountInAccounting.In]
        , SUM([AmountInAccounting.Out]) [AmountInAccounting.Out]
	      , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.AccountablePersons]
      GROUP BY [company], [date], [currency], [Employee], [CashFlow]
      GO
      CREATE UNIQUE CLUSTERED INDEX [ciRegister.Accumulation.AccountablePersons.Totals] ON [dbo].[Register.Accumulation.AccountablePersons.Totals]
      ([company], [date] , [currency], [Employee], [CashFlow])
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.AP.Totals]
      WITH SCHEMABINDING
      AS
        SELECT [company], [date], [currency], [Supplier]
        
        , SUM([Amount]) [Amount]
        , SUM([Amount.In]) [Amount.In]
        , SUM([Amount.Out]) [Amount.Out]
        , SUM([AmountInBalance]) [AmountInBalance]
        , SUM([AmountInBalance.In]) [AmountInBalance.In]
        , SUM([AmountInBalance.Out]) [AmountInBalance.Out]
        , SUM([AmountInAccounting]) [AmountInAccounting]
        , SUM([AmountInAccounting.In]) [AmountInAccounting.In]
        , SUM([AmountInAccounting.Out]) [AmountInAccounting.Out]
	      , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.AP]
      GROUP BY [company], [date], [currency], [Supplier]
      GO
      CREATE UNIQUE CLUSTERED INDEX [ciRegister.Accumulation.AP.Totals] ON [dbo].[Register.Accumulation.AP.Totals]
      ([company], [date] , [currency], [Supplier])
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.AR.Totals]
      WITH SCHEMABINDING
      AS
        SELECT [company], [date], [currency], [Customer]
        
        , SUM([AmountInBalance]) [AmountInBalance]
        , SUM([AmountInBalance.In]) [AmountInBalance.In]
        , SUM([AmountInBalance.Out]) [AmountInBalance.Out]
        , SUM([AmountInAccounting]) [AmountInAccounting]
        , SUM([AmountInAccounting.In]) [AmountInAccounting.In]
        , SUM([AmountInAccounting.Out]) [AmountInAccounting.Out]
	      , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.AR]
      GROUP BY [company], [date], [currency], [Customer]
      GO
      CREATE UNIQUE CLUSTERED INDEX [ciRegister.Accumulation.AR.Totals] ON [dbo].[Register.Accumulation.AR.Totals]
      ([company], [date] , [currency], [Customer])
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Bank.Totals]
      WITH SCHEMABINDING
      AS
        SELECT [company], [date], [currency], [BankAccount], [CashFlow], [Analytics]
        
        , SUM([Amount]) [Amount]
        , SUM([Amount.In]) [Amount.In]
        , SUM([Amount.Out]) [Amount.Out]
        , SUM([AmountInBalance]) [AmountInBalance]
        , SUM([AmountInBalance.In]) [AmountInBalance.In]
        , SUM([AmountInBalance.Out]) [AmountInBalance.Out]
        , SUM([AmountInAccounting]) [AmountInAccounting]
        , SUM([AmountInAccounting.In]) [AmountInAccounting.In]
        , SUM([AmountInAccounting.Out]) [AmountInAccounting.Out]
	      , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.Bank]
      GROUP BY [company], [date], [currency], [BankAccount], [CashFlow], [Analytics]
      GO
      CREATE UNIQUE CLUSTERED INDEX [ciRegister.Accumulation.Bank.Totals] ON [dbo].[Register.Accumulation.Bank.Totals]
      ([company], [date] , [currency], [BankAccount], [CashFlow], [Analytics])
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Balance.Totals]
      WITH SCHEMABINDING
      AS
        SELECT [company], [date], [Balance], [Analytics]
        
        , SUM([Amount]) [Amount]
        , SUM([Amount.In]) [Amount.In]
        , SUM([Amount.Out]) [Amount.Out]
	      , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.Balance]
      GROUP BY [company], [date], [Balance], [Analytics]
      GO
      CREATE UNIQUE CLUSTERED INDEX [ciRegister.Accumulation.Balance.Totals] ON [dbo].[Register.Accumulation.Balance.Totals]
      ([company], [date] , [Balance], [Analytics])
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Cash.Totals]
      WITH SCHEMABINDING
      AS
        SELECT [company], [date], [currency], [CashRegister], [CashFlow], [Analytics]
        
        , SUM([Amount]) [Amount]
        , SUM([Amount.In]) [Amount.In]
        , SUM([Amount.Out]) [Amount.Out]
        , SUM([AmountInBalance]) [AmountInBalance]
        , SUM([AmountInBalance.In]) [AmountInBalance.In]
        , SUM([AmountInBalance.Out]) [AmountInBalance.Out]
        , SUM([AmountInAccounting]) [AmountInAccounting]
        , SUM([AmountInAccounting.In]) [AmountInAccounting.In]
        , SUM([AmountInAccounting.Out]) [AmountInAccounting.Out]
	      , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.Cash]
      GROUP BY [company], [date], [currency], [CashRegister], [CashFlow], [Analytics]
      GO
      CREATE UNIQUE CLUSTERED INDEX [ciRegister.Accumulation.Cash.Totals] ON [dbo].[Register.Accumulation.Cash.Totals]
      ([company], [date] , [currency], [CashRegister], [CashFlow], [Analytics])
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Cash.Transit.Totals]
      WITH SCHEMABINDING
      AS
        SELECT [company], [date], [currency], [Sender], [Recipient], [CashFlow]
        
        , SUM([Amount]) [Amount]
        , SUM([Amount.In]) [Amount.In]
        , SUM([Amount.Out]) [Amount.Out]
        , SUM([AmountInBalance]) [AmountInBalance]
        , SUM([AmountInBalance.In]) [AmountInBalance.In]
        , SUM([AmountInBalance.Out]) [AmountInBalance.Out]
        , SUM([AmountInAccounting]) [AmountInAccounting]
        , SUM([AmountInAccounting.In]) [AmountInAccounting.In]
        , SUM([AmountInAccounting.Out]) [AmountInAccounting.Out]
	      , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.Cash.Transit]
      GROUP BY [company], [date], [currency], [Sender], [Recipient], [CashFlow]
      GO
      CREATE UNIQUE CLUSTERED INDEX [ciRegister.Accumulation.Cash.Transit.Totals] ON [dbo].[Register.Accumulation.Cash.Transit.Totals]
      ([company], [date] , [currency], [Sender], [Recipient], [CashFlow])
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Inventory.Totals]
      WITH SCHEMABINDING
      AS
        SELECT [company], [date], [Storehouse], [SKU], [batch]
        
        , SUM([Cost]) [Cost]
        , SUM([Cost.In]) [Cost.In]
        , SUM([Cost.Out]) [Cost.Out]
        , SUM([Qty]) [Qty]
        , SUM([Qty.In]) [Qty.In]
        , SUM([Qty.Out]) [Qty.Out]
	      , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.Inventory]
      GROUP BY [company], [date], [Storehouse], [SKU], [batch]
      GO
      CREATE UNIQUE CLUSTERED INDEX [ciRegister.Accumulation.Inventory.Totals] ON [dbo].[Register.Accumulation.Inventory.Totals]
      ([company], [date] , [Storehouse], [SKU], [batch])
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Loan.Totals]
      WITH SCHEMABINDING
      AS
        SELECT [company], [date], [Loan], [Counterpartie], [CashFlow]
        
        , SUM([Amount]) [Amount]
        , SUM([Amount.In]) [Amount.In]
        , SUM([Amount.Out]) [Amount.Out]
        , SUM([AmountInBalance]) [AmountInBalance]
        , SUM([AmountInBalance.In]) [AmountInBalance.In]
        , SUM([AmountInBalance.Out]) [AmountInBalance.Out]
        , SUM([AmountInAccounting]) [AmountInAccounting]
        , SUM([AmountInAccounting.In]) [AmountInAccounting.In]
        , SUM([AmountInAccounting.Out]) [AmountInAccounting.Out]
	      , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.Loan]
      GROUP BY [company], [date], [Loan], [Counterpartie], [CashFlow]
      GO
      CREATE UNIQUE CLUSTERED INDEX [ciRegister.Accumulation.Loan.Totals] ON [dbo].[Register.Accumulation.Loan.Totals]
      ([company], [date] , [Loan], [Counterpartie], [CashFlow])
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.PL.Totals]
      WITH SCHEMABINDING
      AS
        SELECT [company], [date], [Department], [PL], [Analytics]
        
        , SUM([Amount]) [Amount]
        , SUM([Amount.In]) [Amount.In]
        , SUM([Amount.Out]) [Amount.Out]
	      , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.PL]
      GROUP BY [company], [date], [Department], [PL], [Analytics]
      GO
      CREATE UNIQUE CLUSTERED INDEX [ciRegister.Accumulation.PL.Totals] ON [dbo].[Register.Accumulation.PL.Totals]
      ([company], [date] , [Department], [PL], [Analytics])
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Sales.Totals]
      WITH SCHEMABINDING
      AS
        SELECT [company], [date], [currency], [Department], [Customer], [Product], [Manager], [Storehouse]
        
        , SUM([Cost]) [Cost]
        , SUM([Cost.In]) [Cost.In]
        , SUM([Cost.Out]) [Cost.Out]
        , SUM([Qty]) [Qty]
        , SUM([Qty.In]) [Qty.In]
        , SUM([Qty.Out]) [Qty.Out]
        , SUM([Amount]) [Amount]
        , SUM([Amount.In]) [Amount.In]
        , SUM([Amount.Out]) [Amount.Out]
        , SUM([Discount]) [Discount]
        , SUM([Discount.In]) [Discount.In]
        , SUM([Discount.Out]) [Discount.Out]
        , SUM([Tax]) [Tax]
        , SUM([Tax.In]) [Tax.In]
        , SUM([Tax.Out]) [Tax.Out]
        , SUM([AmountInDoc]) [AmountInDoc]
        , SUM([AmountInDoc.In]) [AmountInDoc.In]
        , SUM([AmountInDoc.Out]) [AmountInDoc.Out]
        , SUM([AmountInAR]) [AmountInAR]
        , SUM([AmountInAR.In]) [AmountInAR.In]
        , SUM([AmountInAR.Out]) [AmountInAR.Out]
	      , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.Sales]
      GROUP BY [company], [date], [currency], [Department], [Customer], [Product], [Manager], [Storehouse]
      GO
      CREATE UNIQUE CLUSTERED INDEX [ciRegister.Accumulation.Sales.Totals] ON [dbo].[Register.Accumulation.Sales.Totals]
      ([company], [date] , [currency], [Department], [Customer], [Product], [Manager], [Storehouse])
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Depreciation.Totals]
      WITH SCHEMABINDING
      AS
        SELECT [company], [date], [BusinessOperation], [currency], [Department]
        
        , SUM([Amount]) [Amount]
        , SUM([Amount.In]) [Amount.In]
        , SUM([Amount.Out]) [Amount.Out]
        , SUM([AmountInBalance]) [AmountInBalance]
        , SUM([AmountInBalance.In]) [AmountInBalance.In]
        , SUM([AmountInBalance.Out]) [AmountInBalance.Out]
        , SUM([AmountInAccounting]) [AmountInAccounting]
        , SUM([AmountInAccounting.In]) [AmountInAccounting.In]
        , SUM([AmountInAccounting.Out]) [AmountInAccounting.Out]
	      , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.Depreciation]
      GROUP BY [company], [date], [BusinessOperation], [currency], [Department]
      GO
      CREATE UNIQUE CLUSTERED INDEX [ciRegister.Accumulation.Depreciation.Totals] ON [dbo].[Register.Accumulation.Depreciation.Totals]
      ([company], [date] , [BusinessOperation], [currency], [Department])
      GO