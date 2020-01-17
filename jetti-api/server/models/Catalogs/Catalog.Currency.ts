import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.Currency',
  description: 'Валюта',
  icon: 'fa fa-list',
  menu: 'Валюты',
})
export class CatalogCurrency extends DocumentBase {

  @Props({ type: 'Catalog.Currency', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'string', order: 1, required: true, style: { width: '140px' } })
  code = '';

  @Props({ type: 'string', order: 2, required: true, style: { width: '140px' } })
  ShortName = '';
}
