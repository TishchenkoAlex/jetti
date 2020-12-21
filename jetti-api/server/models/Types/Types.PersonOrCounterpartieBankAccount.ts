import { RegisteredDocumentsTypes } from '../documents.factory';
import { TypesBase } from './TypesBase';

export class TypesPersonOrCounterpartieBankAccount extends TypesBase {
  getTypes() {
    return RegisteredDocumentsTypes(type => ['Catalog.Counterpartie.BankAccount', 'Catalog.Person.BankAccount'].includes(type));
  }
}
