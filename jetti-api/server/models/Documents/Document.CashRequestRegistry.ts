import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Document.CashRequestRegistry',
  description: 'Реестр оплат',
  icon: 'pi pi-list',
  menu: 'Реестр оплат',
  prefix: 'CRR-',
  commands: [
    { method: 'Fill', icon: 'pi pi-plus', label: 'Заполнить', order: 1 },
    { method: 'Create', icon: 'pi pi-plus', label: 'Создать документы', order: 2 },
    { method: 'UnloadToText', icon: 'pi pi-plus', label: 'Выгрузить в текст', order: 3 }
  ],
})
export class DocumentCashRequestRegistry extends DocumentBase {
  @Props({ type: 'Types.Document', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'enum', required: true, value: ['PREPARED', 'AWAITING', 'APPROVED', 'REJECTED'] })
  Status = 'PREPARED';

  @Props({ type: 'Catalog.CashFlow', storageType: 'all' })
  CashFlow: Ref = null;

  @Props({ type: 'Catalog.BusinessDirection' })
  BusinessDirection: Ref = null;

  @Props({ type: 'number', readOnly: true, style: { width: '100px', textAlign: 'right' }, totals: 1 })
  Amount = 0;

  @Props({ type: 'Catalog.Currency', required: true })
  сurrency: Ref = null;

  @Props({
    type: 'table', required: false, order: 1, label: 'Cash requests',
    onChange: function (doc: CashRequest, value: CashRequest[]) {
      let Amount = 0; value.forEach(el => { Amount += el.Amount; });
      return { Amount: Math.round(Amount * 100) / 100 };
    }
  })
  CashRequests: CashRequest[] = [new CashRequest()];

}

export class CashRequest {

  @Props({ type: 'Document.CashRequest', label: 'Cash request', readOnly: true })
  CashRequest: Ref = null;

  @Props({ type: 'number', label: 'Cash request amount', readOnly: true, style: { width: '100px', textAlign: 'right' }, totals: 1 })
  CashRequestAmount = 0;

  @Props({ type: 'number', label: 'Paid/ToPay amount', readOnly: true, style: { width: '100px', textAlign: 'right' }, totals: 1 })
  AmountPaid = 0;

  @Props({ type: 'number', label: 'Amount balance', readOnly: true, style: { width: '100px', textAlign: 'right' }, totals: 1 })
  AmountBalance = 0;

  @Props({ type: 'number', label: 'Amount request', readOnly: false,
    style: { width: '100px', textAlign: 'right', background: 'lightgoldenrodyellow', color: 'black' }, totals: 1 })
  AmountRequest = 0;

  @Props({ type: 'number', label: '#AP', readOnly: true, style: { width: '60px', textAlign: 'center' } })
  Delayed = 0;

  @Props({ type: 'number', label: 'Amount', required: true,
    style: { width: '100px', textAlign: 'right', background: 'lightgoldenrodyellow', color: 'black' }, totals: 1,
    onChange: function (doc: CashRequest, value) {
      return { Confirm: value > 0 ? true : false};
    } },
    )
  Amount = 0;

  @Props({ type: 'boolean', label: 'Cnfrm', style: { width: '50px', textAlign: 'center' } })
  Confirm = false;

  @Props({ type: 'Types.CashRecipient', label: 'Cash recipient', readOnly: true })
  CashRecipient: Ref = null;

  @Props({ type: 'Catalog.Company', label: 'Company', readOnly: true })
  company: Ref = null;

  @Props({ type: 'Catalog.BankAccount', label: 'Bank account', owner: [{ dependsOn: 'company', filterBy: 'company' }], required: true })
  BankAccount: Ref = null;

  @Props({ type: 'Catalog.Counterpartie.BankAccount', label: 'Cash recipient bank account', owner: [
    { dependsOn: 'CashRecipient', filterBy: 'owner' },
    { dependsOn: 'currency', filterBy: 'currency' }], required: true })
  CashRecipientBankAccount: Ref = null;

  @Props({ type: 'number', label: '#BA', readOnly: true, style: { width: '40px', textAlign: 'right' } })
  CountOfBankAccountCashRecipient = 0;

  @Props({ type: 'Types.Document', label: 'Linked document', readOnly: true })
  LinkedDocument: Ref = null;
}
