import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Document.ExchangeRates',
  description: 'Exchange rates',
  icon: 'fa fa-file-text-o',
  menu: 'Exchange rates',
  prefix: 'EXC-'
})
export class DocumentExchangeRates extends DocumentBase {
  @Props({ type: 'Types.Document', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Catalog.Company', required: true, onChangeServer: true, style: { width: '350px' } })
  company: Ref = null;

  @Props({ type: 'table', required: true, order: 1 })
  Rates: TableRates[] = [new TableRates()];
}

class TableRates {

  @Props({ type: 'Catalog.Currency', required: true, style: { width: '150px' } })
  Currency: Ref = null;

  @Props({ type: 'number', required: true, style: { 'width': '150px', 'text-align': 'right' } })
  Rate = 1;

  @Props({ type: 'number', required: true, style: { 'width': '150px', 'text-align': 'right' } })
  Mutiplicity = 1;
}
