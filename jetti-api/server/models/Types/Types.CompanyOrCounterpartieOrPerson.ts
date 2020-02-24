import { DocumentOptions } from '../document';
import { RegisteredDocument, createDocument } from '../documents.factory';
import { buildTypesQueryList } from './../../fuctions/SQLGenerator.MSSQL';
import { TypesBase } from './TypesBase';

export class TypesCompanyOrCounterpartieOrPerson extends TypesBase {

  QueryList() {
    const select = RegisteredDocument.filter(d =>
      d.type === 'Catalog.Company' ||
      d.type === 'Catalog.Counterpartie' ||
      d.type === 'Catalog.Person')

      .map(el => ({ type: el.type, description: (createDocument(el.type).Prop() as DocumentOptions).description }));
    return buildTypesQueryList(select);
  }
}
