import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Document.UserSettings',
  description: 'User settings',
  icon: 'far fa-file-alt',
  menu: 'User settings',
  prefix: 'USET-',
  commands: [
    { method: 'AddDescendantsCompany', icon: 'pi pi-plus', label: 'Добавить починенные компании', order: 1 },
    { method: 'ClearCompanyList', icon: 'pi pi-plus', label: 'Очистить ТЧ "Companys"', order: 2 }
  ],
})
export class DocumentUserSettings extends DocumentBase {
  @Props({ type: 'Types.Document', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Types.UserOrGroup', required: true })
  UserOrGroup: Ref = null;

  @Props({ type: 'boolean', label: 'Exclude Companys'})
  COMP = false;

  @Props({ type: 'boolean', label: 'Exclude Departments'})
  DEPT = false;

  @Props({ type: 'boolean', label: 'Exclude Storehouse'})
  STOR = false;

  @Props({ type: 'boolean', label: 'Exclude CashRegisters'})
  CASH = false;

  @Props({ type: 'boolean', label: 'Exclude BankAccounts'})
  BANK = false;

  @Props({ type: 'boolean', label: 'Exclude Operations '})
  GROUP = false;

  @Props({ type: 'table', order: 1, label: 'Roles' })
  RoleList: RoleItems[] = [new RoleItems()];

  @Props({ type: 'table', order: 2, label: 'Сompanys' })
  CompanyList: CompanyItems[] = [new CompanyItems()];

  @Props({ type: 'table', order: 3, label: 'Departments' })
  Departments: Departments[] = [new Departments()];

  @Props({ type: 'table', order: 4, label: 'Storehouses' })
  Storehouses: Storehouses[] = [new Storehouses()];

  @Props({ type: 'table', order: 5, label: 'CashRegisters' })
  CashRegisters: CashRegisters[] = [new CashRegisters()];

  @Props({ type: 'table', order: 6, label: 'BankAccounts' })
  BankAccounts: BankAccounts[] = [new BankAccounts()];

  @Props({ type: 'table', order: 7, label: 'Operation Groups' })
  OperationGroups: OperationGroups[] = [new OperationGroups()];

}

class RoleItems {
  @Props({ type: 'Catalog.Role', required: true, style: { width: '100%' }})
  Role: Ref = null;
}

export class CompanyItems {
  @Props({ type: 'Catalog.Company', required: true, style: { width: '100%' }})
  company: Ref = null;
}

class OperationGroups {
  @Props({ type: 'Catalog.Operation.Group', required: true, style: { width: '100%' }})
  Group: Ref = null;
}

class Storehouses {
  @Props({ type: 'Catalog.Storehouse', required: true, style: { width: '100%' }})
  Storehouse: Ref = null;
}

class CashRegisters {
  @Props({ type: 'Catalog.CashRegister', required: true, style: { width: '100%' }})
  CashRegister: Ref = null;
}

class BankAccounts {
  @Props({ type: 'Catalog.BankAccount', required: true, style: { width: '100%' }})
  BankAccount: Ref = null;
}

class Departments {
  @Props({ type: 'Catalog.Department', required: true, style: { width: '100%' }})
  Department: Ref = null;
}




