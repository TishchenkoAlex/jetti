import { Props, Ref } from '../../document';
import { JRegisterInfo, RegisterInfo } from './RegisterInfo';

@JRegisterInfo({
  type: 'Register.Info.DepartmentCompanyHistory',
  description: 'История изменения организации в подразделении',
})
export class DepartmentCompanyHistory extends RegisterInfo {

  @Props({ type: 'Catalog.Department', required: true, unique: true, order: 1 })
  Department: Ref = null;

  @Props({ type: 'Catalog.Company', required: true, unique: true, order: 2 })
  company: Ref = null;

  constructor(init: Partial<DepartmentCompanyHistory>) {
    super(init);
    Object.assign(this, init);
  }
}
