import { Type } from './../common-types';
import { DocTypes } from '../documents.types';
import { buildSubcountQueryList } from './../../fuctions/SQLGenerator.MSSQL';
import { createDocument, RegisteredDocument } from './../../models/documents.factory';
import { DocumentBase, DocumentOptions, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.Documents',
  description: 'Documents types',
  icon: '',
  menu: 'Documents types',
  prefix: ''
})
export class CatalogDocuments extends DocumentBase {
  @Props({ type: 'Catalog.Documents', hiddenInList: true, order: -1 })
  parent: Ref = null;


  QueryList() {
    const select = RegisteredDocument().filter(el => Type.isDocument(el.type))
      .map(el => ({ type: el.type as DocTypes, description: (<DocumentOptions>(createDocument(el.type).Prop())).description }));

    return buildSubcountQueryList(select);
  }

}
