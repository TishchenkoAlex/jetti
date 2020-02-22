import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.Company.Group',
  description: 'Группа организаций',
  icon: 'fa fa-list',
  menu: 'Группы организаций',
  hierarchy: 'folders',
  relations: [
    { name: 'company', type: 'Catalog.Company', field: 'company' },
  ],
})
export class CatalogCompanyGroup extends DocumentBase {

  @Props({ type: 'Catalog.Company.Group', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'string', required: false })
  FullName = '';

}
