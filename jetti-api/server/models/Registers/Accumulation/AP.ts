import { Props, Ref } from '../../document';
import { JRegisterAccumulation, RegisterAccumulation } from './RegisterAccumulation';

@JRegisterAccumulation({
  type: 'Register.Accumulation.AP',
  description: 'Расчеты с поставщиками'
})
export class RegisterAccumulationAP extends RegisterAccumulation {

  @Props({ type: 'Catalog.Currency', required: true })
  currency: Ref = null;

  @Props({ type: 'Catalog.Department' })
  Department: Ref = null;

  @Props({ type: 'Types.Document' })
  AO: Ref = null;

  @Props({ type: 'Catalog.Counterpartie', required: true })
  Supplier: Ref = null;

  @Props({ type: 'datetime' })
  PayDay = new Date();

  @Props({ type: 'number' })
  Amount = 0;

  @Props({ type: 'number' })
  AmountInBalance = 0;

  @Props({ type: 'number' })
  AmountInAccounting = 0;

  constructor(kind: boolean, public data: {
    currency: Ref,
    Department: Ref,
    Supplier: Ref,
    AO: Ref,
    PayDay: Date,
    Amount: number,
    AmountInBalance: number,
    AmountInAccounting: number,
  }) {
    super(kind, data);
  }
}
