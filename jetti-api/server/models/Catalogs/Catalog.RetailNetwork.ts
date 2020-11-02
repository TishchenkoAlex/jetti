import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.RetailNetwork',
  description: 'Торговая сеть',
  icon: 'fa fa-list',
  menu: 'Торговые сети',
  hierarchy: 'folders'
})
export class CatalogRetailNetwork extends DocumentBase {

  @Props({ type: 'Catalog.RetailNetwork', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Catalog.Brand' })
  Brand = '';

  @Props({ type: 'Catalog.Country' })
  Country: Ref = null;

  @Props({ type: 'Catalog.BusinessRegion' })
  BusinessRegion: Ref = null;

  @Props({ type: 'Catalog.Currency' })
  Currency: Ref = null;

}
