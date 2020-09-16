
------------------------------ BEGIN Operation.LOAD_SALARY ------------------------------

      BEGIN TRY
      ALTER SECURITY POLICY[rls].[companyAccessPolicy] DROP FILTER PREDICATE ON[dbo].[Operation.LOAD_SALARY.v];
      END TRY
      BEGIN CATCH
      END CATCH
GO
CREATE OR ALTER VIEW dbo.[Operation.LOAD_SALARY.v] WITH SCHEMABINDING AS 
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
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."AmountIncome"')), 0) [AmountIncome]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."AmountIncomeBalance"')), 0) [AmountIncomeBalance]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."AmountExpense"')), 0) [AmountExpense]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."AmountTax"')), 0) [AmountTax]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Status"')), '') [Status]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."DocVerified"')), 0) [DocVerified]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."IsPortal"')), 0) [IsPortal]
      FROM dbo.[Documents]
      WHERE JSON_VALUE(doc, N'$."Operation"') = '5B7E7060-4155-11EA-84A3-FDBDF894036C'
    ; 
GO
CREATE UNIQUE CLUSTERED INDEX[Operation.LOAD_SALARY.v] ON[Operation.LOAD_SALARY.v](id);
      CREATE UNIQUE NONCLUSTERED INDEX[Operation.LOAD_SALARY.v.date] ON[Operation.LOAD_SALARY.v](date, id) INCLUDE([company]);
      
GO
GRANT SELECT ON dbo.[Operation.LOAD_SALARY.v]TO jetti; 
GO
ALTER SECURITY POLICY[rls].[companyAccessPolicy]
      ADD FILTER PREDICATE[rls].[fn_companyAccessPredicate]([company]) ON[dbo].[Operation.LOAD_SALARY.v];
      
------------------------------ END Operation.LOAD_SALARY ------------------------------

GO

------------------------------ BEGIN Operation.SPECIFICATION ------------------------------

      BEGIN TRY
      ALTER SECURITY POLICY[rls].[companyAccessPolicy] DROP FILTER PREDICATE ON[dbo].[Operation.SPECIFICATION.v];
      END TRY
      BEGIN CATCH
      END CATCH
GO
CREATE OR ALTER VIEW dbo.[Operation.SPECIFICATION.v] WITH SCHEMABINDING AS 
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user], [version]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Group"')) [Group]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Operation"')) [Operation]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Amount"')), 0) [Amount]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."currency"')) [currency]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f1"')) [f1]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f2"')) [f2]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f3"')) [f3]
      FROM dbo.[Documents]
      WHERE JSON_VALUE(doc, N'$."Operation"') = '6D43E8B0-645B-11EA-A8B2-95688F3F3592'
    ; 
GO
CREATE UNIQUE CLUSTERED INDEX[Operation.SPECIFICATION.v] ON[Operation.SPECIFICATION.v](id);
      CREATE UNIQUE NONCLUSTERED INDEX[Operation.SPECIFICATION.v.date] ON[Operation.SPECIFICATION.v](date, id) INCLUDE([company]);
      
GO
GRANT SELECT ON dbo.[Operation.SPECIFICATION.v]TO jetti; 
GO
ALTER SECURITY POLICY[rls].[companyAccessPolicy]
      ADD FILTER PREDICATE[rls].[fn_companyAccessPredicate]([company]) ON[dbo].[Operation.SPECIFICATION.v];
      
------------------------------ END Operation.SPECIFICATION ------------------------------

GO

------------------------------ BEGIN Operation.OPER_PREPAY_RETAIL_CLIENT ------------------------------

      BEGIN TRY
      ALTER SECURITY POLICY[rls].[companyAccessPolicy] DROP FILTER PREDICATE ON[dbo].[Operation.OPER_PREPAY_RETAIL_CLIENT.v];
      END TRY
      BEGIN CATCH
      END CATCH
GO
CREATE OR ALTER VIEW dbo.[Operation.OPER_PREPAY_RETAIL_CLIENT.v] WITH SCHEMABINDING AS 
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
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."RetailClient"')) [RetailClient]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."ProductPackage"')) [ProductPackage]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Product"')) [Product]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Qty"')), 0) [Qty]
      , TRY_CONVERT(DATE, JSON_VALUE(doc, N'$.DateExpire'),127) [DateExpire]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Remote_transaction_id"')), '') [Remote_transaction_id]
      FROM dbo.[Documents]
      WHERE JSON_VALUE(doc, N'$."Operation"') = '005952E0-E2EA-11EA-893C-91E601FD7561'
    ; 
