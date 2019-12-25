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
  menu: 'Заявка на ДС',
  prefix: 'CR-',
  copyTo: [
    'Document.PriceList'
  ],
  relations: [
    { name: 'Operations', type: 'Document.Operation', field: 'parent' }
  ]
})
export class DocumentCashRequest extends DocumentBase {

  @Props({ type: 'Types.Document', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Catalog.User', hiddenInList: false, order: -1 })
  user: Ref = null;

  @Props({
    type: 'enum', required: true, value: [
      'PREPARED',
      'AWAITING',
      'APPROVED',
      'REJECTED',
    ]
  })
  Status = 'PREPARED';

  @Props({
    type: 'enum', required: true, value: [
      'Оплата поставщику',
      'Перечисление налогов и взносов',
      'Оплата ДС в другую организацию',
      'Выдача ДС подотчетнику',
      'Оплата по кредитам и займам полученным',
      'Выплата по ведомости',
      'Прочий расход ДС',
      'Выдача займа контрагенту',
      'Возврат оплаты клиенту'
      ]
  })
  Operation = 'Оплата поставщику';

  @Props({ type: 'Catalog.Department' })
  Department: Ref = null;

  @Props({ type: 'Types.CashRecipient', required: true })
  CashRecipient: Ref = null;

  @Props({ type: 'Catalog.Contract', owner: [{ dependsOn: 'CashRecipient', filterBy: 'owner' }] })
  Contract: Ref = null;

  @Props({ type: 'Catalog.CashFlow', required: true })
  CashFlow: Ref = null;

  @Props({ type: 'Catalog.Loan'})
  Loan: Ref = null;

  @Props({ type: 'Types.CashOrBank',
  owner: [
      { dependsOn: 'company', filterBy: 'company' },
      { dependsOn: 'сurrency', filterBy: 'currency' }
  ]
})
  CashOrBank: Ref = null;

  @Props({ type: 'date' })
  PayDay = new Date();

  @Props({ type: 'number', required: true })
  Amount = 0;

  @Props({ type: 'Catalog.Currency', required: true })
  сurrency: Ref = null;

  @Props({ type: 'Types.ExpenseOrBalance'})
  ExpenseOrBalance: Ref = null;

  @Props({ type: 'Catalog.Expense.Analytics' })
  ExpenseAnalytics: Ref = null;

  @Props({ type: 'Catalog.Balance.Analytics' })
  BalanceAnalytics: Ref = null;

  @Props({ type: 'string' })
  workflowID = '';
}
