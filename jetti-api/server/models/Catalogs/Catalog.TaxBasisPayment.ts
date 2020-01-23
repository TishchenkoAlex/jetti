import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.TaxBasisPayment',
  description: 'Основание налогового платежа',
  icon: 'fa fa-list',
  menu: 'Основания платежей',
})
export class CatalogTaxBasisPayment extends DocumentBase {

  @Props({ type: 'Catalog.TaxBasisPayment', hiddenInList: true, order: -1 })
  parent: Ref = null;

}
