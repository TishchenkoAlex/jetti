import { Props, Ref } from '../../document';
import { JRegisterAccumulation, RegisterAccumulation } from './RegisterAccumulation';

@JRegisterAccumulation({
  type: 'Register.Accumulation.OrderPayment',
  description: 'Оплата заказов'
})
export class RegisterAccumulationOrderPayment extends RegisterAccumulation {

  @Props({ type: 'string', dimension: true })
  PaymantKind = '';

  @Props({ type: 'Catalog.Counterpartie', dimension: true })
  Customer: Ref = null;

  @Props({ type: 'Catalog.BankAccount', dimension: true })
  BankAccount: Ref = null;

  @Props({ type: 'Catalog.CashRegister', dimension: true })
  CashRegister: Ref = null;

  @Props({ type: 'Catalog.AcquiringTerminal', dimension: true })
  AcquiringTerminal: Ref = null;

  @Props({ type: 'Catalog.Currency', dimension: true })
  currency: Ref = null;

  @Props({ type: 'number' })
  CashShift = 0;

  @Props({ type: 'number', resource: true })
  Amount = 0;

  @Props({ type: 'number', resource: true })
  AmountInBalance = 0;

  @Props({ type: 'number', resource: true })
  AmountInAccounting = 0;

  constructor(init: Partial<RegisterAccumulationOrderPayment>) {
    super(init);
    Object.assign(this, init);
  }
}
