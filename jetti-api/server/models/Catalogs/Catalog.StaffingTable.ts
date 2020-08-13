import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.StaffingTable',
  description: 'Позиция штатного расписания',
  icon: 'fa fa-list',
  menu: 'Штатное расписание',
  prefix: 'ST-',
  hierarchy: 'folders',
  dimensions: [{ JobTitle: 'Catalog.JobTitle' }, { Department: 'Catalog.Department' }],
  relations: [{ name: 'Employee history', type: 'Register.Info.EmployeeHistory', field: '[StaffingPosition].id' }]
})
export class CatalogStaffingTable extends DocumentBase {

  @Props({ type: 'Catalog.StaffingTable', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'string', required: true, order: 2, style: { width: '135px' }, isUnique: true })
  code = '';

  @Props({ type: 'string', order: 3, readOnly: true, label: 'description (auto)' })
  description = '';

  @Props({ type: 'Catalog.JobTitle', required: true, isProtected: true })
  JobTitle: Ref = null;

  @Props({ type: 'Catalog.Department', required: true, isProtected: true, label: 'Подразделение (фин. структура)' })
  Department: Ref = null;

  @Props({ type: 'Catalog.Department.Company', required: true, isProtected: true, label: 'Подразделение (орг. структура)', storageType: 'all' })
  DepartmentCompany: Ref = null;

  @Props({ type: 'Catalog.Currency', required: true, isProtected: true })
  Currency: Ref = null;

  @Props({ type: 'date' })
  ActivationDate = null;

  @Props({ type: 'date' })
  CloseDate = null;

  @Props({ type: 'number' })
  Qty = 0;

  @Props({ type: 'number' })
  Cost = 0;

}
