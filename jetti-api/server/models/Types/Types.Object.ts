import { buildTypesQueryList } from '../../fuctions/SQLGenerator.MSSQL';
import { DocumentOptions } from '../document';
import { createDocument, RegisteredDocument } from '../documents.factory';
import { TypesBase } from './TypesBase';
import { Type } from '../common-types';

export class TypesObject extends TypesBase {

  getTypes() {
    return RegisteredDocument()
      .filter(d => Type.isRefType(d.type))
      .map(e => e.type);
  }
}
