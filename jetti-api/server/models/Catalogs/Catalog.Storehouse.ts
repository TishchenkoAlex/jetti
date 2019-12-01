import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.Storehouse',
  description: 'Склад',
  icon: 'fa fa-list',
  menu: 'Склады',
  prefix: 'STOR-',
  hierarchy: 'folders'
})
export class CatalogStorehouse extends DocumentBase {

  @Props({ type: 'Catalog.Storehouse', hiddenInList: true, order: -1, storageType: 'folders' })
  parent: Ref = null;

  @Props({ type: 'Catalog.Department'})
  Department: Ref = null;

  @Props({ type: 'Catalog.Company', required: true, hiddenInForm: false})
  company: Ref = null;
}
