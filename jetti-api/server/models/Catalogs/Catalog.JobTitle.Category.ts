import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.JobTitle.Category',
  description: 'Категория должности',
  icon: 'fa fa-list',
  menu: 'Категории должностей',
  prefix: 'JTC-'
})
export class CatalogJobTitleCategory extends DocumentBase {

  @Props({ type: 'Catalog.JobTitle.Category', hiddenInList: true, order: -1 })
  parent: Ref = null;

}
