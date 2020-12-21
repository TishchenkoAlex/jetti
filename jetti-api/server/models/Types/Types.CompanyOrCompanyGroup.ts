import { RegisteredDocumentsTypes } from '../documents.factory';
import { TypesBase } from './TypesBase';

export class TypesCompanyOrCompanyGroup extends TypesBase {

  getTypes() {
    return RegisteredDocumentsTypes(type =>
      ['Catalog.Company', 'Catalog.Company.Group']
        .includes(type));
  }

}
