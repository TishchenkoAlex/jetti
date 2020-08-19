import { DocumentOptions } from '../document';
import { createDocument, RegisteredDocument } from '../documents.factory';
import { buildTypesQueryList } from './../../fuctions/SQLGenerator.MSSQL';
import { TypesBase } from './TypesBase';

export class TypesCatalog extends TypesBase {

  getTypes() {
    return RegisteredDocument()
      .filter(d => d.type.startsWith('Catalog.'))
      .map(e => e.type);
  }
}
