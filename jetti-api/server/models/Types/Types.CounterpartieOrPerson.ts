import { RegisteredDocumentsTypes } from '../documents.factory';
import { TypesBase } from './TypesBase';

export class TypesCounterpartieOrPerson extends TypesBase {

  getTypes() {
    return RegisteredDocumentsTypes(type => ['Catalog.Counterpartie', 'Catalog.Person'].includes(type));
  }
}

