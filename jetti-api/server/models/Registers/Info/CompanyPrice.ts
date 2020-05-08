import { Props, Ref } from '../../document';
import { JRegisterInfo, RegisterInfo } from './RegisterInfo';

@JRegisterInfo({
  type: 'Register.Info.CompanyPrice',
  description: 'Стоимость организаций',
})
export class RegisterInfoCompanyPrice extends RegisterInfo {

  @Props({ type: 'Catalog.Currency' })
  currency: Ref = null;

  @Props({ type: 'number', label: 'Стоимость организации' })
  CompanyPrice = '';

  constructor(init: Partial<RegisterInfoCompanyPrice>) {
    super(init);
    Object.assign(this, init);
  }
}
