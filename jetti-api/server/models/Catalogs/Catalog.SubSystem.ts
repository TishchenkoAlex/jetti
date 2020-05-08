import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.SubSystem',
  description: 'Подсистема',
  icon: 'fa fa-list',
  menu: 'Подсистемы',
})
export class CatalogSubSystem extends DocumentBase {

  @Props({ type: 'Catalog.Role', hiddenInList: true, order: -1, storageType: 'folders' })
  parent: Ref = null;

  @Props({ type: 'string', order: 1, required: true, style: { width: '250px' } })
  code = '';

  @Props({ type: 'string', required: true })
  icon = '';

  @Props({ type: 'table', order: 1, label: 'Catalogs' })
  Catalogs: Catalogs[] = [new Catalogs()];

  @Props({ type: 'table', order: 2, label: 'Documents' })
  Documents: Documents[] = [new Documents()];

  @Props({ type: 'table', order: 3, label: 'Forms' })
  Forms: Forms[] = [new Forms()];

}

class Catalogs {
  @Props({ type: 'Catalog.Catalogs', required: true, style: { width: '100%' }})
  Catalog: Ref = null;
}

class Documents {
  @Props({ type: 'Catalog.Documents', required: true, style: { width: '100%' }})
  Document: Ref = null;

  @Props({ type: 'Catalog.Operation.Group', style: { width: '100%' }})
  Group: Ref = null;

}

class Forms {
  @Props({ type: 'Catalog.Forms', required: true, style: { width: '100%' }})
  Form: Ref = null;
}

