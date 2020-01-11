import { JDocument, Props, Ref, DocumentBase } from '../document';

@JDocument({
  type: 'Catalog.Person.BankAccount',
  description: 'Лицевой счет',
  icon: 'fa fa-list',
  menu: 'Лицевые счета',
  prefix: 'BANK.P-'
})
export class CatalogPersonBankAccount extends DocumentBase {

  @Props({ type: 'Catalog.Person.BankAccount', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Catalog.Company', required: true, hiddenInForm: false })
  company: Ref = null;

  @Props({ type: 'Catalog.Person', required: true, order: 1 })
  owner: Ref = null;

  @Props({ type: 'Catalog.SalaryProject', required: true, hiddenInForm: false })
  SalaryProject: Ref = null;

  @Props({ type: 'date', required: false, hiddenInForm: false })
  OpenDate = new Date;

}