GO
CREATE UNIQUE CLUSTERED INDEX[Operation.OPER_PREPAY_RETAIL_CLIENT.v] ON[Operation.OPER_PREPAY_RETAIL_CLIENT.v](id);
      CREATE UNIQUE NONCLUSTERED INDEX[Operation.OPER_PREPAY_RETAIL_CLIENT.v.date] ON[Operation.OPER_PREPAY_RETAIL_CLIENT.v](date, id) INCLUDE([company]);
      
GO
GRANT SELECT ON dbo.[Operation.OPER_PREPAY_RETAIL_CLIENT.v]TO jetti; 
GO
ALTER SECURITY POLICY[rls].[companyAccessPolicy]
      ADD FILTER PREDICATE[rls].[fn_companyAccessPredicate]([company]) ON[dbo].[Operation.OPER_PREPAY_RETAIL_CLIENT.v];
      
------------------------------ END Operation.OPER_PREPAY_RETAIL_CLIENT ------------------------------

GO

------------------------------ BEGIN Operation.GYM_SALES ------------------------------

      BEGIN TRY
      ALTER SECURITY POLICY[rls].[companyAccessPolicy] DROP FILTER PREDICATE ON[dbo].[Operation.GYM_SALES.v];
      END TRY
      BEGIN CATCH
      END CATCH
GO
CREATE OR ALTER VIEW dbo.[Operation.GYM_SALES.v] WITH SCHEMABINDING AS 
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
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Training_type"')) [Training_type]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Trainer"')) [Trainer]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Department_Finance"')) [Department_Finance]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Max_members"')), 0) [Max_members]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Members_count"')), 0) [Members_count]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Visited_count"')), 0) [Visited_count]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."Is_online"')), 0) [Is_online]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Online_url"')), '') [Online_url]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Training_Id"')), 0) [Training_Id]
      FROM dbo.[Documents]
      WHERE JSON_VALUE(doc, N'$."Operation"') = '82D90D80-E2F1-11EA-893C-91E601FD7561'
    ; 
GO
CREATE UNIQUE CLUSTERED INDEX[Operation.GYM_SALES.v] ON[Operation.GYM_SALES.v](id);
      CREATE UNIQUE NONCLUSTERED INDEX[Operation.GYM_SALES.v.date] ON[Operation.GYM_SALES.v](date, id) INCLUDE([company]);
      
GO
GRANT SELECT ON dbo.[Operation.GYM_SALES.v]TO jetti; 
GO
ALTER SECURITY POLICY[rls].[companyAccessPolicy]
      ADD FILTER PREDICATE[rls].[fn_companyAccessPredicate]([company]) ON[dbo].[Operation.GYM_SALES.v];
      
------------------------------ END Operation.GYM_SALES ------------------------------

GO

------------------------------ BEGIN Operation.LOAD_GYM_SMARTASS ------------------------------

      BEGIN TRY
      ALTER SECURITY POLICY[rls].[companyAccessPolicy] DROP FILTER PREDICATE ON[dbo].[Operation.LOAD_GYM_SMARTASS.v];
      END TRY
      BEGIN CATCH
      END CATCH
GO
CREATE OR ALTER VIEW dbo.[Operation.LOAD_GYM_SMARTASS.v] WITH SCHEMABINDING AS 
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user], [version]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Group"')) [Group]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Operation"')) [Operation]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Amount"')), 0) [Amount]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."currency"')) [currency]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f1"')) [f1]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f2"')) [f2]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f3"')) [f3]
      , TRY_CONVERT(DATE, JSON_VALUE(doc, N'$.DateOpen'),127) [DateOpen]
      , TRY_CONVERT(DATE, JSON_VALUE(doc, N'$.DateClose'),127) [DateClose]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Department"')) [Department]
      FROM dbo.[Documents]
      WHERE JSON_VALUE(doc, N'$."Operation"') = '5F3E3D80-F0DB-11EA-9610-27768698B7AE'
    ; 
GO
CREATE UNIQUE CLUSTERED INDEX[Operation.LOAD_GYM_SMARTASS.v] ON[Operation.LOAD_GYM_SMARTASS.v](id);
      CREATE UNIQUE NONCLUSTERED INDEX[Operation.LOAD_GYM_SMARTASS.v.date] ON[Operation.LOAD_GYM_SMARTASS.v](date, id) INCLUDE([company]);
      
