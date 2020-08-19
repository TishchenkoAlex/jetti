import { DocumentOptions } from '../document';
import { RegisteredDocument, createDocument } from '../documents.factory';
import { buildTypesQueryList } from './../../fuctions/SQLGenerator.MSSQL';
import { TypesBase } from './TypesBase';

export class TypesCashOrBank extends TypesBase {

  getTypes() {
    return RegisteredDocument()
      .filter(d => d.type === 'Catalog.BankAccount' ||
        d.type === 'Catalog.CashRegister')
      .map(e => e.type);
  }
}
