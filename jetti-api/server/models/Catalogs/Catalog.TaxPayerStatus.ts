import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.TaxPayerStatus',
  description: 'Статус плательщика налогов',
  icon: 'fa fa-list',
  menu: 'Статусы плательщиков налогов',
})
export class CatalogTaxPayerStatus extends DocumentBase {

  @Props({ type: 'Catalog.TaxPayerStatus', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({type: 'string'})
  FullDescription = '';

}
