import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.SalaryProject',
  description: 'Зарплатный проект',
  icon: 'fa fa-list',
  menu: 'Зарплатные проекты',
})
export class CatalogSalaryProject extends DocumentBase {

  @Props({ type: 'Catalog.SalaryProject', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Catalog.Bank', required: true, style: { width: '100px' } })
  bank: Ref = null;

  @Props({ type: 'Catalog.Currency', required: true, style: { width: '100px' } })
  currency: Ref = null;

  @Props({ type: 'date', required: true, style: { width: '100px' } })
  OpenDate = new Date;
  
  @Props({ type: 'string' })
  BankBranch = '';
  
  @Props({ type: 'string' })
  BankBranchOffice = '';

  @Props({ type: 'string' })
  BankAccount = '';

}
