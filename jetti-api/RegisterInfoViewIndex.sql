
------------------------------ BEGIN Register.Info.Dynamic ------------------------------

    CREATE OR ALTER VIEW [Register.Info.Dynamic]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.Dynamic';
    GO
    GRANT SELECT,DELETE ON [Register.Info.Dynamic] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.Dynamic] ON [dbo].[Register.Info.Dynamic](
      company,date,id
    )
    GO
    
------------------------------ END Register.Info.Dynamic ------------------------------

------------------------------ BEGIN Register.Info.Holiday ------------------------------

    CREATE OR ALTER VIEW [Register.Info.Holiday]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Country"')) "Country"
        , ISNULL(JSON_VALUE(data, '$.Info'), '') "Info"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.Holiday';
    GO
    GRANT SELECT,DELETE ON [Register.Info.Holiday] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.Holiday] ON [dbo].[Register.Info.Holiday](
      company,date,id
    )
    GO
    
------------------------------ END Register.Info.Holiday ------------------------------

------------------------------ BEGIN Register.Info.PriceList ------------------------------

    CREATE OR ALTER VIEW [Register.Info.PriceList]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) "Department"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Storehouse"')) "Storehouse"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Product"')) "Product"
        , ISNULL(JSON_VALUE(data, '$.Role'), '') "Role"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Unit"')) "Unit"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) "currency"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."PriceType"')) "PriceType"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Price')) "Price"
        , TRY_CONVERT(BIT, JSON_VALUE(data, N'$.forSales')) "forSales"
        , TRY_CONVERT(BIT, JSON_VALUE(data, N'$.forPurchases')) "forPurchases"
        , TRY_CONVERT(BIT, JSON_VALUE(data, N'$.isActive')) "isActive"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.PriceList';
    GO
    GRANT SELECT,DELETE ON [Register.Info.PriceList] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.PriceList] ON [dbo].[Register.Info.PriceList](
      company,date,id
    )
    GO
    
------------------------------ END Register.Info.PriceList ------------------------------

------------------------------ BEGIN Register.Info.SelfEmployed ------------------------------

    CREATE OR ALTER VIEW [Register.Info.SelfEmployed]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Person"')) "Person"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Contract"')) "Contract"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BankAccount"')) "BankAccount"
        , TRY_CONVERT(BIT, JSON_VALUE(data, N'$.isActive')) "isActive"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.SelfEmployed';
    GO
    GRANT SELECT,DELETE ON [Register.Info.SelfEmployed] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.SelfEmployed] ON [dbo].[Register.Info.SelfEmployed](
      company,date,id
    )
    GO
    
------------------------------ END Register.Info.SelfEmployed ------------------------------

------------------------------ BEGIN Register.Info.ProductModifier ------------------------------

    CREATE OR ALTER VIEW [Register.Info.ProductModifier]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) "Department"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Product"')) "Product"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Modifier"')) "Modifier"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Qty')) "Qty"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.ProductModifier';
    GO
    GRANT SELECT,DELETE ON [Register.Info.ProductModifier] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.ProductModifier] ON [dbo].[Register.Info.ProductModifier](
      company,date,id
    )
    GO
    
------------------------------ END Register.Info.ProductModifier ------------------------------

------------------------------ BEGIN Register.Info.SettlementsReconciliation ------------------------------

    CREATE OR ALTER VIEW [Register.Info.SettlementsReconciliation]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Customer"')) "Customer"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Contract"')) "Contract"
        , ISNULL(JSON_VALUE(data, '$.Status'), '') "Status"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) "currency"
        , TRY_CONVERT(DATE,JSON_VALUE(data, N'$.Period'),127) "Period"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Operation"')) "Operation"
        , ISNULL(JSON_VALUE(data, '$.OperationDescription'), '') "OperationDescription"
        , ISNULL(JSON_VALUE(data, '$.OperationInDocNumber'), '') "OperationInDocNumber"
        , TRY_CONVERT(DATE,JSON_VALUE(data, N'$.OperationInDocDate'),127) "OperationInDocDate"
        , ISNULL(JSON_VALUE(data, '$.Comment'), '') "Comment"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Amount')) "Amount"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountPaid')) "AmountPaid"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountBalance')) "AmountBalance"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.SettlementsReconciliation';
    GO
    GRANT SELECT,DELETE ON [Register.Info.SettlementsReconciliation] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.SettlementsReconciliation] ON [dbo].[Register.Info.SettlementsReconciliation](
      company,date,id
    )
    GO
    
------------------------------ END Register.Info.SettlementsReconciliation ------------------------------

