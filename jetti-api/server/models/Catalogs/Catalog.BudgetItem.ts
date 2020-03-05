import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.BudgetItem',
  description: 'Budget items',
  icon: 'fa fa-list',
  menu: 'Статьи бюджета',
  hierarchy: 'folders',
})
export class CatalogBudgetItem extends DocumentBase {

  @Props({ type: 'Catalog.BudgetItem', hiddenInList: true, order: -1, storageType: 'folders' })
  parent: Ref = null;

  @Props({ type: 'enum', value: [
    '+',
    '-',
    '*',
    '/',
    '~',
  ]})
  UnaryOperator = '';

}
