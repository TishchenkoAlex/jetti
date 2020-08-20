import { RegisteredDocument } from '../documents.factory';
import { TypesBase } from './TypesBase';

export class TypesCompanyOrCounterpartieOrPersonOrRetailClient extends TypesBase {

  getTypes() {
    return RegisteredDocument()
      .filter(d =>
        d.type === 'Catalog.Company' ||
        d.type === 'Catalog.Counterpartie' ||
        d.type === 'Catalog.RetailClient' ||
        d.type === 'Catalog.Person')
      .map(e => e.type);

  }
}
