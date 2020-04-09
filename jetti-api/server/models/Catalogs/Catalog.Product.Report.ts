import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.Product.Report',
  description: 'Номенклатура отчета',
  icon: 'fa fa-list',
  menu: 'Номенклатура отчета',
  hierarchy: 'folders',
  dimensions: [
    { Brand: 'Catalog.Brand' },
  ],
})
export class CatalogProductReport extends DocumentBase {

  @Props({ type: 'Catalog.Product.Report', hiddenInList: true, order: -1, storageType: 'folders' })
  parent: Ref = null;

  @Props({ type: 'Catalog.Brand' })
  Brand: Ref = null;

  @Props({ type: 'Catalog.Unit', label: 'Unit' })
  Unit: Ref = null;

}
