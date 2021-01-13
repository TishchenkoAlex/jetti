
------------------------------ BEGIN Catalog.Account ------------------------------

RAISERROR('Catalog.Account start', 0 ,1) WITH NOWAIT;
      
BEGIN TRY
  ALTER SECURITY POLICY[rls].[companyAccessPolicy] DROP FILTER PREDICATE ON[dbo].[Catalog.Account.v];
END TRY
BEGIN CATCH
END CATCH;
GO
CREATE OR ALTER VIEW dbo.[Catalog.Account.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user], [version]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."descriptionEng"')), '') [descriptionEng]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."isActive"')), 0) [isActive]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."isPassive"')), 0) [isPassive]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."isForex"')), 0) [isForex]
      FROM dbo.[Documents]
      WHERE [type] = N'Catalog.Account'
;
GO
CREATE UNIQUE CLUSTERED INDEX [Catalog.Account.v] ON [Catalog.Account.v](id);
        
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Account.v.deleted] ON [Catalog.Account.v](deleted,description,id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Account.v.code.f] ON [Catalog.Account.v](parent,isfolder,code,id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Account.v.description.f] ON [Catalog.Account.v](parent,isfolder,description,id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Account.v.description] ON [Catalog.Account.v](description,id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Account.v.code] ON [Catalog.Account.v](code,id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Account.v.user] ON [Catalog.Account.v]([user],id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Account.v.company] ON [Catalog.Account.v](company,id);
GO
GRANT SELECT ON dbo.[Catalog.Account.v]TO jetti;
GO

ALTER SECURITY POLICY [rls].[companyAccessPolicy] ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.Account.v];
RAISERROR('Catalog.Account end', 0 ,1) WITH NOWAIT;
      
------------------------------ END Catalog.Account ------------------------------

------------------------------ BEGIN Catalog.BusinessRegion ------------------------------

RAISERROR('Catalog.BusinessRegion start', 0 ,1) WITH NOWAIT;
      
BEGIN TRY
  ALTER SECURITY POLICY[rls].[companyAccessPolicy] DROP FILTER PREDICATE ON[dbo].[Catalog.BusinessRegion.v];
END TRY
BEGIN CATCH
END CATCH;
GO
CREATE OR ALTER VIEW dbo.[Catalog.BusinessRegion.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user], [version]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Population"')), 0) [Population]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."isDevelopmentRegion"')), 0) [isDevelopmentRegion]
      FROM dbo.[Documents]
      WHERE [type] = N'Catalog.BusinessRegion'
;
GO
CREATE UNIQUE CLUSTERED INDEX [Catalog.BusinessRegion.v] ON [Catalog.BusinessRegion.v](id);
        
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BusinessRegion.v.deleted] ON [Catalog.BusinessRegion.v](deleted,description,id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BusinessRegion.v.code.f] ON [Catalog.BusinessRegion.v](parent,isfolder,code,id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BusinessRegion.v.description.f] ON [Catalog.BusinessRegion.v](parent,isfolder,description,id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BusinessRegion.v.description] ON [Catalog.BusinessRegion.v](description,id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BusinessRegion.v.code] ON [Catalog.BusinessRegion.v](code,id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BusinessRegion.v.user] ON [Catalog.BusinessRegion.v]([user],id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.BusinessRegion.v.company] ON [Catalog.BusinessRegion.v](company,id);
GO
GRANT SELECT ON dbo.[Catalog.BusinessRegion.v]TO jetti;
GO

ALTER SECURITY POLICY [rls].[companyAccessPolicy] ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.BusinessRegion.v];
RAISERROR('Catalog.BusinessRegion end', 0 ,1) WITH NOWAIT;
      
------------------------------ END Catalog.BusinessRegion ------------------------------

------------------------------ BEGIN Catalog.Counterpartie ------------------------------

RAISERROR('Catalog.Counterpartie start', 0 ,1) WITH NOWAIT;
      
BEGIN TRY
  ALTER SECURITY POLICY[rls].[companyAccessPolicy] DROP FILTER PREDICATE ON[dbo].[Catalog.Counterpartie.v];
