import { Props, Ref } from '../../document';
import { JRegisterInfo, RegisterInfo } from './RegisterInfo';

@JRegisterInfo({
  type: 'Register.Info.Settings',
  description: 'Settings',
})
export class RegisterInfoSettings extends RegisterInfo {

  @Props({ type: 'Catalog.Currency', required: true })
  balanceCurrency: Ref = null;

  @Props({ type: 'Catalog.Currency', required: true })
  accountingCurrency: Ref = null;

  constructor(init: Partial<RegisterInfoSettings>) {
    super(init);
    Object.assign(this, init);
  }
}

