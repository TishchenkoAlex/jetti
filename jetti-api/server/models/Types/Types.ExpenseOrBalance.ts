import { DocumentOptions } from '../document';
import { RegisteredDocument, createDocument } from '../documents.factory';
import { buildTypesQueryList } from './../../fuctions/SQLGenerator.MSSQL';
import { TypesBase } from './TypesBase';

export class TypesExpenseOrBalance extends TypesBase {

  getTypes() {
    return RegisteredDocument()
      .filter(d => d.type.startsWith('Catalog.Expense') || d.type.startsWith('Catalog.Balance'))
      .map(e => e.type);
  }

}
