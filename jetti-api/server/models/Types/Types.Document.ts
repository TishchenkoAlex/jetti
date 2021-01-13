import { RegisteredDocumentsTypes } from '../documents.factory';
import { TypesBase } from './TypesBase';
import { Type } from '../type';

export class TypesDocument extends TypesBase {

  getTypes() {
    return RegisteredDocumentsTypes(type => Type.isDocument(type) && !Type.isOperation(type));
  }
}
