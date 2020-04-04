import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.Department.StatusReason',
  description: 'Причина статуса подразделения',
  icon: 'fa fa-list',
  menu: 'Причины статусов подр.',
})
export class CatalogDepartmentStatusReason extends DocumentBase {

  @Props({ type: 'Catalog.Department.StatusReason', hiddenInList: true, order: -1 })
  parent: Ref = null;

}
