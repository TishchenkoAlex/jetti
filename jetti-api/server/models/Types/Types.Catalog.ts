import { DocumentOptions } from '../document';
import { createDocument, RegisteredDocument } from '../documents.factory';
import { buildTypesQueryList } from './../../fuctions/SQLGenerator.MSSQL';
import { TypesBase } from './TypesBase';

export class TypesCatalog extends TypesBase {

  QueryList() {
    const select = RegisteredDocument.filter(d => d.type.startsWith('Catalog.'))
      .map(el => ({ type: el.type, description: (createDocument(el.type).Prop() as DocumentOptions).description }));
    return buildTypesQueryList(select);
  }
}
