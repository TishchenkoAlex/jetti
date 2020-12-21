import { RegisteredDocumentsTypes } from '../documents.factory';
import { TypesBase } from './TypesBase';

export class TypesCompanyOrCounterpartieOrPersonOrRetailClient extends TypesBase {

  getTypes() {
    return RegisteredDocumentsTypes(type =>
      ['Catalog.Company', 'Catalog.Counterpartie', 'Catalog.RetailClient', 'Catalog.Person']
        .includes(type));
  }
}
