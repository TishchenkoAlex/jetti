import { Props, Ref } from '../../document';
import { JRegisterAccumulation, RegisterAccumulation } from './RegisterAccumulation';

@JRegisterAccumulation({
  type: 'Register.Accumulation.PL',
  description: 'Доходы/Расходы'
})
export class RegisterAccumulationPL extends RegisterAccumulation {
  @Props({ type: 'Catalog.Department', required: true, dimension: true })
  Department: Ref = null;

  @Props({ type: 'Types.Catalog', required: true, dimension: true })
  PL: Ref = null;

  @Props({ type: 'Types.Catalog', required: true, dimension: true })
  Analytics: Ref = null;

  @Props({ type: 'number', resource: true })
  Amount = 0;

  constructor (init: Partial<RegisterAccumulationPL>) {
    super(init);
    Object.assign(this, init);
  }
}
