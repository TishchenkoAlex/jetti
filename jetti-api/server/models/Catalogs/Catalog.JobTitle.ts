import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.JobTitle',
  description: 'Должность',
  icon: 'fa fa-list',
  menu: 'Должности',
  prefix: 'JT-'
})
export class CatalogJobTitle extends DocumentBase {

  @Props({ type: 'Catalog.JobTitle', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Catalog.JobTitle.Category', label: 'Категория' })
  Category = false;

  @Props({ type: 'boolean', label: 'ТТ' })
  TO = false;

  @Props({ type: 'boolean', label: 'ЦО' })
  CO = false;

}
