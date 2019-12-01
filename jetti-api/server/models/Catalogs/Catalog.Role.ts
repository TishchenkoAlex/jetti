import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.Role',
  description: 'Роль пользователя',
  icon: 'fa fa-list',
  menu: 'Роли пользователя',
})
export class CatalogRole extends DocumentBase {

  @Props({ type: 'Catalog.Role', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'string', order: 1, required: true, style: { width: '250px' } })
  code = '';

  @Props({ type: 'table', order: 1, label: 'Granted Catalogs' })
  Cataogs: Catalogs[] = [new Catalogs()];

  @Props({ type: 'table', order: 2, label: 'Granted Documents' })
  Documents: Documents[] = [new Documents()];

  @Props({ type: 'table', order: 3, label: 'Granted Operation Groups' })
  OperationGroups: OperationGroups[] = [new OperationGroups()];

}

class Catalogs {
  @Props({ type: 'Catalog.Catalogs', required: true, order: -1 })
  Object: Ref = null;

  @Props({ type: 'boolean' })
  read = true;

  @Props({ type: 'boolean' })
  write = false;
}

class Documents {
  @Props({ type: 'Catalog.Documents', required: true, order: -1 })
  Object: Ref = null;

  @Props({ type: 'boolean' })
  read = true;

  @Props({ type: 'boolean' })
  write = false;
}

class OperationGroups {
  @Props({ type: 'Catalog.Operation.Group', order: -1 })
  Object: Ref = null;

  @Props({ type: 'boolean' })
  read = true;

  @Props({ type: 'boolean' })
  write = false;

}


