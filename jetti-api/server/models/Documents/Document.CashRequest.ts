import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Document.CashRequest',
  description: 'Заявка на расходование ДС',
  dimensions: [
    { company: 'Catalog.Company' },
    { Operation: 'enum' },
    { Status: 'enum' },
    { Amount: 'number' },
  ],
  icon: 'far fa-file-alt',
  menu: 'Заявки на ДС',
  prefix: 'CR-',
  copyTo: [
    { type: 'Document.Operation', icon: '', label: 'Платежный документ', order: 1 }
  ],
  relations: [
    { name: 'Операции', type: 'Document.Operation', field: 'parent' },
  ],
  commands: [
    { method: 'FillTaxInfo', icon: 'pi pi-plus', label: 'Сформировать назначение платежа', order: 1 },
    { method: 'returnToStatusPrepared', icon: 'pi pi-plus', label: 'Установить статус "PREPARED"', order: 2 },
    { method: 'CloseCashRequest', icon: 'pi pi-plus', label: 'Закрыть заявку на расход ДС', order: 3 },
    { method: 'FillSalaryBalanceByDepartment', icon: 'pi pi-plus', label: '[ЗП] Заполнить остатками по подразделению', order: 4 },
    { method: 'FillSalaryBalanceByPersons', icon: 'pi pi-plus', label: '[ЗП] Заполнить остатками по сотрудникам', order: 5 },
    {
      method: 'FillSalaryBalanceByDepartmentWithCurrentMonth'
      , icon: 'pi pi-plus', label: '[ЗП] Заполнить остатками по подразделению (с текущим месяцем)', order: 4
    },
    {
      method: 'FillSalaryBalanceByPersonsWithCurrentMonth'
      , icon: 'pi pi-plus', label: '[ЗП] Заполнить остатками по сотрудникам (с текущим месяцем)', order: 5
    }
  ],
  module: `
      {
        const getFilter_CashRecipientBankAccount = () => {
            if (!this._value || !this._value.type) return Filter;
            Filter = [];
            Filter.push({ left: 'owner', center: '=', right: doc.CashRecipient.id });
            if (this._value.type === 'Catalog.Counterpartie.BankAccount')
                Filter.push({ left: 'currency', center: '=', right: doc.сurrency.id });
            return Filter;
        };
        return { getFilter_CashRecipientBankAccount };
    }`
})
export class DocumentCashRequest extends DocumentBase {

  @Props({ type: 'datetime', label: 'Дата', order: 1 })
  date = new Date();

  @Props({ type: 'string', label: 'Номер', required: true, order: 2, style: { width: '135px' } })
  code = '';

  @Props({ type: 'string', label: 'Комментарий', hiddenInList: true, order: -1, controlType: 'textarea' })
  info = '';

