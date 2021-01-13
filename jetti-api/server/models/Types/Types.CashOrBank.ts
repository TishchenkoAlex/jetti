import { RegisteredDocumentsTypes } from '../documents.factory';
import { TypesBase } from './TypesBase';

export class TypesCashOrBank extends TypesBase {

  getTypes() {
    return RegisteredDocumentsTypes(type => ['Catalog.BankAccount', 'Catalog.CashRegister'].includes(type));
  }

}
