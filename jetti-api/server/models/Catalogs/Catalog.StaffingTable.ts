import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.StaffingTable',
  description: 'Позиция штатного расписания',
  icon: 'fa fa-list',
  menu: 'Штатное расписание',
  prefix: 'ST-',
  relations: [{ name: 'Employee history', type: 'Register.Info.EmployeeHistory', field: '[StaffingPosition].id' }]
})
export class CatalogStaffingTable extends DocumentBase {

  @Props({ type: 'Catalog.StaffingTable', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'string', order: 3, readOnly: true, label: 'description (auto)' })
  description = '';

  @Props({ type: 'Catalog.JobTitle', required: true })
  JobTitle: Ref = null;

  @Props({ type: 'Catalog.Department', required: true })
  Department: Ref = null;

  @Props({ type: 'date' })
  ActivationDate = null;

  @Props({ type: 'date' })
  CloseDate = null;

  @Props({ type: 'number' })
  Qty = 0;

  @Props({ type: 'number' })
  Cost = 0;

}
