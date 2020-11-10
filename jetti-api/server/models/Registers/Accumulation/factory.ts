import { RegisterAccumulationPaymentBatch } from './PaymentBatch';
import { RegisterAccumulationStaffingTable } from './StaffingTable';
import { RegisterAccumulationAcquiring } from './Acquiring';
import { RegisterAccumulationIntercompany } from './Intercompany';
import { RegisterAccumulationSalary } from './Salary';
import { RegisterAccumulationBalanceReport } from './Balance.Reports';
import { RegisterAccumulationAccountablePersons } from './AccountablePersons';
import { RegisterAccumulationAP } from './AP';
import { RegisterAccumulationAR } from './AR';
import { RegisterAccumulationBalance } from './Balance';
import { RegisterAccumulationBank } from './Bank';
import { RegisterAccumulationCash } from './Cash';
import { RegisterAccumulationCashTransit } from './Cash.Transit';
import { RegisterAccumulationDepreciation } from './Depreciation';
import { RegisterAccumulationInventory } from './Inventory';
import { RegisterAccumulationLoan } from './Loan';
import { RegisterAccumulationPL } from './PL';
import { RegisterAccumulation } from './RegisterAccumulation';
import { RegisterAccumulationSales } from './Sales';
import { RegisterAccumulationBudgetItemTurnover } from './BudgetItemTurnover';
import { RegisterAccumulationCashToPay } from './CashToPay';
import { RegisterAccumulationOrderPayment } from './OrderPayment';
import { RegisterAccumulationBalanceRC } from './Balance.RC';
import { RegisterAccumulationPLRC } from './PL.RC';
import { RegisterAccumulationInvestmentAnalytics } from './Investment.Analytics';

export type RegisterAccumulationTypes =
  'Register.Accumulation.AccountablePersons' |
  'Register.Accumulation.Investment.Analytics' |
  'Register.Accumulation.PaymentBatch' |
  'Register.Accumulation.OrderPayment' |
  'Register.Accumulation.Acquiring' |
  'Register.Accumulation.AP' |
  'Register.Accumulation.AR' |
  'Register.Accumulation.Bank' |
  'Register.Accumulation.Balance' |
  'Register.Accumulation.Balance.RC' |
  'Register.Accumulation.Balance.Report' |
  'Register.Accumulation.Cash' |
  'Register.Accumulation.Cash.Transit' |
  'Register.Accumulation.Inventory' |
  'Register.Accumulation.Intercompany' |
  'Register.Accumulation.Loan' |
  'Register.Accumulation.PL' |
  'Register.Accumulation.PL.RC' |
  'Register.Accumulation.Sales' |
  'Register.Accumulation.Salary' |
  'Register.Accumulation.Depreciation' |
  'Register.Accumulation.CashToPay' |
  'Register.Accumulation.StaffingTable' |
  'Register.Accumulation.BudgetItemTurnover';

interface IRegisteredRegisterAccumulation { type: RegisterAccumulationTypes; Class: typeof RegisterAccumulation; }
export const RegisteredRegisterAccumulation: IRegisteredRegisterAccumulation[] = [
  { type: 'Register.Accumulation.AccountablePersons', Class: RegisterAccumulationAccountablePersons },
  { type: 'Register.Accumulation.PaymentBatch', Class: RegisterAccumulationPaymentBatch },
  { type: 'Register.Accumulation.Investment.Analytics', Class: RegisterAccumulationInvestmentAnalytics },
  { type: 'Register.Accumulation.OrderPayment', Class: RegisterAccumulationOrderPayment },
  { type: 'Register.Accumulation.AP', Class: RegisterAccumulationAP },
  { type: 'Register.Accumulation.AR', Class: RegisterAccumulationAR },
  { type: 'Register.Accumulation.Bank', Class: RegisterAccumulationBank },
  { type: 'Register.Accumulation.Balance', Class: RegisterAccumulationBalance },
  { type: 'Register.Accumulation.Balance.RC', Class: RegisterAccumulationBalanceRC },
  { type: 'Register.Accumulation.Balance.Report', Class: RegisterAccumulationBalanceReport },
  { type: 'Register.Accumulation.Cash', Class: RegisterAccumulationCash },
  { type: 'Register.Accumulation.Cash.Transit', Class: RegisterAccumulationCashTransit },
  { type: 'Register.Accumulation.Inventory', Class: RegisterAccumulationInventory },
  { type: 'Register.Accumulation.Loan', Class: RegisterAccumulationLoan },
  { type: 'Register.Accumulation.PL', Class: RegisterAccumulationPL },
  { type: 'Register.Accumulation.PL.RC', Class: RegisterAccumulationPLRC },
  { type: 'Register.Accumulation.Sales', Class: RegisterAccumulationSales },
  { type: 'Register.Accumulation.Salary', Class: RegisterAccumulationSalary },
  { type: 'Register.Accumulation.Depreciation', Class: RegisterAccumulationDepreciation },
  { type: 'Register.Accumulation.CashToPay', Class: RegisterAccumulationCashToPay },
  { type: 'Register.Accumulation.BudgetItemTurnover', Class: RegisterAccumulationBudgetItemTurnover },
  { type: 'Register.Accumulation.Intercompany', Class: RegisterAccumulationIntercompany },
  { type: 'Register.Accumulation.Acquiring', Class: RegisterAccumulationAcquiring },
  { type: 'Register.Accumulation.StaffingTable', Class: RegisterAccumulationStaffingTable },
];

export function createRegisterAccumulation(init: Partial<RegisterAccumulation>) {
  const doc = RegisteredRegisterAccumulation.find(el => el.type === init.type);
  if (doc) return new doc.Class({ type: init.type, ...init });
  else throw new Error(`createRegisterAccumulation: Can't create type! ${init.type} is not registered`);
}
