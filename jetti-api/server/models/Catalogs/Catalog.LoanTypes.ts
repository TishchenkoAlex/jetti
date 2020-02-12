import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.LoanTypes',
  description: 'Тип кредита/займа',
  icon: 'fa fa-list',
  menu: 'Типы кредита/займа',
  prefix: 'LT-'
})
export class CatalogLoanTypes extends DocumentBase {

  @Props({ type: 'Catalog.LoanTypes', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Catalog.Balance' })
  Balance: Ref = null;

}
