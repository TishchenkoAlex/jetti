import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.OrderSource',
  description: 'Источник заказа',
  icon: 'fa fa-list',
  menu: 'Источники заказов',
  prefix: 'OS-',
  hierarchy: 'folders'
})
export class CatalogOrderSource extends DocumentBase {

  @Props({ type: 'Catalog.OrderSource', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'enum', value: ['ONLINE', 'OFFINE'] })
  Kind = false;

  @Props({ type: 'string' })
  DescriptionENG = '';

}
