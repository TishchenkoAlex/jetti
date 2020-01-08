import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.TaxRate',
  description: 'Ставка налогов',
  icon: 'fa fa-list',
  menu: 'Ставки налого',
  prefix: 'TXR-'
})
export class CatalogTaxRate extends DocumentBase {

  @Props({ type: 'Catalog.TaxRate', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'number', required: true})
  Rate = 0;

}
