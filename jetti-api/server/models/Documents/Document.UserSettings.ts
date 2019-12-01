import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Document.UserSettings',
  description: 'User settings',
  icon: 'fa fa-file-text-o',
  menu: 'User settings',
  prefix: 'USET-'
})
export class DocumentUserSettings extends DocumentBase {
  @Props({ type: 'Types.Document', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Catalog.User', required: true, storageType: 'all' })
  user: Ref = null;

  @Props({ type: 'table', order: 1, label: 'Roles' })
  RoleList: RoleItems[] = [new RoleItems()];

  @Props({ type: 'table', order: 2, label: 'Granted Сompanys' })
  CompanyList: CompanyItems[] = [new CompanyItems()];

  @Props({ type: 'table', order: 3, label: 'Granted Operation Groups' })
  OperationGroups: OperationGroups[] = [new OperationGroups()];

  @Props({ type: 'table', order: 4, label: 'Granted Subsystems' })
  Subsystems: Subsystems[] = [new Subsystems()];
}

class RoleItems {
  @Props({ type: 'Catalog.Role', style: { width: '100%' } })
  Role: Ref = null;
}

class CompanyItems {
  @Props({ type: 'Catalog.Company', style: { width: '100%' } })
  company: Ref = null;
}

class Subsystems {
  @Props({ type: 'Catalog.SubSystem', style: { width: '100%' } })
  SubSystem: Ref = null;
}

class OperationGroups {
  @Props({ type: 'Catalog.Operation.Group', style: { width: '100%' } })
  Group: Ref = null;
}
