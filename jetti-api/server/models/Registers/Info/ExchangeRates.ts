import { Props, Ref } from '../../document';
import { JRegisterInfo, RegisterInfo } from './RegisterInfo';

@JRegisterInfo({
  type: 'Register.Info.ExchangeRates',
  description: 'Exchange rates',
})
export class RegisterInfoExchangeRates extends RegisterInfo {

  @Props({ type: 'Catalog.Currency', required: true })
  currency: Ref = null;

  @Props({ type: 'number', required: true })
  Rate = 1;

  @Props({ type: 'number' })
  Mutiplicity = 1;

  constructor(public data: {
    currency: Ref,
    Rate: number,
    Mutiplicity: number
  }) {
    super(data);
  }
}
