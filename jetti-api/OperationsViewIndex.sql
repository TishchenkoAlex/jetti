
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
CREATE UNIQUE CLUSTERED INDEX[Operation.AdditionalParametersDepartment.v] ON[Operation.AdditionalParametersDepartment.v](id);
      CREATE UNIQUE NONCLUSTERED INDEX[Operation.AdditionalParametersDepartment.v.date] ON[Operation.AdditionalParametersDepartment.v](date, id) INCLUDE([company]);
      
GO
GRANT SELECT ON dbo.[Operation.AdditionalParametersDepartment.v]TO jetti; 
GO
ALTER SECURITY POLICY[rls].[companyAccessPolicy]
      ADD FILTER PREDICATE[rls].[fn_companyAccessPredicate]([company]) ON[dbo].[Operation.AdditionalParametersDepartment.v];
      RAISERROR('Operation.AdditionalParametersDepartment finish', 0 ,1) WITH NOWAIT;
      
------------------------------ BEGIN Operation.AdditionalParametersDepartment ------------------------------

      
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
CREATE UNIQUE CLUSTERED INDEX[Operation.LotModelsVsDepartment.v] ON[Operation.LotModelsVsDepartment.v](id);
      CREATE UNIQUE NONCLUSTERED INDEX[Operation.LotModelsVsDepartment.v.date] ON[Operation.LotModelsVsDepartment.v](date, id) INCLUDE([company]);
      
GO
GRANT SELECT ON dbo.[Operation.LotModelsVsDepartment.v]TO jetti; 
GO
ALTER SECURITY POLICY[rls].[companyAccessPolicy]
      ADD FILTER PREDICATE[rls].[fn_companyAccessPredicate]([company]) ON[dbo].[Operation.LotModelsVsDepartment.v];
      RAISERROR('Operation.LotModelsVsDepartment finish', 0 ,1) WITH NOWAIT;
      
------------------------------ BEGIN Operation.LotModelsVsDepartment ------------------------------

      