import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Document.WorkFlow',
  description: 'Workflow',
  dimensions: [
    { Status: 'enum' },
    { Document: 'Types.Object' },
    { user: 'Catalog.User' },
  ],
  icon: 'far fa-file-alt',
  menu: 'WorkFlow list',
  prefix: 'WF-'
})
export class DocumentWorkFlow extends DocumentBase {
  @Props({ type: 'Types.Document', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Catalog.User', hiddenInList: false, order: -1 })
  user: Ref = null;

  @Props({ type: 'Types.Object', required: true, label: 'Document' })
  Document: Ref = null;

  @Props({ type: 'enum', required: true, value: [
    'PREPARED',
    'AWAITING',
    'APPROVED',
    'REJECTED',
    ]})
  Status = 'PREPARED';
}
