import { ComplexTypes } from '../documents.types';
import { TypesCatalog } from './Types.Catalog';
import { TypesDocument } from './Types.Document';
import { TypesExpenseOrBalance } from './Types.ExpenseOrBalance';
import { TypesObject } from './Types.Object';
import { TypesSubcount } from './Types.Subcount';
import { TypesBase } from './TypesBase';
import { TypesUserOrGroup } from './Types.UserOrGroup';
import { TypesCashOrBank } from './Types.CashOrBank';
import { TypesCashRecipient } from './Types.CashRecipient';
import { TypesCounterpartieOrPerson } from './Types.CounterpartieOrPerson';
import { TypesPersonOrCounterpartieBankAccount } from './Types.PersonOrCounterpartieBankAccount';

export interface IRegisteredTypes {
  type: ComplexTypes;
  Class: typeof TypesBase;
}

export function createTypes(type: ComplexTypes): TypesBase  {
  const doc = RegisteredTypes.find(el => el.type === type);
  if (doc) return new doc.Class;
  else throw new Error(`type: ${type} is not defined.`);
}

export const RegisteredTypes: IRegisteredTypes[] = [
  { type: 'Types.Document', Class: TypesDocument },
  { type: 'Types.Catalog', Class: TypesCatalog },
  { type: 'Types.Subcount', Class: TypesSubcount },
  { type: 'Types.Object', Class: TypesObject },
  { type: 'Types.ExpenseOrBalance', Class: TypesExpenseOrBalance },
  { type: 'Types.CashOrBank', Class: TypesCashOrBank },
  { type: 'Types.CashRecipient', Class: TypesCashRecipient },
  { type: 'Types.UserOrGroup', Class: TypesUserOrGroup },
  { type: 'Types.CounterpartieOrPerson', Class: TypesCounterpartieOrPerson },
  { type: 'Types.PersonOrCounterpartieBankAccount', Class: TypesPersonOrCounterpartieBankAccount },
];
