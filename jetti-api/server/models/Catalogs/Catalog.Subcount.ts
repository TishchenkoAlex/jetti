import { AllTypes } from '../documents.types';
import { buildSubcountQueryList } from './../../fuctions/SQLGenerator.MSSQL';
import { createDocument, RegisteredDocument } from './../../models/documents.factory';
import { DocumentBase, DocumentOptions, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.Subcount',
  description: 'Субконко',
  icon: '',
  menu: 'Субконто',
  prefix: ''
})
export class CatalogSubcount extends DocumentBase {
  @Props({ type: 'Catalog.Subcount', hiddenInList: true, order: -1 })
  parent: Ref = null;

  QueryList() {
    const select = RegisteredDocument
      .map(el => ({ type: el.type as AllTypes, description: (<DocumentOptions>(createDocument(el.type).Prop())).description }));

    select.push({type: 'number', description: 'number'});
    select.push({type: 'date', description: 'date'});
    select.push({type: 'datetime', description: 'datetime'});
    select.push({type: 'string', description: 'string'});
    select.push({type: 'boolean', description: 'boolean'});
    select.push({type: 'table', description: 'table'});

    return buildSubcountQueryList(select);
  }

}
