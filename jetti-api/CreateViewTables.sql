
    DROP VIEW IF EXISTS [dbo].[Catalog.Account.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Account.workflow];
    ALTER TABLE Documents ADD [Catalog.Account.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.Account.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.Account.workflow] [workflow]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."isForex"') AS BIT), 0) [isForex]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."isActive"') AS BIT), 0) [isActive]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."isPassive"') AS BIT), 0) [isPassive]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.Account'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.Account.v.id] ON [dbo].[Catalog.Account.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Account.v.decription] ON [dbo].[Catalog.Account.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Account.v.code] ON [dbo].[Catalog.Account.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Account.v.company] ON [dbo].[Catalog.Account.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Account.v.parent] ON [dbo].[Catalog.Account.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Account.v.date] ON [dbo].[Catalog.Account.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Account.v.isfolder] ON [dbo].[Catalog.Account.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Account.v.workflow] ON [dbo].[Catalog.Account.v]([workflow], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.Account.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.Balance.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Balance.workflow];
    ALTER TABLE Documents ADD [Catalog.Balance.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.Balance.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.Balance.workflow] [workflow]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."isActive"') AS BIT), 0) [isActive]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."isPassive"') AS BIT), 0) [isPassive]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.Balance'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.Balance.v.id] ON [dbo].[Catalog.Balance.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Balance.v.decription] ON [dbo].[Catalog.Balance.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Balance.v.code] ON [dbo].[Catalog.Balance.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Balance.v.company] ON [dbo].[Catalog.Balance.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Balance.v.parent] ON [dbo].[Catalog.Balance.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Balance.v.date] ON [dbo].[Catalog.Balance.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Balance.v.isfolder] ON [dbo].[Catalog.Balance.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Balance.v.workflow] ON [dbo].[Catalog.Balance.v]([workflow], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.Balance.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.Balance.Analytics.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Balance.Analytics.workflow];
    ALTER TABLE Documents ADD [Catalog.Balance.Analytics.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.Balance.Analytics.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.Balance.Analytics.workflow] [workflow]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.Balance.Analytics'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.Balance.Analytics.v.id] ON [dbo].[Catalog.Balance.Analytics.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Balance.Analytics.v.decription] ON [dbo].[Catalog.Balance.Analytics.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Balance.Analytics.v.code] ON [dbo].[Catalog.Balance.Analytics.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Balance.Analytics.v.company] ON [dbo].[Catalog.Balance.Analytics.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Balance.Analytics.v.parent] ON [dbo].[Catalog.Balance.Analytics.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Balance.Analytics.v.date] ON [dbo].[Catalog.Balance.Analytics.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Balance.Analytics.v.isfolder] ON [dbo].[Catalog.Balance.Analytics.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Balance.Analytics.v.workflow] ON [dbo].[Catalog.Balance.Analytics.v]([workflow], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.Balance.Analytics.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.BankAccount.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.BankAccount.workflow];
    ALTER TABLE Documents ADD [Catalog.BankAccount.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.BankAccount.currency];
    ALTER TABLE Documents ADD [Catalog.BankAccount.currency] AS CAST(JSON_VALUE(doc, N'$."currency"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.BankAccount.Department];
    ALTER TABLE Documents ADD [Catalog.BankAccount.Department] AS CAST(JSON_VALUE(doc, N'$."Department"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.BankAccount.Bank];
    ALTER TABLE Documents ADD [Catalog.BankAccount.Bank] AS CAST(JSON_VALUE(doc, N'$."Bank"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.BankAccount.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.BankAccount.workflow] [workflow]
      , [Catalog.BankAccount.currency] [currency]
      , [Catalog.BankAccount.Department] [Department]
      , [Catalog.BankAccount.Bank] [Bank]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."isDefault"') AS BIT), 0) [isDefault]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.BankAccount'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.BankAccount.v.id] ON [dbo].[Catalog.BankAccount.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BankAccount.v.decription] ON [dbo].[Catalog.BankAccount.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BankAccount.v.code] ON [dbo].[Catalog.BankAccount.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BankAccount.v.company] ON [dbo].[Catalog.BankAccount.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BankAccount.v.parent] ON [dbo].[Catalog.BankAccount.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BankAccount.v.date] ON [dbo].[Catalog.BankAccount.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BankAccount.v.isfolder] ON [dbo].[Catalog.BankAccount.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BankAccount.v.workflow] ON [dbo].[Catalog.BankAccount.v]([workflow], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BankAccount.v.currency] ON [dbo].[Catalog.BankAccount.v]([currency], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BankAccount.v.Department] ON [dbo].[Catalog.BankAccount.v]([Department], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BankAccount.v.Bank] ON [dbo].[Catalog.BankAccount.v]([Bank], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.BankAccount.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.CashFlow.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.CashFlow.workflow];
    ALTER TABLE Documents ADD [Catalog.CashFlow.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.CashFlow.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.CashFlow.workflow] [workflow]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.CashFlow'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.CashFlow.v.id] ON [dbo].[Catalog.CashFlow.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.CashFlow.v.decription] ON [dbo].[Catalog.CashFlow.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.CashFlow.v.code] ON [dbo].[Catalog.CashFlow.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.CashFlow.v.company] ON [dbo].[Catalog.CashFlow.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.CashFlow.v.parent] ON [dbo].[Catalog.CashFlow.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.CashFlow.v.date] ON [dbo].[Catalog.CashFlow.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.CashFlow.v.isfolder] ON [dbo].[Catalog.CashFlow.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.CashFlow.v.workflow] ON [dbo].[Catalog.CashFlow.v]([workflow], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.CashFlow.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.CashRegister.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.CashRegister.workflow];
    ALTER TABLE Documents ADD [Catalog.CashRegister.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.CashRegister.currency];
    ALTER TABLE Documents ADD [Catalog.CashRegister.currency] AS CAST(JSON_VALUE(doc, N'$."currency"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.CashRegister.Department];
    ALTER TABLE Documents ADD [Catalog.CashRegister.Department] AS CAST(JSON_VALUE(doc, N'$."Department"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.CashRegister.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.CashRegister.workflow] [workflow]
      , [Catalog.CashRegister.currency] [currency]
      , [Catalog.CashRegister.Department] [Department]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."isAccounting"') AS BIT), 0) [isAccounting]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.CashRegister'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.CashRegister.v.id] ON [dbo].[Catalog.CashRegister.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.CashRegister.v.decription] ON [dbo].[Catalog.CashRegister.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.CashRegister.v.code] ON [dbo].[Catalog.CashRegister.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.CashRegister.v.company] ON [dbo].[Catalog.CashRegister.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.CashRegister.v.parent] ON [dbo].[Catalog.CashRegister.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.CashRegister.v.date] ON [dbo].[Catalog.CashRegister.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.CashRegister.v.isfolder] ON [dbo].[Catalog.CashRegister.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.CashRegister.v.workflow] ON [dbo].[Catalog.CashRegister.v]([workflow], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.CashRegister.v.currency] ON [dbo].[Catalog.CashRegister.v]([currency], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.CashRegister.v.Department] ON [dbo].[Catalog.CashRegister.v]([Department], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.CashRegister.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.Currency.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Currency.workflow];
    ALTER TABLE Documents ADD [Catalog.Currency.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.Currency.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.Currency.workflow] [workflow]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.Currency'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.Currency.v.id] ON [dbo].[Catalog.Currency.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Currency.v.decription] ON [dbo].[Catalog.Currency.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Currency.v.code] ON [dbo].[Catalog.Currency.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Currency.v.company] ON [dbo].[Catalog.Currency.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Currency.v.parent] ON [dbo].[Catalog.Currency.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Currency.v.date] ON [dbo].[Catalog.Currency.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Currency.v.isfolder] ON [dbo].[Catalog.Currency.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Currency.v.workflow] ON [dbo].[Catalog.Currency.v]([workflow], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.Currency.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.Company.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Company.workflow];
    ALTER TABLE Documents ADD [Catalog.Company.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Company.currency];
    ALTER TABLE Documents ADD [Catalog.Company.currency] AS CAST(JSON_VALUE(doc, N'$."currency"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Company.Intercompany];
    ALTER TABLE Documents ADD [Catalog.Company.Intercompany] AS CAST(JSON_VALUE(doc, N'$."Intercompany"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.Company.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.Company.workflow] [workflow]
      , [Catalog.Company.currency] [currency]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."prefix"') AS NVARCHAR(150)), '') [prefix]
      , [Catalog.Company.Intercompany] [Intercompany]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."timeZone"') AS NVARCHAR(150)), '') [timeZone]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.Company'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.Company.v.id] ON [dbo].[Catalog.Company.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Company.v.decription] ON [dbo].[Catalog.Company.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Company.v.code] ON [dbo].[Catalog.Company.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Company.v.company] ON [dbo].[Catalog.Company.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Company.v.parent] ON [dbo].[Catalog.Company.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Company.v.date] ON [dbo].[Catalog.Company.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Company.v.isfolder] ON [dbo].[Catalog.Company.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Company.v.workflow] ON [dbo].[Catalog.Company.v]([workflow], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Company.v.currency] ON [dbo].[Catalog.Company.v]([currency], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Company.v.Intercompany] ON [dbo].[Catalog.Company.v]([Intercompany], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.Company.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.Counterpartie.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Counterpartie.workflow];
    ALTER TABLE Documents ADD [Catalog.Counterpartie.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Counterpartie.Department];
    ALTER TABLE Documents ADD [Catalog.Counterpartie.Department] AS CAST(JSON_VALUE(doc, N'$."Department"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.Counterpartie.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.Counterpartie.workflow] [workflow]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."kind"') AS NVARCHAR(150)), '') [kind]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."FullName"') AS NVARCHAR(150)), '') [FullName]
      , [Catalog.Counterpartie.Department] [Department]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."Client"') AS BIT), 0) [Client]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."Supplier"') AS BIT), 0) [Supplier]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."isInternal"') AS BIT), 0) [isInternal]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."AddressShipping"') AS NVARCHAR(150)), '') [AddressShipping]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."AddressBilling"') AS NVARCHAR(150)), '') [AddressBilling]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."Phone"') AS NVARCHAR(150)), '') [Phone]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."Code1"') AS NVARCHAR(150)), '') [Code1]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."Code2"') AS NVARCHAR(150)), '') [Code2]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."Code3"') AS NVARCHAR(150)), '') [Code3]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.Counterpartie'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.Counterpartie.v.id] ON [dbo].[Catalog.Counterpartie.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.v.decription] ON [dbo].[Catalog.Counterpartie.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.v.code] ON [dbo].[Catalog.Counterpartie.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.v.company] ON [dbo].[Catalog.Counterpartie.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.v.parent] ON [dbo].[Catalog.Counterpartie.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.v.date] ON [dbo].[Catalog.Counterpartie.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.v.isfolder] ON [dbo].[Catalog.Counterpartie.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.v.workflow] ON [dbo].[Catalog.Counterpartie.v]([workflow], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.v.Department] ON [dbo].[Catalog.Counterpartie.v]([Department], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.Counterpartie.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.Counterpartie.BankAccount.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Counterpartie.BankAccount.workflow];
    ALTER TABLE Documents ADD [Catalog.Counterpartie.BankAccount.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Counterpartie.BankAccount.currency];
    ALTER TABLE Documents ADD [Catalog.Counterpartie.BankAccount.currency] AS CAST(JSON_VALUE(doc, N'$."currency"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Counterpartie.BankAccount.Department];
    ALTER TABLE Documents ADD [Catalog.Counterpartie.BankAccount.Department] AS CAST(JSON_VALUE(doc, N'$."Department"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Counterpartie.BankAccount.Bank];
    ALTER TABLE Documents ADD [Catalog.Counterpartie.BankAccount.Bank] AS CAST(JSON_VALUE(doc, N'$."Bank"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Counterpartie.BankAccount.owner];
    ALTER TABLE Documents ADD [Catalog.Counterpartie.BankAccount.owner] AS CAST(JSON_VALUE(doc, N'$."owner"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.Counterpartie.BankAccount.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.Counterpartie.BankAccount.workflow] [workflow]
      , [Catalog.Counterpartie.BankAccount.currency] [currency]
      , [Catalog.Counterpartie.BankAccount.Department] [Department]
      , [Catalog.Counterpartie.BankAccount.Bank] [Bank]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."isDefault"') AS BIT), 0) [isDefault]
      , [Catalog.Counterpartie.BankAccount.owner] [owner]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.Counterpartie.BankAccount'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.Counterpartie.BankAccount.v.id] ON [dbo].[Catalog.Counterpartie.BankAccount.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.BankAccount.v.decription] ON [dbo].[Catalog.Counterpartie.BankAccount.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.BankAccount.v.code] ON [dbo].[Catalog.Counterpartie.BankAccount.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.BankAccount.v.company] ON [dbo].[Catalog.Counterpartie.BankAccount.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.BankAccount.v.parent] ON [dbo].[Catalog.Counterpartie.BankAccount.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.BankAccount.v.date] ON [dbo].[Catalog.Counterpartie.BankAccount.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.BankAccount.v.isfolder] ON [dbo].[Catalog.Counterpartie.BankAccount.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.BankAccount.v.workflow] ON [dbo].[Catalog.Counterpartie.BankAccount.v]([workflow], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.BankAccount.v.currency] ON [dbo].[Catalog.Counterpartie.BankAccount.v]([currency], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.BankAccount.v.Department] ON [dbo].[Catalog.Counterpartie.BankAccount.v]([Department], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.BankAccount.v.Bank] ON [dbo].[Catalog.Counterpartie.BankAccount.v]([Bank], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.BankAccount.v.owner] ON [dbo].[Catalog.Counterpartie.BankAccount.v]([owner], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.Counterpartie.BankAccount.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.Contract.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Contract.workflow];
    ALTER TABLE Documents ADD [Catalog.Contract.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Contract.owner];
    ALTER TABLE Documents ADD [Catalog.Contract.owner] AS CAST(JSON_VALUE(doc, N'$."owner"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Contract.BusinessDirection];
    ALTER TABLE Documents ADD [Catalog.Contract.BusinessDirection] AS CAST(JSON_VALUE(doc, N'$."BusinessDirection"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Contract.currency];
    ALTER TABLE Documents ADD [Catalog.Contract.currency] AS CAST(JSON_VALUE(doc, N'$."currency"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Contract.Manager];
    ALTER TABLE Documents ADD [Catalog.Contract.Manager] AS CAST(JSON_VALUE(doc, N'$."Manager"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.Contract.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.Contract.workflow] [workflow]
      , [Catalog.Contract.owner] [owner]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."Status"') AS NVARCHAR(150)), '') [Status]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."kind"') AS NVARCHAR(150)), '') [kind]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."StartDate"') AS NVARCHAR(150)), '') [StartDate]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."EndDate"') AS NVARCHAR(150)), '') [EndDate]
      , [Catalog.Contract.BusinessDirection] [BusinessDirection]
      , [Catalog.Contract.currency] [currency]
      , [Catalog.Contract.Manager] [Manager]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.Contract'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.Contract.v.id] ON [dbo].[Catalog.Contract.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Contract.v.decription] ON [dbo].[Catalog.Contract.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Contract.v.code] ON [dbo].[Catalog.Contract.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Contract.v.company] ON [dbo].[Catalog.Contract.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Contract.v.parent] ON [dbo].[Catalog.Contract.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Contract.v.date] ON [dbo].[Catalog.Contract.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Contract.v.isfolder] ON [dbo].[Catalog.Contract.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Contract.v.workflow] ON [dbo].[Catalog.Contract.v]([workflow], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Contract.v.owner] ON [dbo].[Catalog.Contract.v]([owner], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Contract.v.BusinessDirection] ON [dbo].[Catalog.Contract.v]([BusinessDirection], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Contract.v.currency] ON [dbo].[Catalog.Contract.v]([currency], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Contract.v.Manager] ON [dbo].[Catalog.Contract.v]([Manager], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.Contract.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.BusinessDirection.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.BusinessDirection.workflow];
    ALTER TABLE Documents ADD [Catalog.BusinessDirection.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.BusinessDirection.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.BusinessDirection.workflow] [workflow]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.BusinessDirection'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.BusinessDirection.v.id] ON [dbo].[Catalog.BusinessDirection.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BusinessDirection.v.decription] ON [dbo].[Catalog.BusinessDirection.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BusinessDirection.v.code] ON [dbo].[Catalog.BusinessDirection.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BusinessDirection.v.company] ON [dbo].[Catalog.BusinessDirection.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BusinessDirection.v.parent] ON [dbo].[Catalog.BusinessDirection.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BusinessDirection.v.date] ON [dbo].[Catalog.BusinessDirection.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BusinessDirection.v.isfolder] ON [dbo].[Catalog.BusinessDirection.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BusinessDirection.v.workflow] ON [dbo].[Catalog.BusinessDirection.v]([workflow], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.BusinessDirection.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.Department.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Department.workflow];
    ALTER TABLE Documents ADD [Catalog.Department.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.Department.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.Department.workflow] [workflow]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.Department'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.Department.v.id] ON [dbo].[Catalog.Department.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Department.v.decription] ON [dbo].[Catalog.Department.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Department.v.code] ON [dbo].[Catalog.Department.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Department.v.company] ON [dbo].[Catalog.Department.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Department.v.parent] ON [dbo].[Catalog.Department.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Department.v.date] ON [dbo].[Catalog.Department.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Department.v.isfolder] ON [dbo].[Catalog.Department.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Department.v.workflow] ON [dbo].[Catalog.Department.v]([workflow], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.Department.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.Expense.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Expense.workflow];
    ALTER TABLE Documents ADD [Catalog.Expense.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Expense.Account];
    ALTER TABLE Documents ADD [Catalog.Expense.Account] AS CAST(JSON_VALUE(doc, N'$."Account"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.Expense.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.Expense.workflow] [workflow]
      , [Catalog.Expense.Account] [Account]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.Expense'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.Expense.v.id] ON [dbo].[Catalog.Expense.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Expense.v.decription] ON [dbo].[Catalog.Expense.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Expense.v.code] ON [dbo].[Catalog.Expense.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Expense.v.company] ON [dbo].[Catalog.Expense.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Expense.v.parent] ON [dbo].[Catalog.Expense.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Expense.v.date] ON [dbo].[Catalog.Expense.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Expense.v.isfolder] ON [dbo].[Catalog.Expense.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Expense.v.workflow] ON [dbo].[Catalog.Expense.v]([workflow], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Expense.v.Account] ON [dbo].[Catalog.Expense.v]([Account], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.Expense.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.Expense.Analytics.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Expense.Analytics.workflow];
    ALTER TABLE Documents ADD [Catalog.Expense.Analytics.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.Expense.Analytics.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.Expense.Analytics.workflow] [workflow]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.Expense.Analytics'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.Expense.Analytics.v.id] ON [dbo].[Catalog.Expense.Analytics.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Expense.Analytics.v.decription] ON [dbo].[Catalog.Expense.Analytics.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Expense.Analytics.v.code] ON [dbo].[Catalog.Expense.Analytics.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Expense.Analytics.v.company] ON [dbo].[Catalog.Expense.Analytics.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Expense.Analytics.v.parent] ON [dbo].[Catalog.Expense.Analytics.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Expense.Analytics.v.date] ON [dbo].[Catalog.Expense.Analytics.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Expense.Analytics.v.isfolder] ON [dbo].[Catalog.Expense.Analytics.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Expense.Analytics.v.workflow] ON [dbo].[Catalog.Expense.Analytics.v]([workflow], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.Expense.Analytics.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.Income.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Income.workflow];
    ALTER TABLE Documents ADD [Catalog.Income.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Income.Account];
    ALTER TABLE Documents ADD [Catalog.Income.Account] AS CAST(JSON_VALUE(doc, N'$."Account"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.Income.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.Income.workflow] [workflow]
      , [Catalog.Income.Account] [Account]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.Income'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.Income.v.id] ON [dbo].[Catalog.Income.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Income.v.decription] ON [dbo].[Catalog.Income.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Income.v.code] ON [dbo].[Catalog.Income.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Income.v.company] ON [dbo].[Catalog.Income.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Income.v.parent] ON [dbo].[Catalog.Income.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Income.v.date] ON [dbo].[Catalog.Income.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Income.v.isfolder] ON [dbo].[Catalog.Income.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Income.v.workflow] ON [dbo].[Catalog.Income.v]([workflow], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Income.v.Account] ON [dbo].[Catalog.Income.v]([Account], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.Income.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.Loan.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Loan.workflow];
    ALTER TABLE Documents ADD [Catalog.Loan.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Loan.Department];
    ALTER TABLE Documents ADD [Catalog.Loan.Department] AS CAST(JSON_VALUE(doc, N'$."Department"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Loan.currency];
    ALTER TABLE Documents ADD [Catalog.Loan.currency] AS CAST(JSON_VALUE(doc, N'$."currency"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.Loan.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.Loan.workflow] [workflow]
      , [Catalog.Loan.Department] [Department]
      , [Catalog.Loan.currency] [currency]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.Loan'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.Loan.v.id] ON [dbo].[Catalog.Loan.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Loan.v.decription] ON [dbo].[Catalog.Loan.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Loan.v.code] ON [dbo].[Catalog.Loan.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Loan.v.company] ON [dbo].[Catalog.Loan.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Loan.v.parent] ON [dbo].[Catalog.Loan.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Loan.v.date] ON [dbo].[Catalog.Loan.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Loan.v.isfolder] ON [dbo].[Catalog.Loan.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Loan.v.workflow] ON [dbo].[Catalog.Loan.v]([workflow], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Loan.v.Department] ON [dbo].[Catalog.Loan.v]([Department], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Loan.v.currency] ON [dbo].[Catalog.Loan.v]([currency], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.Loan.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.Manager.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Manager.workflow];
    ALTER TABLE Documents ADD [Catalog.Manager.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.Manager.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.Manager.workflow] [workflow]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."FullName"') AS NVARCHAR(150)), '') [FullName]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."Gender"') AS BIT), 0) [Gender]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."Birthday"') AS NVARCHAR(150)), '') [Birthday]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.Manager'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.Manager.v.id] ON [dbo].[Catalog.Manager.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Manager.v.decription] ON [dbo].[Catalog.Manager.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Manager.v.code] ON [dbo].[Catalog.Manager.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Manager.v.company] ON [dbo].[Catalog.Manager.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Manager.v.parent] ON [dbo].[Catalog.Manager.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Manager.v.date] ON [dbo].[Catalog.Manager.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Manager.v.isfolder] ON [dbo].[Catalog.Manager.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Manager.v.workflow] ON [dbo].[Catalog.Manager.v]([workflow], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.Manager.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.Person.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Person.workflow];
    ALTER TABLE Documents ADD [Catalog.Person.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.Person.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.Person.workflow] [workflow]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.Person'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.Person.v.id] ON [dbo].[Catalog.Person.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Person.v.decription] ON [dbo].[Catalog.Person.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Person.v.code] ON [dbo].[Catalog.Person.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Person.v.company] ON [dbo].[Catalog.Person.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Person.v.parent] ON [dbo].[Catalog.Person.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Person.v.date] ON [dbo].[Catalog.Person.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Person.v.isfolder] ON [dbo].[Catalog.Person.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Person.v.workflow] ON [dbo].[Catalog.Person.v]([workflow], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.Person.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.PriceType.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.PriceType.workflow];
    ALTER TABLE Documents ADD [Catalog.PriceType.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.PriceType.currency];
    ALTER TABLE Documents ADD [Catalog.PriceType.currency] AS CAST(JSON_VALUE(doc, N'$."currency"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.PriceType.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.PriceType.workflow] [workflow]
      , [Catalog.PriceType.currency] [currency]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."TaxInclude"') AS BIT), 0) [TaxInclude]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.PriceType'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.PriceType.v.id] ON [dbo].[Catalog.PriceType.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.PriceType.v.decription] ON [dbo].[Catalog.PriceType.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.PriceType.v.code] ON [dbo].[Catalog.PriceType.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.PriceType.v.company] ON [dbo].[Catalog.PriceType.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.PriceType.v.parent] ON [dbo].[Catalog.PriceType.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.PriceType.v.date] ON [dbo].[Catalog.PriceType.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.PriceType.v.isfolder] ON [dbo].[Catalog.PriceType.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.PriceType.v.workflow] ON [dbo].[Catalog.PriceType.v]([workflow], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.PriceType.v.currency] ON [dbo].[Catalog.PriceType.v]([currency], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.PriceType.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.Product.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Product.workflow];
    ALTER TABLE Documents ADD [Catalog.Product.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Product.ProductKind];
    ALTER TABLE Documents ADD [Catalog.Product.ProductKind] AS CAST(JSON_VALUE(doc, N'$."ProductKind"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Product.ProductCategory];
    ALTER TABLE Documents ADD [Catalog.Product.ProductCategory] AS CAST(JSON_VALUE(doc, N'$."ProductCategory"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Product.Brand];
    ALTER TABLE Documents ADD [Catalog.Product.Brand] AS CAST(JSON_VALUE(doc, N'$."Brand"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Product.Unit];
    ALTER TABLE Documents ADD [Catalog.Product.Unit] AS CAST(JSON_VALUE(doc, N'$."Unit"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.Product.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.Product.workflow] [workflow]
      , [Catalog.Product.ProductKind] [ProductKind]
      , [Catalog.Product.ProductCategory] [ProductCategory]
      , [Catalog.Product.Brand] [Brand]
      , [Catalog.Product.Unit] [Unit]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."Volume"') AS MONEY), 0) [Volume]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.Product'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.Product.v.id] ON [dbo].[Catalog.Product.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Product.v.decription] ON [dbo].[Catalog.Product.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Product.v.code] ON [dbo].[Catalog.Product.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Product.v.company] ON [dbo].[Catalog.Product.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Product.v.parent] ON [dbo].[Catalog.Product.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Product.v.date] ON [dbo].[Catalog.Product.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Product.v.isfolder] ON [dbo].[Catalog.Product.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Product.v.workflow] ON [dbo].[Catalog.Product.v]([workflow], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Product.v.ProductKind] ON [dbo].[Catalog.Product.v]([ProductKind], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Product.v.ProductCategory] ON [dbo].[Catalog.Product.v]([ProductCategory], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Product.v.Brand] ON [dbo].[Catalog.Product.v]([Brand], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Product.v.Unit] ON [dbo].[Catalog.Product.v]([Unit], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.Product.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.ProductCategory.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.ProductCategory.workflow];
    ALTER TABLE Documents ADD [Catalog.ProductCategory.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.ProductCategory.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.ProductCategory.workflow] [workflow]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.ProductCategory'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.ProductCategory.v.id] ON [dbo].[Catalog.ProductCategory.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ProductCategory.v.decription] ON [dbo].[Catalog.ProductCategory.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ProductCategory.v.code] ON [dbo].[Catalog.ProductCategory.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ProductCategory.v.company] ON [dbo].[Catalog.ProductCategory.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ProductCategory.v.parent] ON [dbo].[Catalog.ProductCategory.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ProductCategory.v.date] ON [dbo].[Catalog.ProductCategory.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ProductCategory.v.isfolder] ON [dbo].[Catalog.ProductCategory.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ProductCategory.v.workflow] ON [dbo].[Catalog.ProductCategory.v]([workflow], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.ProductCategory.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.ProductKind.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.ProductKind.workflow];
    ALTER TABLE Documents ADD [Catalog.ProductKind.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.ProductKind.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.ProductKind.workflow] [workflow]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."ProductType"') AS NVARCHAR(150)), '') [ProductType]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.ProductKind'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.ProductKind.v.id] ON [dbo].[Catalog.ProductKind.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ProductKind.v.decription] ON [dbo].[Catalog.ProductKind.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ProductKind.v.code] ON [dbo].[Catalog.ProductKind.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ProductKind.v.company] ON [dbo].[Catalog.ProductKind.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ProductKind.v.parent] ON [dbo].[Catalog.ProductKind.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ProductKind.v.date] ON [dbo].[Catalog.ProductKind.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ProductKind.v.isfolder] ON [dbo].[Catalog.ProductKind.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ProductKind.v.workflow] ON [dbo].[Catalog.ProductKind.v]([workflow], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.ProductKind.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.Storehouse.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Storehouse.workflow];
    ALTER TABLE Documents ADD [Catalog.Storehouse.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Storehouse.Department];
    ALTER TABLE Documents ADD [Catalog.Storehouse.Department] AS CAST(JSON_VALUE(doc, N'$."Department"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.Storehouse.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.Storehouse.workflow] [workflow]
      , [Catalog.Storehouse.Department] [Department]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.Storehouse'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.Storehouse.v.id] ON [dbo].[Catalog.Storehouse.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Storehouse.v.decription] ON [dbo].[Catalog.Storehouse.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Storehouse.v.code] ON [dbo].[Catalog.Storehouse.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Storehouse.v.company] ON [dbo].[Catalog.Storehouse.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Storehouse.v.parent] ON [dbo].[Catalog.Storehouse.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Storehouse.v.date] ON [dbo].[Catalog.Storehouse.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Storehouse.v.isfolder] ON [dbo].[Catalog.Storehouse.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Storehouse.v.workflow] ON [dbo].[Catalog.Storehouse.v]([workflow], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Storehouse.v.Department] ON [dbo].[Catalog.Storehouse.v]([Department], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.Storehouse.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.Operation.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Operation.workflow];
    ALTER TABLE Documents ADD [Catalog.Operation.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Operation.Group];
    ALTER TABLE Documents ADD [Catalog.Operation.Group] AS CAST(JSON_VALUE(doc, N'$."Group"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.Operation.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.Operation.workflow] [workflow]
      , [Catalog.Operation.Group] [Group]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."script"') AS NVARCHAR(150)), '') [script]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."module"') AS NVARCHAR(150)), '') [module]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.Operation'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.Operation.v.id] ON [dbo].[Catalog.Operation.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.v.decription] ON [dbo].[Catalog.Operation.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.v.code] ON [dbo].[Catalog.Operation.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.v.company] ON [dbo].[Catalog.Operation.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.v.parent] ON [dbo].[Catalog.Operation.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.v.date] ON [dbo].[Catalog.Operation.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.v.isfolder] ON [dbo].[Catalog.Operation.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.v.workflow] ON [dbo].[Catalog.Operation.v]([workflow], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.v.Group] ON [dbo].[Catalog.Operation.v]([Group], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.Operation.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.Operation.Group.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Operation.Group.workflow];
    ALTER TABLE Documents ADD [Catalog.Operation.Group.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.Operation.Group.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.Operation.Group.workflow] [workflow]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."Prefix"') AS NVARCHAR(150)), '') [Prefix]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.Operation.Group'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.Operation.Group.v.id] ON [dbo].[Catalog.Operation.Group.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.Group.v.decription] ON [dbo].[Catalog.Operation.Group.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.Group.v.code] ON [dbo].[Catalog.Operation.Group.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.Group.v.company] ON [dbo].[Catalog.Operation.Group.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.Group.v.parent] ON [dbo].[Catalog.Operation.Group.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.Group.v.date] ON [dbo].[Catalog.Operation.Group.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.Group.v.isfolder] ON [dbo].[Catalog.Operation.Group.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.Group.v.workflow] ON [dbo].[Catalog.Operation.Group.v]([workflow], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.Operation.Group.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.Operation.Type.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Operation.Type.workflow];
    ALTER TABLE Documents ADD [Catalog.Operation.Type.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.Operation.Type.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.Operation.Type.workflow] [workflow]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.Operation.Type'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.Operation.Type.v.id] ON [dbo].[Catalog.Operation.Type.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.Type.v.decription] ON [dbo].[Catalog.Operation.Type.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.Type.v.code] ON [dbo].[Catalog.Operation.Type.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.Type.v.company] ON [dbo].[Catalog.Operation.Type.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.Type.v.parent] ON [dbo].[Catalog.Operation.Type.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.Type.v.date] ON [dbo].[Catalog.Operation.Type.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.Type.v.isfolder] ON [dbo].[Catalog.Operation.Type.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.Type.v.workflow] ON [dbo].[Catalog.Operation.Type.v]([workflow], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.Operation.Type.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.Unit.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Unit.workflow];
    ALTER TABLE Documents ADD [Catalog.Unit.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.Unit.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.Unit.workflow] [workflow]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.Unit'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.Unit.v.id] ON [dbo].[Catalog.Unit.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Unit.v.decription] ON [dbo].[Catalog.Unit.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Unit.v.code] ON [dbo].[Catalog.Unit.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Unit.v.company] ON [dbo].[Catalog.Unit.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Unit.v.parent] ON [dbo].[Catalog.Unit.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Unit.v.date] ON [dbo].[Catalog.Unit.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Unit.v.isfolder] ON [dbo].[Catalog.Unit.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Unit.v.workflow] ON [dbo].[Catalog.Unit.v]([workflow], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.Unit.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.User.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.User.workflow];
    ALTER TABLE Documents ADD [Catalog.User.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.User.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.User.workflow] [workflow]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."isAdmin"') AS BIT), 0) [isAdmin]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.User'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.User.v.id] ON [dbo].[Catalog.User.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.User.v.decription] ON [dbo].[Catalog.User.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.User.v.code] ON [dbo].[Catalog.User.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.User.v.company] ON [dbo].[Catalog.User.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.User.v.parent] ON [dbo].[Catalog.User.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.User.v.date] ON [dbo].[Catalog.User.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.User.v.isfolder] ON [dbo].[Catalog.User.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.User.v.workflow] ON [dbo].[Catalog.User.v]([workflow], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.User.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.UsersGroup.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.UsersGroup.workflow];
    ALTER TABLE Documents ADD [Catalog.UsersGroup.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.UsersGroup.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.UsersGroup.workflow] [workflow]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.UsersGroup'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.UsersGroup.v.id] ON [dbo].[Catalog.UsersGroup.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.UsersGroup.v.decription] ON [dbo].[Catalog.UsersGroup.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.UsersGroup.v.code] ON [dbo].[Catalog.UsersGroup.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.UsersGroup.v.company] ON [dbo].[Catalog.UsersGroup.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.UsersGroup.v.parent] ON [dbo].[Catalog.UsersGroup.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.UsersGroup.v.date] ON [dbo].[Catalog.UsersGroup.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.UsersGroup.v.isfolder] ON [dbo].[Catalog.UsersGroup.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.UsersGroup.v.workflow] ON [dbo].[Catalog.UsersGroup.v]([workflow], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.UsersGroup.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.Role.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Role.workflow];
    ALTER TABLE Documents ADD [Catalog.Role.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.Role.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.Role.workflow] [workflow]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.Role'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.Role.v.id] ON [dbo].[Catalog.Role.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Role.v.decription] ON [dbo].[Catalog.Role.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Role.v.code] ON [dbo].[Catalog.Role.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Role.v.company] ON [dbo].[Catalog.Role.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Role.v.parent] ON [dbo].[Catalog.Role.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Role.v.date] ON [dbo].[Catalog.Role.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Role.v.isfolder] ON [dbo].[Catalog.Role.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Role.v.workflow] ON [dbo].[Catalog.Role.v]([workflow], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.Role.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.SubSystem.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.SubSystem.workflow];
    ALTER TABLE Documents ADD [Catalog.SubSystem.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.SubSystem.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.SubSystem.workflow] [workflow]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."icon"') AS NVARCHAR(150)), '') [icon]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.SubSystem'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.SubSystem.v.id] ON [dbo].[Catalog.SubSystem.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.SubSystem.v.decription] ON [dbo].[Catalog.SubSystem.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.SubSystem.v.code] ON [dbo].[Catalog.SubSystem.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.SubSystem.v.company] ON [dbo].[Catalog.SubSystem.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.SubSystem.v.parent] ON [dbo].[Catalog.SubSystem.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.SubSystem.v.date] ON [dbo].[Catalog.SubSystem.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.SubSystem.v.isfolder] ON [dbo].[Catalog.SubSystem.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.SubSystem.v.workflow] ON [dbo].[Catalog.SubSystem.v]([workflow], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.SubSystem.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.Documents.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Documents.workflow];
    ALTER TABLE Documents ADD [Catalog.Documents.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.Documents.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.Documents.workflow] [workflow]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.Documents'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.Documents.v.id] ON [dbo].[Catalog.Documents.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Documents.v.decription] ON [dbo].[Catalog.Documents.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Documents.v.code] ON [dbo].[Catalog.Documents.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Documents.v.company] ON [dbo].[Catalog.Documents.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Documents.v.parent] ON [dbo].[Catalog.Documents.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Documents.v.date] ON [dbo].[Catalog.Documents.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Documents.v.isfolder] ON [dbo].[Catalog.Documents.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Documents.v.workflow] ON [dbo].[Catalog.Documents.v]([workflow], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.Documents.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.Catalogs.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Catalogs.workflow];
    ALTER TABLE Documents ADD [Catalog.Catalogs.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.Catalogs.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.Catalogs.workflow] [workflow]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.Catalogs'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.Catalogs.v.id] ON [dbo].[Catalog.Catalogs.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Catalogs.v.decription] ON [dbo].[Catalog.Catalogs.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Catalogs.v.code] ON [dbo].[Catalog.Catalogs.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Catalogs.v.company] ON [dbo].[Catalog.Catalogs.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Catalogs.v.parent] ON [dbo].[Catalog.Catalogs.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Catalogs.v.date] ON [dbo].[Catalog.Catalogs.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Catalogs.v.isfolder] ON [dbo].[Catalog.Catalogs.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Catalogs.v.workflow] ON [dbo].[Catalog.Catalogs.v]([workflow], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.Catalogs.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.Forms.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Forms.workflow];
    ALTER TABLE Documents ADD [Catalog.Forms.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.Forms.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.Forms.workflow] [workflow]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.Forms'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.Forms.v.id] ON [dbo].[Catalog.Forms.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Forms.v.decription] ON [dbo].[Catalog.Forms.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Forms.v.code] ON [dbo].[Catalog.Forms.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Forms.v.company] ON [dbo].[Catalog.Forms.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Forms.v.parent] ON [dbo].[Catalog.Forms.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Forms.v.date] ON [dbo].[Catalog.Forms.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Forms.v.isfolder] ON [dbo].[Catalog.Forms.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Forms.v.workflow] ON [dbo].[Catalog.Forms.v]([workflow], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.Forms.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.Objects.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Objects.workflow];
    ALTER TABLE Documents ADD [Catalog.Objects.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.Objects.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.Objects.workflow] [workflow]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.Objects'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.Objects.v.id] ON [dbo].[Catalog.Objects.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Objects.v.decription] ON [dbo].[Catalog.Objects.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Objects.v.code] ON [dbo].[Catalog.Objects.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Objects.v.company] ON [dbo].[Catalog.Objects.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Objects.v.parent] ON [dbo].[Catalog.Objects.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Objects.v.date] ON [dbo].[Catalog.Objects.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Objects.v.isfolder] ON [dbo].[Catalog.Objects.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Objects.v.workflow] ON [dbo].[Catalog.Objects.v]([workflow], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.Objects.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.Subcount.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Subcount.workflow];
    ALTER TABLE Documents ADD [Catalog.Subcount.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.Subcount.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.Subcount.workflow] [workflow]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.Subcount'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.Subcount.v.id] ON [dbo].[Catalog.Subcount.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Subcount.v.decription] ON [dbo].[Catalog.Subcount.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Subcount.v.code] ON [dbo].[Catalog.Subcount.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Subcount.v.company] ON [dbo].[Catalog.Subcount.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Subcount.v.parent] ON [dbo].[Catalog.Subcount.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Subcount.v.date] ON [dbo].[Catalog.Subcount.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Subcount.v.isfolder] ON [dbo].[Catalog.Subcount.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Subcount.v.workflow] ON [dbo].[Catalog.Subcount.v]([workflow], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.Subcount.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.Brand.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Brand.workflow];
    ALTER TABLE Documents ADD [Catalog.Brand.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.Brand.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.Brand.workflow] [workflow]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.Brand'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.Brand.v.id] ON [dbo].[Catalog.Brand.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Brand.v.decription] ON [dbo].[Catalog.Brand.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Brand.v.code] ON [dbo].[Catalog.Brand.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Brand.v.company] ON [dbo].[Catalog.Brand.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Brand.v.parent] ON [dbo].[Catalog.Brand.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Brand.v.date] ON [dbo].[Catalog.Brand.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Brand.v.isfolder] ON [dbo].[Catalog.Brand.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Brand.v.workflow] ON [dbo].[Catalog.Brand.v]([workflow], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.Brand.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.GroupObjectsExploitation.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.GroupObjectsExploitation.workflow];
    ALTER TABLE Documents ADD [Catalog.GroupObjectsExploitation.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.GroupObjectsExploitation.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.GroupObjectsExploitation.workflow] [workflow]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."Method"') AS NVARCHAR(150)), '') [Method]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.GroupObjectsExploitation'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.GroupObjectsExploitation.v.id] ON [dbo].[Catalog.GroupObjectsExploitation.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.GroupObjectsExploitation.v.decription] ON [dbo].[Catalog.GroupObjectsExploitation.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.GroupObjectsExploitation.v.code] ON [dbo].[Catalog.GroupObjectsExploitation.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.GroupObjectsExploitation.v.company] ON [dbo].[Catalog.GroupObjectsExploitation.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.GroupObjectsExploitation.v.parent] ON [dbo].[Catalog.GroupObjectsExploitation.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.GroupObjectsExploitation.v.date] ON [dbo].[Catalog.GroupObjectsExploitation.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.GroupObjectsExploitation.v.isfolder] ON [dbo].[Catalog.GroupObjectsExploitation.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.GroupObjectsExploitation.v.workflow] ON [dbo].[Catalog.GroupObjectsExploitation.v]([workflow], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.GroupObjectsExploitation.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.ObjectsExploitation.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.ObjectsExploitation.workflow];
    ALTER TABLE Documents ADD [Catalog.ObjectsExploitation.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.ObjectsExploitation.Group];
    ALTER TABLE Documents ADD [Catalog.ObjectsExploitation.Group] AS CAST(JSON_VALUE(doc, N'$."Group"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.ObjectsExploitation.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.ObjectsExploitation.workflow] [workflow]
      , [Catalog.ObjectsExploitation.Group] [Group]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."InventoryNumber"') AS NVARCHAR(150)), '') [InventoryNumber]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.ObjectsExploitation'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.ObjectsExploitation.v.id] ON [dbo].[Catalog.ObjectsExploitation.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ObjectsExploitation.v.decription] ON [dbo].[Catalog.ObjectsExploitation.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ObjectsExploitation.v.code] ON [dbo].[Catalog.ObjectsExploitation.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ObjectsExploitation.v.company] ON [dbo].[Catalog.ObjectsExploitation.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ObjectsExploitation.v.parent] ON [dbo].[Catalog.ObjectsExploitation.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ObjectsExploitation.v.date] ON [dbo].[Catalog.ObjectsExploitation.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ObjectsExploitation.v.isfolder] ON [dbo].[Catalog.ObjectsExploitation.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ObjectsExploitation.v.workflow] ON [dbo].[Catalog.ObjectsExploitation.v]([workflow], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ObjectsExploitation.v.Group] ON [dbo].[Catalog.ObjectsExploitation.v]([Group], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.ObjectsExploitation.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.Catalog.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Catalog.workflow];
    ALTER TABLE Documents ADD [Catalog.Catalog.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.Catalog.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.Catalog.workflow] [workflow]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."prefix"') AS NVARCHAR(150)), '') [prefix]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."icon"') AS NVARCHAR(150)), '') [icon]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."menu"') AS NVARCHAR(150)), '') [menu]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."presentation"') AS NVARCHAR(150)), '') [presentation]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."hierarchy"') AS NVARCHAR(150)), '') [hierarchy]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."module"') AS NVARCHAR(150)), '') [module]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.Catalog'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.Catalog.v.id] ON [dbo].[Catalog.Catalog.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Catalog.v.decription] ON [dbo].[Catalog.Catalog.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Catalog.v.code] ON [dbo].[Catalog.Catalog.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Catalog.v.company] ON [dbo].[Catalog.Catalog.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Catalog.v.parent] ON [dbo].[Catalog.Catalog.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Catalog.v.date] ON [dbo].[Catalog.Catalog.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Catalog.v.isfolder] ON [dbo].[Catalog.Catalog.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Catalog.v.workflow] ON [dbo].[Catalog.Catalog.v]([workflow], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.Catalog.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.BudgetItem.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.BudgetItem.workflow];
    ALTER TABLE Documents ADD [Catalog.BudgetItem.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.BudgetItem.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.BudgetItem.workflow] [workflow]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.BudgetItem'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.BudgetItem.v.id] ON [dbo].[Catalog.BudgetItem.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BudgetItem.v.decription] ON [dbo].[Catalog.BudgetItem.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BudgetItem.v.code] ON [dbo].[Catalog.BudgetItem.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BudgetItem.v.company] ON [dbo].[Catalog.BudgetItem.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BudgetItem.v.parent] ON [dbo].[Catalog.BudgetItem.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BudgetItem.v.date] ON [dbo].[Catalog.BudgetItem.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BudgetItem.v.isfolder] ON [dbo].[Catalog.BudgetItem.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BudgetItem.v.workflow] ON [dbo].[Catalog.BudgetItem.v]([workflow], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.BudgetItem.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.Scenario.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Scenario.workflow];
    ALTER TABLE Documents ADD [Catalog.Scenario.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Scenario.currency];
    ALTER TABLE Documents ADD [Catalog.Scenario.currency] AS CAST(JSON_VALUE(doc, N'$."currency"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.Scenario.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.Scenario.workflow] [workflow]
      , [Catalog.Scenario.currency] [currency]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.Scenario'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.Scenario.v.id] ON [dbo].[Catalog.Scenario.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Scenario.v.decription] ON [dbo].[Catalog.Scenario.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Scenario.v.code] ON [dbo].[Catalog.Scenario.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Scenario.v.company] ON [dbo].[Catalog.Scenario.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Scenario.v.parent] ON [dbo].[Catalog.Scenario.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Scenario.v.date] ON [dbo].[Catalog.Scenario.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Scenario.v.isfolder] ON [dbo].[Catalog.Scenario.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Scenario.v.workflow] ON [dbo].[Catalog.Scenario.v]([workflow], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Scenario.v.currency] ON [dbo].[Catalog.Scenario.v]([currency], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.Scenario.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.AcquiringTerminal.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.AcquiringTerminal.workflow];
    ALTER TABLE Documents ADD [Catalog.AcquiringTerminal.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.AcquiringTerminal.BankAccount];
    ALTER TABLE Documents ADD [Catalog.AcquiringTerminal.BankAccount] AS CAST(JSON_VALUE(doc, N'$."BankAccount"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.AcquiringTerminal.Counterpartie];
    ALTER TABLE Documents ADD [Catalog.AcquiringTerminal.Counterpartie] AS CAST(JSON_VALUE(doc, N'$."Counterpartie"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.AcquiringTerminal.Department];
    ALTER TABLE Documents ADD [Catalog.AcquiringTerminal.Department] AS CAST(JSON_VALUE(doc, N'$."Department"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.AcquiringTerminal.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.AcquiringTerminal.workflow] [workflow]
      , [Catalog.AcquiringTerminal.BankAccount] [BankAccount]
      , [Catalog.AcquiringTerminal.Counterpartie] [Counterpartie]
      , [Catalog.AcquiringTerminal.Department] [Department]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."isDefault"') AS BIT), 0) [isDefault]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.AcquiringTerminal'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.AcquiringTerminal.v.id] ON [dbo].[Catalog.AcquiringTerminal.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.AcquiringTerminal.v.decription] ON [dbo].[Catalog.AcquiringTerminal.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.AcquiringTerminal.v.code] ON [dbo].[Catalog.AcquiringTerminal.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.AcquiringTerminal.v.company] ON [dbo].[Catalog.AcquiringTerminal.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.AcquiringTerminal.v.parent] ON [dbo].[Catalog.AcquiringTerminal.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.AcquiringTerminal.v.date] ON [dbo].[Catalog.AcquiringTerminal.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.AcquiringTerminal.v.isfolder] ON [dbo].[Catalog.AcquiringTerminal.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.AcquiringTerminal.v.workflow] ON [dbo].[Catalog.AcquiringTerminal.v]([workflow], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.AcquiringTerminal.v.BankAccount] ON [dbo].[Catalog.AcquiringTerminal.v]([BankAccount], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.AcquiringTerminal.v.Counterpartie] ON [dbo].[Catalog.AcquiringTerminal.v]([Counterpartie], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.AcquiringTerminal.v.Department] ON [dbo].[Catalog.AcquiringTerminal.v]([Department], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.AcquiringTerminal.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Catalog.Bank.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Catalog.Bank.workflow];
    ALTER TABLE Documents ADD [Catalog.Bank.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Catalog.Bank.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Catalog.Bank.workflow] [workflow]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."Code1"') AS NVARCHAR(150)), '') [Code1]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."Code2"') AS NVARCHAR(150)), '') [Code2]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."Address"') AS NVARCHAR(150)), '') [Address]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."KorrAccount"') AS NVARCHAR(150)), '') [KorrAccount]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."isActive"') AS BIT), 0) [isActive]
    FROM dbo.[Documents]
    WHERE [type] = 'Catalog.Bank'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Catalog.Bank.v.id] ON [dbo].[Catalog.Bank.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Bank.v.decription] ON [dbo].[Catalog.Bank.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Bank.v.code] ON [dbo].[Catalog.Bank.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Bank.v.company] ON [dbo].[Catalog.Bank.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Bank.v.parent] ON [dbo].[Catalog.Bank.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Bank.v.date] ON [dbo].[Catalog.Bank.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Bank.v.isfolder] ON [dbo].[Catalog.Bank.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Bank.v.workflow] ON [dbo].[Catalog.Bank.v]([workflow], [id]);
    GO
    GRANT SELECT ON [dbo].[Catalog.Bank.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Document.ExchangeRates.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Document.ExchangeRates.workflow];
    ALTER TABLE Documents ADD [Document.ExchangeRates.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Document.ExchangeRates.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Document.ExchangeRates.workflow] [workflow]
    FROM dbo.[Documents]
    WHERE [type] = 'Document.ExchangeRates'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Document.ExchangeRates.v.id] ON [dbo].[Document.ExchangeRates.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.ExchangeRates.v.decription] ON [dbo].[Document.ExchangeRates.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.ExchangeRates.v.code] ON [dbo].[Document.ExchangeRates.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.ExchangeRates.v.company] ON [dbo].[Document.ExchangeRates.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.ExchangeRates.v.parent] ON [dbo].[Document.ExchangeRates.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.ExchangeRates.v.date] ON [dbo].[Document.ExchangeRates.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.ExchangeRates.v.isfolder] ON [dbo].[Document.ExchangeRates.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Document.ExchangeRates.v.workflow] ON [dbo].[Document.ExchangeRates.v]([workflow], [id]);
    GO
    GRANT SELECT ON [dbo].[Document.ExchangeRates.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Document.Invoice.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Document.Invoice.workflow];
    ALTER TABLE Documents ADD [Document.Invoice.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Document.Invoice.Department];
    ALTER TABLE Documents ADD [Document.Invoice.Department] AS CAST(JSON_VALUE(doc, N'$."Department"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Document.Invoice.Storehouse];
    ALTER TABLE Documents ADD [Document.Invoice.Storehouse] AS CAST(JSON_VALUE(doc, N'$."Storehouse"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Document.Invoice.Customer];
    ALTER TABLE Documents ADD [Document.Invoice.Customer] AS CAST(JSON_VALUE(doc, N'$."Customer"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Document.Invoice.Manager];
    ALTER TABLE Documents ADD [Document.Invoice.Manager] AS CAST(JSON_VALUE(doc, N'$."Manager"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Document.Invoice.currency];
    ALTER TABLE Documents ADD [Document.Invoice.currency] AS CAST(JSON_VALUE(doc, N'$."currency"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Document.Invoice.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Document.Invoice.workflow] [workflow]
      , [Document.Invoice.Department] [Department]
      , [Document.Invoice.Storehouse] [Storehouse]
      , [Document.Invoice.Customer] [Customer]
      , [Document.Invoice.Manager] [Manager]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."Status"') AS NVARCHAR(150)), '') [Status]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."PayDay"') AS NVARCHAR(150)), '') [PayDay]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."Amount"') AS MONEY), 0) [Amount]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."Tax"') AS MONEY), 0) [Tax]
      , [Document.Invoice.currency] [currency]
    FROM dbo.[Documents]
    WHERE [type] = 'Document.Invoice'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Document.Invoice.v.id] ON [dbo].[Document.Invoice.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Invoice.v.decription] ON [dbo].[Document.Invoice.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Invoice.v.code] ON [dbo].[Document.Invoice.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Invoice.v.company] ON [dbo].[Document.Invoice.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Invoice.v.parent] ON [dbo].[Document.Invoice.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Invoice.v.date] ON [dbo].[Document.Invoice.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Invoice.v.isfolder] ON [dbo].[Document.Invoice.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Invoice.v.workflow] ON [dbo].[Document.Invoice.v]([workflow], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Invoice.v.Department] ON [dbo].[Document.Invoice.v]([Department], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Invoice.v.Storehouse] ON [dbo].[Document.Invoice.v]([Storehouse], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Invoice.v.Customer] ON [dbo].[Document.Invoice.v]([Customer], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Invoice.v.Manager] ON [dbo].[Document.Invoice.v]([Manager], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Invoice.v.currency] ON [dbo].[Document.Invoice.v]([currency], [id]);
    GO
    GRANT SELECT ON [dbo].[Document.Invoice.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Document.Operation.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Document.Operation.workflow];
    ALTER TABLE Documents ADD [Document.Operation.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Document.Operation.Group];
    ALTER TABLE Documents ADD [Document.Operation.Group] AS CAST(JSON_VALUE(doc, N'$."Group"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Document.Operation.Operation];
    ALTER TABLE Documents ADD [Document.Operation.Operation] AS CAST(JSON_VALUE(doc, N'$."Operation"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Document.Operation.currency];
    ALTER TABLE Documents ADD [Document.Operation.currency] AS CAST(JSON_VALUE(doc, N'$."currency"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Document.Operation.f1];
    ALTER TABLE Documents ADD [Document.Operation.f1] AS CAST(JSON_VALUE(doc, N'$."f1"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Document.Operation.f2];
    ALTER TABLE Documents ADD [Document.Operation.f2] AS CAST(JSON_VALUE(doc, N'$."f2"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Document.Operation.f3];
    ALTER TABLE Documents ADD [Document.Operation.f3] AS CAST(JSON_VALUE(doc, N'$."f3"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Document.Operation.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Document.Operation.workflow] [workflow]
      , [Document.Operation.Group] [Group]
      , [Document.Operation.Operation] [Operation]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."Amount"') AS MONEY), 0) [Amount]
      , [Document.Operation.currency] [currency]
      , [Document.Operation.f1] [f1]
      , [Document.Operation.f2] [f2]
      , [Document.Operation.f3] [f3]
    FROM dbo.[Documents]
    WHERE [type] = 'Document.Operation'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Document.Operation.v.id] ON [dbo].[Document.Operation.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.decription] ON [dbo].[Document.Operation.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.code] ON [dbo].[Document.Operation.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.company] ON [dbo].[Document.Operation.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.parent] ON [dbo].[Document.Operation.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.date] ON [dbo].[Document.Operation.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.isfolder] ON [dbo].[Document.Operation.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.workflow] ON [dbo].[Document.Operation.v]([workflow], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.Group] ON [dbo].[Document.Operation.v]([Group], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.Operation] ON [dbo].[Document.Operation.v]([Operation], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.currency] ON [dbo].[Document.Operation.v]([currency], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.f1] ON [dbo].[Document.Operation.v]([f1], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.f2] ON [dbo].[Document.Operation.v]([f2], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.f3] ON [dbo].[Document.Operation.v]([f3], [id]);
    GO
    GRANT SELECT ON [dbo].[Document.Operation.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Document.PriceList.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Document.PriceList.workflow];
    ALTER TABLE Documents ADD [Document.PriceList.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Document.PriceList.PriceType];
    ALTER TABLE Documents ADD [Document.PriceList.PriceType] AS CAST(JSON_VALUE(doc, N'$."PriceType"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Document.PriceList.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Document.PriceList.workflow] [workflow]
      , [Document.PriceList.PriceType] [PriceType]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."TaxInclude"') AS BIT), 0) [TaxInclude]
    FROM dbo.[Documents]
    WHERE [type] = 'Document.PriceList'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Document.PriceList.v.id] ON [dbo].[Document.PriceList.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.PriceList.v.decription] ON [dbo].[Document.PriceList.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.PriceList.v.code] ON [dbo].[Document.PriceList.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.PriceList.v.company] ON [dbo].[Document.PriceList.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.PriceList.v.parent] ON [dbo].[Document.PriceList.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.PriceList.v.date] ON [dbo].[Document.PriceList.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.PriceList.v.isfolder] ON [dbo].[Document.PriceList.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Document.PriceList.v.workflow] ON [dbo].[Document.PriceList.v]([workflow], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.PriceList.v.PriceType] ON [dbo].[Document.PriceList.v]([PriceType], [id]);
    GO
    GRANT SELECT ON [dbo].[Document.PriceList.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Document.Settings.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Document.Settings.workflow];
    ALTER TABLE Documents ADD [Document.Settings.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Document.Settings.balanceCurrency];
    ALTER TABLE Documents ADD [Document.Settings.balanceCurrency] AS CAST(JSON_VALUE(doc, N'$."balanceCurrency"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Document.Settings.accountingCurrency];
    ALTER TABLE Documents ADD [Document.Settings.accountingCurrency] AS CAST(JSON_VALUE(doc, N'$."accountingCurrency"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Document.Settings.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Document.Settings.workflow] [workflow]
      , [Document.Settings.balanceCurrency] [balanceCurrency]
      , [Document.Settings.accountingCurrency] [accountingCurrency]
    FROM dbo.[Documents]
    WHERE [type] = 'Document.Settings'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Document.Settings.v.id] ON [dbo].[Document.Settings.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Settings.v.decription] ON [dbo].[Document.Settings.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Settings.v.code] ON [dbo].[Document.Settings.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Settings.v.company] ON [dbo].[Document.Settings.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Settings.v.parent] ON [dbo].[Document.Settings.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Settings.v.date] ON [dbo].[Document.Settings.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Settings.v.isfolder] ON [dbo].[Document.Settings.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Settings.v.workflow] ON [dbo].[Document.Settings.v]([workflow], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Settings.v.balanceCurrency] ON [dbo].[Document.Settings.v]([balanceCurrency], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Settings.v.accountingCurrency] ON [dbo].[Document.Settings.v]([accountingCurrency], [id]);
    GO
    GRANT SELECT ON [dbo].[Document.Settings.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Document.UserSettings.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Document.UserSettings.workflow];
    ALTER TABLE Documents ADD [Document.UserSettings.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Document.UserSettings.UserOrGroup];
    ALTER TABLE Documents ADD [Document.UserSettings.UserOrGroup] AS CAST(JSON_VALUE(doc, N'$."UserOrGroup"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Document.UserSettings.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Document.UserSettings.workflow] [workflow]
      , [Document.UserSettings.UserOrGroup] [UserOrGroup]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."COMP"') AS BIT), 0) [COMP]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."DEPT"') AS BIT), 0) [DEPT]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."STOR"') AS BIT), 0) [STOR]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."CASH"') AS BIT), 0) [CASH]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."BANK"') AS BIT), 0) [BANK]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."GROUP"') AS BIT), 0) [GROUP]
    FROM dbo.[Documents]
    WHERE [type] = 'Document.UserSettings'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Document.UserSettings.v.id] ON [dbo].[Document.UserSettings.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.UserSettings.v.decription] ON [dbo].[Document.UserSettings.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.UserSettings.v.code] ON [dbo].[Document.UserSettings.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.UserSettings.v.company] ON [dbo].[Document.UserSettings.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.UserSettings.v.parent] ON [dbo].[Document.UserSettings.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.UserSettings.v.date] ON [dbo].[Document.UserSettings.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.UserSettings.v.isfolder] ON [dbo].[Document.UserSettings.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Document.UserSettings.v.workflow] ON [dbo].[Document.UserSettings.v]([workflow], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.UserSettings.v.UserOrGroup] ON [dbo].[Document.UserSettings.v]([UserOrGroup], [id]);
    GO
    GRANT SELECT ON [dbo].[Document.UserSettings.v] TO JETTI;
    GO
    -------------------------
    
    DROP VIEW IF EXISTS [dbo].[Document.WorkFlow.v];
    GO
    
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Document.WorkFlow.workflow];
    ALTER TABLE Documents ADD [Document.WorkFlow.workflow] AS CAST(JSON_VALUE(doc, N'$."workflow"') AS UNIQUEIDENTIFIER) PERSISTED;
    ALTER TABLE Documents DROP COLUMN IF EXISTS [Document.WorkFlow.Document];
    ALTER TABLE Documents ADD [Document.WorkFlow.Document] AS CAST(JSON_VALUE(doc, N'$."Document"') AS UNIQUEIDENTIFIER) PERSISTED;;
    GO
    CREATE VIEW [dbo].[Document.WorkFlow.v]
    WITH SCHEMABINDING
    AS
      SELECT
        id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
        
      , [Document.WorkFlow.workflow] [workflow]
      , [Document.WorkFlow.Document] [Document]
      , ISNULL(CAST(JSON_VALUE(doc, N'$."Status"') AS NVARCHAR(150)), '') [Status]
    FROM dbo.[Documents]
    WHERE [type] = 'Document.WorkFlow'
    GO

    CREATE UNIQUE CLUSTERED INDEX [Document.WorkFlow.v.id] ON [dbo].[Document.WorkFlow.v]([id],[type], [description]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.WorkFlow.v.decription] ON [dbo].[Document.WorkFlow.v]([description],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.WorkFlow.v.code] ON [dbo].[Document.WorkFlow.v]([code],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.WorkFlow.v.company] ON [dbo].[Document.WorkFlow.v]([company],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.WorkFlow.v.parent] ON [dbo].[Document.WorkFlow.v]([parent],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.WorkFlow.v.date] ON [dbo].[Document.WorkFlow.v]([date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.WorkFlow.v.isfolder] ON [dbo].[Document.WorkFlow.v]([isfolder],[id]);
    
    CREATE UNIQUE NONCLUSTERED INDEX [Document.WorkFlow.v.workflow] ON [dbo].[Document.WorkFlow.v]([workflow], [id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.WorkFlow.v.Document] ON [dbo].[Document.WorkFlow.v]([Document], [id]);
    GO
    GRANT SELECT ON [dbo].[Document.WorkFlow.v] TO JETTI;
    GO
    -------------------------
    