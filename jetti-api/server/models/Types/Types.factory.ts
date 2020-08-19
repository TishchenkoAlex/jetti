import { AllTypes } from './../documents.types';
import { TypesCompanyOrCompanyGroup } from './Types.CompanyOrCompanyGroup';
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
import { TypesCompanyOrCounterpartieOrPerson } from './Types.CompanyOrCounterpartieOrPerson';
import { RegisteredDocument, createDocument } from '../documents.factory';
import { DocumentOptions } from '../document';

export interface IRegisteredTypes {
  type: ComplexTypes;
  Class: typeof TypesBase;
}

export function allTypes(): { type: AllTypes, description: string }[] {
  return [...documentsTypes(), ...simpleTypes()];
}

export function documentsTypes(): { type: AllTypes, description: string }[] {
  return RegisteredDocument()
    .map(el => ({
      type: el.type as AllTypes,
      description: (<DocumentOptions>(createDocument(el.type).Prop())).description
    }));
}

export function simpleTypes(): { type: AllTypes, description: string, defaultValue?: any }[] {

  const result: { type: AllTypes, description: string, defaultValue?: any }[] = [];

  result.push({ type: 'number', description: 'number', defaultValue: 0 });
  result.push({ type: 'date', description: 'date', defaultValue: null });
  result.push({ type: 'datetime', description: 'datetime', defaultValue: null });
  result.push({ type: 'string', description: 'string', defaultValue: '' });
  result.push({ type: 'boolean', description: 'boolean', defaultValue: false });
  result.push({ type: 'table', description: 'table', defaultValue: [] });
  result.push({ type: 'javascript', description: 'javascript', defaultValue: '' });
  result.push({ type: 'enum', description: 'emum', defaultValue: '' });
  result.push({ type: 'link', description: 'link', defaultValue: '' });
  result.push({ type: 'URL', description: 'URL', defaultValue: '' });

  return result;
}

export function createTypes(type: ComplexTypes): TypesBase {
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
  { type: 'Types.CompanyOrCounterpartieOrPerson', Class: TypesCompanyOrCounterpartieOrPerson },
  { type: 'Types.CompanyOrCompanyGroup', Class: TypesCompanyOrCompanyGroup },
];
