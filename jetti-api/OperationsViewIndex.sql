
------------------------------ BEGIN Operation.AdditionalParametersDepartment ------------------------------

      RAISERROR('Operation.AdditionalParametersDepartment start', 0 ,1) WITH NOWAIT;
      
      BEGIN TRY
        ALTER SECURITY POLICY[rls].[companyAccessPolicy] DROP FILTER PREDICATE ON[dbo].[Operation.AdditionalParametersDepartment.v];
      END TRY
      BEGIN CATCH
      END CATCH
GO
CREATE OR ALTER VIEW dbo.[Operation.AdditionalParametersDepartment.v] WITH SCHEMABINDING AS 
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user], [version]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Group"')) [Group]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Operation"')) [Operation]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Amount"')), 0) [Amount]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."currency"')) [currency]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f1"')) [f1]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f2"')) [f2]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f3"')) [f3]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Department"')) [Department]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."MainStoreHouse"')) [MainStoreHouse]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."FrontType"')), '') [FrontType]
      FROM dbo.[Documents]
      WHERE JSON_VALUE(doc, N'$."Operation"') = 'CE62E430-3004-11E8-A0FF-732D589B1ACA'
; 
GO
CREATE UNIQUE CLUSTERED INDEX [Operation.AdditionalParametersDepartment.v] ON [Operation.AdditionalParametersDepartment.v](id);
      CREATE UNIQUE NONCLUSTERED INDEX[Operation.AdditionalParametersDepartment.v.date] ON[Operation.AdditionalParametersDepartment.v](date, id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.AdditionalParametersDepartment.v.parent] ON [Operation.AdditionalParametersDepartment.v](parent,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.AdditionalParametersDepartment.v.deleted] ON [Operation.AdditionalParametersDepartment.v](deleted,date,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.AdditionalParametersDepartment.v.code] ON [Operation.AdditionalParametersDepartment.v](code,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.AdditionalParametersDepartment.v.user] ON [Operation.AdditionalParametersDepartment.v]([user],id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.AdditionalParametersDepartment.v.company] ON [Operation.AdditionalParametersDepartment.v](company,id);
      
GO
GRANT SELECT ON dbo.[Operation.AdditionalParametersDepartment.v]TO jetti; 
GO
ALTER SECURITY POLICY[rls].[companyAccessPolicy]
      ADD FILTER PREDICATE[rls].[fn_companyAccessPredicate]([company]) ON[dbo].[Operation.AdditionalParametersDepartment.v];
      RAISERROR('Operation.AdditionalParametersDepartment finish', 0 ,1) WITH NOWAIT;
      
------------------------------ BEGIN Operation.AdditionalParametersDepartment ------------------------------

      
------------------------------ BEGIN Operation.AutoAdditionSettings ------------------------------

      RAISERROR('Operation.AutoAdditionSettings start', 0 ,1) WITH NOWAIT;
      
      BEGIN TRY
        ALTER SECURITY POLICY[rls].[companyAccessPolicy] DROP FILTER PREDICATE ON[dbo].[Operation.AutoAdditionSettings.v];
      END TRY
      BEGIN CATCH
      END CATCH
GO
CREATE OR ALTER VIEW dbo.[Operation.AutoAdditionSettings.v] WITH SCHEMABINDING AS 
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user], [version]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Group"')) [Group]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Operation"')) [Operation]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Amount"')), 0) [Amount]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."currency"')) [currency]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f1"')) [f1]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f2"')) [f2]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f3"')) [f3]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."RetailNetwork"')) [RetailNetwork]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."AdditionalType"')), '') [AdditionalType]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."MainSKU"')) [MainSKU]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Qty"')), 0) [Qty]
      FROM dbo.[Documents]
      WHERE JSON_VALUE(doc, N'$."Operation"') = '73F98550-33E2-11EB-A7C3-274B4A063111'
