import { Props, Ref } from '../../document';
import { JRegisterInfo, RegisterInfo } from './RegisterInfo';

@JRegisterInfo({
  type: 'Register.Info.ExchangeRates.National',
  description: 'Exchange rates national',
})
export class RegisterInfoExchangeRatesNational extends RegisterInfo {

  @Props({ type: 'Catalog.Country' })
  Country: Ref = null;

  @Props({ type: 'Catalog.Currency', required: true })
  Currency1: Ref = null;

  @Props({ type: 'Catalog.Currency', required: true })
  Currency2: Ref = null;

  @Props({ type: 'number', required: true })
  Rate = 1;

  @Props({ type: 'number' })
  Mutiplicity = 1;

  constructor(init: Partial<RegisterInfoExchangeRatesNational>) {
    super(init);
    Object.assign(this, init);
  }
}
