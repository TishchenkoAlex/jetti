import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.Operation.Group',
  description: 'Группа операции',
  icon: 'fa fa-list',
  menu: 'Группы операций',
  prefix: 'OPG-',
  relations: [
    { name: 'Operations', type: 'Catalog.Operation', field: 'Group' }
  ],
})
export class CatalogOperationGroup extends DocumentBase {

  @Props({ type: 'Catalog.Operation.Group', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'string', required: true})
  Prefix = '';

}
