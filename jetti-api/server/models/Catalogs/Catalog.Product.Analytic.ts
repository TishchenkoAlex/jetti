import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.Product.Analytic',
  description: 'Аналитика номенклатуры',
  icon: 'fa fa-list',
  menu: 'Аналитика номенклатуры',
  hierarchy: 'folders'
})
export class CatalogProductAnalytic extends DocumentBase {

  @Props({ type: 'Catalog.Product.Analytic', hiddenInList: true, order: -1, storageType: 'folders' })
  parent: Ref = null;

  @Props({ type: 'string', hiddenInList: true, controlType: 'textarea' })
  Note = '';

  @Props({ type: 'boolean' })
  isActive = '';

  @Props({ type: 'number' })
  SortOrder = '';

}