; 
GO
CREATE UNIQUE CLUSTERED INDEX [Operation.AutoAdditionSettings.v] ON [Operation.AutoAdditionSettings.v](id);
      CREATE UNIQUE NONCLUSTERED INDEX[Operation.AutoAdditionSettings.v.date] ON[Operation.AutoAdditionSettings.v](date, id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.AutoAdditionSettings.v.parent] ON [Operation.AutoAdditionSettings.v](parent,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.AutoAdditionSettings.v.deleted] ON [Operation.AutoAdditionSettings.v](deleted,date,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.AutoAdditionSettings.v.code] ON [Operation.AutoAdditionSettings.v](code,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.AutoAdditionSettings.v.user] ON [Operation.AutoAdditionSettings.v]([user],id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.AutoAdditionSettings.v.company] ON [Operation.AutoAdditionSettings.v](company,id);
      
GO
GRANT SELECT ON dbo.[Operation.AutoAdditionSettings.v]TO jetti; 
GO
ALTER SECURITY POLICY[rls].[companyAccessPolicy]
      ADD FILTER PREDICATE[rls].[fn_companyAccessPredicate]([company]) ON[dbo].[Operation.AutoAdditionSettings.v];
      RAISERROR('Operation.AutoAdditionSettings finish', 0 ,1) WITH NOWAIT;
      
------------------------------ BEGIN Operation.AutoAdditionSettings ------------------------------

      
------------------------------ BEGIN Operation.CashShifts ------------------------------

      RAISERROR('Operation.CashShifts start', 0 ,1) WITH NOWAIT;
      
      BEGIN TRY
        ALTER SECURITY POLICY[rls].[companyAccessPolicy] DROP FILTER PREDICATE ON[dbo].[Operation.CashShifts.v];
      END TRY
      BEGIN CATCH
      END CATCH
GO
CREATE OR ALTER VIEW dbo.[Operation.CashShifts.v] WITH SCHEMABINDING AS 
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user], [version]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Group"')) [Group]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Operation"')) [Operation]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Amount"')), 0) [Amount]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."currency"')) [currency]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f1"')) [f1]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f2"')) [f2]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f3"')) [f3]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Department"')) [Department]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."UserId"')) [UserId]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."SashShiftNumber"')), '') [SashShiftNumber]
      , TRY_CONVERT(DATETIME, JSON_VALUE(doc, N'$.StartDate'),127) [StartDate]
      , TRY_CONVERT(DATETIME, JSON_VALUE(doc, N'$.EndDate'),127) [EndDate]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."ChecksLoaded"')), 0) [ChecksLoaded]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."ProductionCalculated"')), 0) [ProductionCalculated]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."startBalance"')), 0) [startBalance]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."endBalance"')), 0) [endBalance]
      FROM dbo.[Documents]
      WHERE JSON_VALUE(doc, N'$."Operation"') = '72D21520-144D-11EB-B23D-A9B204614E62'
; 
GO
CREATE UNIQUE CLUSTERED INDEX [Operation.CashShifts.v] ON [Operation.CashShifts.v](id);
      CREATE UNIQUE NONCLUSTERED INDEX[Operation.CashShifts.v.date] ON[Operation.CashShifts.v](date, id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.CashShifts.v.parent] ON [Operation.CashShifts.v](parent,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.CashShifts.v.deleted] ON [Operation.CashShifts.v](deleted,date,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.CashShifts.v.code] ON [Operation.CashShifts.v](code,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.CashShifts.v.user] ON [Operation.CashShifts.v]([user],id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.CashShifts.v.company] ON [Operation.CashShifts.v](company,id);
      
GO
GRANT SELECT ON dbo.[Operation.CashShifts.v]TO jetti; 
GO
ALTER SECURITY POLICY[rls].[companyAccessPolicy]
      ADD FILTER PREDICATE[rls].[fn_companyAccessPredicate]([company]) ON[dbo].[Operation.CashShifts.v];
      RAISERROR('Operation.CashShifts finish', 0 ,1) WITH NOWAIT;
      
------------------------------ BEGIN Operation.CashShifts ------------------------------

      
------------------------------ BEGIN Operation.CHECK_JETTI_FRONT ------------------------------

      RAISERROR('Operation.CHECK_JETTI_FRONT start', 0 ,1) WITH NOWAIT;
      
      BEGIN TRY
        ALTER SECURITY POLICY[rls].[companyAccessPolicy] DROP FILTER PREDICATE ON[dbo].[Operation.CHECK_JETTI_FRONT.v];
      END TRY
      BEGIN CATCH
      END CATCH
