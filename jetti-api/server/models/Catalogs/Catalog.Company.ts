import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.Company',
  description: 'Организация',
  icon: 'fa fa-list',
  menu: 'Организации',
  relations: [
    { name: 'Intercompany history', type: 'Register.Info.IntercompanyHistory', field: 'company.id' },
    { name: 'Departments', type: 'Catalog.Department', field: 'company' },
    { name: 'Bank accounts', type: 'Catalog.BankAccount', field: 'company' },
    { name: 'Acquiring terminals', type: 'Catalog.AcquiringTerminal', field: 'company' },
    { name: 'Cash registers', type: 'Catalog.CashRegister', field: 'company' },
    { name: 'Storehouses', type: 'Catalog.Storehouse', field: 'company' },
    { name: 'Responsible persons', type: 'Register.Info.CompanyResponsiblePersons', field: 'companyOrGroup.id' },
  ],
})
export class CatalogCompany extends DocumentBase {

  @Props({ type: 'Catalog.Company', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'enum', value: ['ЮрЛицо', 'ИндПред'] })
  kind = 'ЮрЛицо';

  @Props({ type: 'string', required: false })
  FullName = '';

  @Props({ type: 'Catalog.Currency', required: true, label: 'default currency', style: { width: '100px' } })
  currency: Ref = null;

  @Props({ type: 'string', required: true })
  prefix = '';

  @Props({ type: 'Catalog.Company.Group', required: true })
  Group: Ref = null;

  @Props({ type: 'Catalog.Company' })
  Intercompany: Ref = null;

  @Props({ type: 'Catalog.Country' })
  Country: Ref = null;

  @Props({ type: 'Catalog.BusinessCalendar' })
  BusinessCalendar: Ref = null;

  @Props({ type: 'Catalog.ResponsibilityCenter', required: true, isProtected: true })
  ResponsibilityCenter: Ref = null;

  @Props({ type: 'string', required: false })
  AddressShipping: Ref = null;

  @Props({ type: 'string', required: false })
  AddressBilling: Ref = null;

  @Props({ type: 'string', required: false })
  Phone: Ref = null;

  @Props({ type: 'string', required: false })
  Code1: Ref = null;

  @Props({ type: 'string', required: false })
  Code2: Ref = null;

  @Props({ type: 'string', required: false })
  Code3: Ref = null;

  @Props({ type: 'string', required: false })// Код Бенефициара (для Казахастана)
  BC = '';

  @Props({
    type: 'enum', required: true, value: [
      'UTC',
      'Central European Standard Time',
      'Russian Standard Time',
      'E. Europe Standard Time',
      'US Eastern Standard Time'
    ]
  })
  timeZone = 'UTC';

  @Props({ type: 'Catalog.TaxOffice', hiddenInList: true })
  TaxOffice: Ref = null;

  @Props({ type: 'string', readOnly: true, isAdditional: true })
  GLN = '';

}
