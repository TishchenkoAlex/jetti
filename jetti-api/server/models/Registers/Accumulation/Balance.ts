import { Props, Ref } from '../../document';
import { JRegisterAccumulation, RegisterAccumulation } from './RegisterAccumulation';

@JRegisterAccumulation({
  type: 'Register.Accumulation.Balance',
  description: 'Активы/Пассивы'
})
export class RegisterAccumulationBalance extends RegisterAccumulation {
  @Props({ type: 'Catalog.Department' })
  Department: Ref = null;

  @Props({ type: 'Catalog.Balance' })
  Balance: Ref = null;

  @Props({ type: 'Types.Catalog' })
  Analytics: Ref = null;

  @Props({ type: 'number' })
  Amount = 0;

  constructor(kind: boolean, public data: {
    Department: Ref,
    Balance: Ref,
    Analytics: Ref,
    Amount: number,
  }) {
    super(kind, data);
  }
}
