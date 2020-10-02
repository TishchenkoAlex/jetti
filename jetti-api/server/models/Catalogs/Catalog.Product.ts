import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.Product',
  description: 'Номенклатура',
  icon: ' fa fa-list',
  menu: 'Номенклатура',
  prefix: 'SKU-',
  hierarchy: 'folders',
  relations: [{ name: 'Specification by department', type: 'Register.Info.ProductSpecificationByDepartment', field: 'Product.id' }],
  dimensions: [
    { Unit: 'Catalog.Unit' },
    { Kind: 'Catalog.ProductKind' }
  ],
  commands: [{ method: 'SavePropsValuesInChilds', icon: 'pi pi-plus', order: 1, label: 'Save in child elements' }]
})
export class CatalogProduct extends DocumentBase {

  @Props({ type: 'Catalog.Product', hiddenInList: true, order: -1, storageType: 'folders' })
  parent: Ref = null;

  @Props({ type: 'boolean', hidden: false, hiddenInList: true, isAdditional: true })
  isfolder = false;

  @Props({ type: 'Catalog.ProductKind', label: 'Kind', order: 5, onChangeServer: true, useIn: 'all' })
  ProductKind: Ref = null;

  @Props({ type: 'Catalog.ProductCategory', label: 'Сategory', order: 666, useIn: 'all' })
  ProductCategory: Ref = null;

  @Props({ type: 'Catalog.Specification', label: 'Specification', order: 666, useIn: 'all' })
  Specification: Ref = null;

  @Props({ type: 'Catalog.Brand', order: 666, useIn: 'all' })
  Brand: Ref = null;

  @Props({ type: 'Catalog.Unit', label: 'Unit', order: 666, useIn: 'all' })
  Unit: Ref = null;

  @Props({ type: 'Catalog.Expense', label: 'Expense', order: 666, useIn: 'all' })
  Expense: Ref = null;

  @Props({
    type: 'Catalog.Expense.Analytics', label: 'Analytics', order: 666, useIn: 'all',
    owner: [{ dependsOn: 'Expense', filterBy: 'parent' }]
  })
  Analytics: Ref = null;

  @Props({ type: 'Catalog.Product.Report', order: 666, useIn: 'all' })
  ProductReport: Ref = null;

  @Props({ type: 'Document.Operation', order: 666, useIn: 'all' })
  Settings: Ref = null;

  @Props({ type: 'boolean', order: 666, useIn: 'all' })
  Purchased = false;

  @Props({ type: 'string', order: 666, useIn: 'all' })
  ShortCode = '';

  @Props({ type: 'string', order: 666, useIn: 'all' })
  ShortName = '';

  @Props({ type: 'string', order: 666, useIn: 'all' })
  Tags = '';

  @Props({ type: 'number', order: 666, useIn: 'all' })
  Weight = '';

  @Props({ type: 'number', order: 666, useIn: 'all' })
  Volume = '';

  @Props({ type: 'enum', order: 666, value: ['kitchen', 'outlet'], useIn: 'all' })
  CookingPlace = 'kitchen';

  @Props({ type: 'table', label: 'Products', order: 666 })
  Product: Product[] = [new Product()];

}

export class Product {

  @Props({ type: 'Catalog.Product' })
  Product = '';

  @Props({ type: 'number' })
  Qty = '';

}

