import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.Department.Kind',
  description: 'Тип подразделения',
  icon: 'fa fa-list',
  menu: 'Типы подразделений',
})
export class CatalogDepartmentKind extends DocumentBase {

  @Props({ type: 'Catalog.Department.Kind', hiddenInList: true, order: -1 })
  parent: Ref = null;

}
