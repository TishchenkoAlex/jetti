import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.Employee',
  description: 'Сотрудник',
  icon: 'fa fa-list',
  menu: 'Сотрудники',
  prefix: 'EMP-',
  relations: [{ name: 'Employee history', type: 'Register.Info.EmployeeHistory', field: '[Employee].id' }],
  dimensions: [{ Person: 'Catalog.Person' }]
})
export class CatalogEmployee extends DocumentBase {

  @Props({ type: 'Catalog.Employee', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Catalog.Person', readOnly: true })
  Person: Ref = null;

}
