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

  @Props({ type: 'Catalog.Person', isProtected: true })
  Person: Ref = null;

  @Props({ type: 'Catalog.Company', required: true, isProtected: true })
  company: Ref = null;

  @Props({ type: 'string', required: true, order: 2, style: { width: '135px' }, isUnique: true })
  code = '';

  @Props({ type: 'string', label: 'Description (auto)', order: 3, required: false, style: { width: '300px' } })
  description = '';

}
