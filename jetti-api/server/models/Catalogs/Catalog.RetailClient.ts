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

  @Props({ type: 'string' })
  Email: Ref = null;

  @Props({ type: 'enum', value: ['MALE', 'FEMALE', 'SELF'] })
  Gender = null;

  @Props({ type: 'string' })
  FirstName: Ref = null;

  @Props({ type: 'string' })
  LastName: Ref = null;

  @Props({ type: 'string' })
  MiddleName: Ref = null;

  @Props({ type: 'string' })
  Address: Ref = null;

}
