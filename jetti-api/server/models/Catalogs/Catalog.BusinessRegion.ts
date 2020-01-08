import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.BusinessRegion',
  description: 'Бизнес-регион',
  icon: 'fa fa-list',
  menu: 'Бизнес-регионы',
  prefix: 'BR-',
  hierarchy: 'folders'
})
export class CatalogBusinessRegion extends DocumentBase {

  @Props({ type: 'Catalog.BusinessRegion', hiddenInList: true, order: -1, storageType: 'all' })
  parent: Ref = null;

}
