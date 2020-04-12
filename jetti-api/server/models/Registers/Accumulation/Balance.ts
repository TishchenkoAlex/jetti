import { Props, Ref } from '../../document';
import { JRegisterAccumulation, RegisterAccumulation } from './RegisterAccumulation';

@JRegisterAccumulation({
  type: 'Register.Accumulation.Balance',
  description: 'Активы/Пассивы'
})
export class RegisterAccumulationBalance extends RegisterAccumulation {
  @Props({ type: 'Catalog.Department' })
  Department: Ref = null;

  @Props({ type: 'Catalog.Balance', dimension: true })
  Balance: Ref = null;

  @Props({ type: 'Types.Catalog', dimension: true })
  Analytics: Ref = null;

  @Props({ type: 'number', resource: true })
  Amount = 0;

  @Props({ type: 'string' })
  Info = '';

  constructor (init: Partial<RegisterAccumulationBalance>) {
    super(init);
    Object.assign(this, init);
  }
}
