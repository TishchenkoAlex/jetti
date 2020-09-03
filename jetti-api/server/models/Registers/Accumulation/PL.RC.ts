import { Props, Ref } from '../../document';
import { JRegisterAccumulation, RegisterAccumulation } from './RegisterAccumulation';

@JRegisterAccumulation({
  type: 'Register.Accumulation.PL.RC',
  description: 'Доходы/Расходы'
})
export class RegisterAccumulationPLRC extends RegisterAccumulation {

  @Props({ type: 'Catalog.ResponsibilityCenter', dimension: true })
  ResponsibilityCenter: Ref = null;

  @Props({ type: 'Catalog.Department', required: true, dimension: true })
  Department: Ref = null;

  @Props({ type: 'Types.Catalog', required: true, dimension: true })
  PL: Ref = null;

  @Props({ type: 'Types.Catalog', required: true, dimension: true })
  Analytics: Ref = null;

  @Props({ type: 'Types.Catalog', required: true, dimension: true })
  Analytics2: Ref = null;

  @Props({ type: 'Catalog.Currency', dimension: true })
  Currency: Ref = null;

  @Props({ type: 'number', resource: true })
  Amount = 0;

  @Props({ type: 'number', resource: true })
  AmountRC = 0;

  @Props({ type: 'string' })
  Info = '';

  constructor(init: Partial<RegisterAccumulationPLRC>) {
    super(init);
    Object.assign(this, init);
  }
}
