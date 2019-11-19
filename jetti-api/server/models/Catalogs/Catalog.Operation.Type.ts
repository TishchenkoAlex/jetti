import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.Operation.Type',
  description: 'Хозяйственная операция',
  icon: 'fa fa-list',
  menu: 'Хозяйственные операции',
  prefix: 'OPERT-'
})
export class CatalogOperationType extends DocumentBase {

  @Props({ type: 'Catalog.Operation.Type', hiddenInList: true, order: -1 })
  parent: Ref = null;

}
