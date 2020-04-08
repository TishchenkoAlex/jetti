import { Props, Ref } from '../../document';
import { JRegisterInfo, RegisterInfo } from './RegisterInfo';

@JRegisterInfo({
  type: 'Register.Info.RoyaltySales',
  description: 'Процент роялти от продаж',
})
export class RegisterInfoRoyaltySales extends RegisterInfo {

  @Props({ type: 'Catalog.Department' })
  Department: Ref = null;

  @Props({ type: 'number' })
  AmountMin = 0;

  @Props({ type: 'number' })
  AmountMax = 0;

  @Props({ type: 'number' })
  Royalty = null;

  constructor(init: Partial<RegisterInfoRoyaltySales>) {
    super(init);
    Object.assign(this, init);

  }
}
