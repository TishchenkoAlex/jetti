import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Document.Operation',
  description: 'Operation',
  dimensions: [
    { Operation: 'Catalog.Operation' },
    { Amount: 'number'},
    { currency: 'Catalog.Currency'},
    { f1: 'string' },
    { f2: 'string' },
    { f3: 'string' },
    { company: 'Catalog.Company' }
  ],
  icon: 'fa fa-file-text-o',
  menu: 'Operations',
  prefix: 'OPER-',
  commands: [],
  relations: [
    { name: 'Descendants', type: 'Document.Operation', field: 'parent' }
  ]
})
export class DocumentOperation extends DocumentBase {
  @Props({ type: 'Types.Document', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Catalog.Operation.Group', required: true, order: 5, label: 'Group', hiddenInList: true })
  Group: Ref = null;

  @Props({
    type: 'Catalog.Operation', owner: [{ dependsOn: 'Group', filterBy: 'Group' }],
    required: true, onChangeServer: true, order: 6, style: { width: '270px' }
  })
  Operation: Ref = null;

  @Props({ type: 'number', order: 7 })
  Amount = 0;

  @Props({ type: 'Catalog.Currency', required: true, order: 7, label: 'Cur', style: { width: '70px' } })
  currency: Ref = null;

  @Props({ type: 'Types.Catalog', label: 'additional filed #1', style: { width: '270px' }, hiddenInForm: true })
  f1: Ref = null;

  @Props({ type: 'Types.Catalog', label: 'additional filed #2', style: { width: '270px' }, hiddenInForm: true })
  f2: Ref = null;

  @Props({ type: 'Types.Catalog', label: 'additional filed #3', style: { width: '270px' }, hiddenInForm: true })
  f3: Ref = null;

  @Props({ type: 'Catalog.User', hiddenInList: false, order: 200})
  user: Ref = null;

}
