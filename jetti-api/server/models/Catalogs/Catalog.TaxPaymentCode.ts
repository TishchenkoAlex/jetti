import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.TaxPaymentCode',
  description: 'КБК',
  icon: 'fa fa-list',
  menu: 'КБК',
})
export class CatalogTaxPaymentCode extends DocumentBase {

  @Props({ type: 'Catalog.TaxPaymentCode', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({type: 'string', hiddenInList: true})
  FullDescription = '';

  @Props({ type: 'Catalog.Balance.Analytics', label: 'Balance analytics' })
  BalanceAnalytics: Ref = null;

}
