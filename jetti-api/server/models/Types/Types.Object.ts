import { buildTypesQueryList } from '../../fuctions/SQLGenerator.MSSQL';
import { DocumentOptions } from '../document';
import { createDocument, RegisteredDocument } from '../documents.factory';
import { TypesBase } from './TypesBase';

export class TypesObject extends TypesBase {

  QueryList() {
    const select = RegisteredDocument.filter(d => d.type.startsWith('Catalog.') || d.type.startsWith('Documents.'))
      .map(el => ({ type: el.type, description: (createDocument(el.type).Prop() as DocumentOptions).description }));
    return buildTypesQueryList(select);
  }
}
