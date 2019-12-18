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

  @Props({ type: 'Catalog.Currency', required: true, label: 'default currency', style: { width: '100px' } })
  currency: Ref = null;

  @Props({ type: 'string', required: true })
  prefix = '';

  @Props({ type: 'Catalog.Company' })
  Intercompany: Ref = null;

  @Props({ type: 'enum', required: true, value: [
    'UTC',
    'Central European Standard Time',
    'Russian Standard Time',
    'E. Europe Standard Time',
    'US Eastern Standard Time'
    ]})
  timeZone = 'UTC';

}
