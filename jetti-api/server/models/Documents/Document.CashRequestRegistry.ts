import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Document.CashRequestRegistry',
  description: 'Price list',
  icon: 'fa fa-file-text-o',
  menu: 'Price list',
  prefix: 'PRICE-'
})
export class DocumentCashRequestRegistry extends DocumentBase {
  @Props({ type: 'Types.Document', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'enum', required: true, value: ['PREPARED', 'AWAITING', 'APPROVED', 'REJECTED']})
  Status = 'PREPARED';

  @Props({ type: 'Catalog.CashFlow' })
  CashFlow: Ref = null;

  @Props({ type: 'Catalog.BusinessDirection'})
  BusinessDirection: Ref = null;

  @Props({ type: 'table', required: true, order: 1 })
  CashRequest: CashRequest[] = [new CashRequest()];
}

class CashRequest {
  @Props({ type: 'Document.CashRequest', required: true, onChangeServer: true })
  CashRequest: Ref = null;

  @Props({ type: 'Types.CashRecipient', required: true, onChangeServer: true })
  CashRecipient: Ref = null;

  @Props({ type: 'Catalog.Counterpartie.BankAccount', owner: [{ dependsOn: 'CashRecipient', filterBy: 'owner' }] })
  BankAccount: Ref = null;

  @Props({ type: 'number',  required: true })
  CashRequestAmount: Ref = null;

  @Props({ type: 'number',  required: true })
  Amount: Ref = null;

}
