import { Props, Ref } from '../../document';
import { JRegisterAccumulation, RegisterAccumulation } from './RegisterAccumulation';

@JRegisterAccumulation({
  type: 'Register.Accumulation.AccountablePersons',
  description: 'Расчеты с подотчетными'
})
export class RegisterAccumulationAccountablePersons extends RegisterAccumulation {

  @Props({ type: 'Catalog.Currency', required: true, dimension: true })
  currency: Ref = null;

  @Props({ type: 'Catalog.Person', required: true, dimension: true })
  Employee: Ref = null;

  @Props({ type: 'Catalog.CashFlow', required: true, dimension: true })
  CashFlow: Ref = null;

  @Props({ type: 'number', resource: true })
  Amount = 0;

  @Props({ type: 'number', resource: true })
  AmountInBalance = 0;

  @Props({ type: 'number', resource: true })
  AmountInAccounting = 0;

  constructor (init: Partial<RegisterAccumulationAccountablePersons>) {
    super(init);
    Object.assign(this, init);
  }
}
