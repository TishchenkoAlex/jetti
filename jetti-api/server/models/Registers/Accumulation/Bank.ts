import { Props, Ref } from '../../document';
import { JRegisterAccumulation, RegisterAccumulation } from './RegisterAccumulation';

@JRegisterAccumulation({
  type: 'Register.Accumulation.Bank',
  description: 'Денежные средства безналичные'
})
export class RegisterAccumulationBank extends RegisterAccumulation {

  @Props({ type: 'Catalog.Currency', required: true, dimension: true, })
  currency: Ref = null;

  @Props({ type: 'Catalog.BankAccount', required: true, dimension: true })
  BankAccount: Ref = null;

  @Props({ type: 'Catalog.CashFlow', required: true, dimension: true })
  CashFlow: Ref = null;

  @Props({ type: 'Types.Catalog', dimension: true })
  Analytics: Ref = null;

  @Props({ type: 'number', resource: true })
  Amount = 0;

  @Props({ type: 'number', resource: true })
  AmountInBalance = 0;

  @Props({ type: 'number', resource: true })
  AmountInAccounting = 0;

  constructor (init: Partial<RegisterAccumulationBank>) {
    super(init);
    Object.assign(this, init);
  }
}
