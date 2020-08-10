import { Props, Ref } from '../../document';
import { JRegisterInfo, RegisterInfo } from './RegisterInfo';

@JRegisterInfo({
  type: 'Register.Info.ProductModifier',
  description: 'Product modifier',
})
export class RegisterInfoProductModifier extends RegisterInfo {

  @Props({ type: 'Catalog.Department', required: true })
  Department: Ref = null;

  @Props({ type: 'Catalog.Product', required: true })
  Product: Ref = null;

  @Props({ type: 'Catalog.Product', required: true })
  Modifier: Ref = null;

  @Props({ type: 'number', required: true })
  Qty = 0;

  constructor(init: Partial<RegisterInfoProductModifier>) {
    super(init);
    Object.assign(this, init);
  }
}


