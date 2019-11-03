import { Props, Ref } from '../../document';
import { JRegisterAccumulation, RegisterAccumulation } from './RegisterAccumulation';

@JRegisterAccumulation({
  type: 'Register.Accumulation.Depreciation',
  description: 'Амортизация'
})
export class RegisterAccumulationDepreciation extends RegisterAccumulation {

  @Props({ type: 'string', required: true, dimension: true })
  BusinessOperation = '';

  @Props({ type: 'Catalog.Currency', required: true, dimension: true })
  currency: Ref = null;

  @Props({ type: 'Catalog.Department', required: true, dimension: true })
  Department: Ref = null;

  @Props({ type: 'Catalog.ObjectsExploitation', required: true })
  OE: Ref = null;

  @Props({ type: 'number', resource: true })
  Amount = 0;

  @Props({ type: 'number', resource: true })
  AmountInBalance = 0;

  @Props({ type: 'number', resource: true })
  AmountInAccounting = 0;

  constructor (init: Partial<RegisterAccumulationDepreciation>) {
    super(init);
    Object.assign(this, init);
  }
}
