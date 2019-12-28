import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Document.CashRequestRegistry',
  description: 'Реестр оплат',
  icon: 'pi pi-list',
  menu: 'Реестр оплат',
  prefix: 'CRR-',
  commands: [
    { command: 'Fill', icon: 'pi pi-plus', label: 'Заполнить' }
  ],
})
export class DocumentCashRequestRegistry extends DocumentBase {
  @Props({ type: 'Types.Document', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'enum', required: true, value: ['PREPARED', 'AWAITING', 'APPROVED', 'REJECTED'] })
  Status = 'PREPARED';

  @Props({ type: 'Catalog.CashFlow' })
  CashFlow: Ref = null;

  @Props({ type: 'Catalog.BusinessDirection' })
  BusinessDirection: Ref = null;

  @Props({ type: 'number', readOnly: true })
  Amount = 0;

  @Props({ type: 'Catalog.Currency', required: true })
  сurrency: Ref = null;

  @Props({
    type: 'table', required: true, order: 1,
    onChange: function (doc: CashRequest, value: CashRequest[]) {
      let Amount = 0; value.forEach(el => { Amount += el.Amount; });
      return { Amount: Math.round(Amount * 100) / 100 };
    }
  })
  CashRequests: CashRequest[] = [new CashRequest()];

}

export class CashRequest {

  @Props({ type: 'Document.CashRequest', readOnly: true })
  CashRequest: Ref = null;

  @Props({ type: 'number', readOnly: true, style: { width: '170px' }, totals: 1 })
  CashRequestAmount = 0;

  @Props({ type: 'number', readOnly: true, style: { width: '170px' }, totals: 1 })
  AmountPaid = 0;

  @Props({ type: 'number', readOnly: true, style: { width: '170px' }, totals: 1 })
  AmountBalance = 0;

  @Props({ type: 'number', readOnly: true, style: { width: '170px' }, totals: 1 })
  AmountRequest = 0;

  @Props({ type: 'number', readOnly: true, style: { width: '70px' }, totals: 1 })
  Delayed = 0;

  @Props({ type: 'number', required: true, style: { width: '170px' }, totals: 1 })
  Amount = 0;

  @Props({ type: 'boolean', style: { width: '50px' } })
  Confirm = false;

  @Props({ type: 'Types.CashRecipient', readOnly: true })
  CashRecipient: Ref = null;

  @Props({ type: 'Catalog.Company', readOnly: true })
  company: Ref = null;

  @Props({ type: 'Catalog.BankAccount', owner: [{ dependsOn: 'company', filterBy: 'company' }], required: true })
  BankAccount: Ref = null;

}
