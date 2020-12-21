import { CatalogProductPackage } from './Catalogs/Catalog.Product.Package';
import { CatalogEmployee } from './Catalogs/Catalog.Employee';
import { CatalogAttachmentType } from './Catalogs/Catalog.Attachment.Type';
import { CatalogReasonTypes } from './Catalogs/Catalog.ReasonTypes';
import { CatalogJobTitleCategory } from './Catalogs/Catalog.JobTitle.Category';
import { CatalogProductReport } from './Catalogs/Catalog.Product.Report';
import { CatalogDepartmentStatusReason } from './Catalogs/Catalog.Department.StatusReason';
import { CatalogDepartmentKind } from './Catalogs/Catalog.Department.Kind';
import { CatalogContractIntercompany } from './Catalogs/Catalog.Contract.Intercompany';
import { CatalogPersonIdentity } from './Catalogs/Catalog.PersonIdentity';
import { CatalogLoanRepaymentProcedure } from './Catalogs/Catalog.LoanRepaymentProcedure';
import { CatalogCountry } from './Catalogs/Catalog.Country';
import { CatalogTaxAssignmentCode } from './Catalogs/Catalog.TaxAssignmentCode';
import { CatalogAccount } from './Catalogs/Catalog.Account';
import { CatalogBalance } from './Catalogs/Catalog.Balance';
import { CatalogBalanceAnalytics } from './Catalogs/Catalog.Balance.Analytics';
import { CatalogBankAccount } from './Catalogs/Catalog.BankAccount';
import { CatalogBrand } from './Catalogs/Catalog.Brand';
import { CatalogCashFlow } from './Catalogs/Catalog.CashFlow';
import { CatalogCashRegister } from './Catalogs/Catalog.CashRegister';
import { CatalogCatalog } from './Catalogs/Catalog.Catalog';
import { CatalogCatalogs } from './Catalogs/Catalog.Catalogs';
import { CatalogCompany } from './Catalogs/Catalog.Company';
import { CatalogCounterpartie } from './Catalogs/Catalog.Counterpartie';
import { CatalogCurrency } from './Catalogs/Catalog.Currency';
import { CatalogDepartment } from './Catalogs/Catalog.Department';
import { CatalogDocuments } from './Catalogs/Catalog.Documents';
import { CatalogExpense } from './Catalogs/Catalog.Expense';
import { CatalogExpenseAnalytics } from './Catalogs/Catalog.Expense.Analytics';
import { CatalogGroupObjectsExploitation } from './Catalogs/Catalog.GroupObjectsExploitation';
import { CatalogIncome } from './Catalogs/Catalog.Income';
import { CatalogLoan } from './Catalogs/Catalog.Loan';
import { CatalogManager } from './Catalogs/Catalog.Manager';
import { CatalogObjects } from './Catalogs/Catalog.Objects';
import { CatalogObjectsExploitation } from './Catalogs/Catalog.ObjectsExploitation';
import { CatalogOperation } from './Catalogs/Catalog.Operation';
import { CatalogOperationGroup } from './Catalogs/Catalog.Operation.Group';
import { CatalogPerson } from './Catalogs/Catalog.Person';
import { CatalogPriceType } from './Catalogs/Catalog.PriceType';
import { CatalogPromotionChannel } from './Catalogs/Catalog.PromotionChannel';
import { CatalogProduct } from './Catalogs/Catalog.Product';
import { CatalogProductCategory } from './Catalogs/Catalog.ProductCategory';
import { CatalogProductKind } from './Catalogs/Catalog.ProductKind';
import { CatalogRole } from './Catalogs/Catalog.Role';
import { CatalogStorehouse } from './Catalogs/Catalog.Storehouse';
import { CatalogSubcount } from './Catalogs/Catalog.Subcount';
import { CatalogSubSystem } from './Catalogs/Catalog.SubSystem';
import { CatalogUnit } from './Catalogs/Catalog.Unit';
import { CatalogUser } from './Catalogs/Catalog.User';
import { DocumentBase, Ref } from './document';
import { DocTypes, AllTypes } from './documents.types';
import { DocumentExchangeRates } from './Documents/Document.ExchangeRates';
import { DocumentInvoice } from './Documents/Document.Invoice';
import { DocumentOperation } from './Documents/Document.Operation';
import { DocumentPriceList } from './Documents/Document.PriceList';
import { DocumentSettings } from './Documents/Document.Settings';
import { DocumentUserSettings } from './Documents/Document.UserSettings';
import { CatalogOperationType } from './Catalogs/Catalog.Operation.Type';
import { CatalogBudgetItem } from './Catalogs/Catalog.BudgetItem';
import { CatalogScenario } from './Catalogs/Catalog.Scenario';
import { CatalogAcquiringTerminal } from './Catalogs/Catalog.AcquiringTerminal';
import { CatalogBank } from './Catalogs/Catalog.Bank';
import { CatalogForms } from './Catalogs/Catalog.Forms';
import { CatalogUsersGroup } from './Catalogs/Catalog.UsersGroup';
import { CatalogCounterpartieBankAccount } from './Catalogs/Catalog.Counterpartie.BankAccount';
import { CatalogContract } from './Catalogs/Catalog.Contract';
import { CatalogBusinessDirection } from './Catalogs/Catalog.BusinessDirection';
import { DocumentWorkFlow } from './Documents/Document.WokrFlow';
import { DocumentCashRequest } from './Documents/Document.CashRequest';
import { CatalogLoanTypes } from './Catalogs/Catalog.LoanTypes';
import { DocumentCashRequestRegistry } from './Documents/Document.CashRequestRegistry';
import { CatalogJobTitle } from './Catalogs/Catalog.JobTitle';
import { CatalogBusinessRegion } from './Catalogs/Catalog.BusinessRegion';
import { CatalogTaxRate } from './Catalogs/Catalog.TaxRates';
import { CatalogTaxPaymentCode } from './Catalogs/Catalog.TaxPaymentCode';
import { CatalogTaxPaymentPeriod } from './Catalogs/Catalog.TaxPaymentPeriod';
import { CatalogTaxPayerStatus } from './Catalogs/Catalog.TaxPayerStatus';
import { CatalogRetailClient } from './Catalogs/Catalog.RetailClient';
import { CatalogTaxOffice } from './Catalogs/Catalog.TaxOffice';
import { CatalogPersonBankAccount } from './Catalogs/Catalog.Person.BankAccount';
import { CatalogPersonContract } from './Catalogs/Catalog.Person.Contract';
import { CatalogSalaryProject } from './Catalogs/Catalog.SalaryProject';
import { CatalogTaxBasisPayment } from './Catalogs/Catalog.TaxBasisPayment';
import { CatalogSalaryAnalytics } from './Catalogs/Catalog.Salary.Analytics';
import { CatalogCompanyGroup } from './Catalogs/Catalog.Company.Group';
import { CatalogPlanningScenario } from './Catalogs/Catalog.PlanningScenario';
import { CatalogSpecification } from './Catalogs/Catalog.Specification';
import { CatalogOrderSource } from './Catalogs/Catalog.OrderSource';
import { CatalogInvestorGroup } from './Catalogs/Catalog.InvestorGroup';
import { CatalogAttachment } from './Catalogs/Catalog.Attachment';
import { CatalogStaffingTable } from './Catalogs/Catalog.StaffingTable';
import { CatalogAllUnicLot } from './Catalogs/Catalog.AllUnic.Lot';
import { CatalogManufactureLocation } from './Catalogs/Catalog.ManufactureLocation';
import { CatalogProductAnalytic } from './Catalogs/Catalog.Product.Analytic';
import { CatalogDepartmentCompany } from './Catalogs/Catalog.Department.Company';
import { CatalogDynamic } from './Dynamic/dynamic.prototype';
import { CatalogResponsibilityCenter } from './Catalogs/Catalog.ResponsibilityCenter';
import { Global } from './global';
import { defaultTypeValue } from './Types/Types.factory';
import { CatalogConfiguration } from './Catalogs/Catalog.Configuration';
import { CatalogRetailNetwork } from './Catalogs/Catalog.RetailNetwork';
import { configSchema, getConfigSchema } from './config';

