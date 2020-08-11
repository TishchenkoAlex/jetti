import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.Product.Package',
  description: 'Пакет продуктов',
  icon: 'fa fa-list',
  menu: 'Пакеты продуктов',
  hierarchy: 'folders',
  dimensions: [
    { Product: 'Catalog.Product' }, { Label: 'string' }, { isActive: 'boolean' }
  ],
})
export class CatalogProductPackage extends DocumentBase {

  @Props({ type: 'Catalog.Product.Package', hiddenInList: true, order: -1, storageType: 'folders' })
  parent: Ref = null;

  @Props({ type: 'Catalog.Product' })
  Product: Ref = null;

  @Props({ type: 'number', label: 'Qty' })
  Qty = 0;

  @Props({ type: 'boolean' })
  isActive = false;

  @Props({ type: 'string' })
  Label = '';

}
