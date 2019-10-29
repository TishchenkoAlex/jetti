import { Props, Ref } from '../../document';
import { JRegisterAccumulation, RegisterAccumulation } from './RegisterAccumulation';

@JRegisterAccumulation({
  type: 'Register.Accumulation.PL',
  description: 'Доходы/Расходы'
})
export class RegisterAccumulationPL extends RegisterAccumulation {
  @Props({ type: 'Catalog.Department' })
  Department: Ref = null;

  @Props({ type: 'Types.Catalog' })
  PL: Ref = null;

  @Props({ type: 'Types.Catalog' })
  Analytics: Ref = null;

  @Props({ type: 'number' })
  Amount = 0;

  constructor (init: Partial<RegisterAccumulationPL>) {
    super(init);
    Object.assign(this, init);
  }
}
