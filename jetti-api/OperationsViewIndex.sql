
------------------------------ BEGIN Operation.balance ------------------------------

      RAISERROR('Operation.balance start', 0 ,1) WITH NOWAIT;
      
      BEGIN TRY
        ALTER SECURITY POLICY[rls].[companyAccessPolicy] DROP FILTER PREDICATE ON[dbo].[Operation.balance.v];
      END TRY
      BEGIN CATCH
      END CATCH
GO
CREATE OR ALTER VIEW dbo.[Operation.balance.v] WITH SCHEMABINDING AS 
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user], [version]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Group"')) [Group]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Operation"')) [Operation]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Amount"')), 0) [Amount]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."currency"')) [currency]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f1"')) [f1]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f2"')) [f2]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f3"')) [f3]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."RegisterName"')), '') [RegisterName]
      , TRY_CONVERT(DATE, JSON_VALUE(doc, N'$.BalanceDate'),127) [BalanceDate]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."Fields"')), '') [Fields]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."GroupBy"')), '') [GroupBy]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."TopRows"')), 0) [TopRows]
      FROM dbo.[Documents]
      WHERE JSON_VALUE(doc, N'$."Operation"') = '3E66A8C0-F80D-11EA-A4DB-81D4427614D7'
; 
GO
CREATE UNIQUE CLUSTERED INDEX[Operation.balance.v] ON[Operation.balance.v](id);
      CREATE UNIQUE NONCLUSTERED INDEX[Operation.balance.v.date] ON[Operation.balance.v](date, id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.balance.v.parent] ON [Operation.balance.v](parent,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.balance.v.deleted] ON [Operation.balance.v](deleted,date,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.balance.v.code] ON [Operation.balance.v](code,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.balance.v.user] ON [Operation.balance.v]([user],id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.balance.v.company] ON [Operation.balance.v](company,id);
      
GO
GRANT SELECT ON dbo.[Operation.balance.v]TO jetti; 
GO
ALTER SECURITY POLICY[rls].[companyAccessPolicy]
      ADD FILTER PREDICATE[rls].[fn_companyAccessPredicate]([company]) ON[dbo].[Operation.balance.v];
      RAISERROR('Operation.balance finish', 0 ,1) WITH NOWAIT;
      
------------------------------ BEGIN Operation.balance ------------------------------

      
------------------------------ BEGIN Operation.load ------------------------------

      RAISERROR('Operation.load start', 0 ,1) WITH NOWAIT;
      
      BEGIN TRY
        ALTER SECURITY POLICY[rls].[companyAccessPolicy] DROP FILTER PREDICATE ON[dbo].[Operation.load.v];
      END TRY
      BEGIN CATCH
      END CATCH
GO
CREATE OR ALTER VIEW dbo.[Operation.load.v] WITH SCHEMABINDING AS 
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user], [version]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Group"')) [Group]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Operation"')) [Operation]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Amount"')), 0) [Amount]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."currency"')) [currency]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f1"')) [f1]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f2"')) [f2]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f3"')) [f3]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."CSV"')), '') [CSV]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."UsersParent"')) [UsersParent]
      FROM dbo.[Documents]
      WHERE JSON_VALUE(doc, N'$."Operation"') = '2F092D30-7577-11EA-A771-6F1F7E13F48A'
; 
GO
CREATE UNIQUE CLUSTERED INDEX[Operation.load.v] ON[Operation.load.v](id);
      CREATE UNIQUE NONCLUSTERED INDEX[Operation.load.v.date] ON[Operation.load.v](date, id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.load.v.parent] ON [Operation.load.v](parent,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.load.v.deleted] ON [Operation.load.v](deleted,date,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.load.v.code] ON [Operation.load.v](code,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.load.v.user] ON [Operation.load.v]([user],id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.load.v.company] ON [Operation.load.v](company,id);
      
GO
GRANT SELECT ON dbo.[Operation.load.v]TO jetti; 
GO
ALTER SECURITY POLICY[rls].[companyAccessPolicy]
      ADD FILTER PREDICATE[rls].[fn_companyAccessPredicate]([company]) ON[dbo].[Operation.load.v];
      RAISERROR('Operation.load finish', 0 ,1) WITH NOWAIT;
      
------------------------------ BEGIN Operation.load ------------------------------

      
------------------------------ BEGIN Operation.OperName1 ------------------------------

      RAISERROR('Operation.OperName1 start', 0 ,1) WITH NOWAIT;
      
      BEGIN TRY
        ALTER SECURITY POLICY[rls].[companyAccessPolicy] DROP FILTER PREDICATE ON[dbo].[Operation.OperName1.v];
      END TRY
      BEGIN CATCH
      END CATCH
