import { Props, Ref } from '../../document';
import { JRegisterAccumulation, RegisterAccumulation } from './RegisterAccumulation';

@JRegisterAccumulation({
  type: 'Register.Accumulation.Cash.Transit',
  description: 'Денежные средства в пути'
})
export class RegisterAccumulationCashTransit extends RegisterAccumulation {

  @Props({ type: 'Catalog.Company', required: true, dimension: true })
  CompanyRecipient: Ref = null;

  @Props({ type: 'Catalog.Currency', required: true, dimension: true })
  currency: Ref = null;

  @Props({ type: 'Types.Catalog', required: true, dimension: true })
  Sender: Ref = null;

  @Props({ type: 'Types.Catalog', required: true, dimension: true })
  Recipient: Ref = null;

  @Props({ type: 'Catalog.CashFlow', required: true, dimension: true })
  CashFlow: Ref = null;

  @Props({ type: 'number', resource: true })
  Amount = 0;

  @Props({ type: 'number', resource: true })
  AmountInBalance = 0;

  @Props({ type: 'number', resource: true })
  AmountInAccounting = 0;

  constructor (init: Partial<RegisterAccumulationCashTransit>) {
    super(init);
    Object.assign(this, init);
  }
}
