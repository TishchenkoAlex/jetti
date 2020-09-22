import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.PriceType',
  description: 'Типы цен',
  icon: 'fa fa-list',
  menu: 'Типы цен',
  prefix: 'PRT-',
  hierarchy: 'folders'
})
export class CatalogPriceType extends DocumentBase {

  @Props({ type: 'Catalog.PriceType', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Catalog.Currency', required: true, style: { width: '100px' }, isProtected: true })
  currency: Ref = null;

  @Props({ type: 'boolean', required: true })
  TaxInclude = false;

  @Props({ type: 'Catalog.Brand', isProtected: true })
  Brand: Ref = null;

}
