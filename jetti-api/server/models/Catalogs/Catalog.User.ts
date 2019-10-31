import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.User',
  description: 'Пользователь',
  icon: 'fa fa-list',
  menu: 'Пользователи',
  prefix: 'USR-'
})
export class CatalogUser extends DocumentBase {

  @Props({ type: 'Catalog.User', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'string', order: 1, required: true, style: { width: '250px' } })
  code = '';

  @Props({ type: 'boolean'})
  isAdmin = false;


  @Props({ type: 'table', required: true, order: 1, label: 'Roles' })
  Roles: Roles[] = [new Roles()];
}

class Roles {
  @Props({ type: 'Catalog.Role', required: true})
  role: Ref = null;
}
