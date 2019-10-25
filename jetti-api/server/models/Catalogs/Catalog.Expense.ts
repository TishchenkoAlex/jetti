import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.Expense',
  description: 'Статья расходов',
  icon: 'fa fa-list',
  menu: 'Статьи расходов',
  hierarchy: 'folders',
  prefix: '',
  relations: [
    { name: 'Expense analytics', type: 'Catalog.Expense.Analytics', field: 'parent' }
  ]
})
export class CatalogExpense extends DocumentBase {

  @Props({ type: 'Catalog.Expense', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Catalog.Account' })
  Account: Ref = null;

}
