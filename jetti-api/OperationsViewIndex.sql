
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
CREATE UNIQUE CLUSTERED INDEX[Operation.IncomeBank_CRAUD_LoanInternational.v] ON[Operation.IncomeBank_CRAUD_LoanInternational.v](id);
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
CREATE UNIQUE CLUSTERED INDEX[Operation.LOT_Sales.v] ON[Operation.LOT_Sales.v](id);
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
CREATE UNIQUE CLUSTERED INDEX[Operation.LotModelsVsDepartment.v] ON[Operation.LotModelsVsDepartment.v](id);
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

      