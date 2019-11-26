DROP USER [jetti]
GO

CREATE USER [jetti] WITH PASSWORD='MyNew01Password';
GO

GRANT SHOWPLAN TO jetti;

GRANT SELECT TO jetti;  
GRANT SELECT, INSERT, UPDATE ON [dbo].[Documents] TO jetti;
GRANT SELECT ON [dbo].[Documents.Hisroty] TO jetti;  
GRANT SELECT ON [dbo].[Documents.Operation] TO jetti;  
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[Accumulation] TO jetti;  
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[Register.Info] TO jetti;  
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[Register.Account] TO jetti;  

GRANT SELECT ON [Register.Info.ExchangeRates]  TO jetti;
GRANT SELECT ON [Register.Info.Settings]  TO jetti;
GRANT SELECT ON [Register.Info.RLS] TO jetti;
GRANT SELECT ON [Register.Info.PriceList]  TO jetti;
GRANT SELECT ON [Register.Info.Depreciation]  TO jetti;
GRANT SELECT ON [dbo].[Register.Account.View] TO jetti;

GRANT SELECT ON [dbo].[Register.Accumulation.Inventory] TO jetti;

GRANT UPDATE ON [dbo].[Sq.Catalog.Account] TO jetti;
GRANT UPDATE ON [dbo].[Sq.Catalog.Balance] TO jetti;
GRANT UPDATE ON [dbo].[Sq.Catalog.Balance.Analytics] TO jetti;
GRANT UPDATE ON [dbo].[Sq.Catalog.BankAccount] TO jetti;
GRANT UPDATE ON [dbo].[Sq.Catalog.CashFlow] TO jetti;
GRANT UPDATE ON [dbo].[Sq.Catalog.Currency] TO jetti;
GRANT UPDATE ON [dbo].[Sq.Catalog.Company] TO jetti;
GRANT UPDATE ON [dbo].[Sq.Catalog.Counterpartie] TO jetti;
GRANT UPDATE ON [dbo].[Sq.Catalog.Department] TO jetti;
GRANT UPDATE ON [dbo].[Sq.Catalog.Expense] TO jetti;
GRANT UPDATE ON [dbo].[Sq.Catalog.Expense.Analytics] TO jetti;
GRANT UPDATE ON [dbo].[Sq.Catalog.Income] TO jetti;
GRANT UPDATE ON [dbo].[Sq.Catalog.Loan] TO jetti;
GRANT UPDATE ON [dbo].[Sq.Catalog.Manager] TO jetti;
GRANT UPDATE ON [dbo].[Sq.Catalog.PriceType] TO jetti;
GRANT UPDATE ON [dbo].[Sq.Catalog.Product] TO jetti;
GRANT UPDATE ON [dbo].[Sq.Catalog.Storehouse] TO jetti;
GRANT UPDATE ON [dbo].[Sq.Catalog.Operation] TO jetti;
GRANT UPDATE ON [dbo].[Sq.Catalog.Operation.Group] TO jetti;
GRANT UPDATE ON [dbo].[Sq.Catalog.Unit] TO jetti;
GRANT UPDATE ON [dbo].[Sq.Catalog.User] TO jetti;
GRANT UPDATE ON [dbo].[Sq.Document.ExchangeRates] TO jetti;
GRANT UPDATE ON [dbo].[Sq.Document.PriceList] TO jetti;
GRANT UPDATE ON [dbo].[Sq.Catalog.ProductCategory] TO jetti;
GRANT UPDATE ON [dbo].[Sq.Catalog.ProductKind] TO jetti;
GRANT UPDATE ON [dbo].[Sq.Document.UserSettings] TO jetti;