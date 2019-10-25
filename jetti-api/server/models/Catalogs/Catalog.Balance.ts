import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.Balance',
  description: 'Статья баланса',
  icon: 'fa fa-list',
  menu: 'Статьи баланса',
  prefix: '',
  relations: [
    { name: 'Balance analytics', type: 'Catalog.Balance.Analytics', field: 'parent' }
  ],
  hierarchy: 'folders'
})
export class CatalogBalance extends DocumentBase {

  @Props({ type: 'Catalog.Balance', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'boolean'})
  isActive = false;

  @Props({ type: 'boolean'})
  isPassive = false;

  @Props({ type: 'table'})
  Subcounts: Subcounts[] = [new Subcounts()];
}

class Subcounts {
  @Props({ type: 'Catalog.Subcount', required: true})
  Subcount: Ref = null;
}
