import { RegisteredDocumentsTypes } from '../documents.factory';
import { TypesBase } from './TypesBase';

export class TypesCompanyOrCounterpartieOrPerson extends TypesBase {

  getTypes() {
    return RegisteredDocumentsTypes(type =>
      ['Catalog.Company', 'Catalog.Counterpartie', 'Catalog.Person']
        .includes(type));
  }

}
