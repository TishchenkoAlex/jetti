import { RegisteredDocumentsTypes } from '../documents.factory';
import { TypesBase } from './TypesBase';
import { Type } from '../type';

export class TypesCatalog extends TypesBase {

  getTypes() {
    return RegisteredDocumentsTypes(type => Type.isCatalog(type));
  }

}
