import { Props, Ref } from '../../document';
import { JRegisterAccumulation, RegisterAccumulation } from './RegisterAccumulation';

@JRegisterAccumulation({
  type: 'Register.Accumulation.Balance.RC',
  description: 'Активы/Пассивы по ЦФО'
})
export class RegisterAccumulationBalanceRC extends RegisterAccumulation {

  @Props({ type: 'Catalog.ResponsibilityCenter', dimension: true })
  ResponsibilityCenter: Ref = null;

  @Props({ type: 'Catalog.Department', dimension: true })
  Department: Ref = null;

  @Props({ type: 'Catalog.Balance', dimension: true })
  Balance: Ref = null;

  @Props({ type: 'Types.Catalog', dimension: true })
  Analytics: Ref = null;

  @Props({ type: 'Types.Catalog', dimension: true })
  Analytics2: Ref = null;

  @Props({ type: 'Catalog.Currency', dimension: true })
  Currency: Ref = null;

  @Props({ type: 'number', resource: true })
  Amount = 0;

  @Props({ type: 'number', resource: true })
  AmountRC = 0;

  @Props({ type: 'string' })
  Info = '';

  constructor (init: Partial<RegisterAccumulationBalanceRC>) {
    super(init);
    Object.assign(this, init);
  }
}
