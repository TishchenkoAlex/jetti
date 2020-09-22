
------------------------------ BEGIN Operation.CURR_CB_RUS ------------------------------

      BEGIN TRY
      ALTER SECURITY POLICY[rls].[companyAccessPolicy] DROP FILTER PREDICATE ON[dbo].[Operation.CURR_CB_RUS.v];
      END TRY
      BEGIN CATCH
      END CATCH
GO
CREATE OR ALTER VIEW dbo.[Operation.CURR_CB_RUS.v] WITH SCHEMABINDING AS 
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user], [version]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Group"')) [Group]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Operation"')) [Operation]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Amount"')), 0) [Amount]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."currency"')) [currency]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f1"')) [f1]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f2"')) [f2]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f3"')) [f3]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Country"')) [Country]
      , TRY_CONVERT(DATE, JSON_VALUE(doc, N'$.StartDate'),127) [StartDate]
      , TRY_CONVERT(DATE, JSON_VALUE(doc, N'$.EndDate'),127) [EndDate]
      FROM dbo.[Documents]
      WHERE JSON_VALUE(doc, N'$."Operation"') = 'ACAB7D10-F722-11EA-88BD-7922573A583F'
    ; 
GO
CREATE UNIQUE CLUSTERED INDEX[Operation.CURR_CB_RUS.v] ON[Operation.CURR_CB_RUS.v](id);
      CREATE UNIQUE NONCLUSTERED INDEX[Operation.CURR_CB_RUS.v.date] ON[Operation.CURR_CB_RUS.v](date, id) INCLUDE([company]);
      
GO
GRANT SELECT ON dbo.[Operation.CURR_CB_RUS.v]TO jetti; 
GO
ALTER SECURITY POLICY[rls].[companyAccessPolicy]
      ADD FILTER PREDICATE[rls].[fn_companyAccessPredicate]([company]) ON[dbo].[Operation.CURR_CB_RUS.v];
      
------------------------------ END Operation.CURR_CB_RUS ------------------------------
