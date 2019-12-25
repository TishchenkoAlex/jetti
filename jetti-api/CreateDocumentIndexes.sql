
    DROP INDEX IF EXISTS [Catalog.Account] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Account]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.Account')
    DROP INDEX IF EXISTS [Catalog.Balance] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Balance]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.Balance')
    DROP INDEX IF EXISTS [Catalog.Balance.Analytics] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Balance.Analytics]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.Balance.Analytics')
    DROP INDEX IF EXISTS [Catalog.BankAccount] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BankAccount]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.BankAccount')
    DROP INDEX IF EXISTS [Catalog.CashFlow] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.CashFlow]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.CashFlow')
    DROP INDEX IF EXISTS [Catalog.CashRegister] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.CashRegister]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.CashRegister')
    DROP INDEX IF EXISTS [Catalog.Currency] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Currency]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.Currency')
    DROP INDEX IF EXISTS [Catalog.Company] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Company]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.Company')
    DROP INDEX IF EXISTS [Catalog.Counterpartie] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.Counterpartie')
    DROP INDEX IF EXISTS [Catalog.Counterpartie.BankAccount] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.BankAccount]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.Counterpartie.BankAccount')
    DROP INDEX IF EXISTS [Catalog.Contract] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Contract]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.Contract')
    DROP INDEX IF EXISTS [Catalog.BusinessDirection] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BusinessDirection]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.BusinessDirection')
    DROP INDEX IF EXISTS [Catalog.Department] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Department]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.Department')
    DROP INDEX IF EXISTS [Catalog.Expense] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Expense]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.Expense')
    DROP INDEX IF EXISTS [Catalog.Expense.Analytics] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Expense.Analytics]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.Expense.Analytics')
    DROP INDEX IF EXISTS [Catalog.Income] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Income]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.Income')
    DROP INDEX IF EXISTS [Catalog.Loan] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Loan]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.Loan')
<<<<<<< HEAD
    DROP INDEX IF EXISTS [Catalog.LoanTypes] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.LoanTypes]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.LoanTypes')
=======
>>>>>>> d85d7d8b22bbb388ad5136ea7772689c5ee84621
    DROP INDEX IF EXISTS [Catalog.Manager] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Manager]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.Manager')
    DROP INDEX IF EXISTS [Catalog.Person] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Person]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.Person')
    DROP INDEX IF EXISTS [Catalog.PriceType] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.PriceType]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.PriceType')
    DROP INDEX IF EXISTS [Catalog.Product] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Product]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.Product')
    DROP INDEX IF EXISTS [Catalog.ProductCategory] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ProductCategory]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.ProductCategory')
    DROP INDEX IF EXISTS [Catalog.ProductKind] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ProductKind]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.ProductKind')
    DROP INDEX IF EXISTS [Catalog.Storehouse] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Storehouse]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.Storehouse')
    DROP INDEX IF EXISTS [Catalog.Operation] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.Operation')
    DROP INDEX IF EXISTS [Catalog.Operation.Group] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.Group]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.Operation.Group')
    DROP INDEX IF EXISTS [Catalog.Operation.Type] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.Type]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.Operation.Type')
    DROP INDEX IF EXISTS [Catalog.Unit] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Unit]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.Unit')
    DROP INDEX IF EXISTS [Catalog.User] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.User]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.User')
    DROP INDEX IF EXISTS [Catalog.UsersGroup] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.UsersGroup]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.UsersGroup')
    DROP INDEX IF EXISTS [Catalog.Role] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Role]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.Role')
    DROP INDEX IF EXISTS [Catalog.SubSystem] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.SubSystem]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.SubSystem')
    DROP INDEX IF EXISTS [Catalog.Brand] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Brand]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.Brand')
    DROP INDEX IF EXISTS [Catalog.GroupObjectsExploitation] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.GroupObjectsExploitation]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.GroupObjectsExploitation')
    DROP INDEX IF EXISTS [Catalog.ObjectsExploitation] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ObjectsExploitation]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.ObjectsExploitation')
    DROP INDEX IF EXISTS [Catalog.Catalog] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Catalog]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.Catalog')
    DROP INDEX IF EXISTS [Catalog.BudgetItem] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BudgetItem]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.BudgetItem')
    DROP INDEX IF EXISTS [Catalog.Scenario] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Scenario]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.Scenario')
    DROP INDEX IF EXISTS [Catalog.AcquiringTerminal] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.AcquiringTerminal]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.AcquiringTerminal')
    DROP INDEX IF EXISTS [Catalog.Bank] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Bank]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.Bank')
<<<<<<< HEAD
=======
    DROP INDEX IF EXISTS [Catalog.LoanTypes] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.LoanTypes]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Catalog.LoanTypes')
>>>>>>> d85d7d8b22bbb388ad5136ea7772689c5ee84621
    DROP INDEX IF EXISTS [Document.ExchangeRates] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Document.ExchangeRates]
    ON [dbo].[Documents]([date],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[description],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Document.ExchangeRates')
    DROP INDEX IF EXISTS [Document.Invoice] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Invoice]
    ON [dbo].[Documents]([date],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[description],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Document.Invoice')
    DROP INDEX IF EXISTS [Document.Operation] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation]
    ON [dbo].[Documents]([date],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[description],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Document.Operation')
    DROP INDEX IF EXISTS [Document.PriceList] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Document.PriceList]
    ON [dbo].[Documents]([date],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[description],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Document.PriceList')
    DROP INDEX IF EXISTS [Document.Settings] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Settings]
    ON [dbo].[Documents]([date],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[description],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Document.Settings')
    DROP INDEX IF EXISTS [Document.UserSettings] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Document.UserSettings]
    ON [dbo].[Documents]([date],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[description],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Document.UserSettings')
    DROP INDEX IF EXISTS [Document.WorkFlow] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Document.WorkFlow]
    ON [dbo].[Documents]([date],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[description],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Document.WorkFlow')
    DROP INDEX IF EXISTS [Document.CashRequest] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [Document.CashRequest]
    ON [dbo].[Documents]([date],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[description],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='Document.CashRequest')