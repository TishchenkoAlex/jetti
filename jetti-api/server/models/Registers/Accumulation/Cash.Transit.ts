import { RegisterAccumulation, JRegisterAccumulation } from './RegisterAccumulation';
import { Ref, Props } from '../../document';

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

  constructor(kind: boolean, public data: {
    currency: Ref,
    Sender: Ref,
    Recipient: Ref,
    CashFlow: Ref,
    Amount: number,
    AmountInBalance: number,
    AmountInAccounting: number,
  }) {
    super(kind, data);
  }
}
