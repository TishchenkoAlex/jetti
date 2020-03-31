import { Props, Ref } from '../../document';
import { JRegisterInfo, RegisterInfo } from './RegisterInfo';

@JRegisterInfo({
  type: 'Register.Info.MainSpecification',
  description: 'Основные спецификации',
})
export class RegisterInfoMainSpecification extends RegisterInfo {

  @Props({ type: 'Catalog.Department' })
  Department: Ref = null;

  @Props({ type: 'Catalog.Product' })
  SKU: Ref = null;

  @Props({ type: 'Catalog.ResourceSpecification' })
  ResourceSpecification: Ref = null;

  @Props({ type: 'boolean' })
  Active = '';

  constructor(init: Partial<RegisterInfoMainSpecification>) {
    super(init);
    Object.assign(this, init);
  }
}