GO
CREATE OR ALTER VIEW dbo.[Operation.CHECK_JETTI_FRONT.v] WITH SCHEMABINDING AS 
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user], [version]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Group"')) [Group]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Operation"')) [Operation]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Amount"')), 0) [Amount]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."currency"')) [currency]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f1"')) [f1]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f2"')) [f2]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f3"')) [f3]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Department"')) [Department]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Customer"')) [Customer]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Manager"')) [Manager]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Storehouse"')) [Storehouse]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."DiscountDoc"')), 0) [DiscountDoc]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."TypeDocument"')), '') [TypeDocument]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."NumCashShift"')), '') [NumCashShift]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."counterpartyId"')), '') [counterpartyId]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."orderId"')), '') [orderId]
      FROM dbo.[Documents]
      WHERE JSON_VALUE(doc, N'$."Operation"') = '1D5BE740-298A-11EB-87AE-6D4972EE7833'
; 
GO
CREATE UNIQUE CLUSTERED INDEX [Operation.CHECK_JETTI_FRONT.v] ON [Operation.CHECK_JETTI_FRONT.v](id);
      CREATE UNIQUE NONCLUSTERED INDEX[Operation.CHECK_JETTI_FRONT.v.date] ON[Operation.CHECK_JETTI_FRONT.v](date, id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.CHECK_JETTI_FRONT.v.parent] ON [Operation.CHECK_JETTI_FRONT.v](parent,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.CHECK_JETTI_FRONT.v.deleted] ON [Operation.CHECK_JETTI_FRONT.v](deleted,date,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.CHECK_JETTI_FRONT.v.code] ON [Operation.CHECK_JETTI_FRONT.v](code,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.CHECK_JETTI_FRONT.v.user] ON [Operation.CHECK_JETTI_FRONT.v]([user],id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.CHECK_JETTI_FRONT.v.company] ON [Operation.CHECK_JETTI_FRONT.v](company,id);
      CREATE UNIQUE NONCLUSTERED INDEX[Operation.CHECK_JETTI_FRONT.v.Department] ON[Operation.CHECK_JETTI_FRONT.v](Department, id) INCLUDE([company]);
CREATE UNIQUE NONCLUSTERED INDEX[Operation.CHECK_JETTI_FRONT.v.Customer] ON[Operation.CHECK_JETTI_FRONT.v](Customer, id) INCLUDE([company]);
CREATE UNIQUE NONCLUSTERED INDEX[Operation.CHECK_JETTI_FRONT.v.Storehouse] ON[Operation.CHECK_JETTI_FRONT.v](Storehouse, id) INCLUDE([company]);
GO
GRANT SELECT ON dbo.[Operation.CHECK_JETTI_FRONT.v]TO jetti; 
GO
ALTER SECURITY POLICY[rls].[companyAccessPolicy]
      ADD FILTER PREDICATE[rls].[fn_companyAccessPredicate]([company]) ON[dbo].[Operation.CHECK_JETTI_FRONT.v];
      RAISERROR('Operation.CHECK_JETTI_FRONT finish', 0 ,1) WITH NOWAIT;
      
------------------------------ BEGIN Operation.CHECK_JETTI_FRONT ------------------------------

      
------------------------------ BEGIN Operation.CRAUD_INTEGRATION ------------------------------

      RAISERROR('Operation.CRAUD_INTEGRATION start', 0 ,1) WITH NOWAIT;
      
      BEGIN TRY
        ALTER SECURITY POLICY[rls].[companyAccessPolicy] DROP FILTER PREDICATE ON[dbo].[Operation.CRAUD_INTEGRATION.v];
      END TRY
      BEGIN CATCH
      END CATCH
GO
CREATE OR ALTER VIEW dbo.[Operation.CRAUD_INTEGRATION.v] WITH SCHEMABINDING AS 
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user], [version]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Group"')) [Group]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Operation"')) [Operation]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Amount"')), 0) [Amount]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."currency"')) [currency]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f1"')) [f1]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f2"')) [f2]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f3"')) [f3]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."alias"')), '') [alias]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."OperationJETTI"')) [OperationJETTI]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Status"')), '') [Status]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."StatusPosted"')), '') [StatusPosted]
      FROM dbo.[Documents]
      WHERE JSON_VALUE(doc, N'$."Operation"') = '492FFDE0-2D8E-11EB-8F97-B98B2F73F45B'
