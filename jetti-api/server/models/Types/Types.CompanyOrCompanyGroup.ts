import { DocumentOptions } from '../document';
import { RegisteredDocument, createDocument } from '../documents.factory';
import { buildTypesQueryList } from './../../fuctions/SQLGenerator.MSSQL';
import { TypesBase } from './TypesBase';

export class TypesCompanyOrCompanyGroup extends TypesBase {

  getTypes() {
    return RegisteredDocument
      .filter(d =>
        d.type === 'Catalog.Company' ||
        d.type === 'Catalog.Company.Group')
      .map(e => e.type);
  }
}
