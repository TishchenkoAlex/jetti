import { Props } from '../../document';
import { JRegisterInfo, RegisterInfo } from './RegisterInfo';

@JRegisterInfo({
  type: 'Register.Info.TaxCheck',
  description: 'Чеки',
})
export class RegisterInfoTaxCheck extends RegisterInfo {

  @Props({ type: 'string' })
  clientInn = '';

  @Props({ type: 'string' })
  inn = '';

  @Props({ type: 'number' })
  totalAmount = 0;

  @Props({ type: 'string' })
  receiptId = '';

  @Props({ type: 'datetime' })
  operationTime = null;

  @Props({ type: 'datetime' })
  modifyDate = null;

  constructor(init: Partial<RegisterInfoTaxCheck>) {
    super(init);
    Object.assign(this, init);
  }
}