; 
GO
CREATE UNIQUE CLUSTERED INDEX [Operation.CRAUD_INTEGRATION.v] ON [Operation.CRAUD_INTEGRATION.v](id);
      CREATE UNIQUE NONCLUSTERED INDEX[Operation.CRAUD_INTEGRATION.v.date] ON[Operation.CRAUD_INTEGRATION.v](date, id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.CRAUD_INTEGRATION.v.parent] ON [Operation.CRAUD_INTEGRATION.v](parent,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.CRAUD_INTEGRATION.v.deleted] ON [Operation.CRAUD_INTEGRATION.v](deleted,date,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.CRAUD_INTEGRATION.v.code] ON [Operation.CRAUD_INTEGRATION.v](code,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.CRAUD_INTEGRATION.v.user] ON [Operation.CRAUD_INTEGRATION.v]([user],id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.CRAUD_INTEGRATION.v.company] ON [Operation.CRAUD_INTEGRATION.v](company,id);
      
GO
GRANT SELECT ON dbo.[Operation.CRAUD_INTEGRATION.v]TO jetti; 
GO
ALTER SECURITY POLICY[rls].[companyAccessPolicy]
      ADD FILTER PREDICATE[rls].[fn_companyAccessPredicate]([company]) ON[dbo].[Operation.CRAUD_INTEGRATION.v];
      RAISERROR('Operation.CRAUD_INTEGRATION finish', 0 ,1) WITH NOWAIT;
      
------------------------------ BEGIN Operation.CRAUD_INTEGRATION ------------------------------

      
------------------------------ BEGIN Operation.CRAUD_INTEGRATION_CREATE_LOAN ------------------------------

      RAISERROR('Operation.CRAUD_INTEGRATION_CREATE_LOAN start', 0 ,1) WITH NOWAIT;
      
      BEGIN TRY
        ALTER SECURITY POLICY[rls].[companyAccessPolicy] DROP FILTER PREDICATE ON[dbo].[Operation.CRAUD_INTEGRATION_CREATE_LOAN.v];
      END TRY
      BEGIN CATCH
      END CATCH
GO
CREATE OR ALTER VIEW dbo.[Operation.CRAUD_INTEGRATION_CREATE_LOAN.v] WITH SCHEMABINDING AS 
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user], [version]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Group"')) [Group]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Operation"')) [Operation]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Amount"')), 0) [Amount]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."currency"')) [currency]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f1"')) [f1]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f2"')) [f2]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f3"')) [f3]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Status"')), '') [Status]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."ScriptFindLoan"')), '') [ScriptFindLoan]
      FROM dbo.[Documents]
      WHERE JSON_VALUE(doc, N'$."Operation"') = '1A628370-2FD7-11EB-8258-97B2F1CC49F6'
; 
GO
CREATE UNIQUE CLUSTERED INDEX [Operation.CRAUD_INTEGRATION_CREATE_LOAN.v] ON [Operation.CRAUD_INTEGRATION_CREATE_LOAN.v](id);
      CREATE UNIQUE NONCLUSTERED INDEX[Operation.CRAUD_INTEGRATION_CREATE_LOAN.v.date] ON[Operation.CRAUD_INTEGRATION_CREATE_LOAN.v](date, id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.CRAUD_INTEGRATION_CREATE_LOAN.v.parent] ON [Operation.CRAUD_INTEGRATION_CREATE_LOAN.v](parent,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.CRAUD_INTEGRATION_CREATE_LOAN.v.deleted] ON [Operation.CRAUD_INTEGRATION_CREATE_LOAN.v](deleted,date,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.CRAUD_INTEGRATION_CREATE_LOAN.v.code] ON [Operation.CRAUD_INTEGRATION_CREATE_LOAN.v](code,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.CRAUD_INTEGRATION_CREATE_LOAN.v.user] ON [Operation.CRAUD_INTEGRATION_CREATE_LOAN.v]([user],id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.CRAUD_INTEGRATION_CREATE_LOAN.v.company] ON [Operation.CRAUD_INTEGRATION_CREATE_LOAN.v](company,id);
      
