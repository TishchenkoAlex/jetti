import { ISubSystem } from './SubSystems';

export const FinanceSubSystem: ISubSystem = {
  type: 'Finance',
  icon: 'fa fa-fw fa-sign-in', description: 'Finance', Objects: [
    'Catalog.Account',
    'Catalog.Balance',
    'Catalog.Balance.Analytics',
    'Catalog.BankAccount',
    'Catalog.Counterpartie.BankAccount',
    'Catalog.CashRegister',
    'Catalog.Expense',
    'Catalog.Expense.Analytics',
    'Catalog.Income',
    'Catalog.CashFlow',
    'Catalog.Loan',
    'Catalog.TaxRates',
    'Catalog.Contract',
    'Catalog.BusinessDirection',
    'Catalog.Operation.Type',
    'Catalog.AcquiringTerminal',
    'Document.CashRequest',
    'Catalog.Bank'
  ]
};
