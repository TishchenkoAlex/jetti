import { Props, Ref } from '../../document';
import { JRegisterAccumulation, RegisterAccumulation } from './RegisterAccumulation';

@JRegisterAccumulation({
  type: 'Register.Accumulation.AP',
  description: 'Расчеты с поставщиками'
})
export class RegisterAccumulationAP extends RegisterAccumulation {

  @Props({ type: 'Catalog.Currency', required: true, dimension: true })
  currency: Ref = null;

  @Props({ type: 'Catalog.Department' })
  Department: Ref = null;

  @Props({ type: 'Types.Document', dimension: true })
  AO: Ref = null;

  @Props({ type: 'Catalog.Counterpartie', required: true, dimension: true })
  Supplier: Ref = null;

  @Props({ type: 'date' })
  PayDay = new Date();

  @Props({ type: 'number', resource: true })
  Amount = 0;

  @Props({ type: 'number', resource: true })
  AmountInBalance = 0;

  @Props({ type: 'number', resource: true })
  AmountInAccounting = 0;

  @Props({ type: 'number', resource: true })
  AmountToPay = 0;

  @Props({ type: 'number', resource: true })
  AmountIsPaid = 0;

  constructor(init: Partial<RegisterAccumulationAP>) {
    super(init);
    Object.assign(this, init);
  }
}