export interface INoSqlDocument {
  id: Ref;
  date: Date;
  type: DocTypes;
  code: string;
  description: string;
  company: Ref;
  user: Ref;
  posted: boolean;
  deleted: boolean;
  isfolder: boolean;
  parent: Ref;
  info: string;
  timestamp: Date;
  ExchangeCode?: string;
  ExchangeBase?: string;
  doc: { [x: string]: any };
  docByKeys?: { key: string, value: any }[];
}

export interface IFlatDocument {
  id: Ref;
  date: Date;
  type: DocTypes;
  code: string;
  description: string;
  company: Ref;
  user: Ref;
  posted: boolean;
  deleted: boolean;
  isfolder: boolean;
  parent: Ref;
  info: string;
  timestamp: Date | null;
  ExchangeCode?: string;
  ExchangeBase?: string;
}

export function createDocument<T extends DocumentBase>(type: DocTypes, document?: IFlatDocument): T {

  const cs = configSchema().get(type);
  let result: DocumentBase;
  const doc = RegisteredDocuments().get(type);
  if (!doc) throw new Error(`createDocument: can't create '${type}' type! '${type}' is not registered`);
  result = <T>new doc.Class;
  if (doc.dynamic) {
    const docMeta = Global.dynamicMeta().Metadata.find(e => e.type === type);
    const Props = docMeta!.Props();
    Object.keys(Props)
      .forEach(propName => {
        const defVal = Object.keys(Props[propName]).find(propOpts => propOpts === 'value');
        result[propName] = defVal || defaultTypeValue(Props[propName].type);
      });
    result.Props = () => ({ ...Props });
    result.Prop = () => ({ ...docMeta!.Prop() });
    result.type = type;
    if (!document && !result.date) result.date = new Date;
  } else {
    const ArrayProps = Object.keys(result).filter(k => Array.isArray(result[k]));
    ArrayProps.forEach(prop => result[prop].length = 0);
  }
  if (document) result.map(document);
  return result as T;
}

