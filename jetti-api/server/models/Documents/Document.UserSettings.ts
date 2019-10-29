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

  @Props({ type: 'Catalog.User', required: true })
  user: Ref = null;

  @Props({ type: 'table', required: true, order: 1, label: 'Granted company list' })
  CompanyList: CompanyItems[] = [new CompanyItems()];
}

class CompanyItems {
  @Props({ type: 'Catalog.Company', required: true, style: {width: '100%'} })
  company: Ref = null;
}
