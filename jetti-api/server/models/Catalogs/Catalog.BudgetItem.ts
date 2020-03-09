import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.BudgetItem',
  description: 'Budget items',
  icon: 'fa fa-list',
  menu: 'Статьи бюджета',
  hierarchy: 'all',
  dimensions: [
    { parent: 'Catalog.BudgetItem' },
    { UnaryOperator: 'enum' },
  ]
})
export class CatalogBudgetItem extends DocumentBase {

  @Props({ type: 'Catalog.BudgetItem', order: 3, storageType: 'all' })
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