export interface RegisteredDocumentType { type: DocTypes; Class: typeof DocumentBase; dynamic?: boolean; }


export function RegisteredDocumentsTypes(filter?: (DocTypes) => boolean): DocTypes[] {
  if (filter) return [...RegisteredDocuments().keys()].filter(filter);
  return [...RegisteredDocuments().keys()];
}

export function RegisteredDocuments(): Map<DocTypes, RegisteredDocumentType> {
  return Global.RegisteredDocuments(); // global['RegisteredDocuments'] || new Map();
}

export const RegisteredDocumentStatic: RegisteredDocumentType[] = [
  { type: 'Catalog.ResponsibilityCenter', Class: CatalogResponsibilityCenter },
  { type: 'Catalog.Dynamic', Class: CatalogDynamic },
  { type: 'Catalog.Attachment', Class: CatalogAttachment },
  { type: 'Catalog.Attachment.Type', Class: CatalogAttachmentType },
  { type: 'Catalog.AllUnic.Lot', Class: CatalogAllUnicLot },
  { type: 'Catalog.Account', Class: CatalogAccount },
  { type: 'Catalog.Balance', Class: CatalogBalance },
  { type: 'Catalog.Balance.Analytics', Class: CatalogBalanceAnalytics },
  { type: 'Catalog.BankAccount', Class: CatalogBankAccount },
  { type: 'Catalog.CashFlow', Class: CatalogCashFlow },
  { type: 'Catalog.CashRegister', Class: CatalogCashRegister },
  { type: 'Catalog.Currency', Class: CatalogCurrency },
  { type: 'Catalog.Configuration', Class: CatalogConfiguration },
  { type: 'Catalog.Company', Class: CatalogCompany },
  { type: 'Catalog.Company.Group', Class: CatalogCompanyGroup },
  { type: 'Catalog.Country', Class: CatalogCountry },
  { type: 'Catalog.Counterpartie', Class: CatalogCounterpartie },
  { type: 'Catalog.Counterpartie.BankAccount', Class: CatalogCounterpartieBankAccount },
  { type: 'Catalog.Contract', Class: CatalogContract },
  { type: 'Catalog.Contract.Intercompany', Class: CatalogContractIntercompany },
  { type: 'Catalog.BusinessDirection', Class: CatalogBusinessDirection },
  { type: 'Catalog.Salary.Analytics', Class: CatalogSalaryAnalytics },
  { type: 'Catalog.Department', Class: CatalogDepartment },
  { type: 'Catalog.Department.Kind', Class: CatalogDepartmentKind },
  { type: 'Catalog.Department.Company', Class: CatalogDepartmentCompany },
  { type: 'Catalog.Department.StatusReason', Class: CatalogDepartmentStatusReason },
  { type: 'Catalog.Expense', Class: CatalogExpense },
  { type: 'Catalog.Expense.Analytics', Class: CatalogExpenseAnalytics },
  { type: 'Catalog.Income', Class: CatalogIncome },
  { type: 'Catalog.Loan', Class: CatalogLoan },
  { type: 'Catalog.LoanRepaymentProcedure', Class: CatalogLoanRepaymentProcedure },
  { type: 'Catalog.LoanTypes', Class: CatalogLoanTypes },
  { type: 'Catalog.Manager', Class: CatalogManager },
  { type: 'Catalog.Person', Class: CatalogPerson },
  { type: 'Catalog.PriceType', Class: CatalogPriceType },
  { type: 'Catalog.Product', Class: CatalogProduct },
  { type: 'Catalog.PlanningScenario', Class: CatalogPlanningScenario },
  { type: 'Catalog.ProductCategory', Class: CatalogProductCategory },
  { type: 'Catalog.ProductKind', Class: CatalogProductKind },
  { type: 'Catalog.Product.Report', Class: CatalogProductReport },
  { type: 'Catalog.PromotionChannel', Class: CatalogPromotionChannel },
  { type: 'Catalog.Storehouse', Class: CatalogStorehouse },
  { type: 'Catalog.Operation', Class: CatalogOperation },
  { type: 'Catalog.Operation.Group', Class: CatalogOperationGroup },
  { type: 'Catalog.Operation.Type', Class: CatalogOperationType },
  { type: 'Catalog.OrderSource', Class: CatalogOrderSource },
  { type: 'Catalog.Unit', Class: CatalogUnit },
  { type: 'Catalog.User', Class: CatalogUser },
  { type: 'Catalog.UsersGroup', Class: CatalogUsersGroup },
  { type: 'Catalog.Role', Class: CatalogRole },
  { type: 'Catalog.SubSystem', Class: CatalogSubSystem },
  { type: 'Catalog.JobTitle', Class: CatalogJobTitle },
  { type: 'Catalog.JobTitle.Category', Class: CatalogJobTitleCategory },
  { type: 'Catalog.PersonIdentity', Class: CatalogPersonIdentity },
  { type: 'Catalog.ReasonTypes', Class: CatalogReasonTypes },
  { type: 'Catalog.Product.Package', Class: CatalogProductPackage },
  { type: 'Catalog.Product.Analytic', Class: CatalogProductAnalytic },

  { type: 'Catalog.Documents', Class: CatalogDocuments },
  { type: 'Catalog.Catalogs', Class: CatalogCatalogs },
  { type: 'Catalog.Forms', Class: CatalogForms },
  { type: 'Catalog.Objects', Class: CatalogObjects },
  { type: 'Catalog.Subcount', Class: CatalogSubcount },
  { type: 'Catalog.StaffingTable', Class: CatalogStaffingTable },
  { type: 'Catalog.Brand', Class: CatalogBrand },
  { type: 'Catalog.GroupObjectsExploitation', Class: CatalogGroupObjectsExploitation },
  { type: 'Catalog.ObjectsExploitation', Class: CatalogObjectsExploitation },
  { type: 'Catalog.Catalog', Class: CatalogCatalog },
  { type: 'Catalog.BudgetItem', Class: CatalogBudgetItem },
  { type: 'Catalog.Scenario', Class: CatalogScenario },
  { type: 'Catalog.ManufactureLocation', Class: CatalogManufactureLocation },
  { type: 'Catalog.AcquiringTerminal', Class: CatalogAcquiringTerminal },
  { type: 'Catalog.Bank', Class: CatalogBank },
  { type: 'Catalog.Person.BankAccount', Class: CatalogPersonBankAccount },
  { type: 'Catalog.Person.Contract', Class: CatalogPersonContract },
  { type: 'Catalog.BusinessRegion', Class: CatalogBusinessRegion },
  { type: 'Catalog.TaxRate', Class: CatalogTaxRate },
  { type: 'Catalog.TaxAssignmentCode', Class: CatalogTaxAssignmentCode },
  { type: 'Catalog.TaxPaymentCode', Class: CatalogTaxPaymentCode },
  { type: 'Catalog.TaxBasisPayment', Class: CatalogTaxBasisPayment },
  { type: 'Catalog.TaxPaymentPeriod', Class: CatalogTaxPaymentPeriod },
  { type: 'Catalog.TaxPayerStatus', Class: CatalogTaxPayerStatus },
  { type: 'Catalog.TaxOffice', Class: CatalogTaxOffice },
  { type: 'Catalog.RetailClient', Class: CatalogRetailClient },
  { type: 'Catalog.RetailNetwork', Class: CatalogRetailNetwork },
  { type: 'Catalog.SalaryProject', Class: CatalogSalaryProject },
  { type: 'Catalog.Specification', Class: CatalogSpecification },
  { type: 'Catalog.InvestorGroup', Class: CatalogInvestorGroup },
  { type: 'Catalog.Employee', Class: CatalogEmployee },

  { type: 'Document.ExchangeRates', Class: DocumentExchangeRates },
  { type: 'Document.Invoice', Class: DocumentInvoice },
  { type: 'Document.Operation', Class: DocumentOperation },
  { type: 'Document.PriceList', Class: DocumentPriceList },
  { type: 'Document.Settings', Class: DocumentSettings },
  { type: 'Document.UserSettings', Class: DocumentUserSettings },
  { type: 'Document.WorkFlow', Class: DocumentWorkFlow },
  { type: 'Document.CashRequest', Class: DocumentCashRequest },
  { type: 'Document.CashRequestRegistry', Class: DocumentCashRequestRegistry },
];

