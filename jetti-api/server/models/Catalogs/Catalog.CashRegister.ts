import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.CashRegister',
  description: 'Касса',
  icon: 'fa fa-list',
  menu: 'Кассы',
  prefix: 'CSREG-'
})
export class CatalogCashRegister extends DocumentBase {

  @Props({ type: 'Catalog.CashRegister', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Catalog.Currency', required: true, style: { width: '100px' } })
  currency: Ref = null;

  @Props({ type: 'Catalog.Department'})
  Department: Ref = null;

  @Props({ type: 'Catalog.Company', required: true, hiddenInForm: false })
  company: Ref = null;
}
