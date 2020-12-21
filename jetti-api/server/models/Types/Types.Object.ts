import { RegisteredDocumentsTypes } from '../documents.factory';
import { TypesBase } from './TypesBase';
import { Type } from '../type';

export class TypesObject extends TypesBase {
  getTypes() {
    return RegisteredDocumentsTypes(type => Type.isRefType(type));
  }
}
