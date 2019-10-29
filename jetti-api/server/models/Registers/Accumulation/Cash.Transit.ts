import { Props, Ref } from '../../document';
import { JRegisterAccumulation, RegisterAccumulation } from './RegisterAccumulation';

@JRegisterAccumulation({
  type: 'Register.Accumulation.Cash.Transit',
  description: 'Денежные средства в пути'
})
export class RegisterAccumulationCashTransit extends RegisterAccumulation {

  @Props({ type: 'Catalog.Currency' })
  currency: Ref = null;

  @Props({ type: 'Types.Catalog' })
  Sender: Ref = null;

  @Props({ type: 'Types.Catalog' })
  Recipient: Ref = null;

  @Props({ type: 'Catalog.CashFlow' })
  CashFlow: Ref = null;

  @Props({ type: 'number' })
  Amount = 0;

  @Props({ type: 'number' })
  AmountInBalance = 0;

  @Props({ type: 'number' })
  AmountInAccounting = 0;

  constructor (init: Partial<RegisterAccumulationCashTransit>) {
    super(init);
    Object.assign(this, init);
  }
}