END TRY
BEGIN CATCH
END CATCH;
GO
CREATE OR ALTER VIEW dbo.[Catalog.Counterpartie.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user], [version]
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
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."BC"')), '') [BC]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."GLN"')), '') [GLN]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Manager"')) [Manager]
      FROM dbo.[Documents]
      WHERE [type] = N'Catalog.Counterpartie'
;
GO
CREATE UNIQUE CLUSTERED INDEX [Catalog.Counterpartie.v] ON [Catalog.Counterpartie.v](id);
        
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.v.deleted] ON [Catalog.Counterpartie.v](deleted,description,id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.v.code.f] ON [Catalog.Counterpartie.v](parent,isfolder,code,id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.v.description.f] ON [Catalog.Counterpartie.v](parent,isfolder,description,id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.v.description] ON [Catalog.Counterpartie.v](description,id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.v.code] ON [Catalog.Counterpartie.v](code,id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.v.user] ON [Catalog.Counterpartie.v]([user],id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.Counterpartie.v.company] ON [Catalog.Counterpartie.v](company,id);
GO
GRANT SELECT ON dbo.[Catalog.Counterpartie.v]TO jetti;
GO

ALTER SECURITY POLICY [rls].[companyAccessPolicy] ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.Counterpartie.v];
RAISERROR('Catalog.Counterpartie end', 0 ,1) WITH NOWAIT;
      
------------------------------ END Catalog.Counterpartie ------------------------------

------------------------------ BEGIN Catalog.JobTitle ------------------------------

RAISERROR('Catalog.JobTitle start', 0 ,1) WITH NOWAIT;
      
BEGIN TRY
  ALTER SECURITY POLICY[rls].[companyAccessPolicy] DROP FILTER PREDICATE ON[dbo].[Catalog.JobTitle.v];
END TRY
BEGIN CATCH
END CATCH;
GO
CREATE OR ALTER VIEW dbo.[Catalog.JobTitle.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user], [version]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Category"')) [Category]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."TO"')), 0) [TO]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."CO"')), 0) [CO]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."FunctionalStructure"')) [FunctionalStructure]
      FROM dbo.[Documents]
      WHERE [type] = N'Catalog.JobTitle'
;
GO
CREATE UNIQUE CLUSTERED INDEX [Catalog.JobTitle.v] ON [Catalog.JobTitle.v](id);
        
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.JobTitle.v.deleted] ON [Catalog.JobTitle.v](deleted,description,id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.JobTitle.v.code.f] ON [Catalog.JobTitle.v](parent,isfolder,code,id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.JobTitle.v.description.f] ON [Catalog.JobTitle.v](parent,isfolder,description,id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.JobTitle.v.description] ON [Catalog.JobTitle.v](description,id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.JobTitle.v.code] ON [Catalog.JobTitle.v](code,id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.JobTitle.v.user] ON [Catalog.JobTitle.v]([user],id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.JobTitle.v.company] ON [Catalog.JobTitle.v](company,id);
GO
GRANT SELECT ON dbo.[Catalog.JobTitle.v]TO jetti;
GO

ALTER SECURITY POLICY [rls].[companyAccessPolicy] ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.JobTitle.v];
RAISERROR('Catalog.JobTitle end', 0 ,1) WITH NOWAIT;
      
------------------------------ END Catalog.JobTitle ------------------------------

------------------------------ BEGIN Catalog.JobTitle.Functional ------------------------------

RAISERROR('Catalog.JobTitle.Functional start', 0 ,1) WITH NOWAIT;
      
BEGIN TRY
  ALTER SECURITY POLICY[rls].[companyAccessPolicy] DROP FILTER PREDICATE ON[dbo].[Catalog.JobTitle.Functional.v];
END TRY
BEGIN CATCH
END CATCH;
GO
CREATE OR ALTER VIEW dbo.[Catalog.JobTitle.Functional.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user], [version]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."StaffingTableResponsible"')) [StaffingTableResponsible]
      FROM dbo.[Documents]
      WHERE [type] = N'Catalog.JobTitle.Functional'
