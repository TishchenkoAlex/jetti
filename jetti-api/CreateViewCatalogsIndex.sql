
      
      DROP SECURITY POLICY [rls].[companyAccessPolicy]
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.Account.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."isForex"')), 0) [isForex]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."isActive"')), 0) [isActive]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."isPassive"')), 0) [isPassive]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.Account'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.Account.v] ON [Catalog.Account.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Account.v.code.f] ON [Catalog.Account.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Account.v.description.f] ON [Catalog.Account.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Account.v.description] ON [Catalog.Account.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Account.v.code] ON [Catalog.Account.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Account.v.user] ON [Catalog.Account.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Account.v.company] ON [Catalog.Account.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.Account.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.Balance.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."isActive"')), 0) [isActive]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."isPassive"')), 0) [isPassive]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.Balance'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.Balance.v] ON [Catalog.Balance.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Balance.v.code.f] ON [Catalog.Balance.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Balance.v.description.f] ON [Catalog.Balance.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Balance.v.description] ON [Catalog.Balance.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Balance.v.code] ON [Catalog.Balance.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Balance.v.user] ON [Catalog.Balance.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Balance.v.company] ON [Catalog.Balance.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.Balance.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.Balance.Analytics.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.Balance.Analytics'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.Balance.Analytics.v] ON [Catalog.Balance.Analytics.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Balance.Analytics.v.code.f] ON [Catalog.Balance.Analytics.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Balance.Analytics.v.description.f] ON [Catalog.Balance.Analytics.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Balance.Analytics.v.description] ON [Catalog.Balance.Analytics.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Balance.Analytics.v.code] ON [Catalog.Balance.Analytics.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Balance.Analytics.v.user] ON [Catalog.Balance.Analytics.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Balance.Analytics.v.company] ON [Catalog.Balance.Analytics.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.Balance.Analytics.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.BankAccount.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."currency"')) [currency]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Department"')) [Department]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Bank"')) [Bank]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."isDefault"')), 0) [isDefault]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.BankAccount'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.BankAccount.v] ON [Catalog.BankAccount.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BankAccount.v.code.f] ON [Catalog.BankAccount.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BankAccount.v.description.f] ON [Catalog.BankAccount.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BankAccount.v.description] ON [Catalog.BankAccount.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BankAccount.v.code] ON [Catalog.BankAccount.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BankAccount.v.user] ON [Catalog.BankAccount.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BankAccount.v.company] ON [Catalog.BankAccount.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.BankAccount.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.CashFlow.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.CashFlow'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.CashFlow.v] ON [Catalog.CashFlow.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.CashFlow.v.code.f] ON [Catalog.CashFlow.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.CashFlow.v.description.f] ON [Catalog.CashFlow.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.CashFlow.v.description] ON [Catalog.CashFlow.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.CashFlow.v.code] ON [Catalog.CashFlow.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.CashFlow.v.user] ON [Catalog.CashFlow.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.CashFlow.v.company] ON [Catalog.CashFlow.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.CashFlow.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.CashRegister.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."currency"')) [currency]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Department"')) [Department]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."isAccounting"')), 0) [isAccounting]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.CashRegister'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.CashRegister.v] ON [Catalog.CashRegister.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.CashRegister.v.code.f] ON [Catalog.CashRegister.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.CashRegister.v.description.f] ON [Catalog.CashRegister.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.CashRegister.v.description] ON [Catalog.CashRegister.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.CashRegister.v.code] ON [Catalog.CashRegister.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.CashRegister.v.user] ON [Catalog.CashRegister.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.CashRegister.v.company] ON [Catalog.CashRegister.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.CashRegister.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.Currency.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.Currency'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.Currency.v] ON [Catalog.Currency.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Currency.v.code.f] ON [Catalog.Currency.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Currency.v.description.f] ON [Catalog.Currency.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Currency.v.description] ON [Catalog.Currency.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Currency.v.code] ON [Catalog.Currency.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Currency.v.user] ON [Catalog.Currency.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Currency.v.company] ON [Catalog.Currency.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.Currency.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.Company.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."kind"')), '') [kind]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."FullName"')), '') [FullName]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."currency"')) [currency]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."prefix"')), '') [prefix]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Intercompany"')) [Intercompany]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."AddressShipping"')), '') [AddressShipping]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."AddressBilling"')), '') [AddressBilling]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Phone"')), '') [Phone]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Code1"')), '') [Code1]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Code2"')), '') [Code2]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Code3"')), '') [Code3]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."timeZone"')), '') [timeZone]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."TaxOffice"')) [TaxOffice]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.Company'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.Company.v] ON [Catalog.Company.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Company.v.code.f] ON [Catalog.Company.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Company.v.description.f] ON [Catalog.Company.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Company.v.description] ON [Catalog.Company.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Company.v.code] ON [Catalog.Company.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Company.v.user] ON [Catalog.Company.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Company.v.company] ON [Catalog.Company.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.Company.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.Counterpartie.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."kind"')), '') [kind]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."FullName"')), '') [FullName]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Department"')) [Department]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."Client"')), 0) [Client]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."Supplier"')), 0) [Supplier]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."isInternal"')), 0) [isInternal]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."AddressShipping"')), '') [AddressShipping]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."AddressBilling"')), '') [AddressBilling]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Phone"')), '') [Phone]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Code1"')), '') [Code1]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Code2"')), '') [Code2]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Code3"')), '') [Code3]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.Counterpartie'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.Counterpartie.v] ON [Catalog.Counterpartie.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.v.code.f] ON [Catalog.Counterpartie.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.v.description.f] ON [Catalog.Counterpartie.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.v.description] ON [Catalog.Counterpartie.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.v.code] ON [Catalog.Counterpartie.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.v.user] ON [Catalog.Counterpartie.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.v.company] ON [Catalog.Counterpartie.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.Counterpartie.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.Counterpartie.BankAccount.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."currency"')) [currency]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Department"')) [Department]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Bank"')) [Bank]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."isDefault"')), 0) [isDefault]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."owner"')) [owner]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.Counterpartie.BankAccount'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.Counterpartie.BankAccount.v] ON [Catalog.Counterpartie.BankAccount.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.BankAccount.v.code.f] ON [Catalog.Counterpartie.BankAccount.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.BankAccount.v.description.f] ON [Catalog.Counterpartie.BankAccount.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.BankAccount.v.description] ON [Catalog.Counterpartie.BankAccount.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.BankAccount.v.code] ON [Catalog.Counterpartie.BankAccount.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.BankAccount.v.user] ON [Catalog.Counterpartie.BankAccount.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.BankAccount.v.company] ON [Catalog.Counterpartie.BankAccount.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.Counterpartie.BankAccount.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.Contract.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."owner"')) [owner]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Status"')), '') [Status]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."kind"')), '') [kind]
      , TRY_CONVERT(DATE, JSON_VALUE(doc, N'$.StartDate'),127) [StartDate]
      , TRY_CONVERT(DATE, JSON_VALUE(doc, N'$.EndDate'),127) [EndDate]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."BusinessDirection"')) [BusinessDirection]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."CashFlow"')) [CashFlow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."currency"')) [currency]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."BankAccount"')) [BankAccount]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Manager"')) [Manager]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."isDefault"')), 0) [isDefault]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."notAccounting"')), 0) [notAccounting]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.Contract'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.Contract.v] ON [Catalog.Contract.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Contract.v.code.f] ON [Catalog.Contract.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Contract.v.description.f] ON [Catalog.Contract.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Contract.v.description] ON [Catalog.Contract.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Contract.v.code] ON [Catalog.Contract.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Contract.v.user] ON [Catalog.Contract.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Contract.v.company] ON [Catalog.Contract.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.Contract.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.BusinessDirection.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.BusinessDirection'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.BusinessDirection.v] ON [Catalog.BusinessDirection.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BusinessDirection.v.code.f] ON [Catalog.BusinessDirection.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BusinessDirection.v.description.f] ON [Catalog.BusinessDirection.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BusinessDirection.v.description] ON [Catalog.BusinessDirection.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BusinessDirection.v.code] ON [Catalog.BusinessDirection.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BusinessDirection.v.user] ON [Catalog.BusinessDirection.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BusinessDirection.v.company] ON [Catalog.BusinessDirection.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.BusinessDirection.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.Department.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."BusinessRegion"')) [BusinessRegion]
      , TRY_CONVERT(DATE, JSON_VALUE(doc, N'$.OpeningDate'),127) [OpeningDate]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."TaxOffice"')) [TaxOffice]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.Department'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.Department.v] ON [Catalog.Department.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Department.v.code.f] ON [Catalog.Department.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Department.v.description.f] ON [Catalog.Department.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Department.v.description] ON [Catalog.Department.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Department.v.code] ON [Catalog.Department.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Department.v.user] ON [Catalog.Department.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Department.v.company] ON [Catalog.Department.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.Department.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.Expense.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Account"')) [Account]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.Expense'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.Expense.v] ON [Catalog.Expense.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Expense.v.code.f] ON [Catalog.Expense.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Expense.v.description.f] ON [Catalog.Expense.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Expense.v.description] ON [Catalog.Expense.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Expense.v.code] ON [Catalog.Expense.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Expense.v.user] ON [Catalog.Expense.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Expense.v.company] ON [Catalog.Expense.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.Expense.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.Expense.Analytics.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.Expense.Analytics'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.Expense.Analytics.v] ON [Catalog.Expense.Analytics.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Expense.Analytics.v.code.f] ON [Catalog.Expense.Analytics.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Expense.Analytics.v.description.f] ON [Catalog.Expense.Analytics.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Expense.Analytics.v.description] ON [Catalog.Expense.Analytics.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Expense.Analytics.v.code] ON [Catalog.Expense.Analytics.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Expense.Analytics.v.user] ON [Catalog.Expense.Analytics.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Expense.Analytics.v.company] ON [Catalog.Expense.Analytics.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.Expense.Analytics.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.Income.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Account"')) [Account]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.Income'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.Income.v] ON [Catalog.Income.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Income.v.code.f] ON [Catalog.Income.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Income.v.description.f] ON [Catalog.Income.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Income.v.description] ON [Catalog.Income.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Income.v.code] ON [Catalog.Income.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Income.v.user] ON [Catalog.Income.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Income.v.company] ON [Catalog.Income.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.Income.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.Loan.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."owner"')) [owner]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."kind"')), '') [kind]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."currency"')) [currency]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."loanType"')) [loanType]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Department"')) [Department]
      , TRY_CONVERT(DATE, JSON_VALUE(doc, N'$.PayDay'),127) [PayDay]
      , TRY_CONVERT(DATE, JSON_VALUE(doc, N'$.CloseDay'),127) [CloseDay]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.Loan'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.Loan.v] ON [Catalog.Loan.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Loan.v.code.f] ON [Catalog.Loan.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Loan.v.description.f] ON [Catalog.Loan.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Loan.v.description] ON [Catalog.Loan.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Loan.v.code] ON [Catalog.Loan.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Loan.v.user] ON [Catalog.Loan.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Loan.v.company] ON [Catalog.Loan.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.Loan.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.LoanTypes.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.LoanTypes'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.LoanTypes.v] ON [Catalog.LoanTypes.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.LoanTypes.v.code.f] ON [Catalog.LoanTypes.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.LoanTypes.v.description.f] ON [Catalog.LoanTypes.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.LoanTypes.v.description] ON [Catalog.LoanTypes.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.LoanTypes.v.code] ON [Catalog.LoanTypes.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.LoanTypes.v.user] ON [Catalog.LoanTypes.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.LoanTypes.v.company] ON [Catalog.LoanTypes.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.LoanTypes.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.Manager.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."FullName"')), '') [FullName]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."Gender"')), 0) [Gender]
      , TRY_CONVERT(DATE, JSON_VALUE(doc, N'$.Birthday'),127) [Birthday]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.Manager'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.Manager.v] ON [Catalog.Manager.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Manager.v.code.f] ON [Catalog.Manager.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Manager.v.description.f] ON [Catalog.Manager.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Manager.v.description] ON [Catalog.Manager.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Manager.v.code] ON [Catalog.Manager.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Manager.v.user] ON [Catalog.Manager.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Manager.v.company] ON [Catalog.Manager.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.Manager.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.Person.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Code1"')), '') [Code1]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Code2"')), '') [Code2]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Address"')), '') [Address]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Phone"')), '') [Phone]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Department"')) [Department]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."JobTitle"')) [JobTitle]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Profile"')), '') [Profile]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.Person'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.Person.v] ON [Catalog.Person.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Person.v.code.f] ON [Catalog.Person.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Person.v.description.f] ON [Catalog.Person.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Person.v.description] ON [Catalog.Person.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Person.v.code] ON [Catalog.Person.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Person.v.user] ON [Catalog.Person.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Person.v.company] ON [Catalog.Person.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.Person.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.PriceType.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."currency"')) [currency]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."TaxInclude"')), 0) [TaxInclude]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.PriceType'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.PriceType.v] ON [Catalog.PriceType.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.PriceType.v.code.f] ON [Catalog.PriceType.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.PriceType.v.description.f] ON [Catalog.PriceType.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.PriceType.v.description] ON [Catalog.PriceType.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.PriceType.v.code] ON [Catalog.PriceType.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.PriceType.v.user] ON [Catalog.PriceType.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.PriceType.v.company] ON [Catalog.PriceType.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.PriceType.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.Product.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."ProductKind"')) [ProductKind]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."ProductCategory"')) [ProductCategory]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Brand"')) [Brand]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Unit"')) [Unit]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.Product'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.Product.v] ON [Catalog.Product.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Product.v.code.f] ON [Catalog.Product.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Product.v.description.f] ON [Catalog.Product.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Product.v.description] ON [Catalog.Product.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Product.v.code] ON [Catalog.Product.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Product.v.user] ON [Catalog.Product.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Product.v.company] ON [Catalog.Product.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.Product.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.ProductCategory.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.ProductCategory'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.ProductCategory.v] ON [Catalog.ProductCategory.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ProductCategory.v.code.f] ON [Catalog.ProductCategory.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ProductCategory.v.description.f] ON [Catalog.ProductCategory.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ProductCategory.v.description] ON [Catalog.ProductCategory.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ProductCategory.v.code] ON [Catalog.ProductCategory.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ProductCategory.v.user] ON [Catalog.ProductCategory.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ProductCategory.v.company] ON [Catalog.ProductCategory.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.ProductCategory.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.ProductKind.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."ProductType"')), '') [ProductType]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.ProductKind'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.ProductKind.v] ON [Catalog.ProductKind.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ProductKind.v.code.f] ON [Catalog.ProductKind.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ProductKind.v.description.f] ON [Catalog.ProductKind.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ProductKind.v.description] ON [Catalog.ProductKind.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ProductKind.v.code] ON [Catalog.ProductKind.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ProductKind.v.user] ON [Catalog.ProductKind.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ProductKind.v.company] ON [Catalog.ProductKind.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.ProductKind.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.Storehouse.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Department"')) [Department]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.Storehouse'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.Storehouse.v] ON [Catalog.Storehouse.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Storehouse.v.code.f] ON [Catalog.Storehouse.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Storehouse.v.description.f] ON [Catalog.Storehouse.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Storehouse.v.description] ON [Catalog.Storehouse.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Storehouse.v.code] ON [Catalog.Storehouse.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Storehouse.v.user] ON [Catalog.Storehouse.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Storehouse.v.company] ON [Catalog.Storehouse.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.Storehouse.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.Operation.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Group"')) [Group]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."script"')), '') [script]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."module"')), '') [module]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.Operation'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.Operation.v] ON [Catalog.Operation.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.v.code.f] ON [Catalog.Operation.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.v.description.f] ON [Catalog.Operation.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.v.description] ON [Catalog.Operation.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.v.code] ON [Catalog.Operation.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.v.user] ON [Catalog.Operation.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.v.company] ON [Catalog.Operation.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.Operation.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.Operation.Group.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Prefix"')), '') [Prefix]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.Operation.Group'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.Operation.Group.v] ON [Catalog.Operation.Group.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.Group.v.code.f] ON [Catalog.Operation.Group.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.Group.v.description.f] ON [Catalog.Operation.Group.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.Group.v.description] ON [Catalog.Operation.Group.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.Group.v.code] ON [Catalog.Operation.Group.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.Group.v.user] ON [Catalog.Operation.Group.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.Group.v.company] ON [Catalog.Operation.Group.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.Operation.Group.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.Operation.Type.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.Operation.Type'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.Operation.Type.v] ON [Catalog.Operation.Type.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.Type.v.code.f] ON [Catalog.Operation.Type.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.Type.v.description.f] ON [Catalog.Operation.Type.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.Type.v.description] ON [Catalog.Operation.Type.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.Type.v.code] ON [Catalog.Operation.Type.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.Type.v.user] ON [Catalog.Operation.Type.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Operation.Type.v.company] ON [Catalog.Operation.Type.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.Operation.Type.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.Unit.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.Unit'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.Unit.v] ON [Catalog.Unit.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Unit.v.code.f] ON [Catalog.Unit.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Unit.v.description.f] ON [Catalog.Unit.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Unit.v.description] ON [Catalog.Unit.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Unit.v.code] ON [Catalog.Unit.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Unit.v.user] ON [Catalog.Unit.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Unit.v.company] ON [Catalog.Unit.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.Unit.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.User.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."isAdmin"')), 0) [isAdmin]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Person"')) [Person]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Department"')) [Department]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.User'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.User.v] ON [Catalog.User.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.User.v.code.f] ON [Catalog.User.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.User.v.description.f] ON [Catalog.User.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.User.v.description] ON [Catalog.User.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.User.v.code] ON [Catalog.User.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.User.v.user] ON [Catalog.User.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.User.v.company] ON [Catalog.User.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.User.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.UsersGroup.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.UsersGroup'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.UsersGroup.v] ON [Catalog.UsersGroup.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.UsersGroup.v.code.f] ON [Catalog.UsersGroup.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.UsersGroup.v.description.f] ON [Catalog.UsersGroup.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.UsersGroup.v.description] ON [Catalog.UsersGroup.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.UsersGroup.v.code] ON [Catalog.UsersGroup.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.UsersGroup.v.user] ON [Catalog.UsersGroup.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.UsersGroup.v.company] ON [Catalog.UsersGroup.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.UsersGroup.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.Role.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.Role'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.Role.v] ON [Catalog.Role.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Role.v.code.f] ON [Catalog.Role.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Role.v.description.f] ON [Catalog.Role.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Role.v.description] ON [Catalog.Role.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Role.v.code] ON [Catalog.Role.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Role.v.user] ON [Catalog.Role.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Role.v.company] ON [Catalog.Role.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.Role.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.SubSystem.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."icon"')), '') [icon]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.SubSystem'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.SubSystem.v] ON [Catalog.SubSystem.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.SubSystem.v.code.f] ON [Catalog.SubSystem.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.SubSystem.v.description.f] ON [Catalog.SubSystem.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.SubSystem.v.description] ON [Catalog.SubSystem.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.SubSystem.v.code] ON [Catalog.SubSystem.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.SubSystem.v.user] ON [Catalog.SubSystem.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.SubSystem.v.company] ON [Catalog.SubSystem.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.SubSystem.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.JobTitle.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.JobTitle'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.JobTitle.v] ON [Catalog.JobTitle.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.JobTitle.v.code.f] ON [Catalog.JobTitle.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.JobTitle.v.description.f] ON [Catalog.JobTitle.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.JobTitle.v.description] ON [Catalog.JobTitle.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.JobTitle.v.code] ON [Catalog.JobTitle.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.JobTitle.v.user] ON [Catalog.JobTitle.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.JobTitle.v.company] ON [Catalog.JobTitle.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.JobTitle.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.Brand.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.Brand'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.Brand.v] ON [Catalog.Brand.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Brand.v.code.f] ON [Catalog.Brand.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Brand.v.description.f] ON [Catalog.Brand.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Brand.v.description] ON [Catalog.Brand.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Brand.v.code] ON [Catalog.Brand.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Brand.v.user] ON [Catalog.Brand.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Brand.v.company] ON [Catalog.Brand.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.Brand.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.GroupObjectsExploitation.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Method"')), '') [Method]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.GroupObjectsExploitation'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.GroupObjectsExploitation.v] ON [Catalog.GroupObjectsExploitation.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.GroupObjectsExploitation.v.code.f] ON [Catalog.GroupObjectsExploitation.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.GroupObjectsExploitation.v.description.f] ON [Catalog.GroupObjectsExploitation.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.GroupObjectsExploitation.v.description] ON [Catalog.GroupObjectsExploitation.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.GroupObjectsExploitation.v.code] ON [Catalog.GroupObjectsExploitation.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.GroupObjectsExploitation.v.user] ON [Catalog.GroupObjectsExploitation.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.GroupObjectsExploitation.v.company] ON [Catalog.GroupObjectsExploitation.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.GroupObjectsExploitation.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.ObjectsExploitation.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Group"')) [Group]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."InventoryNumber"')), '') [InventoryNumber]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.ObjectsExploitation'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.ObjectsExploitation.v] ON [Catalog.ObjectsExploitation.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ObjectsExploitation.v.code.f] ON [Catalog.ObjectsExploitation.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ObjectsExploitation.v.description.f] ON [Catalog.ObjectsExploitation.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ObjectsExploitation.v.description] ON [Catalog.ObjectsExploitation.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ObjectsExploitation.v.code] ON [Catalog.ObjectsExploitation.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ObjectsExploitation.v.user] ON [Catalog.ObjectsExploitation.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ObjectsExploitation.v.company] ON [Catalog.ObjectsExploitation.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.ObjectsExploitation.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.Catalog.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."prefix"')), '') [prefix]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."icon"')), '') [icon]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."menu"')), '') [menu]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."presentation"')), '') [presentation]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."hierarchy"')), '') [hierarchy]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."module"')), '') [module]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.Catalog'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.Catalog.v] ON [Catalog.Catalog.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Catalog.v.code.f] ON [Catalog.Catalog.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Catalog.v.description.f] ON [Catalog.Catalog.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Catalog.v.description] ON [Catalog.Catalog.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Catalog.v.code] ON [Catalog.Catalog.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Catalog.v.user] ON [Catalog.Catalog.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Catalog.v.company] ON [Catalog.Catalog.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.Catalog.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.BudgetItem.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.BudgetItem'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.BudgetItem.v] ON [Catalog.BudgetItem.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BudgetItem.v.code.f] ON [Catalog.BudgetItem.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BudgetItem.v.description.f] ON [Catalog.BudgetItem.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BudgetItem.v.description] ON [Catalog.BudgetItem.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BudgetItem.v.code] ON [Catalog.BudgetItem.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BudgetItem.v.user] ON [Catalog.BudgetItem.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BudgetItem.v.company] ON [Catalog.BudgetItem.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.BudgetItem.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.Scenario.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."currency"')) [currency]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.Scenario'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.Scenario.v] ON [Catalog.Scenario.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Scenario.v.code.f] ON [Catalog.Scenario.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Scenario.v.description.f] ON [Catalog.Scenario.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Scenario.v.description] ON [Catalog.Scenario.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Scenario.v.code] ON [Catalog.Scenario.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Scenario.v.user] ON [Catalog.Scenario.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Scenario.v.company] ON [Catalog.Scenario.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.Scenario.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.AcquiringTerminal.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."BankAccount"')) [BankAccount]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Counterpartie"')) [Counterpartie]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Department"')) [Department]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."isDefault"')), 0) [isDefault]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.AcquiringTerminal'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.AcquiringTerminal.v] ON [Catalog.AcquiringTerminal.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.AcquiringTerminal.v.code.f] ON [Catalog.AcquiringTerminal.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.AcquiringTerminal.v.description.f] ON [Catalog.AcquiringTerminal.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.AcquiringTerminal.v.description] ON [Catalog.AcquiringTerminal.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.AcquiringTerminal.v.code] ON [Catalog.AcquiringTerminal.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.AcquiringTerminal.v.user] ON [Catalog.AcquiringTerminal.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.AcquiringTerminal.v.company] ON [Catalog.AcquiringTerminal.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.AcquiringTerminal.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.Bank.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Code1"')), '') [Code1]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Code2"')), '') [Code2]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Address"')), '') [Address]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."KorrAccount"')), '') [KorrAccount]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."isActive"')), 0) [isActive]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.Bank'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.Bank.v] ON [Catalog.Bank.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Bank.v.code.f] ON [Catalog.Bank.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Bank.v.description.f] ON [Catalog.Bank.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Bank.v.description] ON [Catalog.Bank.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Bank.v.code] ON [Catalog.Bank.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Bank.v.user] ON [Catalog.Bank.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Bank.v.company] ON [Catalog.Bank.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.Bank.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.Person.BankAccount.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."owner"')) [owner]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."SalaryProject"')) [SalaryProject]
      , TRY_CONVERT(DATE, JSON_VALUE(doc, N'$.OpenDate'),127) [OpenDate]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.Person.BankAccount'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.Person.BankAccount.v] ON [Catalog.Person.BankAccount.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Person.BankAccount.v.code.f] ON [Catalog.Person.BankAccount.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Person.BankAccount.v.description.f] ON [Catalog.Person.BankAccount.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Person.BankAccount.v.description] ON [Catalog.Person.BankAccount.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Person.BankAccount.v.code] ON [Catalog.Person.BankAccount.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Person.BankAccount.v.user] ON [Catalog.Person.BankAccount.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Person.BankAccount.v.company] ON [Catalog.Person.BankAccount.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.Person.BankAccount.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.BusinessRegion.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.BusinessRegion'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.BusinessRegion.v] ON [Catalog.BusinessRegion.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BusinessRegion.v.code.f] ON [Catalog.BusinessRegion.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BusinessRegion.v.description.f] ON [Catalog.BusinessRegion.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BusinessRegion.v.description] ON [Catalog.BusinessRegion.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BusinessRegion.v.code] ON [Catalog.BusinessRegion.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BusinessRegion.v.user] ON [Catalog.BusinessRegion.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BusinessRegion.v.company] ON [Catalog.BusinessRegion.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.BusinessRegion.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.TaxRate.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Rate"')), 0) [Rate]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.TaxRate'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.TaxRate.v] ON [Catalog.TaxRate.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.TaxRate.v.code.f] ON [Catalog.TaxRate.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.TaxRate.v.description.f] ON [Catalog.TaxRate.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.TaxRate.v.description] ON [Catalog.TaxRate.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.TaxRate.v.code] ON [Catalog.TaxRate.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.TaxRate.v.user] ON [Catalog.TaxRate.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.TaxRate.v.company] ON [Catalog.TaxRate.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.TaxRate.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.TaxPaymentCode.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."FullDescription"')), '') [FullDescription]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.TaxPaymentCode'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.TaxPaymentCode.v] ON [Catalog.TaxPaymentCode.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.TaxPaymentCode.v.code.f] ON [Catalog.TaxPaymentCode.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.TaxPaymentCode.v.description.f] ON [Catalog.TaxPaymentCode.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.TaxPaymentCode.v.description] ON [Catalog.TaxPaymentCode.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.TaxPaymentCode.v.code] ON [Catalog.TaxPaymentCode.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.TaxPaymentCode.v.user] ON [Catalog.TaxPaymentCode.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.TaxPaymentCode.v.company] ON [Catalog.TaxPaymentCode.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.TaxPaymentCode.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.TaxPaymentPeriod.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.TaxPaymentPeriod'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.TaxPaymentPeriod.v] ON [Catalog.TaxPaymentPeriod.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.TaxPaymentPeriod.v.code.f] ON [Catalog.TaxPaymentPeriod.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.TaxPaymentPeriod.v.description.f] ON [Catalog.TaxPaymentPeriod.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.TaxPaymentPeriod.v.description] ON [Catalog.TaxPaymentPeriod.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.TaxPaymentPeriod.v.code] ON [Catalog.TaxPaymentPeriod.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.TaxPaymentPeriod.v.user] ON [Catalog.TaxPaymentPeriod.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.TaxPaymentPeriod.v.company] ON [Catalog.TaxPaymentPeriod.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.TaxPaymentPeriod.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.TaxPayerStatus.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."FullDescription"')), '') [FullDescription]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.TaxPayerStatus'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.TaxPayerStatus.v] ON [Catalog.TaxPayerStatus.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.TaxPayerStatus.v.code.f] ON [Catalog.TaxPayerStatus.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.TaxPayerStatus.v.description.f] ON [Catalog.TaxPayerStatus.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.TaxPayerStatus.v.description] ON [Catalog.TaxPayerStatus.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.TaxPayerStatus.v.code] ON [Catalog.TaxPayerStatus.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.TaxPayerStatus.v.user] ON [Catalog.TaxPayerStatus.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.TaxPayerStatus.v.company] ON [Catalog.TaxPayerStatus.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.TaxPayerStatus.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.TaxOffice.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."FullName"')), '') [FullName]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Code1"')), '') [Code1]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Code2"')), '') [Code2]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Code3"')), '') [Code3]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.TaxOffice'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.TaxOffice.v] ON [Catalog.TaxOffice.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.TaxOffice.v.code.f] ON [Catalog.TaxOffice.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.TaxOffice.v.description.f] ON [Catalog.TaxOffice.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.TaxOffice.v.description] ON [Catalog.TaxOffice.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.TaxOffice.v.code] ON [Catalog.TaxOffice.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.TaxOffice.v.user] ON [Catalog.TaxOffice.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.TaxOffice.v.company] ON [Catalog.TaxOffice.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.TaxOffice.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.ReatailClient.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Email"')), '') [Email]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Gender"')), '') [Gender]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."FirstName"')), '') [FirstName]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."LastName"')), '') [LastName]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."MiddleName"')), '') [MiddleName]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Address"')), '') [Address]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.ReatailClient'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.ReatailClient.v] ON [Catalog.ReatailClient.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ReatailClient.v.code.f] ON [Catalog.ReatailClient.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ReatailClient.v.description.f] ON [Catalog.ReatailClient.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ReatailClient.v.description] ON [Catalog.ReatailClient.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ReatailClient.v.code] ON [Catalog.ReatailClient.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ReatailClient.v.user] ON [Catalog.ReatailClient.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.ReatailClient.v.company] ON [Catalog.ReatailClient.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.ReatailClient.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Catalog.SalaryProject.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."bank"')) [bank]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."currency"')) [currency]
      , TRY_CONVERT(DATE, JSON_VALUE(doc, N'$.OpenDate'),127) [OpenDate]
      FROM dbo.[Documents]
      WHERE [type] = 'Catalog.SalaryProject'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Catalog.SalaryProject.v] ON [Catalog.SalaryProject.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.SalaryProject.v.code.f] ON [Catalog.SalaryProject.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.SalaryProject.v.description.f] ON [Catalog.SalaryProject.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.SalaryProject.v.description] ON [Catalog.SalaryProject.v](description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.SalaryProject.v.code] ON [Catalog.SalaryProject.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.SalaryProject.v.user] ON [Catalog.SalaryProject.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Catalog.SalaryProject.v.company] ON [Catalog.SalaryProject.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Catalog.SalaryProject.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Document.ExchangeRates.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      FROM dbo.[Documents]
      WHERE [type] = 'Document.ExchangeRates'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Document.ExchangeRates.v] ON [Document.ExchangeRates.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Document.ExchangeRates.v.date] ON [Document.ExchangeRates.v](date,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.ExchangeRates.v.parent] ON [Document.ExchangeRates.v](parent,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.ExchangeRates.v.code] ON [Document.ExchangeRates.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.ExchangeRates.v.user] ON [Document.ExchangeRates.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.ExchangeRates.v.company] ON [Document.ExchangeRates.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Document.ExchangeRates.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Document.Invoice.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Department"')) [Department]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Storehouse"')) [Storehouse]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Customer"')) [Customer]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Manager"')) [Manager]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Status"')), '') [Status]
      , TRY_CONVERT(DATE, JSON_VALUE(doc, N'$.PayDay'),127) [PayDay]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Amount"')), 0) [Amount]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Tax"')), 0) [Tax]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."currency"')) [currency]
      FROM dbo.[Documents]
      WHERE [type] = 'Document.Invoice'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Document.Invoice.v] ON [Document.Invoice.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Document.Invoice.v.date] ON [Document.Invoice.v](date,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.Invoice.v.parent] ON [Document.Invoice.v](parent,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.Invoice.v.code] ON [Document.Invoice.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.Invoice.v.user] ON [Document.Invoice.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.Invoice.v.company] ON [Document.Invoice.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Document.Invoice.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Document.Operation.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Group"')) [Group]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Operation"')) [Operation]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Amount"')), 0) [Amount]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."currency"')) [currency]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f1"')) [f1]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f2"')) [f2]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f3"')) [f3]
      FROM dbo.[Documents]
      WHERE [type] = 'Document.Operation'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Document.Operation.v] ON [Document.Operation.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.date] ON [Document.Operation.v](date,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.parent] ON [Document.Operation.v](parent,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.code] ON [Document.Operation.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.user] ON [Document.Operation.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.company] ON [Document.Operation.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Document.Operation.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Document.PriceList.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."PriceType"')) [PriceType]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."TaxInclude"')), 0) [TaxInclude]
      FROM dbo.[Documents]
      WHERE [type] = 'Document.PriceList'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Document.PriceList.v] ON [Document.PriceList.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Document.PriceList.v.date] ON [Document.PriceList.v](date,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.PriceList.v.parent] ON [Document.PriceList.v](parent,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.PriceList.v.code] ON [Document.PriceList.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.PriceList.v.user] ON [Document.PriceList.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.PriceList.v.company] ON [Document.PriceList.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Document.PriceList.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Document.Settings.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."balanceCurrency"')) [balanceCurrency]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."accountingCurrency"')) [accountingCurrency]
      FROM dbo.[Documents]
      WHERE [type] = 'Document.Settings'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Document.Settings.v] ON [Document.Settings.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Document.Settings.v.date] ON [Document.Settings.v](date,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.Settings.v.parent] ON [Document.Settings.v](parent,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.Settings.v.code] ON [Document.Settings.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.Settings.v.user] ON [Document.Settings.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.Settings.v.company] ON [Document.Settings.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Document.Settings.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Document.UserSettings.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."UserOrGroup"')) [UserOrGroup]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."COMP"')), 0) [COMP]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."DEPT"')), 0) [DEPT]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."STOR"')), 0) [STOR]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."CASH"')), 0) [CASH]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."BANK"')), 0) [BANK]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."GROUP"')), 0) [GROUP]
      FROM dbo.[Documents]
      WHERE [type] = 'Document.UserSettings'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Document.UserSettings.v] ON [Document.UserSettings.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Document.UserSettings.v.date] ON [Document.UserSettings.v](date,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.UserSettings.v.parent] ON [Document.UserSettings.v](parent,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.UserSettings.v.code] ON [Document.UserSettings.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.UserSettings.v.user] ON [Document.UserSettings.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.UserSettings.v.company] ON [Document.UserSettings.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Document.UserSettings.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Document.WorkFlow.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Document"')) [Document]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Status"')), '') [Status]
      FROM dbo.[Documents]
      WHERE [type] = 'Document.WorkFlow'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Document.WorkFlow.v] ON [Document.WorkFlow.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Document.WorkFlow.v.date] ON [Document.WorkFlow.v](date,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.WorkFlow.v.parent] ON [Document.WorkFlow.v](parent,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.WorkFlow.v.code] ON [Document.WorkFlow.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.WorkFlow.v.user] ON [Document.WorkFlow.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.WorkFlow.v.company] ON [Document.WorkFlow.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Document.WorkFlow.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Document.CashRequest.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Status"')), '') [Status]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Operation"')), '') [Operation]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."PaymentKind"')), '') [PaymentKind]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."CashKind"')), '') [CashKind]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."PayRollKind"')), '') [PayRollKind]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Department"')) [Department]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."CashRecipient"')) [CashRecipient]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Contract"')) [Contract]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."CashFlow"')) [CashFlow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Loan"')) [Loan]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."CashOrBank"')) [CashOrBank]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."CashRecipientBankAccount"')) [CashRecipientBankAccount]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."CashOrBankIn"')) [CashOrBankIn]
      , TRY_CONVERT(DATE, JSON_VALUE(doc, N'$.PayDay'),127) [PayDay]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Amount"')), 0) [Amount]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."сurrency"')) [сurrency]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."ExpenseOrBalance"')) [ExpenseOrBalance]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."ExpenseAnalytics"')) [ExpenseAnalytics]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."BalanceAnalytics"')) [BalanceAnalytics]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."workflowID"')), '') [workflowID]
      FROM dbo.[Documents]
      WHERE [type] = 'Document.CashRequest'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Document.CashRequest.v] ON [Document.CashRequest.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Document.CashRequest.v.date] ON [Document.CashRequest.v](date,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.CashRequest.v.parent] ON [Document.CashRequest.v](parent,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.CashRequest.v.code] ON [Document.CashRequest.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.CashRequest.v.user] ON [Document.CashRequest.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.CashRequest.v.company] ON [Document.CashRequest.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Document.CashRequest.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE OR ALTER VIEW dbo.[Document.CashRequestRegistry.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Status"')), '') [Status]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Operation"')), '') [Operation]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."CashFlow"')) [CashFlow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."BusinessDirection"')) [BusinessDirection]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Amount"')), 0) [Amount]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."сurrency"')) [сurrency]
      FROM dbo.[Documents]
      WHERE [type] = 'Document.CashRequestRegistry'
    
      GO
      CREATE UNIQUE CLUSTERED INDEX [Document.CashRequestRegistry.v] ON [Document.CashRequestRegistry.v](id);
      
      CREATE UNIQUE NONCLUSTERED INDEX [Document.CashRequestRegistry.v.date] ON [Document.CashRequestRegistry.v](date,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.CashRequestRegistry.v.parent] ON [Document.CashRequestRegistry.v](parent,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.CashRequestRegistry.v.code] ON [Document.CashRequestRegistry.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.CashRequestRegistry.v.user] ON [Document.CashRequestRegistry.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.CashRequestRegistry.v.company] ON [Document.CashRequestRegistry.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[Document.CashRequestRegistry.v] TO jetti;
      GO
      --------------------------------------------------------------------------------------
      
      CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.Amount] ON [Document.Operation.v](Amount,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.Group] ON [Document.Operation.v]([Group],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.Operation] ON [Document.Operation.v](Operation,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.currency] ON [Document.Operation.v](currency,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.f1] ON [Document.Operation.v](f1,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.f2] ON [Document.Operation.v](f2,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.f3] ON [Document.Operation.v](f3,id) INCLUDE([company]);


      CREATE SECURITY POLICY [rls].[companyAccessPolicy] 
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.Account.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.Balance.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.Balance.Analytics.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.BankAccount.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.CashFlow.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.CashRegister.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.Currency.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.Company.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.Counterpartie.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.Counterpartie.BankAccount.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.Contract.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.BusinessDirection.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.Department.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.Expense.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.Expense.Analytics.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.Income.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.Loan.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.LoanTypes.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.Manager.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.Person.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.PriceType.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.Product.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.ProductCategory.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.ProductKind.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.Storehouse.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.Operation.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.Operation.Group.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.Operation.Type.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.Unit.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.User.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.UsersGroup.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.Role.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.SubSystem.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.JobTitle.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.Brand.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.GroupObjectsExploitation.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.ObjectsExploitation.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.Catalog.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.BudgetItem.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.Scenario.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.AcquiringTerminal.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.Bank.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.Person.BankAccount.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.BusinessRegion.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.TaxRate.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.TaxPaymentCode.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.TaxPaymentPeriod.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.TaxPayerStatus.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.TaxOffice.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.ReatailClient.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.SalaryProject.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Document.ExchangeRates.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Document.Invoice.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Document.Operation.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Document.PriceList.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Document.Settings.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Document.UserSettings.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Document.WorkFlow.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Document.CashRequest.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Document.CashRequestRegistry.v],
      ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Documents.Hisroty]
      WITH (STATE = ON, SCHEMABINDING = ON)
      GO