import { RegisterAccumulation, JRegisterAccumulation } from './RegisterAccumulation';
import { Ref, Props } from '../../document';

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

  constructor(kind: boolean, public data: {
    Department: Ref,
    Analytics: Ref,
    Amount: number,
    PL: Ref,
  }) {
    super(kind, data);
  }
}