  @Props({ type: 'Types.Document', label: 'Основание', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Catalog.User', label: 'Автор', readOnly: true, hiddenInList: false, order: 991, style: { width: '200px' } })
  user: Ref = null;

  @Props({
    type: 'enum', required: true, readOnly: true, hiddenInList: false, style: { width: '100px' }, order: 7, label: 'Статус', value: [
      'PREPARED',
      'AWAITING',
      'MODIFY',
      'APPROVED',
      'REJECTED',
      'CLOSED',
    ]
  })
  Status = 'PREPARED';

  @Props({
    type: 'enum', required: true, order: 8, style: { width: '250px' }, label: 'Вид операции', value: [
      'Оплата поставщику',
      'Перечисление налогов и взносов',
      'Оплата ДС в другую организацию',
      'Выдача ДС подотчетнику',
      'Оплата по кредитам и займам полученным',
      'Прочий расход ДС',
      'Выдача займа контрагенту',
      'Возврат оплаты клиенту',
      'Выплата заработной платы',
      'Выплата заработной платы без ведомости',
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
    type: 'enum', style: { width: '140px' },
    label: 'Тип платежа',
    value: [
      'BANK',
      'CASH',
      'ANY',
    ]
  })
  CashKind = 'ANY';

  @Props({
    type: 'enum', required: false, hiddenInList: true, style: { width: '140px' },
    label: 'Способ выплаты',
    value: [
      'CASH',
      'SALARYPROJECT'
    ]
  })
  PayRollKind = 'SALARYPROJECT';

  @Props({ type: 'Catalog.Department', label: 'Подразделение' })
  Department: Ref = null;

  @Props({
    type: 'Types.CashRecipient',
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

  @Props({
    type: 'Catalog.Contract.Intercompany',
    hiddenInList: true,
    required: false,
    label: 'Договор',
    owner: [
      { dependsOn: 'CashRecipient', filterBy: 'KorrCompany' },
      { dependsOn: 'company', filterBy: 'company' },
      { dependsOn: 'currency', filterBy: 'currency' }]
  })
  ContractIntercompany: Ref = null;

  @Props({ type: 'Catalog.CashFlow', label: 'Статья ДДС', required: true })
  CashFlow: Ref = null;

  @Props({
    type: 'Catalog.SalaryProject', label: 'Зарплатный проект',
    owner: [
      { dependsOn: 'company', filterBy: 'company' },
      { dependsOn: 'currency', filterBy: 'currency' }]
  })
  SalaryProject: Ref = null;

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
    type: 'Types.PersonOrCounterpartieBankAccount',
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
  сurrency: Ref = 'A4867005-66B8-4A8A-9105-3F25BB081936'; // RUB

  @Props({ type: 'Types.ExpenseOrBalance', label: 'Аналитики расходов', hiddenInList: true })
  ExpenseOrBalance: Ref = null;

  @Props({ type: 'Catalog.Expense.Analytics', label: 'Аналитики расходов', hiddenInList: true })
  ExpenseAnalytics: Ref = null;

  @Props({
    type: 'Catalog.Salary.Analytics', label: 'Выплачено', hiddenInList: true,
    owner: [
      { dependsOn: 'tempSalaryKind', filterBy: 'SalaryKind' }
    ]
  })
  SalaryAnalitics: Ref = null;

  @Props({ type: 'Catalog.TaxRate', label: 'Ставка НДС', hiddenInList: true })
  TaxRate: Ref = null;

  @Props({ type: 'string', label: 'КПП', hiddenInList: true })
  TaxKPP = '';

  @Props({
    type: 'Catalog.TaxPaymentCode', label: 'КБК', hiddenInList: true,
    owner: [
      { dependsOn: 'tempCompanyParent', filterBy: 'company' }]
  })
  TaxPaymentCode: Ref = null;

  @Props({
    type: 'Catalog.TaxAssignmentCode', label: 'КНП', hiddenInList: true
  })
  TaxAssignmentCode: Ref = null;

  @Props({
    type: 'Catalog.TaxPayerStatus', label: 'Статус плательщика', hiddenInList: true,
    owner: [
      { dependsOn: 'tempCompanyParent', filterBy: 'company' }]
  })
  TaxPayerStatus: Ref = null;

  @Props({
    type: 'Catalog.TaxBasisPayment', label: 'Основание', hiddenInList: true,
    owner: [
      { dependsOn: 'tempCompanyParent', filterBy: 'company' }]
  })
  TaxBasisPayment: Ref = null;

  @Props({
    type: 'Catalog.TaxPaymentPeriod', label: 'Период', hiddenInList: true,
    owner: [
      { dependsOn: 'tempCompanyParent', filterBy: 'company' }]
  })
  TaxPaymentPeriod: Ref = null;

  @Props({ type: 'string', label: 'Номер документа' })
  TaxDocNumber = '';

  @Props({ type: 'date', label: 'Дата документа' })
  TaxDocDate = '';

  @Props({ type: 'string', label: 'ОКТМО', hiddenInList: true })
  TaxOfficeCode2 = '';

  @Props({
    type: 'Catalog.Balance.Analytics', label: 'Аналитика баланса', hiddenInList: true,
    owner: [
      { dependsOn: 'ExpenseOrBalance', filterBy: 'parent' }]
  })
  BalanceAnalytics: Ref = null;

  @Props({ type: 'string', label: 'Бизнес-процесс №' })
  workflowID = '';

  @Props({ type: 'boolean', label: 'Ручной ввод назначения платежа', hiddenInList: true })
  ManualInfo = false;

  @Props({ type: 'URL', hiddenInList: true, isAdditional: true })
  RelatedURL = '';

  @Props({ type: 'Catalog.Company', hiddenInList: true })
  tempCompanyParent: Ref = null;

  @Props({ type: 'string', hiddenInList: true })
  tempSalaryKind = 'PAID';

  @Props({
    type: 'table', required: false, order: 1,
    onChange: function (doc: PayRoll, value: PayRoll[]) {
      let Amount = 0; value.forEach(el => { Amount += el.Salary; });
      return { Amount: Math.round(Amount * 100) / 100 };
    }
  })
  PayRolls: PayRoll[] = [new PayRoll()];

  @Props({
    type: 'table', required: false, order: 1,
    onChange: function (doc: Item, value: Item[]) {
      let Amount = 0; value.forEach(el => { Amount += el.Amount; });
      return { Amount: Math.round(Amount * 100) / 100 };
    }
  })
  Items: Item[] = [new Item()];

}

export class PayRoll {

  @Props({ type: 'Catalog.Person', label: 'Сотрудник', style: { width: '350px' } })
  Employee: Ref = null;

  @Props({ type: 'number', label: 'К выплате', totals: 1 })
  Salary = 0;

  @Props({ type: 'number', label: 'Налог', totals: 1 })
  Tax = 0;

  @Props({
    type: 'Catalog.Person.BankAccount', label: 'Счет', style: { width: '350px' }
    , owner: [{ dependsOn: 'Employee', filterBy: 'owner' }]
  })
  BankAccount: Ref = null;

}

export class Item {

  @Props({ type: 'Catalog.Product', label: 'Товар/Услуга', style: { width: '350px' } })
  Item: Ref = null;

  @Props({ type: 'number', label: 'Сумма', totals: 1 })
  Amount = 0;

}

