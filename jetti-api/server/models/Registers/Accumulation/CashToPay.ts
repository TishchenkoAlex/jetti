import { Props, Ref } from '../../document';
import { JRegisterAccumulation, RegisterAccumulation } from './RegisterAccumulation';

@JRegisterAccumulation({
  type: 'Register.Accumulation.CashToPay',
  description: 'Денежные средства к выплате'
})
export class RegisterAccumulationCashToPay extends RegisterAccumulation {

  @Props({ type: 'Catalog.Currency', required: true, dimension: true })
  currency: Ref = null;

  @Props({ type: 'Catalog.CashFlow', required: true, dimension: true })
  CashFlow: Ref = null;

  @Props({ type: 'Catalog.Contract', required: true, dimension: true })
  Contract: Ref = null;

  @Props({ type: 'Catalog.Department', dimension: true })
  Department: Ref = null;

  @Props({ type: 'string', required: true, dimension: true })
  OperationType = '';

  @Props({ type: 'Catalog.Loan', dimension: true })
  Loan: Ref = null;

  @Props({ type: 'Types.CashOrBank', dimension: true  })
  CashOrBank: Ref = null;

  @Props({ type: 'Types.CashRecipient', dimension: true  })
  CashRecipient: Ref = null;

  @Props({ type: 'Types.ExpenseOrBalance', dimension: true })
  ExpenseOrBalance: Ref = null;

  @Props({ type: 'Catalog.Expense.Analytics' })
  ExpenseAnalytics: Ref = null;

  @Props({ type: 'Catalog.Balance.Analytics' })
  BalanceAnalytics: Ref = null;

  @Props({ type: 'date' })
  PayDay = new Date();

  @Props({ type: 'number', resource: true })
  Amount = 0;

  constructor (init: Partial<RegisterAccumulationCashToPay>) {
    super(init);
    Object.assign(this, init);
  }
}
