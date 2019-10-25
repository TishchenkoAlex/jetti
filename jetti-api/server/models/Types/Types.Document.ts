import { DocumentOptions } from '../document';
import { createDocument, RegisteredDocument } from '../documents.factory';
import { buildTypesQueryList } from './../../fuctions/SQLGenerator.MSSQL';
import { TypesBase } from './TypesBase';

export class TypesDocument extends TypesBase {

  QueryList(): string {
    const select = RegisteredDocument.filter(d => d.type.startsWith('Document.'))
      .map(el => ({ type: el.type, description: (createDocument(el.type).Prop() as DocumentOptions).description}));
    return buildTypesQueryList(select);
  }

}