------------------------------ BEGIN Register.Info.ExchangeRates ------------------------------

    CREATE OR ALTER VIEW [Register.Info.ExchangeRates]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) "currency"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Rate')) "Rate"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Mutiplicity')) "Mutiplicity"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.ExchangeRates';
    GO
    GRANT SELECT,DELETE ON [Register.Info.ExchangeRates] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.ExchangeRates] ON [dbo].[Register.Info.ExchangeRates](
      company,date,id
    )
    GO
    
------------------------------ END Register.Info.ExchangeRates ------------------------------

------------------------------ BEGIN Register.Info.ExchangeRates.National ------------------------------

    CREATE OR ALTER VIEW [Register.Info.ExchangeRates.National]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Country"')) "Country"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Currency1"')) "Currency1"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Currency2"')) "Currency2"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Rate')) "Rate"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Mutiplicity')) "Mutiplicity"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.ExchangeRates.National';
    GO
    GRANT SELECT,DELETE ON [Register.Info.ExchangeRates.National] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.ExchangeRates.National] ON [dbo].[Register.Info.ExchangeRates.National](
      company,date,id
    )
    GO
    
------------------------------ END Register.Info.ExchangeRates.National ------------------------------

------------------------------ BEGIN Register.Info.ProductSpecificationByDepartment ------------------------------

    CREATE OR ALTER VIEW [Register.Info.ProductSpecificationByDepartment]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) "Department"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Storehouse"')) "Storehouse"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Product"')) "Product"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Specification"')) "Specification"
        , TRY_CONVERT(BIT, JSON_VALUE(data, N'$.isActive')) "isActive"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.ProductSpecificationByDepartment';
    GO
    GRANT SELECT,DELETE ON [Register.Info.ProductSpecificationByDepartment] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.ProductSpecificationByDepartment] ON [dbo].[Register.Info.ProductSpecificationByDepartment](
      company,date,id
    )
    GO
    
------------------------------ END Register.Info.ProductSpecificationByDepartment ------------------------------

------------------------------ BEGIN Register.Info.Settings ------------------------------

    CREATE OR ALTER VIEW [Register.Info.Settings]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."balanceCurrency"')) "balanceCurrency"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."accountingCurrency"')) "accountingCurrency"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.Settings';
    GO
    GRANT SELECT,DELETE ON [Register.Info.Settings] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.Settings] ON [dbo].[Register.Info.Settings](
      company,date,id
    )
    GO
    
------------------------------ END Register.Info.Settings ------------------------------

------------------------------ BEGIN Register.Info.Depreciation ------------------------------

    CREATE OR ALTER VIEW [Register.Info.Depreciation]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."OE"')) "OE"
        , TRY_CONVERT(DATE,JSON_VALUE(data, N'$.StartDate'),127) "StartDate"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Period')) "Period"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.StartCost')) "StartCost"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.EndCost')) "EndCost"
        , ISNULL(JSON_VALUE(data, '$.Method'), '') "Method"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.Depreciation';
    GO
    GRANT SELECT,DELETE ON [Register.Info.Depreciation] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.Depreciation] ON [dbo].[Register.Info.Depreciation](
      company,date,id
    )
    GO
    
------------------------------ END Register.Info.Depreciation ------------------------------

------------------------------ BEGIN Register.Info.RLS.Period ------------------------------

    CREATE OR ALTER VIEW [Register.Info.RLS.Period]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , ISNULL(JSON_VALUE(data, '$.user'), '') "user"
        , ISNULL(JSON_VALUE(data, '$.partition'), '') "partition"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.RLS.Period';
    GO
    GRANT SELECT,DELETE ON [Register.Info.RLS.Period] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.RLS.Period] ON [dbo].[Register.Info.RLS.Period](
      company,date,id
    )
    GO
    
------------------------------ END Register.Info.RLS.Period ------------------------------

------------------------------ BEGIN Register.Info.RLS ------------------------------

    CREATE OR ALTER VIEW [Register.Info.RLS]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , ISNULL(JSON_VALUE(data, '$.user'), '') "user"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.RLS';
    GO
    GRANT SELECT,DELETE ON [Register.Info.RLS] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.RLS] ON [dbo].[Register.Info.RLS](
      company,date,id
    )
    GO
    
------------------------------ END Register.Info.RLS ------------------------------

------------------------------ BEGIN Register.Info.BudgetItemRule ------------------------------

    CREATE OR ALTER VIEW [Register.Info.BudgetItemRule]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."BudgetItem"')) "BudgetItem"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Scenario"')) "Scenario"
        , ISNULL(JSON_VALUE(data, '$.Rule'), '') "Rule"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.BudgetItemRule';
    GO
    GRANT SELECT,DELETE ON [Register.Info.BudgetItemRule] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.BudgetItemRule] ON [dbo].[Register.Info.BudgetItemRule](
      company,date,id
    )
    GO
    
