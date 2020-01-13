import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.TaxPaymentPeriod',
  description: 'Налоговый период',
  icon: 'fa fa-list',
  menu: 'Налоговые периоды',
})
export class CatalogTaxPaymentPeriod extends DocumentBase {

  @Props({ type: 'Catalog.TaxPaymentPeriod', hiddenInList: true, order: -1 })
  parent: Ref = null;

}
