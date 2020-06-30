export type CatalogTypes =
  'Catalog.Attachment' |
  'Catalog.Attachment.Type' |
  'Catalog.AllUnic.Lot' |
  'Catalog.Catalog' |
  'Catalog.Account' |
  'Catalog.Balance' |
  'Catalog.Balance.Analytics' |
  'Catalog.BankAccount' |
  'Catalog.Brand' |
  'Catalog.CashFlow' |
  'Catalog.CashRegister' |
  'Catalog.Company' |
  'Catalog.Company.Group' |
  'Catalog.Country' |
  'Catalog.Counterpartie' |
  'Catalog.Currency' |
  'Catalog.Department' |
  'Catalog.Department.Kind' |
  'Catalog.Department.StatusReason' |
  'Catalog.PersonIdentity' |
  'Catalog.Expense' |
  'Catalog.Expense.Analytics' |
  'Catalog.Income' |
  'Catalog.Loan' |
  'Catalog.Operation' |
  'Catalog.Operation.Group' |
  'Catalog.Operation.Type' |
  'Catalog.Manager' |
  'Catalog.Person.BankAccount' |
  'Catalog.Person' |
  'Catalog.PriceType' |
  'Catalog.PlanningScenario' |
  'Catalog.Product' |
  'Catalog.Storehouse' |
  'Catalog.Salary.Analytics' |
  'Catalog.Subcount' |
  'Catalog.Documents' |
  'Catalog.Catalogs' |
  'Catalog.Forms' |
  'Catalog.Objects' |
  'Catalog.User' |
  'Catalog.UsersGroup' |
  'Catalog.Role' |
  'Catalog.SubSystem' |
  'Catalog.SalaryProject' |
  'Catalog.StaffingTable' |
  'Catalog.Unit' |
  'Catalog.TaxRate' |
  'Catalog.ProductCategory' |
  'Catalog.Product.Report' |
  'Catalog.ProductKind' |
  'Catalog.ObjectsExploitation' |
  'Catalog.OrderSource' |
  'Catalog.GroupObjectsExploitation' |
  'Catalog.Scenario' |
  'Catalog.BudgetItem' |
  'Catalog.AcquiringTerminal' |
  'Catalog.Bank' |
  'Catalog.Counterpartie.BankAccount' |
  'Catalog.Contract' |
  'Catalog.LoanRepaymentProcedure' |
  'Catalog.LoanTypes' |
  'Catalog.BusinessDirection' |
  'Catalog.JobTitle' |
  'Catalog.JobTitle.Category' |
  'Catalog.BusinessRegion' |
  'Catalog.TaxPaymentCode' |
  'Catalog.TaxAssignmentCode' |
  'Catalog.TaxPaymentPeriod' |
  'Catalog.TaxPayerStatus' |
  'Catalog.TaxBasisPayment' |
  'Catalog.TaxOffice' |
  'Catalog.RetailClient' |
  'Catalog.Contract.Intercompany' |
  'Catalog.ResourceSpecification' |
  'Catalog.InvestorGroup' |
  'Catalog.ReasonTypes' |
  'Catalog.Employee'
  ;

export type DocumentTypes =
  'Document.ExchangeRates' |
  'Document.Invoice' |
  'Document.Operation' |
  'Document.PriceList' |
  'Document.Settings' |
  'Document.UserSettings' |
  'Document.CashRequest' |
  'Document.WorkFlow' |
  'Document.CashRequestRegistry';

export type ProcessTypes =
  'BusinessProcess.CashRequestApproving';

export type DocTypes =
  CatalogTypes |
  DocumentTypes;

export type AllDocTypes =
  DocTypes |
  ComplexTypes;

export type PrimitiveTypes =
  'string' |
  'number' |
  'date' |
  'datetime' |
  'time' |
  'boolean' |
  'table' |
  'json' |
  'javascript' |
  'textarea' |
  'enum' |
  'link' |
  'URL';

export type ComplexTypes =
  'Types.Document' |
  'Types.Subcount' |
  'Types.Catalog' |
  'Types.Object' |
  'Types.UserOrGroup' |
  'Types.CashOrBank' |
  'Types.CashRecipient' |
  'Types.CounterpartieOrPerson' |
  'Types.PersonOrCounterpartieBankAccount' |
  'Types.CompanyOrCounterpartieOrPerson' |
  'Types.CompanyOrCompanyGroup' |
  'Types.ExpenseOrBalance';

export type IncomeExpenseTypes =
  'Catalog.Expense' |
  'Catalog.Income';

export type CashOrBank =
  'Catalog.BankAccount' |
  'Catalog.CashRegister';

export type IncomeExpenseAnalyticTypes =
  'Catalog.Expense.Analytics' |
  'Catalog.Income.Analytics';

export type AllTypes =
  PrimitiveTypes |
  ComplexTypes |
  DocTypes;
