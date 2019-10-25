import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.Loan',
  description: 'Договор кредита/займа',
  icon: 'fa fa-list',
  menu: 'Договоры кредита/займа',
  prefix: 'LOAN-'
})
export class CatalogLoan extends DocumentBase {

  @Props({ type: 'Catalog.Loan', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Catalog.Department', required: true })
  Department: Ref = null;

  @Props({ type: 'Catalog.Currency', required: true, style: { width: '100px' } })
  currency: Ref = null;

}
