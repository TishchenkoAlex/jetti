import { Props, Ref } from '../../document';
import { JRegisterInfo, RegisterInfo } from './RegisterInfo';

@JRegisterInfo({
  type: 'Register.Info.Modifier',
  description: 'Modifier',
})
export class RegisterInfoModifier extends RegisterInfo {

  @Props({ type: 'Catalog.Department', required: true })
  Department: Ref = null;

  @Props({ type: 'Catalog.Product', required: true })
  Product: Ref = null;

  @Props({ type: 'Catalog.Product', required: true })
  Modifier: Ref = null;

  @Props({ type: 'number', required: true })
  MaxQty = 0;

  constructor(init: Partial<RegisterInfoModifier>) {
    super(init);
    Object.assign(this, init);
  }
}