------------------------------ END Register.Info.BudgetItemRule ------------------------------

------------------------------ BEGIN Register.Info.IntercompanyHistory ------------------------------

    CREATE OR ALTER VIEW [Register.Info.IntercompanyHistory]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Intercompany"')) "Intercompany"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.IntercompanyHistory';
    GO
    GRANT SELECT,DELETE ON [Register.Info.IntercompanyHistory] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.IntercompanyHistory] ON [dbo].[Register.Info.IntercompanyHistory](
      company,date,id
    )
    GO
    
------------------------------ END Register.Info.IntercompanyHistory ------------------------------

------------------------------ BEGIN Register.Info.DepartmentCompanyHistory ------------------------------

    CREATE OR ALTER VIEW [Register.Info.DepartmentCompanyHistory]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) "Department"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."company2"')) "company2"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."InvestorGroup"')) "InvestorGroup"
        , ISNULL(JSON_VALUE(data, '$.TypeFranchise'), '') "TypeFranchise"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.DepartmentCompanyHistory';
    GO
    GRANT SELECT,DELETE ON [Register.Info.DepartmentCompanyHistory] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.DepartmentCompanyHistory] ON [dbo].[Register.Info.DepartmentCompanyHistory](
      company,date,id
    )
    GO
    
------------------------------ END Register.Info.DepartmentCompanyHistory ------------------------------

------------------------------ BEGIN Register.Info.DepartmentStatus ------------------------------

    CREATE OR ALTER VIEW [Register.Info.DepartmentStatus]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) "Department"
        , TRY_CONVERT(DATE,JSON_VALUE(data, N'$.BeginDate'),127) "BeginDate"
        , TRY_CONVERT(DATE,JSON_VALUE(data, N'$.EndDate'),127) "EndDate"
        , ISNULL(JSON_VALUE(data, '$.Info'), '') "Info"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."StatusReason"')) "StatusReason"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.DepartmentStatus';
    GO
    GRANT SELECT,DELETE ON [Register.Info.DepartmentStatus] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.DepartmentStatus] ON [dbo].[Register.Info.DepartmentStatus](
      company,date,id
    )
    GO
    
------------------------------ END Register.Info.DepartmentStatus ------------------------------

------------------------------ BEGIN Register.Info.CounterpartiePriceList ------------------------------

    CREATE OR ALTER VIEW [Register.Info.CounterpartiePriceList]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , ISNULL(JSON_VALUE(data, '$.Scenario'), '') "Scenario"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Counterpartie"')) "Counterpartie"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Contract"')) "Contract"
        , ISNULL(JSON_VALUE(data, '$.DocNumber'), '') "DocNumber"
        , TRY_CONVERT(DATETIME,JSON_VALUE(data, N'$.DocDate'),127) "DocDate"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) "Department"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Storehouse"')) "Storehouse"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Product"')) "Product"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Qty')) "Qty"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Price')) "Price"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Cost')) "Cost"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) "currency"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.CounterpartiePriceList';
    GO
    GRANT SELECT,DELETE ON [Register.Info.CounterpartiePriceList] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.CounterpartiePriceList] ON [dbo].[Register.Info.CounterpartiePriceList](
      company,date,id
    )
    GO
    
------------------------------ END Register.Info.CounterpartiePriceList ------------------------------

------------------------------ BEGIN Register.Info.CompanyResponsiblePersons ------------------------------

    CREATE OR ALTER VIEW [Register.Info.CompanyResponsiblePersons]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."companyOrGroup"')) "companyOrGroup"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) "Department"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Loan"')) "Loan"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."User"')) "User"
        , TRY_CONVERT(BIT, JSON_VALUE(data, N'$.isActive')) "isActive"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.CompanyResponsiblePersons';
    GO
    GRANT SELECT,DELETE ON [Register.Info.CompanyResponsiblePersons] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.CompanyResponsiblePersons] ON [dbo].[Register.Info.CompanyResponsiblePersons](
      company,date,id
    )
    GO
    
------------------------------ END Register.Info.CompanyResponsiblePersons ------------------------------

