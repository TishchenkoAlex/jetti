import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.User',
  description: 'Пользователь',
  icon: 'fa fa-list',
  menu: 'Пользователи',
  prefix: 'USR-',
  hierarchy: 'folders'
})
export class CatalogUser extends DocumentBase {

  @Props({ type: 'Catalog.User', hiddenInList: true, order: -1, storageType: 'folders' })
  parent: Ref = null;

  @Props({ type: 'string', order: 1, required: true, style: { width: '250px' } })
  code = '';

  @Props({ type: 'boolean'})
  isAdmin = false;

  @Props({ type: 'Catalog.Person' })
  Person: Ref = null;

  @Props({ type: 'Catalog.Department' })
  Department: Ref = null;

}
