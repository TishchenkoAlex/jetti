import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.Income',
  description: 'Статья доходов',
  icon: 'fa fa-list',
  menu: 'Статьи доходов',
  hierarchy: 'folders',
  relations: [
    { name: 'Income analytics', type: 'Catalog.Expense.Analytics', field: 'parent' }
  ]
})
export class CatalogIncome extends DocumentBase {

  @Props({ type: 'Catalog.Income', hiddenInList: true, order: -1, storageType: 'folders' })
  parent: Ref = null;

  @Props({ type: 'Catalog.Account' })
  Account: Ref = null;

  @Props({ type: 'Catalog.BudgetItem' })
  BudgetItem: Ref = null;

  @Props({ type: 'enum', value: ['FINRES', 'INVEST', 'NOTASSIGN'] })
  Assign = 'FINRES';

  @Props({ type: 'string' })
  DescriptionENG = '';

}
