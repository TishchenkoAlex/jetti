import { Props, Ref } from '../../document';
import { JRegisterInfo, RegisterInfo } from './RegisterInfo';

@JRegisterInfo({
  type: 'Register.Info.ProductSpecificationByDepartment',
  description: 'Основные спецификации',
})
export class RegisterInfoProductSpecificationByDepartment extends RegisterInfo {

  @Props({ type: 'Catalog.Department' })
  Department: Ref = null;

  @Props({ type: 'Catalog.Storehouse', required: true })
  Storehouse: Ref = null;

  @Props({ type: 'Catalog.Product' })
  Product: Ref = null;

  @Props({ type: 'Catalog.Specification' })
  Specification: Ref = null;

  @Props({ type: 'boolean' })
  isActive = false;

  constructor(init: Partial<RegisterInfoProductSpecificationByDepartment>) {
    super(init);
    Object.assign(this, init);
  }
}
