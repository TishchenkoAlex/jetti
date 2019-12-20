import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.Company',
  description: 'Организация',
  icon: 'fa fa-list',
  menu: 'Организации',
})
export class CatalogCompany extends DocumentBase {

  @Props({ type: 'Catalog.Company', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'string', required: false })
  FullName = '';

  @Props({ type: 'Catalog.Currency', required: true, label: 'default currency', style: { width: '100px' } })
  currency: Ref = null;

  @Props({ type: 'string', required: true })
  prefix = '';

  @Props({ type: 'Catalog.Company' })
  Intercompany: Ref = null;

  @Props({ type: 'string', required: false })
  AddressShipping: Ref = null;

  @Props({ type: 'string', required: false })
  AddressBilling: Ref = null;

  @Props({ type: 'string', required: false })
  Phone: Ref = null;

  @Props({ type: 'string', required: false })
  Code1: Ref = null;

  @Props({ type: 'string', required: false })
  Code2: Ref = null;

  @Props({ type: 'string', required: false })
  Code3: Ref = null;

  @Props({ type: 'enum', required: true, value: [
    'UTC',
    'Central European Standard Time',
    'Russian Standard Time',
    'E. Europe Standard Time',
    'US Eastern Standard Time'
    ]})
  timeZone = 'UTC';

}
