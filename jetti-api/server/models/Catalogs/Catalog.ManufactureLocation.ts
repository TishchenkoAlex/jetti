import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.ManufactureLocation',
  description: 'Станция производства',
  icon: 'fa fa-list',
  menu: 'Станции производства',
})
export class CatalogManufactureLocation extends DocumentBase {

  @Props({ type: 'Catalog.ManufactureLocation', hiddenInList: true, order: -1 })
  parent: Ref = null;

}
