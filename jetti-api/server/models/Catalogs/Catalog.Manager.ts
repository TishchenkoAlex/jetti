import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.Manager',
  description: 'Менеджер',
  icon: 'fa fa-list',
  menu: 'Менеджеры',
  prefix: 'MAN-'
})
export class CatalogManager extends DocumentBase {

  @Props({ type: 'Catalog.Manager', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'string', required: true })
  FullName = '';

  @Props({ type: 'boolean', required: true })
  Gender = false;

  @Props({ type: 'date' })
  Birthday: Date | null = null;

  @Props({ type: 'Types.Subcount', required: true })
  Product: Ref = null;

}
