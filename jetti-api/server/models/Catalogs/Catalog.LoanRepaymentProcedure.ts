import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.LoanRepaymentProcedure',
  description: 'Порядок возврата займа',
  icon: 'fa fa-list',
  menu: 'Порядок возврата займа',
})
export class CatalogLoanRepaymentProcedure extends DocumentBase {

  @Props({ type: 'Catalog.LoanRepaymentProcedure', hiddenInList: true, order: -1 })
  parent: Ref = null;

}
