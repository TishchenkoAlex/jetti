import { buildSubcountQueryList } from '../../fuctions/SQLGenerator.MSSQL';
import { DocumentBase, DocumentOptions, JDocument, Props, Ref } from '../document';
import { createDocument, RegisteredDocument } from '../documents.factory';
import { DocTypes } from '../documents.types';

@JDocument({
  type: 'Catalog.Catalogs',
  description: 'Catalogs types',
  icon: '',
  menu: 'Catalogs types',
})
export class CatalogCatalogs extends DocumentBase {
  @Props({ type: 'Catalog.Documents', hiddenInList: true, order: -1 })
  parent: Ref = null;


  QueryList() {
    const select = RegisteredDocument().filter(el => el.type.startsWith('Catalog.'))
      .map(el => ({ type: el.type as DocTypes, description: (<DocumentOptions>(createDocument(el.type).Prop())).description }));

    return buildSubcountQueryList(select);
  }

}
