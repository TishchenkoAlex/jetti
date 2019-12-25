

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
        , SUM([AmountToPay]) [AmountToPay]
        , SUM([AmountToPay.In]) [AmountToPay.In]
        , SUM([AmountToPay.Out]) [AmountToPay.Out]
        , SUM([AmountIsPaid]) [AmountIsPaid]
        , SUM([AmountIsPaid.In]) [AmountIsPaid.In]
        , SUM([AmountIsPaid.Out]) [AmountIsPaid.Out]
	      , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.AccountablePersons]
      GROUP BY [company], [date], [currency], [Employee], [CashFlow]
      GO
      CREATE UNIQUE CLUSTERED INDEX [ciRegister.Accumulation.AccountablePersons.Totals] ON [dbo].[Register.Accumulation.AccountablePersons.Totals]
      ([company], [date] , [currency], [Employee], [CashFlow])
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.AccountablePersons.Totals] TO jetti;
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
        , SUM([AmountToPay]) [AmountToPay]
        , SUM([AmountToPay.In]) [AmountToPay.In]
        , SUM([AmountToPay.Out]) [AmountToPay.Out]
        , SUM([AmountIsPaid]) [AmountIsPaid]
        , SUM([AmountIsPaid.In]) [AmountIsPaid.In]
        , SUM([AmountIsPaid.Out]) [AmountIsPaid.Out]
	      , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.AP]
      GROUP BY [company], [date], [currency], [Supplier]
      GO
      CREATE UNIQUE CLUSTERED INDEX [ciRegister.Accumulation.AP.Totals] ON [dbo].[Register.Accumulation.AP.Totals]
      ([company], [date] , [currency], [Supplier])
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.AP.Totals] TO jetti;
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
        , SUM([AmountToPay]) [AmountToPay]
        , SUM([AmountToPay.In]) [AmountToPay.In]
        , SUM([AmountToPay.Out]) [AmountToPay.Out]
        , SUM([AmountIsPaid]) [AmountIsPaid]
        , SUM([AmountIsPaid.In]) [AmountIsPaid.In]
        , SUM([AmountIsPaid.Out]) [AmountIsPaid.Out]
	      , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.AR]
      GROUP BY [company], [date], [currency], [Customer]
      GO
      CREATE UNIQUE CLUSTERED INDEX [ciRegister.Accumulation.AR.Totals] ON [dbo].[Register.Accumulation.AR.Totals]
      ([company], [date] , [currency], [Customer])
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.AR.Totals] TO jetti;
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
      GRANT SELECT ON [dbo].[Register.Accumulation.Bank.Totals] TO jetti;
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
      GRANT SELECT ON [dbo].[Register.Accumulation.Balance.Totals] TO jetti;
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
      GRANT SELECT ON [dbo].[Register.Accumulation.Cash.Totals] TO jetti;
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
      GRANT SELECT ON [dbo].[Register.Accumulation.Cash.Transit.Totals] TO jetti;
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Inventory.Totals]
      WITH SCHEMABINDING
      AS
        SELECT [company], [date], [Storehouse], [SKU], [batch], [Department]
        
        , SUM([Cost]) [Cost]
        , SUM([Cost.In]) [Cost.In]
        , SUM([Cost.Out]) [Cost.Out]
        , SUM([Qty]) [Qty]
        , SUM([Qty.In]) [Qty.In]
        , SUM([Qty.Out]) [Qty.Out]
	      , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.Inventory]
      GROUP BY [company], [date], [Storehouse], [SKU], [batch], [Department]
      GO
      CREATE UNIQUE CLUSTERED INDEX [ciRegister.Accumulation.Inventory.Totals] ON [dbo].[Register.Accumulation.Inventory.Totals]
      ([company], [date] , [Storehouse], [SKU], [batch], [Department])
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.Inventory.Totals] TO jetti;
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Loan.Totals]
      WITH SCHEMABINDING
      AS
        SELECT [company], [date], [Loan], [Counterpartie], [CashFlow], [currency]
        
        , SUM([Amount]) [Amount]
        , SUM([Amount.In]) [Amount.In]
        , SUM([Amount.Out]) [Amount.Out]
        , SUM([AmountInBalance]) [AmountInBalance]
        , SUM([AmountInBalance.In]) [AmountInBalance.In]
        , SUM([AmountInBalance.Out]) [AmountInBalance.Out]
        , SUM([AmountInAccounting]) [AmountInAccounting]
        , SUM([AmountInAccounting.In]) [AmountInAccounting.In]
        , SUM([AmountInAccounting.Out]) [AmountInAccounting.Out]
        , SUM([AmountToPay]) [AmountToPay]
        , SUM([AmountToPay.In]) [AmountToPay.In]
        , SUM([AmountToPay.Out]) [AmountToPay.Out]
        , SUM([AmountIsPaid]) [AmountIsPaid]
        , SUM([AmountIsPaid.In]) [AmountIsPaid.In]
        , SUM([AmountIsPaid.Out]) [AmountIsPaid.Out]
	      , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.Loan]
      GROUP BY [company], [date], [Loan], [Counterpartie], [CashFlow], [currency]
      GO
      CREATE UNIQUE CLUSTERED INDEX [ciRegister.Accumulation.Loan.Totals] ON [dbo].[Register.Accumulation.Loan.Totals]
      ([company], [date] , [Loan], [Counterpartie], [CashFlow], [currency])
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.Loan.Totals] TO jetti;
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
      GRANT SELECT ON [dbo].[Register.Accumulation.PL.Totals] TO jetti;
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
      GRANT SELECT ON [dbo].[Register.Accumulation.Sales.Totals] TO jetti;
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
      GRANT SELECT ON [dbo].[Register.Accumulation.Depreciation.Totals] TO jetti;
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.CashToPay.Totals]
      WITH SCHEMABINDING
      AS
        SELECT [company], [date], [currency], [CashFlow], [CashRequest], [Contract], [Department], [OperationType], [Loan], [CashOrBank], [CashRecipient], [ExpenseOrBalance]
        
        , SUM([Amount]) [Amount]
        , SUM([Amount.In]) [Amount.In]
        , SUM([Amount.Out]) [Amount.Out]
	      , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.CashToPay]
      GROUP BY [company], [date], [currency], [CashFlow], [CashRequest], [Contract], [Department], [OperationType], [Loan], [CashOrBank], [CashRecipient], [ExpenseOrBalance]
      GO
      CREATE UNIQUE CLUSTERED INDEX [ciRegister.Accumulation.CashToPay.Totals] ON [dbo].[Register.Accumulation.CashToPay.Totals]
      ([company], [date] , [currency], [CashFlow], [CashRequest], [Contract], [Department], [OperationType], [Loan], [CashOrBank], [CashRecipient], [ExpenseOrBalance])
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.CashToPay.Totals] TO jetti;
      GO

      CREATE OR ALTER VIEW [dbo].[Register.Accumulation.BudgetItemTurnover.Totals]
      WITH SCHEMABINDING
      AS
        SELECT [company], [date], [Department], [Scenario], [BudgetItem], [currency]
        
        , SUM([Amount]) [Amount]
        , SUM([Amount.In]) [Amount.In]
        , SUM([Amount.Out]) [Amount.Out]
        , SUM([AmountInScenatio]) [AmountInScenatio]
        , SUM([AmountInScenatio.In]) [AmountInScenatio.In]
        , SUM([AmountInScenatio.Out]) [AmountInScenatio.Out]
        , SUM([AmountInCurrency]) [AmountInCurrency]
        , SUM([AmountInCurrency.In]) [AmountInCurrency.In]
        , SUM([AmountInCurrency.Out]) [AmountInCurrency.Out]
        , SUM([AmountInAccounting]) [AmountInAccounting]
        , SUM([AmountInAccounting.In]) [AmountInAccounting.In]
        , SUM([AmountInAccounting.Out]) [AmountInAccounting.Out]
        , SUM([Qty]) [Qty]
        , SUM([Qty.In]) [Qty.In]
        , SUM([Qty.Out]) [Qty.Out]
	      , COUNT_BIG(*) AS COUNT
      FROM [dbo].[Register.Accumulation.BudgetItemTurnover]
      GROUP BY [company], [date], [Department], [Scenario], [BudgetItem], [currency]
      GO
      CREATE UNIQUE CLUSTERED INDEX [ciRegister.Accumulation.BudgetItemTurnover.Totals] ON [dbo].[Register.Accumulation.BudgetItemTurnover.Totals]
      ([company], [date] , [Department], [Scenario], [BudgetItem], [currency])
      GO
      GRANT SELECT ON [dbo].[Register.Accumulation.BudgetItemTurnover.Totals] TO jetti;
      GO