import { Props, Ref } from '../../document';
import { JRegisterInfo, RegisterInfo } from './RegisterInfo';

@JRegisterInfo({
  type: 'Register.Info.ExchangeRates.Source',
  description: 'Exchange rates (from sources)',
})
export class RegisterInfoExchangeRatesSource extends RegisterInfo {

  @Props({ type: 'string' })
  Source = '';

  @Props({ type: 'Catalog.Counterpartie' })
  Counterpartie: Ref = null;

  @Props({ type: 'Catalog.Currency' })
  CurrencySource: Ref = null;

  @Props({ type: 'Catalog.Currency', required: true })
  currency: Ref = null;

  @Props({ type: 'number', required: true })
  Rate = 1;

  @Props({ type: 'number' })
  Mutiplicity = 1;

  constructor(init: Partial<RegisterInfoExchangeRatesSource>) {
    super(init);
    Object.assign(this, init);
  }
}
