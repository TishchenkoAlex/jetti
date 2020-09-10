import { DocumentOptions } from '../document';
import { createDocument, RegisteredDocument } from '../documents.factory';
import { buildTypesQueryList } from './../../fuctions/SQLGenerator.MSSQL';
import { TypesBase } from './TypesBase';
import { Type } from '../type';

export class TypesCatalog extends TypesBase {

  getTypes() {
    return RegisteredDocument()
      .filter(d => Type.isCatalog(d.type))
      .map(e => e.type);
  }
}
