import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.Department.Company',
  description: 'Подразделение организации',
  icon: 'fa fa-list',
  menu: 'Подразделения организаций',
  prefix: 'DEPC-',
  hierarchy: 'folders',
  relations: [
    { name: 'Employee history', type: 'Register.Info.EmployeeHistory', field: 'DepartmentCompany.id' },
  ],
  dimensions: [
    { company: 'Catalog.Company' }
  ]
})
export class CatalogDepartmentCompany extends DocumentBase {

  @Props({ type: 'Catalog.Department.Company', hiddenInList: true, order: -1 })
  parent: Ref = null;


  @Props({ type: 'boolean', hidden: false, hiddenInList: true, order: 6, isIndexed: true })
  isfolder = false;

  @Props({ type: 'enum', value: ['COMPANY', 'DEPARTMENT', 'NETWORK', 'REGION', 'BRANCH', 'SALEPOINT', 'NONE'], useIn: 'all' })
  kind = 'NONE';

  @Props({
    type: 'string', required: false, hiddenInList: false
    , label: 'Short name (max 30 symbols)', order: 4, validators: [{ key: 'maxLength', value: 30 }]
  })
  ShortName = '';

  @Props({ type: 'string', required: false, hiddenInList: false, label: 'Security group', order: 4, useIn: 'all' })
  SecurityGroup = '';

  @Props({ type: 'Catalog.StaffingTable', label: 'Должность руководителя', useIn: 'all', order: 5 })
  StaffingPositionManager: Ref = null;

  @Props({ type: 'Catalog.StaffingTable', label: 'Должность помощника руководителя', useIn: 'all', order: 6 })
  StaffingPositionAssistant: Ref = null;
}