------------------------------ BEGIN Register.Info.IncomeDocumentRegistry ------------------------------

    CREATE OR ALTER VIEW [Register.Info.IncomeDocumentRegistry]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , ISNULL(JSON_VALUE(data, '$.StatusRegistry'), '') "StatusRegistry"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."OperationType"')) "OperationType"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Counterpartie"')) "Counterpartie"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Currency"')) "Currency"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) "Department"
        , ISNULL(JSON_VALUE(data, '$.DocNumber'), '') "DocNumber"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."DocJETTI"')) "DocJETTI"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountIncome')) "AmountIncome"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountJETTI')) "AmountJETTI"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."ReasonType"')) "ReasonType"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.IncomeDocumentRegistry';
    GO
    GRANT SELECT,DELETE ON [Register.Info.IncomeDocumentRegistry] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.IncomeDocumentRegistry] ON [dbo].[Register.Info.IncomeDocumentRegistry](
      company,date,id
    )
    GO
    
------------------------------ END Register.Info.IncomeDocumentRegistry ------------------------------

------------------------------ BEGIN Register.Info.CompanyPrice ------------------------------

    CREATE OR ALTER VIEW [Register.Info.CompanyPrice]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) "currency"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.CompanyPrice')) "CompanyPrice"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.CompanyPrice';
    GO
    GRANT SELECT,DELETE ON [Register.Info.CompanyPrice] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.CompanyPrice] ON [dbo].[Register.Info.CompanyPrice](
      company,date,id
    )
    GO
    
------------------------------ END Register.Info.CompanyPrice ------------------------------

------------------------------ BEGIN Register.Info.ShareEmission ------------------------------

    CREATE OR ALTER VIEW [Register.Info.ShareEmission]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."currency"')) "currency"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.SharePrice')) "SharePrice"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.ShareQty')) "ShareQty"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.ShareEmission';
    GO
    GRANT SELECT,DELETE ON [Register.Info.ShareEmission] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.ShareEmission] ON [dbo].[Register.Info.ShareEmission](
      company,date,id
    )
    GO
    
------------------------------ END Register.Info.ShareEmission ------------------------------

------------------------------ BEGIN Register.Info.LoanOwner ------------------------------

    CREATE OR ALTER VIEW [Register.Info.LoanOwner]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."User"')) "User"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."LoanOwner"')) "LoanOwner"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.LoanOwner';
    GO
    GRANT SELECT,DELETE ON [Register.Info.LoanOwner] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.LoanOwner] ON [dbo].[Register.Info.LoanOwner](
      company,date,id
    )
    GO
    
------------------------------ END Register.Info.LoanOwner ------------------------------

------------------------------ BEGIN Register.Info.RoyaltySales ------------------------------

    CREATE OR ALTER VIEW [Register.Info.RoyaltySales]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) "Department"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountMin')) "AmountMin"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.AmountMax')) "AmountMax"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.Royalty')) "Royalty"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.RoyaltySales';
    GO
    GRANT SELECT,DELETE ON [Register.Info.RoyaltySales] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.RoyaltySales] ON [dbo].[Register.Info.RoyaltySales](
      company,date,id
    )
    GO
    
------------------------------ END Register.Info.RoyaltySales ------------------------------

------------------------------ BEGIN Register.Info.EmployeeHistory ------------------------------

    CREATE OR ALTER VIEW [Register.Info.EmployeeHistory]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Employee"')) "Employee"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Person"')) "Person"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."Department"')) "Department"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."DepartmentCompany"')) "DepartmentCompany"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."JobTitle"')) "JobTitle"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."StaffingPosition"')) "StaffingPosition"
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."OperationType"')) "OperationType"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.SalaryRate')) "SalaryRate"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.EmployeeHistory';
    GO
    GRANT SELECT,DELETE ON [Register.Info.EmployeeHistory] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.EmployeeHistory] ON [dbo].[Register.Info.EmployeeHistory](
      company,date,id
    )
    GO
    
------------------------------ END Register.Info.EmployeeHistory ------------------------------

------------------------------ BEGIN Register.Info.TaxCheck ------------------------------

    CREATE OR ALTER VIEW [Register.Info.TaxCheck]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company
        , ISNULL(JSON_VALUE(data, '$.clientInn'), '') "clientInn"
        , ISNULL(JSON_VALUE(data, '$.inn'), '') "inn"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.totalAmount')) "totalAmount"
        , ISNULL(JSON_VALUE(data, '$.receiptId'), '') "receiptId"
        , TRY_CONVERT(DATETIME,JSON_VALUE(data, N'$.operationTime'),127) "operationTime"
        , TRY_CONVERT(DATETIME,JSON_VALUE(data, N'$.modifyDate'),127) "modifyDate"
      FROM dbo.[Register.Info] WHERE type = N'Register.Info.TaxCheck';
    GO
    GRANT SELECT,DELETE ON [Register.Info.TaxCheck] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [Register.Info.TaxCheck] ON [dbo].[Register.Info.TaxCheck](
      company,date,id
    )
    GO
    
------------------------------ END Register.Info.TaxCheck ------------------------------
