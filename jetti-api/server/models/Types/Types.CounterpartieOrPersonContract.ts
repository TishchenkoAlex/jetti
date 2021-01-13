import { RegisteredDocumentsTypes } from '../documents.factory';
import { TypesBase } from './TypesBase';

export class TypesCounterpartieOrPersonContract extends TypesBase {
  getTypes() {
    return RegisteredDocumentsTypes(type => ['Catalog.Contract', 'Catalog.Person.Contract'].includes(type));
  }
}

