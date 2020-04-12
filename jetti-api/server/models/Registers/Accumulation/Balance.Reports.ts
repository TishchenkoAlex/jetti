import { Props, Ref } from '../../document';
import { JRegisterAccumulation, RegisterAccumulation } from './RegisterAccumulation';

@JRegisterAccumulation({
  type: 'Register.Accumulation.Balance.Report',
  description: 'Активы/Пассивы (аналитика)'
})
export class RegisterAccumulationBalanceReport extends RegisterAccumulation {
  @Props({ type: 'Catalog.Currency', required: true, dimension: true })
  currency: Ref = null;

  @Props({ type: 'Catalog.Department' })
  Department: Ref = null;

  @Props({ type: 'Catalog.Balance', dimension: true })
  Balance: Ref = null;

  @Props({ type: 'Types.Catalog', dimension: true })
  Analytics: Ref = null;

  @Props({ type: 'number', resource: true })
  Amount = 0;

  @Props({ type: 'number', resource: true })
  AmountInBalance = 0;

  @Props({ type: 'number', resource: true })
  AmountInAccounting = 0;

  @Props({ type: 'string' })
  Info = '';

  constructor (init: Partial<RegisterAccumulationBalanceReport>) {
    super(init);
    Object.assign(this, init);
  }
}
