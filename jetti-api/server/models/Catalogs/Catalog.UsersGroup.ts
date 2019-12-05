import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.UsersGroup',
  description: 'Группа пользователей',
  icon: 'fa fa-list',
  menu: 'Группы пользователе',
})
export class CatalogUsersGroup extends DocumentBase {

  @Props({ type: 'Catalog.UsersGroup', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'string', order: 1, required: true, style: { width: '250px' } })
  code = '';

  @Props({ type: 'table', order: 3, label: 'Users' })
  Users: Users[] = [new Users()];
}

class Users {
  @Props({ type: 'Catalog.User', required: true, style: { width: '100%' }})
  User: Ref = null;
}
