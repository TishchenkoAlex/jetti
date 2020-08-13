import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.Department.Company',
  description: 'Подразделение организации',
  icon: 'fa fa-list',
  menu: 'Подразделения организаций',
  prefix: 'DEPC-',
  hierarchy: 'folders',
  relations: [
    { name: 'Manager history', type: 'Register.Info.EmployeeHistory', field: 'StaffingPositionManager.id' }
  ],
  dimensions: [
    { company: 'Catalog.Company' }
  ]
})
export class CatalogDepartmentCompany extends DocumentBase {

  @Props({ type: 'Catalog.Department.Company', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({
    type: 'string', required: false, hiddenInList: false
    , label: 'Short name (max 30 symbols)', order: 16, validators: [{ key: 'maxLength', value: 30 }]
  })
  ShortName = '';

  @Props({ type: 'Catalog.StaffingTable', label: 'Должность руководителя', useIn: 'all' })
  StaffingPositionManager: Ref = null;

}
