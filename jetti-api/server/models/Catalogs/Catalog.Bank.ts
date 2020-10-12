import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.Bank',
  description: 'Банки',
  icon: 'fa fa-list',
  menu: 'Банки',
  hierarchy: 'folders',
})
export class CatalogBank extends DocumentBase {

  @Props({ type: 'Catalog.Bank', hiddenInList: true, order: -1, storageType: 'folders' })
  parent: Ref = null;

  @Props({ type: 'string'})
  Code1 = '';

  @Props({ type: 'string'})
  Code2 = '';

  @Props({ type: 'string'})
  Address = '';

  @Props({ type: 'string'})
  KorrAccount = '';

  @Props({ type: 'Document.Operation'})
  ExportRule = null;

  @Props({ type: 'boolean'})
  isActive = true;

}
