import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.RetailClient',
  description: 'Розничный клиент',
  icon: 'fa fa-list',
  menu: 'Розничные клиенты',
})
export class CatalogRetailClient extends DocumentBase {

  @Props({ type: 'Catalog.RetailClient', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'enum', value: ['MALE', 'FEMALE', 'SELF'] })
  Gender = null;

  @Props({ type: 'boolean' })
  isActive = '';

  @Props({ type: 'date' })
  CreateDate = null;

  @Props({ type: 'string' })
  FirstName = '';

  @Props({ type: 'string' })
  LastName = '';

  @Props({ type: 'string' })
  MiddleName = '';

  @Props({ type: 'string' })
  Phone = '';

  @Props({ type: 'string' })
  Address = '';

  @Props({ type: 'string' })
  Email = '';

}
