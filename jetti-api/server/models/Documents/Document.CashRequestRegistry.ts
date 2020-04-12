import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Document.CashRequestRegistry',
  description: 'Реестр оплат',
  icon: 'far fa-file-alt',
  menu: 'Реестр оплат',
  prefix: 'CRR-',
  dimensions: [
    { Status: 'enum' },
    { company: 'Catalog.Company' },
    { Amount: 'number' },
    { user: 'Catalog.User' },
    { CashFlow: 'Catalog.CashFlow' }
  ],
  commands: [
    { method: 'Fill', icon: 'pi pi-plus', label: 'Заполнить', order: 1 },
    { method: 'Create', icon: 'pi pi-plus', label: 'Создать документы', order: 2 },
    {
      method: 'UnloadToText', icon: 'pi pi-plus', label: 'Выгрузить в текст', order: 3, clientModule:
        `return { afterExecution: () => {
          const savedValue = this.form.get('info').value;
          if (!savedValue) return;
          const vals = this.form;
          let fileName = '';
          if (savedValue.indexOf('COUNT_B') === -1)
          fileName = 'exchange_' + vals.get('code').value + '_' + vals.get('date').value.toLocaleDateString()+ '_' + vals.get('company').value.value + '.' + (savedValue.startsWith('<?xml version=') ? 'xml' : 'txt');
          else fileName = 'jbkl_snd+.csv';
          this.ds.download(savedValue, fileName);
        }
      }`
    },
    {
      method: 'ExportSalaryToCSV', icon: 'pi pi-plus', label: 'Выгрузить в CSV', order: 4, clientModule:
        `return { afterExecution: () => {
          const savedValue = this.form.get('info').value;
          if (!savedValue) return;
          const vals = this.form;
          fileName = 'salary_' + vals.get('code').value + '_' + vals.get('date').value.toLocaleDateString()+ '_' + vals.get('company').value.value + '.csv';
          this.ds.download(savedValue, fileName);
        }
      }`
    }
  ],
})

export class DocumentCashRequestRegistry extends DocumentBase {
  @Props({ type: 'Types.Document', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Catalog.Company', order: 4, required: true, style: { width: '250px' } })
  company: Ref = null;

  @Props({ type: 'enum', required: true, value: ['PREPARED', 'AWAITING', 'APPROVED', 'REJECTED'] })
  Status = 'PREPARED';

  @Props({
    type: 'enum', order: 8, label: 'Вид операции', value: [
      'Оплата поставщику',
      'Перечисление налогов и взносов',
      'Оплата ДС в другую организацию',
      'Выдача ДС подотчетнику',
      'Оплата по кредитам и займам полученным',
      'Прочий расход ДС',
      'Выдача займа контрагенту',
      'Возврат оплаты клиенту',
      'Выплата заработной платы',
      'Выплата заработной платы (наличные)',
      'Выплата заработной платы без ведомости',
    ]
  })
  Operation = 'Оплата поставщику';

  @Props({ type: 'Catalog.CashFlow', storageType: 'all' })
  CashFlow: Ref = null;

  @Props({ type: 'Catalog.BusinessDirection' })
  BusinessDirection: Ref = null;

  @Props({ type: 'number', readOnly: true, style: { width: '100px', textAlign: 'right' }, totals: 1 })
  Amount = 0;

  @Props({ type: 'Catalog.Currency', required: true })
  сurrency: Ref = null;

  @Props({ type: 'Catalog.User', hiddenInList: false, readOnly: true })
  user: Ref = null;

  @Props({ type: 'date', isAdditional: true })
  BankUploadDate = null;

  @Props({ type: 'date', isAdditional: true })
  DocumentsCreationDate = null;

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

  @Props({ type: 'string', label: 'Operation type', readOnly: true, style: { width: '320px', textAlign: 'left' } })
  OperationType: Ref = null;

  @Props({ type: 'Document.CashRequest', label: 'Cash request', readOnly: true, style: { width: '320px', textAlign: 'left' } })
  CashRequest: Ref = null;

  @Props({ type: 'number', label: 'Cash request amount', readOnly: true, style: { width: '100px', textAlign: 'right' }, totals: 1 })
  CashRequestAmount = 0;

  @Props({ type: 'number', label: 'Paid/ToPay amount', readOnly: true, style: { width: '100px', textAlign: 'right' }, totals: 1 })
  AmountPaid = 0;

  @Props({ type: 'number', label: 'Amount balance', readOnly: true, style: { width: '100px', textAlign: 'right' }, totals: 1 })
  AmountBalance = 0;

  @Props({
    type: 'number', label: 'Amount request', readOnly: false,
    style: { width: '100px', textAlign: 'right', background: 'lightgoldenrodyellow', color: 'black' }, totals: 1
  })
  AmountRequest = 0;

  @Props({ type: 'number', label: '#AP', readOnly: true, style: { width: '60px', textAlign: 'center' } })
  Delayed = 0;

  @Props({
    type: 'number', label: 'Amount', required: true,
    style: { width: '100px', textAlign: 'right', background: 'lightgoldenrodyellow', color: 'black' }, totals: 1,
    onChange: function (doc: CashRequest, value) {
      return { Confirm: value > 0 ? true : false };
    }
  },
  )
  Amount = 0;

  @Props({ type: 'boolean', label: 'Cnfrm', style: { width: '50px', textAlign: 'center' } })
  Confirm = false;

  @Props({ type: 'Types.CashRecipient', label: 'Cash recipient', readOnly: true })
  CashRecipient: Ref = null;

  @Props({ type: 'Catalog.Company', label: 'Company', readOnly: true })
  company: Ref = null;

  @Props({
    type: 'Catalog.CashRegister', label: 'Cash register', owner: [
      { dependsOn: 'company', filterBy: 'company' },
      { dependsOn: 'currency', filterBy: 'currency' }]
  })
  CashRegister: Ref = null;

  @Props({
    type: 'Catalog.BankAccount', label: 'Bank account out', owner:
      [{ dependsOn: 'company', filterBy: 'company' },
      { dependsOn: 'currency', filterBy: 'currency' }], required: true
  })
  BankAccount: Ref = null;

  @Props({ type: 'Catalog.BankAccount', label: 'Bank account in', owner: [{ dependsOn: 'company', filterBy: 'company' }, { dependsOn: 'currency', filterBy: 'currency' }] })
  BankAccountIn: Ref = null;

  @Props({
    type: 'Catalog.Counterpartie.BankAccount', label: 'Cash recipient bank account', owner: [
      { dependsOn: 'CashRecipient', filterBy: 'owner' },
      { dependsOn: 'currency', filterBy: 'currency' }]
  })
  CashRecipientBankAccount: Ref = null;

  @Props({ type: 'Catalog.Person.BankAccount', label: 'Bank account person', readOnly: true, required: false })
  BankAccountPerson: Ref = null;


  @Props({ type: 'number', label: '#BA', readOnly: true, style: { width: '40px', textAlign: 'right' } })
  CountOfBankAccountCashRecipient = 0;

  @Props({ type: 'Types.Document', label: 'Linked document', readOnly: true, style: { width: '440px' } })
  LinkedDocument: Ref = null;
}
