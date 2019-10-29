import { Props, Ref } from '../../document';
import { JRegisterInfo, RegisterInfo } from './RegisterInfo';

@JRegisterInfo({
  type: 'Register.Info.PriceList',
  description: 'Price list',
})
export class RegisterInfoPriceList extends RegisterInfo {

  @Props({ type: 'Catalog.Currency', required: true })
  currency: Ref = null;

  @Props({ type: 'Catalog.Product', required: true })
  Product: Ref = null;

  @Props({ type: 'Catalog.PriceType', required: true })
  PriceType: Ref = null;

  @Props({ type: 'Catalog.Unit', required: true })
  Unit: Ref = null;

  @Props({ type: 'number', required: true })
  Price = 0;

  constructor(init: Partial<RegisterInfoPriceList>) {
    super(init);
    Object.assign(this, init);
  }
}