GO
CREATE OR ALTER VIEW dbo.[Operation.OperName1.v] WITH SCHEMABINDING AS 
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user], [version]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Group"')) [Group]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Operation"')) [Operation]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Amount"')), 0) [Amount]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."currency"')) [currency]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f1"')) [f1]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f2"')) [f2]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f3"')) [f3]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."BankConfirm"')), 0) [BankConfirm]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."BankDocNumber"')), '') [BankDocNumber]
      , TRY_CONVERT(DATE, JSON_VALUE(doc, N'$.BankConfirmDate'),127) [BankConfirmDate]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."BankAccount"')) [BankAccount]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Counterpartie"')) [Counterpartie]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Loan"')) [Loan]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."PaymentKind"')), '') [PaymentKind]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."BankAccountSupplier"')) [BankAccountSupplier]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Department"')) [Department]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."CashFlow"')) [CashFlow]
      FROM dbo.[Documents]
      WHERE JSON_VALUE(doc, N'$."Operation"') = '54AA5310-102E-11EA-AA50-31ECFB22CD33'
; 
GO
CREATE UNIQUE CLUSTERED INDEX[Operation.OperName1.v] ON[Operation.OperName1.v](id);
      CREATE UNIQUE NONCLUSTERED INDEX[Operation.OperName1.v.date] ON[Operation.OperName1.v](date, id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.OperName1.v.parent] ON [Operation.OperName1.v](parent,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.OperName1.v.deleted] ON [Operation.OperName1.v](deleted,date,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.OperName1.v.code] ON [Operation.OperName1.v](code,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.OperName1.v.user] ON [Operation.OperName1.v]([user],id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.OperName1.v.company] ON [Operation.OperName1.v](company,id);
      CREATE UNIQUE NONCLUSTERED INDEX[Operation.OperName1.v.BankConfirm] ON[Operation.OperName1.v](BankConfirm, id) INCLUDE([company]);
CREATE UNIQUE NONCLUSTERED INDEX[Operation.OperName1.v.Counterpartie] ON[Operation.OperName1.v](Counterpartie, id) INCLUDE([company]);
CREATE UNIQUE NONCLUSTERED INDEX[Operation.OperName1.v.Department] ON[Operation.OperName1.v](Department, id) INCLUDE([company]);
GO
GRANT SELECT ON dbo.[Operation.OperName1.v]TO jetti; 
GO
ALTER SECURITY POLICY[rls].[companyAccessPolicy]
      ADD FILTER PREDICATE[rls].[fn_companyAccessPredicate]([company]) ON[dbo].[Operation.OperName1.v];
      RAISERROR('Operation.OperName1 finish', 0 ,1) WITH NOWAIT;
      
------------------------------ BEGIN Operation.OperName1 ------------------------------

      
------------------------------ BEGIN Operation.OperName2 ------------------------------

      RAISERROR('Operation.OperName2 start', 0 ,1) WITH NOWAIT;
      
      BEGIN TRY
        ALTER SECURITY POLICY[rls].[companyAccessPolicy] DROP FILTER PREDICATE ON[dbo].[Operation.OperName2.v];
      END TRY
      BEGIN CATCH
      END CATCH
GO
CREATE OR ALTER VIEW dbo.[Operation.OperName2.v] WITH SCHEMABINDING AS 
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user], [version]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."workflow"')) [workflow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Group"')) [Group]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Operation"')) [Operation]
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."Amount"')), 0) [Amount]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."currency"')) [currency]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f1"')) [f1]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f2"')) [f2]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."f3"')) [f3]
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."BankConfirm"')), 0) [BankConfirm]
      , TRY_CONVERT(DATE, JSON_VALUE(doc, N'$.BankConfirmDate'),127) [BankConfirmDate]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."BankDocNumber"')), '') [BankDocNumber]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."BankAccount"')) [BankAccount]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Supplier"')) [Supplier]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."CashFlow"')) [CashFlow]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."Department"')) [Department]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."BankAccountSupplier"')) [BankAccountSupplier]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."CashFlowAPersons"')) [CashFlowAPersons]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."TaxPaymentCode"')) [TaxPaymentCode]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."TaxOfficeCode2"')), '') [TaxOfficeCode2]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."TaxKPP"')), '') [TaxKPP]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."TaxPayerStatus"')) [TaxPayerStatus]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."TaxBasisPayment"')) [TaxBasisPayment]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."TaxPaymentPeriod"')) [TaxPaymentPeriod]
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."TaxDocNumber"')), '') [TaxDocNumber]
      , TRY_CONVERT(DATE, JSON_VALUE(doc, N'$.TaxDocDate'),127) [TaxDocDate]
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."CompanyParent"')) [CompanyParent]
      FROM dbo.[Documents]
      WHERE JSON_VALUE(doc, N'$."Operation"') = '8D128C20-3E20-11EA-A722-63A01E818155'
; 
GO
<<<<<<< HEAD
CREATE UNIQUE CLUSTERED INDEX[Operation.OperName2.v] ON[Operation.OperName2.v](id);
      CREATE UNIQUE NONCLUSTERED INDEX[Operation.OperName2.v.date] ON[Operation.OperName2.v](date, id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.OperName2.v.parent] ON [Operation.OperName2.v](parent,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.OperName2.v.deleted] ON [Operation.OperName2.v](deleted,date,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.OperName2.v.code] ON [Operation.OperName2.v](code,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.OperName2.v.user] ON [Operation.OperName2.v]([user],id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.OperName2.v.company] ON [Operation.OperName2.v](company,id);
