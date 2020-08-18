import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.Department',
  description: 'Подразделение',
  icon: 'fa fa-list',
  menu: 'Подразделения',
  prefix: 'DEP-',
  hierarchy: 'folders',
  relations: [
    { name: 'Cash registers', type: 'Catalog.CashRegister', field: 'Department' },
    { name: 'Acquiring terminals', type: 'Catalog.AcquiringTerminal', field: 'Department' },
    { name: 'Storehouses', type: 'Catalog.Storehouse', field: 'Department' },
    { name: 'Staffing table', type: 'Catalog.StaffingTable', field: 'Department' },
    { name: 'Company & Investors groups history', type: 'Register.Info.DepartmentCompanyHistory', field: 'Department.id' },
    { name: 'Department status', type: 'Register.Info.DepartmentStatus', field: 'Department.id' },
    { name: 'Responsible persons', type: 'Register.Info.CompanyResponsiblePersons', field: 'Department.id' },
  ],
  dimensions: [
    { company: 'Catalog.Company' }
  ]
})
export class CatalogDepartment extends DocumentBase {

  @Props({ type: 'Catalog.Department', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({
    type: 'string', required: false, hiddenInList: false
    , label: 'Short name (max 15 symbols)', order: 16, validators: [{ key: 'maxLength', value: 15 }]
  })
  ShortName = '';

  @Props({ type: 'Catalog.BusinessRegion' })
  BusinessRegion: Ref = null;

  @Props({ type: 'date', label: 'Opening date' })
  OpeningDate = new Date();

  @Props({ type: 'date', label: 'Closing date' })
  ClosingDate = new Date();

  @Props({ type: 'Catalog.TaxOffice', hiddenInList: true })
  TaxOffice: Ref = null;

  @Props({ type: 'Catalog.Person' })
  Manager: Ref = null;

  @Props({ type: 'Catalog.Brand' })
  Brand: Ref = null;

  @Props({ type: 'Catalog.PriceType' })
  PriceType: Ref = null;

  @Props({ type: 'Catalog.Department.Kind' })
  kind: Ref = null;

  @Props({ type: 'string', required: false })
  Address = '';

  @Props({ type: 'string', required: false, isAdditional: true, label: 'Долгота' })
  Longitude = '';

  @Props({ type: 'string', required: false, isAdditional: true, label: 'Широта' })
  Latitude = '';

  @Props({ type: 'enum', value: ['ANALYTICS', 'SYNTHETICS', 'NONE'] })
  IntegrationType = '';

}
