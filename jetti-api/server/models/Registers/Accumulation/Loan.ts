import { Props, Ref } from '../../document';
import { JRegisterAccumulation, RegisterAccumulation } from './RegisterAccumulation';

@JRegisterAccumulation({
  type: 'Register.Accumulation.Loan',
  description: 'Расчеты по кредитам и депозитам'
})
export class RegisterAccumulationLoan extends RegisterAccumulation {

  @Props({ type: 'Catalog.Loan' })
  Loan: Ref = null;

  @Props({ type: 'Catalog.Counterpartie' })
  Counterpartie: Ref = null;

  @Props({ type: 'Catalog.CashFlow' })
  CashFlow: Ref = null;

  @Props({ type: 'number' })
  Amount = 0;

  @Props({ type: 'number' })
  AmountInBalance = 0;

  @Props({ type: 'number' })
  AmountInAccounting = 0;

  constructor(kind: boolean, public data: {
    Loan: Ref,
    Counterpartie: Ref,
    CashFlow: Ref,
    Amount: number,
    AmountInBalance: number,
    AmountInAccounting: number,
  }) {
    super(kind, data);
  }
}
