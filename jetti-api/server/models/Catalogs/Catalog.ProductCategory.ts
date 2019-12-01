import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.ProductCategory',
  description: 'Товарные категории',
  icon: 'fa fa-list',
  menu: 'Товарные категории',
  prefix: 'PRODCAT-',
  hierarchy: 'folders'
})
export class CatalogProductCategory extends DocumentBase {

  @Props({ type: 'Catalog.ProductCategory', hiddenInList: true, order: -1, storageType: 'folders' })
  parent: Ref = null;

}