GO
GRANT SELECT ON dbo.[Operation.CRAUD_INTEGRATION_CREATE_LOAN.v]TO jetti; 
GO
ALTER SECURITY POLICY[rls].[companyAccessPolicy]
      ADD FILTER PREDICATE[rls].[fn_companyAccessPredicate]([company]) ON[dbo].[Operation.CRAUD_INTEGRATION_CREATE_LOAN.v];
      RAISERROR('Operation.CRAUD_INTEGRATION_CREATE_LOAN finish', 0 ,1) WITH NOWAIT;
      
------------------------------ BEGIN Operation.CRAUD_INTEGRATION_CREATE_LOAN ------------------------------

      
------------------------------ BEGIN Operation.DeliveryAreas ------------------------------

      RAISERROR('Operation.DeliveryAreas start', 0 ,1) WITH NOWAIT;
      
      BEGIN TRY
        ALTER SECURITY POLICY[rls].[companyAccessPolicy] DROP FILTER PREDICATE ON[dbo].[Operation.DeliveryAreas.v];
      END TRY
      BEGIN CATCH
      END CATCH
GO
CREATE OR ALTER VIEW dbo.[Operation.DeliveryAreas.v] WITH SCHEMABINDING AS 
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user], [version]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Group"')) [Group]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Operation"')) [Operation]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Amount"')), 0) [Amount]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."currency"')) [currency]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f1"')) [f1]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f2"')) [f2]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f3"')) [f3]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."RetailNetwork"')) [RetailNetwork]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."MapUrl"')), '') [MapUrl]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."LoadFolder"')), '') [LoadFolder]
      FROM dbo.[Documents]
      WHERE JSON_VALUE(doc, N'$."Operation"') = '3C593A00-32FC-11EB-9D67-5B583D0A1D7D'
; 
GO
CREATE UNIQUE CLUSTERED INDEX [Operation.DeliveryAreas.v] ON [Operation.DeliveryAreas.v](id);
      CREATE UNIQUE NONCLUSTERED INDEX[Operation.DeliveryAreas.v.date] ON[Operation.DeliveryAreas.v](date, id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.DeliveryAreas.v.parent] ON [Operation.DeliveryAreas.v](parent,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.DeliveryAreas.v.deleted] ON [Operation.DeliveryAreas.v](deleted,date,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.DeliveryAreas.v.code] ON [Operation.DeliveryAreas.v](code,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.DeliveryAreas.v.user] ON [Operation.DeliveryAreas.v]([user],id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.DeliveryAreas.v.company] ON [Operation.DeliveryAreas.v](company,id);
      
GO
GRANT SELECT ON dbo.[Operation.DeliveryAreas.v]TO jetti; 
GO
ALTER SECURITY POLICY[rls].[companyAccessPolicy]
      ADD FILTER PREDICATE[rls].[fn_companyAccessPredicate]([company]) ON[dbo].[Operation.DeliveryAreas.v];
      RAISERROR('Operation.DeliveryAreas finish', 0 ,1) WITH NOWAIT;
      
------------------------------ BEGIN Operation.DeliveryAreas ------------------------------

      
------------------------------ BEGIN Operation.IncomeBank_CRAUD_LoanInternational ------------------------------

      RAISERROR('Operation.IncomeBank_CRAUD_LoanInternational start', 0 ,1) WITH NOWAIT;
      
      BEGIN TRY
        ALTER SECURITY POLICY[rls].[companyAccessPolicy] DROP FILTER PREDICATE ON[dbo].[Operation.IncomeBank_CRAUD_LoanInternational.v];
      END TRY
      BEGIN CATCH
      END CATCH
