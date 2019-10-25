import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.Brand',
  description: 'Бренд',
  icon: 'fa fa-list',
  menu: 'Бренды',
  prefix: 'BRAND-'
})
export class CatalogBrand extends DocumentBase {

  @Props({ type: 'Catalog.Brand', hiddenInList: true, order: -1 })
  parent: Ref = null;

}
