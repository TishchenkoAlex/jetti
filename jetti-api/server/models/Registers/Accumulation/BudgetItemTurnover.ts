import { Props, Ref } from '../../document';
import { JRegisterAccumulation, RegisterAccumulation } from './RegisterAccumulation';

@JRegisterAccumulation({
  type: 'Register.Accumulation.BudgetItemTurnover',
  description: 'Обороты бюджетов'
})
export class RegisterAccumulationBudgetItemTurnover extends RegisterAccumulation {

  @Props({ type: 'Catalog.Department', dimension: true })
  Department: Ref = null;

  @Props({ type: 'Catalog.Scenario', dimension: true })
  Scenario: Ref = null;

  @Props({ type: 'Catalog.BudgetItem', dimension: true })
  BudgetItem: Ref = null;

  @Props({ type: 'Types.Catalog' })
  Anatitic1: Ref = null;

  @Props({ type: 'Types.Catalog', })
  Anatitic2: Ref = null;

  @Props({ type: 'Types.Catalog' })
  Anatitic3: Ref = null;

  @Props({ type: 'Types.Catalog' })
  Anatitic4: Ref = null;

  @Props({ type: 'Types.Catalog' })
  Anatitic5: Ref = null;

  @Props({ type: 'Catalog.Currency', required: true, dimension: true })
  currency: Ref = null;

  @Props({ type: 'number', resource: true })
  Amount = 0;

  @Props({ type: 'number', resource: true })
  AmountInScenatio = 0;

  @Props({ type: 'number', resource: true })
  AmountInCurrency = 0;

  @Props({ type: 'number', resource: true })
  AmountInAccounting = 0;

  @Props({ type: 'number', resource: true })
  Qty = 0;

  constructor (init: Partial<RegisterAccumulationBudgetItemTurnover>) {
    super(init);
    Object.assign(this, init);
  }
}