GO
CREATE OR ALTER VIEW dbo.[Operation.IncomeBank_CRAUD_LoanInternational.v] WITH SCHEMABINDING AS 
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user], [version]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Group"')) [Group]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Operation"')) [Operation]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Amount"')), 0) [Amount]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."currency"')) [currency]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f1"')) [f1]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f2"')) [f2]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f3"')) [f3]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."BankAccountIN"')) [BankAccountIN]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."CashFlow"')) [CashFlow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."IntercompanyIN"')) [IntercompanyIN]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."IntercompanyOUT"')) [IntercompanyOUT]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."CurrencyVia"')) [CurrencyVia]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."LoanViaIntercompanyIN"')) [LoanViaIntercompanyIN]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."LoanViaIntercompanyOUT"')) [LoanViaIntercompanyOUT]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."AmountVia"')), 0) [AmountVia]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."BankConfirm"')), 0) [BankConfirm]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."BankDocNumber"')), '') [BankDocNumber]
      , TRY_CONVERT(DATE, JSON_VALUE(doc, N'$.BankConfirmDate'),127) [BankConfirmDate]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Intercompany_CRAUD"')) [Intercompany_CRAUD]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Customer"')) [Customer]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Loan_Customer"')) [Loan_Customer]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."SKU"')) [SKU]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Loan_Customer_Company"')) [Loan_Customer_Company]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Amount_Loan_Customer_Company"')), 0) [Amount_Loan_Customer_Company]
      FROM dbo.[Documents]
      WHERE JSON_VALUE(doc, N'$."Operation"') = '482CFFC0-02EF-11EB-9AD5-69E561DF4143'
; 
GO
CREATE UNIQUE CLUSTERED INDEX [Operation.IncomeBank_CRAUD_LoanInternational.v] ON [Operation.IncomeBank_CRAUD_LoanInternational.v](id);
      CREATE UNIQUE NONCLUSTERED INDEX[Operation.IncomeBank_CRAUD_LoanInternational.v.date] ON[Operation.IncomeBank_CRAUD_LoanInternational.v](date, id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.IncomeBank_CRAUD_LoanInternational.v.parent] ON [Operation.IncomeBank_CRAUD_LoanInternational.v](parent,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.IncomeBank_CRAUD_LoanInternational.v.deleted] ON [Operation.IncomeBank_CRAUD_LoanInternational.v](deleted,date,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.IncomeBank_CRAUD_LoanInternational.v.code] ON [Operation.IncomeBank_CRAUD_LoanInternational.v](code,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.IncomeBank_CRAUD_LoanInternational.v.user] ON [Operation.IncomeBank_CRAUD_LoanInternational.v]([user],id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.IncomeBank_CRAUD_LoanInternational.v.company] ON [Operation.IncomeBank_CRAUD_LoanInternational.v](company,id);
      
GO
GRANT SELECT ON dbo.[Operation.IncomeBank_CRAUD_LoanInternational.v]TO jetti; 
GO
ALTER SECURITY POLICY[rls].[companyAccessPolicy]
      ADD FILTER PREDICATE[rls].[fn_companyAccessPredicate]([company]) ON[dbo].[Operation.IncomeBank_CRAUD_LoanInternational.v];
      RAISERROR('Operation.IncomeBank_CRAUD_LoanInternational finish', 0 ,1) WITH NOWAIT;
      
------------------------------ BEGIN Operation.IncomeBank_CRAUD_LoanInternational ------------------------------

      
------------------------------ BEGIN Operation.LOT_Sales ------------------------------

      RAISERROR('Operation.LOT_Sales start', 0 ,1) WITH NOWAIT;
      
      BEGIN TRY
        ALTER SECURITY POLICY[rls].[companyAccessPolicy] DROP FILTER PREDICATE ON[dbo].[Operation.LOT_Sales.v];
      END TRY
      BEGIN CATCH
      END CATCH
GO
CREATE OR ALTER VIEW dbo.[Operation.LOT_Sales.v] WITH SCHEMABINDING AS 
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user], [version]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Group"')) [Group]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Operation"')) [Operation]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Amount"')), 0) [Amount]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."currency"')) [currency]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f1"')) [f1]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f2"')) [f2]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f3"')) [f3]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Customer"')) [Customer]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Department"')) [Department]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."CompanySeller"')) [CompanySeller]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Department_CompanySeller"')) [Department_CompanySeller]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Loan_Customer"')) [Loan_Customer]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Transaction_Id"')), '') [Transaction_Id]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Alias"')), '') [Alias]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Title"')), '') [Title]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Income_CompanySeller"')) [Income_CompanySeller]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Expense_CompanySeller"')) [Expense_CompanySeller]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Income"')) [Income]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."DocReceived"')), 0) [DocReceived]
      FROM dbo.[Documents]
      WHERE JSON_VALUE(doc, N'$."Operation"') = '8C711060-B1AD-11EA-B30E-316ED2102292'
