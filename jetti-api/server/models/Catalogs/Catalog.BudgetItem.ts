import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.BudgetItem',
  description: 'Budget items',
  icon: 'fa fa-list',
  menu: 'Статьи бюджета',
  hierarchy: 'all',
  dimensions: [
    { parent: 'Catalog.BudgetItem' },
    { parent2: 'Catalog.BudgetItem' },
    { UnaryOperator: 'enum' },
  ]
})
export class CatalogBudgetItem extends DocumentBase {

  @Props({ type: 'Catalog.BudgetItem', order: 10, storageType: 'all', hiddenInForm: true })
  parent: Ref = null;

  @Props({ type: 'Catalog.BudgetItem', order: 11, storageType: 'all', hiddenInForm: true })
  parent2: Ref = null;

  @Props({ type: 'boolean', hiddenInList: false })
  isfolder = false;

  @Props({ type: 'enum', useIn: 'all', value: [
    '+',
    '-',
    '*',
    '/',
    '~',
  ]})
  UnaryOperator = '';

  @Props({ type: 'string'})
  DescriptionENG = '';

}
