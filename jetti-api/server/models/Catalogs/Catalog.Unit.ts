import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.Unit',
  description: 'Unit',
  icon: 'fa fa-list',
  menu: 'Units',
  prefix: 'UNIT-'
})
export class CatalogUnit extends DocumentBase {

  @Props({ type: 'Catalog.Unit', hiddenInList: true, order: -1 })
  parent: Ref = null;

}