; 
GO
CREATE UNIQUE CLUSTERED INDEX [Operation.LOT_Sales.v] ON [Operation.LOT_Sales.v](id);
      CREATE UNIQUE NONCLUSTERED INDEX[Operation.LOT_Sales.v.date] ON[Operation.LOT_Sales.v](date, id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.LOT_Sales.v.parent] ON [Operation.LOT_Sales.v](parent,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.LOT_Sales.v.deleted] ON [Operation.LOT_Sales.v](deleted,date,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.LOT_Sales.v.code] ON [Operation.LOT_Sales.v](code,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.LOT_Sales.v.user] ON [Operation.LOT_Sales.v]([user],id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.LOT_Sales.v.company] ON [Operation.LOT_Sales.v](company,id);
      
GO
GRANT SELECT ON dbo.[Operation.LOT_Sales.v]TO jetti; 
GO
ALTER SECURITY POLICY[rls].[companyAccessPolicy]
      ADD FILTER PREDICATE[rls].[fn_companyAccessPredicate]([company]) ON[dbo].[Operation.LOT_Sales.v];
      RAISERROR('Operation.LOT_Sales finish', 0 ,1) WITH NOWAIT;
      
------------------------------ BEGIN Operation.LOT_Sales ------------------------------

      
------------------------------ BEGIN Operation.LotModelsVsDepartment ------------------------------

      RAISERROR('Operation.LotModelsVsDepartment start', 0 ,1) WITH NOWAIT;
      
      BEGIN TRY
        ALTER SECURITY POLICY[rls].[companyAccessPolicy] DROP FILTER PREDICATE ON[dbo].[Operation.LotModelsVsDepartment.v];
      END TRY
      BEGIN CATCH
      END CATCH
GO
CREATE OR ALTER VIEW dbo.[Operation.LotModelsVsDepartment.v] WITH SCHEMABINDING AS 
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user], [version]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Group"')) [Group]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Operation"')) [Operation]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Amount"')), 0) [Amount]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."currency"')) [currency]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f1"')) [f1]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f2"')) [f2]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f3"')) [f3]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Lot"')), '') [Lot]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."isProfitability"')), 0) [isProfitability]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Lot_BonusManager"')), 0) [Lot_BonusManager]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Lot_CommisionAllUnic"')), 0) [Lot_CommisionAllUnic]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Lot_ShareDistribution"')), 0) [Lot_ShareDistribution]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Lot_ShareInvestor"')), 0) [Lot_ShareInvestor]
      FROM dbo.[Documents]
      WHERE JSON_VALUE(doc, N'$."Operation"') = '69FB36A0-F735-11EA-B8BB-29476D5253E2'
; 
GO
CREATE UNIQUE CLUSTERED INDEX [Operation.LotModelsVsDepartment.v] ON [Operation.LotModelsVsDepartment.v](id);
      CREATE UNIQUE NONCLUSTERED INDEX[Operation.LotModelsVsDepartment.v.date] ON[Operation.LotModelsVsDepartment.v](date, id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.LotModelsVsDepartment.v.parent] ON [Operation.LotModelsVsDepartment.v](parent,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.LotModelsVsDepartment.v.deleted] ON [Operation.LotModelsVsDepartment.v](deleted,date,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.LotModelsVsDepartment.v.code] ON [Operation.LotModelsVsDepartment.v](code,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.LotModelsVsDepartment.v.user] ON [Operation.LotModelsVsDepartment.v]([user],id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.LotModelsVsDepartment.v.company] ON [Operation.LotModelsVsDepartment.v](company,id);
      
GO
GRANT SELECT ON dbo.[Operation.LotModelsVsDepartment.v]TO jetti; 
GO
ALTER SECURITY POLICY[rls].[companyAccessPolicy]
      ADD FILTER PREDICATE[rls].[fn_companyAccessPredicate]([company]) ON[dbo].[Operation.LotModelsVsDepartment.v];
      RAISERROR('Operation.LotModelsVsDepartment finish', 0 ,1) WITH NOWAIT;
      
------------------------------ BEGIN Operation.LotModelsVsDepartment ------------------------------

      