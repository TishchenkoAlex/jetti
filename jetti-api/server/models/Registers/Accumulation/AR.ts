import { Props, Ref } from '../../document';
import { JRegisterAccumulation, RegisterAccumulation } from './RegisterAccumulation';

@JRegisterAccumulation({
  type: 'Register.Accumulation.AR',
  description: 'Расчеты с клиентами'
})
export class RegisterAccumulationAR extends RegisterAccumulation {

  @Props({ type: 'Catalog.Currency', required: true, dimension: true })
  currency: Ref = null;

  @Props({ type: 'Catalog.Department' })
  Department: Ref = null;

  @Props({ type: 'Types.Document' })
  AO: Ref = null;

  @Props({ type: 'Catalog.Counterpartie', required: true , dimension: true})
  Customer: Ref = null;

  @Props({ type: 'datetime' })
  PayDay = new Date();

  @Props({ type: 'number' })
  AR = 0;

  @Props({ type: 'number', resource: true })
  AmountInBalance = 0;

  @Props({ type: 'number', resource: true })
  AmountInAccounting = 0;

  @Props({ type: 'number', resource: true })
  AmountToPay = 0;

  @Props({ type: 'number', resource: true })
  AmountIsPaid = 0;

  constructor (init: Partial<RegisterAccumulationAR>) {
    super(init);
    Object.assign(this, init);
  }
}
