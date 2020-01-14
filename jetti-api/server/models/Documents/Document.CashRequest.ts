import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Document.CashRequest',
  description: 'Заявка на расходование ДС',
  dimensions: [
    { Status: 'enum' },
    { Document: 'Types.Object' },
    { user: 'Catalog.User' },
  ],
  icon: 'fa fa-file-text-o',
  menu: 'Заявки на ДС',
  prefix: 'CR-',
  copyTo: [
    { type: 'Document.Operation', icon: '', label: 'Платежный документ', order: 1 }
  ],
  relations: [
    { name: 'Operations', type: 'Document.Operation', field: 'parent' },
  ]
})
export class DocumentCashRequest extends DocumentBase {

  @Props({ type: 'datetime', label: 'Дата', order: 1 })
  date = new Date();

  @Props({ type: 'string', label: 'Номер', required: true, order: 2, style: { width: '135px' } })
  code = '';

  @Props({ type: 'string', label: 'Комментарий', hiddenInList: true, order: -1, controlType: 'textarea' })
  info = '';

  // @Props({ type: 'string', label: 'Назначение платежа', hiddenInList: true, order: -1, controlType: 'textarea'})
  // paymantInfo = '';

  @Props({ type: 'Types.Document', label: 'Основание', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Catalog.User', label: 'Автор', hiddenInList: false, order: 991, style: { width: '200px' } })
  user: Ref = null;

  @Props({
    type: 'enum', required: true, hiddenInList: false, style: { width: '100px' }, order: 7, label: 'Статус', value: [
      'PREPARED',
      'AWAITING',
      'APPROVED',
      'REJECTED',
    ]
  })
  Status = 'PREPARED';

  @Props({
    type: 'enum', required: true, order: 8, label: 'Вид операции', value: [
      'Оплата поставщику',
      'Перечисление налогов и взносов',
      'Оплата ДС в другую организацию',
      'Выдача ДС подотчетнику',
      'Оплата по кредитам и займам полученным',
      'Прочий расход ДС',
      'Выдача займа контрагенту',
      'Возврат оплаты клиенту',
      'Выплата заработной платы'
    ]
  })
  Operation = 'Оплата поставщику';

  @Props({ type: 'Catalog.Company', order: 3, label: 'Организация', required: true, onChangeServer: true, style: { width: '250px' } })
  company: Ref = null;

  @Props({
    type: 'enum', hiddenInList: true, label: 'Вид платежа', value: [
      'BODY',
      'PERCENT',
      'SHARE',
      'CUSTOM1'
    ]
  })
  PaymentKind = 'BODY';

  @Props({
    type: 'enum', required: true, style: { width: '140px' },
    label: 'Тип платежа',
    value: [
      'BANK',
      'CASH',
      'ANY',
    ]
  })
  CashKind = 'ANY';

  @Props({
    type: 'enum', required: false, style: { width: '140px' },
    label: 'Способ выплаты',
    value: [
      'BANK',
      'CASH',
      'SALARYPROJECT'
    ]
  })
  PayRollKind = 'BANK';

  @Props({ type: 'Catalog.Department', label: 'Подразделение' })
  Department: Ref = null;

  @Props({
    type: 'Types.CashRecipient',
    required: true,
    onChangeServer: true,
    label: 'Получатель',
  })
  CashRecipient: Ref = null;

  @Props({
    type: 'Catalog.Contract',
    hiddenInList: true,
    required: false,
    onChangeServer: true,
    label: 'Договор',
    owner: [
      { dependsOn: 'CashRecipient', filterBy: 'owner' },
      { dependsOn: 'company', filterBy: 'company' },
      { dependsOn: 'currency', filterBy: 'currency' }]
  })
  Contract: Ref = null;

  @Props({ type: 'Catalog.CashFlow', label: 'Статья ДДС', required: true })
  CashFlow: Ref = null;

  @Props({
    type: 'Catalog.Loan',
    hiddenInList: true,
    label: 'Договор кредита/займа',
    owner: [
      { dependsOn: 'CashRecipient', filterBy: 'owner' },
      { dependsOn: 'company', filterBy: 'company' },
      { dependsOn: 'currency', filterBy: 'currency' }]
  })
  Loan: Ref = null;

  @Props({
    type: 'Types.CashOrBank',
    label: 'Источник',
    owner: [
      { dependsOn: 'company', filterBy: 'company' },
      { dependsOn: 'сurrency', filterBy: 'currency' }
    ]
  })
  CashOrBank: Ref = null;

  @Props({
    type: 'Catalog.Counterpartie.BankAccount',
    label: 'Счет получателя',
    owner: [
      { dependsOn: 'CashRecipient', filterBy: 'owner' },
      { dependsOn: 'сurrency', filterBy: 'currency' }
    ]
  })
  CashRecipientBankAccount: Ref = null;

  @Props({
    type: 'Types.CashOrBank', hiddenInList: true,
    label: 'Касса/банк получателя',
    owner: [
      { dependsOn: 'CashRecipient', filterBy: 'company' },
      { dependsOn: 'сurrency', filterBy: 'currency' }
    ]
  })
  CashOrBankIn: Ref = null;

  @Props({
    type: 'date',
    hiddenInList: false,
    order: 9,
    label: 'Дата платежа',
    style: { width: '100px' }
  })
  PayDay = new Date();

  @Props({ type: 'number', label: 'Сумма', required: true, order: 4, style: { width: '100px', textAlign: 'right' } })
  Amount = 0;

  @Props({ type: 'Catalog.Currency', label: 'Валюта', required: true, order: 5, style: { width: '70px' } })
  сurrency: Ref = null;

  @Props({ type: 'Types.ExpenseOrBalance', label: 'Аналитики расходов', hiddenInList: true })
  ExpenseOrBalance: Ref = null;

  @Props({ type: 'Catalog.Expense.Analytics', label: 'Аналитики расходов', hiddenInList: true })
  ExpenseAnalytics: Ref = null;

  @Props({ type: 'Catalog.Balance.Analytics', label: 'Аналитика баланса', hiddenInList: true,
  owner: [
    { dependsOn: 'ExpenseOrBalance', filterBy: 'parent' }]
  })
  BalanceAnalytics: Ref = null;

  @Props({ type: 'string', label: 'Бизнес-процесс №' })
  workflowID = '';

  @Props({
    type: 'table', required: false, order: 1,
    onChange: function (doc: PayRoll, value: PayRoll[]) {
      let Amount = 0; value.forEach(el => { Amount += el.Salary; });
      return { Amount: Math.round(Amount * 100) / 100 };
    }
  })
  PayRolls: PayRoll[] = [new PayRoll()];

}

export class PayRoll {

  @Props({ type: 'Catalog.Person', label: 'Сотрудник' })
  Employee: Ref = null;

  @Props({ type: 'number', label: 'К выплате', style: { width: '100px', textAlign: 'right' }, totals: 1 })
  Salary = 0;

  @Props({ type: 'number', label: 'Налог', style: { width: '100px', textAlign: 'right' }, totals: 1 })
  Tax = 0;

  @Props({
    type: 'Types.PersonOrCounterpartieBankAccount', label: 'Счет'
    , owner: [{ dependsOn: 'Employee', filterBy: 'owner' }]
    , required: true
  })
  BankAccount: Ref = null;

}
