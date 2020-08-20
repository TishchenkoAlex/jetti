import { DocumentOptions } from '../document';
import { RegisteredDocument, createDocument } from '../documents.factory';
import { buildTypesQueryList } from './../../fuctions/SQLGenerator.MSSQL';
import { TypesBase } from './TypesBase';

export class TypesPersonOrCounterpartieBankAccount extends TypesBase {

  getTypes() {
    return RegisteredDocument()
      .filter(d => d.type === 'Catalog.Counterpartie.BankAccount' || d.type === 'Catalog.Person.BankAccount')
      .map(e => e.type);
  }
}
