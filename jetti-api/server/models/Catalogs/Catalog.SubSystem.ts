import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.SubSystem',
  description: 'Подсистема',
  icon: 'fa fa-list',
  menu: 'Подсистемы',
})
export class CatalogSubSystem extends DocumentBase {

  @Props({ type: 'Catalog.Role', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'string', order: 1, required: true, style: { width: '250px' } })
  code = '';

  @Props({ type: 'table', required: true, order: 1, label: 'Granted objects' })
  Objects: Objects[] = [new Objects()];
}

class Objects {
  @Props({ type: 'Catalog.Objects', required: true, order: -1 })
  Object: Ref = null;

  @Props({ type: 'boolean' })
  show = true;

}
