import { Props, Ref } from '../../document';
import { JRegisterInfo, RegisterInfo } from './RegisterInfo';

@JRegisterInfo({
  type: 'Register.Info.PriceList',
  description: 'Price list',
})
export class RegisterInfoPriceList extends RegisterInfo {

  @Props({ type: 'Catalog.Department', required: true })
  Department: Ref = null;

  @Props({ type: 'Catalog.Storehouse', required: true })
  Storehouse: Ref = null;

  @Props({ type: 'Catalog.Product', required: true })
  Product: Ref = null;

  @Props({ type: 'enum', value: ['CONSTANT', 'ADDITIONAL', 'TRIAL'] })
  Role = 'CONSTANT';

  @Props({ type: 'Catalog.Unit', required: true })
  Unit: Ref = null;

  @Props({ type: 'Catalog.Currency', required: true })
  currency: Ref = null;

  @Props({ type: 'Catalog.PriceType' })
  PriceType: Ref = null;

  @Props({ type: 'number', required: true })
  Price = 0;

  @Props({ type: 'boolean' })
  forSales = false;

  @Props({ type: 'boolean' })
  forPurchases = false;

  @Props({ type: 'boolean' })
  isActive = false;

  constructor(init: Partial<RegisterInfoPriceList>) {
    super(init);
    Object.assign(this, init);
  }
}

