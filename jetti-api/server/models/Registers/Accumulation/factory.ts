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

export type RegisterAccumulationTypes =
  'Register.Accumulation.AccountablePersons' |
  'Register.Accumulation.AP' |
  'Register.Accumulation.AR' |
  'Register.Accumulation.Bank' |
  'Register.Accumulation.Balance' |
  'Register.Accumulation.Cash' |
  'Register.Accumulation.Cash.Transit' |
  'Register.Accumulation.Inventory' |
  'Register.Accumulation.Loan' |
  'Register.Accumulation.PL' |
  'Register.Accumulation.Sales' |
  'Register.Accumulation.Depreciation' |
  'Register.Accumulation.CashToPay' |
  'Register.Accumulation.BudgetItemTurnover';

interface IRegisteredRegisterAccumulation { type: RegisterAccumulationTypes; Class: typeof RegisterAccumulation; }
export const RegisteredRegisterAccumulation: IRegisteredRegisterAccumulation[] = [
  { type: 'Register.Accumulation.AccountablePersons', Class: RegisterAccumulationAccountablePersons },
  { type: 'Register.Accumulation.AP', Class: RegisterAccumulationAP },
  { type: 'Register.Accumulation.AR', Class: RegisterAccumulationAR },
  { type: 'Register.Accumulation.Bank', Class: RegisterAccumulationBank },
  { type: 'Register.Accumulation.Balance', Class: RegisterAccumulationBalance },
  { type: 'Register.Accumulation.Cash', Class: RegisterAccumulationCash },
  { type: 'Register.Accumulation.Cash.Transit', Class: RegisterAccumulationCashTransit },
  { type: 'Register.Accumulation.Inventory', Class: RegisterAccumulationInventory },
  { type: 'Register.Accumulation.Loan', Class: RegisterAccumulationLoan },
  { type: 'Register.Accumulation.PL', Class: RegisterAccumulationPL },
  { type: 'Register.Accumulation.Sales', Class: RegisterAccumulationSales },
  { type: 'Register.Accumulation.Depreciation', Class: RegisterAccumulationDepreciation },
  { type: 'Register.Accumulation.CashToPay', Class: RegisterAccumulationCashToPay },
  { type: 'Register.Accumulation.BudgetItemTurnover', Class: RegisterAccumulationBudgetItemTurnover }
];

export function createRegisterAccumulation(init: Partial<RegisterAccumulation>) {
  const doc = RegisteredRegisterAccumulation.find(el => el.type === init.type);
  if (doc) return new doc.Class({ type: init.type, ...init });
  else throw new Error(`createRegisterAccumulation: Can't create type! ${init.type} is not registered`);
}
