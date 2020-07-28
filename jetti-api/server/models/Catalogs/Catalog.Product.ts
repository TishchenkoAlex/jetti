import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.Product',
  description: 'Номенклатура',
  icon: ' fa fa-list',
  menu: 'Номенклатура',
  prefix: 'SKU-',
  hierarchy: 'folders',
  dimensions: [
    { Unit: 'Catalog.Unit' },
    { Kind: 'Catalog.ProductKind' }
  ],
})
export class CatalogProduct extends DocumentBase {

  @Props({ type: 'Catalog.Product', hiddenInList: true, order: -1, storageType: 'folders' })
  parent: Ref = null;

  @Props({ type: 'Catalog.ProductKind', label: 'Kind', required: true, order: 5 })
  ProductKind: Ref = null;

  @Props({ type: 'Catalog.ProductCategory', label: 'Сategory' })
  ProductCategory: Ref = null;

  @Props({ type: 'Catalog.Brand' })
  Brand: Ref = null;

  @Props({ type: 'Catalog.Unit', label: 'Unit', required: true })
  Unit: Ref = null;

  @Props({ type: 'Catalog.Expense', label: 'Expense' })
  Expense: Ref = null;

  @Props({
    type: 'Catalog.Expense.Analytics', label: 'Analytics',
    owner: [{ dependsOn: 'Expense', filterBy: 'parent' }]
  })
  Analytics: Ref = null;

  @Props({ type: 'Catalog.Product.Report' })
  ProductReport: Ref = null;

  @Props({ type: 'boolean' })
  Purchased = false;

}
