import { Type } from './../type';
import { buildSubcountQueryList } from './../../fuctions/SQLGenerator.MSSQL';
import { createDocument, RegisteredDocumentsTypes } from './../../models/documents.factory';
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
    const select = RegisteredDocumentsTypes(el => Type.isDocument(el.type))
      .map(type => ({ type, description: (<DocumentOptions>(createDocument(type).Prop())).description }));

    return buildSubcountQueryList(select);
  }

}
