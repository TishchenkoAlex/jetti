import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.BusinessDirection',
  description: 'Бизнес направление договора',
  icon: 'fa fa-list',
  menu: 'Бизнес направления',
  prefix: 'BD-',
  hierarchy: 'folders',
})
export class CatalogBusinessDirection extends DocumentBase {

  @Props({ type: 'Catalog.BusinessDirection', hiddenInList: true, order: -1 })
  parent: Ref = null;

}
