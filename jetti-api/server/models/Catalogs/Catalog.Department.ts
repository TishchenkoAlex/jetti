import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.Department',
  description: 'Подразделение',
  icon: 'fa fa-list',
  menu: 'Подразделения',
  prefix: 'DEP-',
  hierarchy: 'folders'
})
export class CatalogDepartment extends DocumentBase {

  @Props({ type: 'Catalog.Department', hiddenInList: true, order: -1 })
  parent: Ref = null;

}
