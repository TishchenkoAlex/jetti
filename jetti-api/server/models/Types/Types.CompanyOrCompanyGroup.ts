import { DocumentOptions } from '../document';
import { RegisteredDocument, createDocument } from '../documents.factory';
import { buildTypesQueryList } from './../../fuctions/SQLGenerator.MSSQL';
import { TypesBase } from './TypesBase';

export class TypesCompanyOrCompanyGroup extends TypesBase {

  QueryList() {
    const select = RegisteredDocument.filter(d =>
      d.type === 'Catalog.Company' ||
      d.type === 'Catalog.Company.Group')
      .map(el => ({ type: el.type, description: (createDocument(el.type).Prop() as DocumentOptions).description }));
    return buildTypesQueryList(select);
  }
}