=======
CREATE UNIQUE CLUSTERED INDEX [Operation.IncomeBank_CRAUD_LoanInternational.v] ON [Operation.IncomeBank_CRAUD_LoanInternational.v](id);
      CREATE UNIQUE NONCLUSTERED INDEX[Operation.IncomeBank_CRAUD_LoanInternational.v.date] ON[Operation.IncomeBank_CRAUD_LoanInternational.v](date, id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.IncomeBank_CRAUD_LoanInternational.v.parent] ON [Operation.IncomeBank_CRAUD_LoanInternational.v](parent,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.IncomeBank_CRAUD_LoanInternational.v.deleted] ON [Operation.IncomeBank_CRAUD_LoanInternational.v](deleted,date,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.IncomeBank_CRAUD_LoanInternational.v.code] ON [Operation.IncomeBank_CRAUD_LoanInternational.v](code,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.IncomeBank_CRAUD_LoanInternational.v.user] ON [Operation.IncomeBank_CRAUD_LoanInternational.v]([user],id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.IncomeBank_CRAUD_LoanInternational.v.company] ON [Operation.IncomeBank_CRAUD_LoanInternational.v](company,id);
>>>>>>> 994c07af61a0529f4e27f3a25bc59889422deac5
      
GO
GRANT SELECT ON dbo.[Operation.OperName2.v]TO jetti; 
GO
ALTER SECURITY POLICY[rls].[companyAccessPolicy]
      ADD FILTER PREDICATE[rls].[fn_companyAccessPredicate]([company]) ON[dbo].[Operation.OperName2.v];
      RAISERROR('Operation.OperName2 finish', 0 ,1) WITH NOWAIT;
      
------------------------------ BEGIN Operation.OperName2 ------------------------------

      
<<<<<<< HEAD
------------------------------ BEGIN Operation.respPerson ------------------------------
=======
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
>>>>>>> 994c07af61a0529f4e27f3a25bc59889422deac5

      RAISERROR('Operation.respPerson start', 0 ,1) WITH NOWAIT;
      
      BEGIN TRY
        ALTER SECURITY POLICY[rls].[companyAccessPolicy] DROP FILTER PREDICATE ON[dbo].[Operation.respPerson.v];
      END TRY
      BEGIN CATCH
      END CATCH
GO
CREATE OR ALTER VIEW dbo.[Operation.respPerson.v] WITH SCHEMABINDING AS 
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
      WHERE JSON_VALUE(doc, N'$."Operation"') = '1D6E2830-5CA1-11EA-9517-37B915E1B97B'
; 
GO
<<<<<<< HEAD
CREATE UNIQUE CLUSTERED INDEX[Operation.respPerson.v] ON[Operation.respPerson.v](id);
      CREATE UNIQUE NONCLUSTERED INDEX[Operation.respPerson.v.date] ON[Operation.respPerson.v](date, id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.respPerson.v.parent] ON [Operation.respPerson.v](parent,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.respPerson.v.deleted] ON [Operation.respPerson.v](deleted,date,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.respPerson.v.code] ON [Operation.respPerson.v](code,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.respPerson.v.user] ON [Operation.respPerson.v]([user],id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.respPerson.v.company] ON [Operation.respPerson.v](company,id);
=======
CREATE UNIQUE CLUSTERED INDEX [Operation.LotModelsVsDepartment.v] ON [Operation.LotModelsVsDepartment.v](id);
      CREATE UNIQUE NONCLUSTERED INDEX[Operation.LotModelsVsDepartment.v.date] ON[Operation.LotModelsVsDepartment.v](date, id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.LotModelsVsDepartment.v.parent] ON [Operation.LotModelsVsDepartment.v](parent,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.LotModelsVsDepartment.v.deleted] ON [Operation.LotModelsVsDepartment.v](deleted,date,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.LotModelsVsDepartment.v.code] ON [Operation.LotModelsVsDepartment.v](code,id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.LotModelsVsDepartment.v.user] ON [Operation.LotModelsVsDepartment.v]([user],id);
      CREATE UNIQUE NONCLUSTERED INDEX [Operation.LotModelsVsDepartment.v.company] ON [Operation.LotModelsVsDepartment.v](company,id);
>>>>>>> 994c07af61a0529f4e27f3a25bc59889422deac5
      
GO
GRANT SELECT ON dbo.[Operation.respPerson.v]TO jetti; 
GO
ALTER SECURITY POLICY[rls].[companyAccessPolicy]
      ADD FILTER PREDICATE[rls].[fn_companyAccessPredicate]([company]) ON[dbo].[Operation.respPerson.v];
      RAISERROR('Operation.respPerson finish', 0 ,1) WITH NOWAIT;
      
------------------------------ BEGIN Operation.respPerson ------------------------------

      