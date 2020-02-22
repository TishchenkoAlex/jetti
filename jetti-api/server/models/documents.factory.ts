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
import { DocTypes } from './documents.types';
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
import { CatalogReatailClient } from './Catalogs/Catalog.ReatailClient';
import { CatalogTaxOffice } from './Catalogs/Catalog.TaxOffice';
import { CatalogPersonBankAccount } from './Catalogs/Catalog.Person.BankAccount';
import { CatalogSalaryProject } from './Catalogs/Catalog.SalaryProject';
import { CatalogTaxBasisPayment } from './Catalogs/Catalog.TaxBasisPayment';
import { CatalogSalaryAnalytics } from './Catalogs/Catalog.Salary.Analytics';
import { CatalogCompanyGroup } from './Catalogs/Catalog.Company.Group';

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
  doc: { [x: string]: any };
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
}

export function createDocument<T extends DocumentBase>(type: DocTypes, document?: IFlatDocument): T {
  const doc = RegisteredDocument.find(el => el.type === type);
  if (doc) {
    const result = <T>new doc.Class;
    const ArrayProps = Object.keys(result).filter(k => Array.isArray(result[k]));
    ArrayProps.forEach(prop => result[prop].length = 0);
    if (document) result.map(document);
    return result;
  } else throw new Error(`createDocument: can't create '${type}' type! '${type}' is not registered`);
}

export interface RegisteredDocumentType { type: DocTypes; Class: typeof DocumentBase; }

export const RegisteredDocument: RegisteredDocumentType[] = [
  { type: 'Catalog.Account', Class: CatalogAccount },
  { type: 'Catalog.Balance', Class: CatalogBalance },
  { type: 'Catalog.Balance.Analytics', Class: CatalogBalanceAnalytics },
  { type: 'Catalog.BankAccount', Class: CatalogBankAccount },
  { type: 'Catalog.CashFlow', Class: CatalogCashFlow },
  { type: 'Catalog.CashRegister', Class: CatalogCashRegister },
  { type: 'Catalog.Currency', Class: CatalogCurrency },
  { type: 'Catalog.Company', Class: CatalogCompany },
  { type: 'Catalog.Company.Group', Class: CatalogCompanyGroup },
  { type: 'Catalog.Country', Class: CatalogCountry },
  { type: 'Catalog.Counterpartie', Class: CatalogCounterpartie },
  { type: 'Catalog.Counterpartie.BankAccount', Class: CatalogCounterpartieBankAccount },
  { type: 'Catalog.Contract', Class: CatalogContract },
  { type: 'Catalog.BusinessDirection', Class: CatalogBusinessDirection },
  { type: 'Catalog.Salary.Analytics', Class: CatalogSalaryAnalytics },
  { type: 'Catalog.Department', Class: CatalogDepartment },
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
  { type: 'Catalog.ProductCategory', Class: CatalogProductCategory },
  { type: 'Catalog.ProductKind', Class: CatalogProductKind },
  { type: 'Catalog.Storehouse', Class: CatalogStorehouse },
  { type: 'Catalog.Operation', Class: CatalogOperation },
  { type: 'Catalog.Operation.Group', Class: CatalogOperationGroup },
  { type: 'Catalog.Operation.Type', Class: CatalogOperationType },
  { type: 'Catalog.Unit', Class: CatalogUnit },
  { type: 'Catalog.User', Class: CatalogUser },
  { type: 'Catalog.UsersGroup', Class: CatalogUsersGroup },
  { type: 'Catalog.Role', Class: CatalogRole },
  { type: 'Catalog.SubSystem', Class: CatalogSubSystem },
  { type: 'Catalog.JobTitle', Class: CatalogJobTitle },
  { type: 'Catalog.PersonIdentity', Class: CatalogPersonIdentity },

  { type: 'Catalog.Documents', Class: CatalogDocuments },
  { type: 'Catalog.Catalogs', Class: CatalogCatalogs },
  { type: 'Catalog.Forms', Class: CatalogForms },
  { type: 'Catalog.Objects', Class: CatalogObjects },
  { type: 'Catalog.Subcount', Class: CatalogSubcount },

  { type: 'Catalog.Brand', Class: CatalogBrand },
  { type: 'Catalog.GroupObjectsExploitation', Class: CatalogGroupObjectsExploitation },
  { type: 'Catalog.ObjectsExploitation', Class: CatalogObjectsExploitation },
  { type: 'Catalog.Catalog', Class: CatalogCatalog },
  { type: 'Catalog.BudgetItem', Class: CatalogBudgetItem },
  { type: 'Catalog.Scenario', Class: CatalogScenario },
  { type: 'Catalog.AcquiringTerminal', Class: CatalogAcquiringTerminal },
  { type: 'Catalog.Bank', Class: CatalogBank },
  { type: 'Catalog.Person.BankAccount', Class: CatalogPersonBankAccount },
  { type: 'Catalog.BusinessRegion', Class: CatalogBusinessRegion },
  { type: 'Catalog.TaxRate', Class: CatalogTaxRate },
  { type: 'Catalog.TaxAssignmentCode', Class: CatalogTaxAssignmentCode },
  { type: 'Catalog.TaxPaymentCode', Class: CatalogTaxPaymentCode },
  { type: 'Catalog.TaxBasisPayment', Class: CatalogTaxBasisPayment },
  { type: 'Catalog.TaxPaymentPeriod', Class: CatalogTaxPaymentPeriod },
  { type: 'Catalog.TaxPayerStatus', Class: CatalogTaxPayerStatus },
  { type: 'Catalog.TaxOffice', Class: CatalogTaxOffice },
  { type: 'Catalog.ReatailClient', Class: CatalogReatailClient },
  { type: 'Catalog.SalaryProject', Class: CatalogSalaryProject },

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

