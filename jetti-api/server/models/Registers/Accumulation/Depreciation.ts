import { Props, Ref } from '../../document';
import { JRegisterAccumulation, RegisterAccumulation } from './RegisterAccumulation';

@JRegisterAccumulation({
  type: 'Register.Accumulation.Depreciation',
  description: 'Амортизация'
})
export class RegisterAccumulationDepreciation extends RegisterAccumulation {

  @Props({ type: 'string', required: true })
  BusinessOperation = '';

  @Props({ type: 'Catalog.Currency', required: true })
  currency: Ref = null;

  @Props({ type: 'Catalog.Department' })
  Department: Ref = null;

  @Props({ type: 'Catalog.ObjectsExploitation' })
  OE: Ref = null;

  @Props({ type: 'number' })
  Amount = 0;

  @Props({ type: 'number' })
  AmountInBalance = 0;

  @Props({ type: 'number' })
  AmountInAccounting = 0;

  constructor (init: Partial<RegisterAccumulationDepreciation>) {
    super(init);
    Object.assign(this, init);
  }
}
