import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Document.CashRequest',
  description: 'CashRequest',
  icon: 'fa fa-file-text-o',
  menu: 'Заявка на расход ДС',
  prefix: 'CR-'
})
export class DocumentCashRequest extends DocumentBase {
  @Props({ type: 'Types.Document', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Catalog.Company', storageType: 'items'})
  company: Ref = null;

  @Props({ type: 'Catalog.Department', required: true})
  Department: Ref = null;

  @Props({ type: 'Catalog.CashFlow', required: true})
  CashFlow: Ref = null;

  @Props({ type: 'Catalog.Counterpartie', required: true})
  Recipient: Ref = null;

  @Props({ type: 'number', required: true})
  Amount = 0;

  @Props({ type: 'Catalog.Currency', required: true})
  Currency: Ref = null;
  
  @Props({ type: 'Catalog.Operation.Group', required: true})
  OperationGroup: Ref = null;

  @Props({ type: 'Catalog.Operation', required: true})
  Operation: Ref = null;

}