GO
GRANT SELECT ON dbo.[Operation.LOAD_GYM_SMARTASS.v]TO jetti; 
GO
ALTER SECURITY POLICY[rls].[companyAccessPolicy]
      ADD FILTER PREDICATE[rls].[fn_companyAccessPredicate]([company]) ON[dbo].[Operation.LOAD_GYM_SMARTASS.v];
      
------------------------------ END Operation.LOAD_GYM_SMARTASS ------------------------------

GO

------------------------------ BEGIN Operation.LOAD_PREPAY_SMARTASS ------------------------------

      BEGIN TRY
      ALTER SECURITY POLICY[rls].[companyAccessPolicy] DROP FILTER PREDICATE ON[dbo].[Operation.LOAD_PREPAY_SMARTASS.v];
      END TRY
      BEGIN CATCH
      END CATCH
GO
CREATE OR ALTER VIEW dbo.[Operation.LOAD_PREPAY_SMARTASS.v] WITH SCHEMABINDING AS 
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user], [version]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Group"')) [Group]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Operation"')) [Operation]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Amount"')), 0) [Amount]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."currency"')) [currency]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f1"')) [f1]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f2"')) [f2]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f3"')) [f3]
      , TRY_CONVERT(DATE, JSON_VALUE(doc, N'$.DateOpen'),127) [DateOpen]
      , TRY_CONVERT(DATE, JSON_VALUE(doc, N'$.DateClose'),127) [DateClose]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Department"')) [Department]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."CompanyDepartment"')) [CompanyDepartment]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."PaymentAgent_Default"')) [PaymentAgent_Default]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."BankAccount_Default"')) [BankAccount_Default]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."CashRegister_Default"')) [CashRegister_Default]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."AcquiringTerminal_Default"')) [AcquiringTerminal_Default]
      FROM dbo.[Documents]
      WHERE JSON_VALUE(doc, N'$."Operation"') = 'FF7B9B10-F1A5-11EA-8EFC-635C76474611'
    ; 
GO
CREATE UNIQUE CLUSTERED INDEX[Operation.LOAD_PREPAY_SMARTASS.v] ON[Operation.LOAD_PREPAY_SMARTASS.v](id);
      CREATE UNIQUE NONCLUSTERED INDEX[Operation.LOAD_PREPAY_SMARTASS.v.date] ON[Operation.LOAD_PREPAY_SMARTASS.v](date, id) INCLUDE([company]);
      
GO
GRANT SELECT ON dbo.[Operation.LOAD_PREPAY_SMARTASS.v]TO jetti; 
GO
ALTER SECURITY POLICY[rls].[companyAccessPolicy]
      ADD FILTER PREDICATE[rls].[fn_companyAccessPredicate]([company]) ON[dbo].[Operation.LOAD_PREPAY_SMARTASS.v];
      
------------------------------ END Operation.LOAD_PREPAY_SMARTASS ------------------------------

GO

------------------------------ BEGIN Operation.Назначение ценового региона ------------------------------

      BEGIN TRY
      ALTER SECURITY POLICY[rls].[companyAccessPolicy] DROP FILTER PREDICATE ON[dbo].[Operation.Назначение ценового региона.v];
      END TRY
      BEGIN CATCH
      END CATCH
GO
CREATE OR ALTER VIEW dbo.[Operation.Назначение ценового региона.v] WITH SCHEMABINDING AS 
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user], [version]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Group"')) [Group]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Operation"')) [Operation]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Amount"')), 0) [Amount]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."currency"')) [currency]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f1"')) [f1]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f2"')) [f2]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f3"')) [f3]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Role"')), '') [Role]
      FROM dbo.[Documents]
      WHERE JSON_VALUE(doc, N'$."Operation"') = '14C99300-F651-11EA-B248-132E6B964038'
    ; 
GO
CREATE UNIQUE CLUSTERED INDEX[Operation.Назначение ценового региона.v] ON[Operation.Назначение ценового региона.v](id);
      CREATE UNIQUE NONCLUSTERED INDEX[Operation.Назначение ценового региона.v.date] ON[Operation.Назначение ценового региона.v](date, id) INCLUDE([company]);
      
GO
GRANT SELECT ON dbo.[Operation.Назначение ценового региона.v]TO jetti; 
GO
ALTER SECURITY POLICY[rls].[companyAccessPolicy]
      ADD FILTER PREDICATE[rls].[fn_companyAccessPredicate]([company]) ON[dbo].[Operation.Назначение ценового региона.v];
      
------------------------------ END Operation.Назначение ценового региона ------------------------------
