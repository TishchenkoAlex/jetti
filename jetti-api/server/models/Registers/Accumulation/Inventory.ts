import { Props, Ref } from '../../document';
import { JRegisterAccumulation, RegisterAccumulation } from './RegisterAccumulation';

@JRegisterAccumulation({
  type: 'Register.Accumulation.Inventory',
  description: 'Товары на складах'
})
export class RegisterAccumulationInventory extends RegisterAccumulation {

  @Props({ type: 'Catalog.Operation.Type' })
  OperationType: Ref = null;

  @Props({ type: 'Catalog.Expense' })
  Expense: Ref = null;
  @Props({ type: 'Catalog.Expense.Analytics' })
  ExpenseAnalytics: Ref = null;

  @Props({ type: 'Catalog.Income' })
  Income: Ref = null;
  @Props({ type: 'Catalog.Income' })
  IncomeAnalytics: Ref = null;

  @Props({ type: 'Catalog.Balance' })
  BalanceIn: Ref = null;
  @Props({ type: 'Catalog.Balance.Analytics'})
  BalanceInAnalytics: Ref = null;

  @Props({ type: 'Catalog.Balance' })
  BalanceOut: Ref = null;
  @Props({ type: 'Catalog.Balance.Analytics' })
  BalanceOutAnalytics: Ref = null;

  @Props({ type: 'Catalog.Storehouse', required: true, dimension: true})
  Storehouse: Ref = null;

  @Props({ type: 'Catalog.Product', required: true, dimension: true})
  SKU: Ref = null;

  @Props({ type: 'Types.Document', required: true, dimension: true})
  batch: Ref = null;

  @Props({ type: 'number', resource: true })
  Cost = 0;

  @Props({ type: 'number', resource: true })
  Qty = 0;

  constructor (init: Partial<RegisterAccumulationInventory>) {
    super(init);
    Object.assign(this, init);
  }
}
