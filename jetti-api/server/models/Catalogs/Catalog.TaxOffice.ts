import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.TaxOffice',
  description: 'Наголовая служба',
  icon: 'fa fa-list',
  menu: 'Наголовые службы',
  prefix: 'TXR-'
})
export class CatalogTaxOffice extends DocumentBase {

  @Props({ type: 'Catalog.TaxOffice', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'string', label: 'Наименование полное', required: true })
  FullName = '';

  @Props({ type: 'string', label: 'Код налогового органа', required: true})
  Code1 = '';

  @Props({ type: 'string', label: 'ОКТМО', required: true})
  Code2 = '';

  @Props({ type: 'string', label: 'ОКАТО', required: false})
  Code3 = '';

}


