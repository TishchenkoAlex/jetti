import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Document.Settings',
  description: 'Settings',
  icon: 'far fa-file-alt',
  menu: 'Settings',
  prefix: 'SET-'
})
export class DocumentSettings extends DocumentBase {
  @Props({ type: 'Types.Document', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Catalog.Currency', required: true, label: 'balance currency' })
  balanceCurrency: Ref = null;

  @Props({ type: 'Catalog.Currency', required: true, label: 'accounting currency' })
  accountingCurrency: Ref = null;

}