;
GO
CREATE UNIQUE CLUSTERED INDEX [Catalog.JobTitle.Functional.v] ON [Catalog.JobTitle.Functional.v](id);
        
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.JobTitle.Functional.v.deleted] ON [Catalog.JobTitle.Functional.v](deleted,description,id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.JobTitle.Functional.v.code.f] ON [Catalog.JobTitle.Functional.v](parent,isfolder,code,id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.JobTitle.Functional.v.description.f] ON [Catalog.JobTitle.Functional.v](parent,isfolder,description,id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.JobTitle.Functional.v.description] ON [Catalog.JobTitle.Functional.v](description,id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.JobTitle.Functional.v.code] ON [Catalog.JobTitle.Functional.v](code,id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.JobTitle.Functional.v.user] ON [Catalog.JobTitle.Functional.v]([user],id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.JobTitle.Functional.v.company] ON [Catalog.JobTitle.Functional.v](company,id);
GO
GRANT SELECT ON dbo.[Catalog.JobTitle.Functional.v]TO jetti;
GO

ALTER SECURITY POLICY [rls].[companyAccessPolicy] ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.JobTitle.Functional.v];
RAISERROR('Catalog.JobTitle.Functional end', 0 ,1) WITH NOWAIT;
      
------------------------------ END Catalog.JobTitle.Functional ------------------------------

------------------------------ BEGIN Catalog.RetailNetwork ------------------------------

RAISERROR('Catalog.RetailNetwork start', 0 ,1) WITH NOWAIT;
      
BEGIN TRY
  ALTER SECURITY POLICY[rls].[companyAccessPolicy] DROP FILTER PREDICATE ON[dbo].[Catalog.RetailNetwork.v];
END TRY
BEGIN CATCH
END CATCH;
GO
CREATE OR ALTER VIEW dbo.[Catalog.RetailNetwork.v] WITH SCHEMABINDING AS
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user], [version]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Brand"')) [Brand]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Country"')) [Country]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."BusinessRegion"')) [BusinessRegion]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Currency"')) [Currency]
      FROM dbo.[Documents]
      WHERE [type] = N'Catalog.RetailNetwork'
;
GO
CREATE UNIQUE CLUSTERED INDEX [Catalog.RetailNetwork.v] ON [Catalog.RetailNetwork.v](id);
        
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.RetailNetwork.v.deleted] ON [Catalog.RetailNetwork.v](deleted,description,id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.RetailNetwork.v.code.f] ON [Catalog.RetailNetwork.v](parent,isfolder,code,id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.RetailNetwork.v.description.f] ON [Catalog.RetailNetwork.v](parent,isfolder,description,id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.RetailNetwork.v.description] ON [Catalog.RetailNetwork.v](description,id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.RetailNetwork.v.code] ON [Catalog.RetailNetwork.v](code,id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.RetailNetwork.v.user] ON [Catalog.RetailNetwork.v]([user],id);
CREATE UNIQUE NONCLUSTERED INDEX [Catalog.RetailNetwork.v.company] ON [Catalog.RetailNetwork.v](company,id);
GO
GRANT SELECT ON dbo.[Catalog.RetailNetwork.v]TO jetti;
GO

ALTER SECURITY POLICY [rls].[companyAccessPolicy] ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Catalog.RetailNetwork.v];
RAISERROR('Catalog.RetailNetwork end', 0 ,1) WITH NOWAIT;
      
------------------------------ END Catalog.RetailNetwork ------------------------------

    CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.Amount] ON [Document.Operation.v](Amount,id);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.Group] ON [dbo].[Document.Operation.v]([Group],[date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.Group.user] ON [dbo].[Document.Operation.v]([user],[Group],[date],[id]);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.Operation] ON [Document.Operation.v](Operation,id);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.currency] ON [Document.Operation.v](currency,id);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.f1] ON [Document.Operation.v](f1,id);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.f2] ON [Document.Operation.v](f2,id);
    CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.f3] ON [Document.Operation.v](f3,id);
    CREATE NONCLUSTERED INDEX [Document.Operation.v.timestamp] ON [Document.Operation.v]([timestamp],[Operation]);
    