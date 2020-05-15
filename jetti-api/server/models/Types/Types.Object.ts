import { buildTypesQueryList } from '../../fuctions/SQLGenerator.MSSQL';
import { DocumentOptions } from '../document';
import { createDocument, RegisteredDocument } from '../documents.factory';
import { TypesBase } from './TypesBase';

export class TypesObject extends TypesBase {

  getTypes() {
    return RegisteredDocument
      .filter(d => (d.type.startsWith('Catalog.') || d.type.startsWith('Document.')))
      .map(e => e.type);
  }
}
