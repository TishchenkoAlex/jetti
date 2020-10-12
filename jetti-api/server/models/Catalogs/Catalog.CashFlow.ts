import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.CashFlow',
  description: 'Статья ДДС',
  icon: 'fa fa-list',
  menu: 'Статьи ДДС',
  hierarchy: 'folders'
})
export class CatalogCashFlow extends DocumentBase {

  @Props({ type: 'Catalog.CashFlow', hiddenInList: true, order: -1, storageType: 'folders' })
  parent: Ref = null;

  @Props({ type: 'string'})
  DescriptionENG = '';

}
