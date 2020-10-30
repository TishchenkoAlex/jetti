import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.Configuration',
  description: 'Конфигурация',
  icon: 'fa fa-list',
  menu: 'Конфигурации',
  hierarchy: 'folders',
  relations: [{ name: 'Operations', type: 'Catalog.Operation', field: 'Configuration' }]
})
export class CatalogConfiguration extends DocumentBase {

  @Props({ type: 'Catalog.Configuration', hiddenInList: true, order: -1 })
  parent: Ref = null;

}
