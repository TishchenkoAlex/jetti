import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.CashFlow',
  description: 'Статья ДДС',
  icon: 'fa fa-list',
  menu: 'Статьи ДДС',
  prefix: '',
  hierarchy: 'folders'
})
export class CatalogCashFlow extends DocumentBase {

  @Props({ type: 'Catalog.CashFlow', hiddenInList: true, order: -1 })
  parent: Ref = null;

}
