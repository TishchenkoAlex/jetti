import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.Contract.Intercompany',
  description: 'Договор между организациями',
  icon: 'fa fa-list',
  menu: 'Договоры между организациями',
  prefix: 'CONTRC-'
})
export class CatalogContractIntercompany extends DocumentBase {

  @Props({ type: 'Catalog.Contract.Intercompany', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Catalog.Company', required: true, hiddenInList: false })
  company: Ref = null;

  @Props({ type: 'Catalog.Company', required: true, order: 1 })
  KorrCompany: Ref = null;

  @Props({ type: 'enum', value: ['OPEN', 'CLOSE'], required: true })
  Status = 'OPEN';

  @Props({ type: 'date', required: true })
  StartDate: Ref = null;

  @Props({ type: 'date', required: false })
  EndDate: Ref = null;

  @Props({ type: 'number', required: false })
  Amount = 0;

  @Props({ type: 'Catalog.CashFlow', required: false })
  CashFlow: Ref = null;

  @Props({ type: 'Catalog.Currency', required: true })
  currency: Ref = null;

  @Props({ type: 'boolean', required: false })
  isDefault = false;

  @Props({ type: 'boolean', label: 'Ф2' })
  notAccounting = false;

}