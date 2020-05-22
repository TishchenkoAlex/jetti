import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.CashRegister',
  description: 'Касса',
  icon: 'fa fa-list',
  menu: 'Кассы',
  prefix: 'CSREG-',
  hierarchy: 'folders',
  dimensions: [
    { company: 'Catalog.Company' }
  ]
})
export class CatalogCashRegister extends DocumentBase {

  @Props({ type: 'Catalog.CashRegister', hiddenInList: true, order: -1, storageType: 'folders' })
  parent: Ref = null;

  @Props({ type: 'Catalog.Currency', required: true, style: { width: '100px' }, isProtected: true })
  currency: Ref = null;

  @Props({ type: 'Catalog.Department' })
  Department: Ref = null;

  @Props({ type: 'Catalog.Company', required: true, hiddenInForm: false, isProtected: true })
  company: Ref = null;

  @Props({ type: 'boolean' })
  isAccounting = true;
}
