import { TypesCompanyOrCounterpartieOrPersonOrRetailClient } from './Types.CompanyOrCounterpartieOrPersonOrRetailClient';
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
  return RegisteredDocument
    .map(el => ({
      type: el.type as AllTypes,
      description: (<DocumentOptions>(createDocument(el.type).Prop())).description
    }));
}

export function simpleTypes(): { type: AllTypes, description: string }[] {

  const result: { type: AllTypes, description: string }[] = [];

  result.push({ type: 'number', description: 'number' });
  result.push({ type: 'date', description: 'date' });
  result.push({ type: 'datetime', description: 'datetime' });
  result.push({ type: 'string', description: 'string' });
  result.push({ type: 'boolean', description: 'boolean' });
  result.push({ type: 'table', description: 'table' });
  result.push({ type: 'javascript', description: 'javascript' });
  result.push({ type: 'enum', description: 'emum' });
  result.push({ type: 'link', description: 'link' });
  result.push({ type: 'URL', description: 'URL' });

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
  { type: 'Types.CompanyOrCounterpartieOrPersonOrRetailClient', Class: TypesCompanyOrCounterpartieOrPersonOrRetailClient },
  { type: 'Types.CompanyOrCompanyGroup', Class: TypesCompanyOrCompanyGroup },
];
