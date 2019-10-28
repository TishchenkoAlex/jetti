import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.Product',
  description: 'Номенклатура',
  icon: ' fa fa-list',
  menu: 'Номенклатура',
  prefix: 'SKU-',
  hierarchy: 'folders'
})
export class CatalogProduct extends DocumentBase {

  @Props({ type: 'Catalog.Product', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Catalog.ProductKind', label: 'Kind', required: true, order: 5 })
  ProductKind: Ref = null;

  @Props({ type: 'Catalog.ProductCategory', label: 'Сategory' })
  ProductCategory: Ref = null;

  @Props({ type: 'Catalog.Brand' })
  Brand: Ref = null;

  @Props({ type: 'Catalog.Unit', label: 'Unit' })
  Unit: Ref = null;

  @Props({ type: 'number' })
  Volume = 0;

}
