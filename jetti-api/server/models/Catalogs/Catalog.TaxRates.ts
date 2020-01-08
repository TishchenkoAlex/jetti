import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.TaxRates',
  description: 'Ставки налогов',
  icon: 'fa fa-list',
  menu: 'Ставки налого',
  prefix: 'TXR-'
})
export class CatalogTaxRates extends DocumentBase {

  @Props({ type: 'Catalog.TaxRates', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'number', required: true})
  Rate = 0;

}
