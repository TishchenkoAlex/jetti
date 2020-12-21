import { RegisteredDocumentsTypes } from '../documents.factory';
import { TypesBase } from './TypesBase';
import { Type } from '../type';

export class TypesDocument extends TypesBase {

  getTypes() {
    return RegisteredDocumentsTypes(d => Type.isDocument(d.type));
  }
}
