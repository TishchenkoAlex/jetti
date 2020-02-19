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

  @Props({ type: 'enum', value: ['Own organization', 'Classic franchise', 'Management franchise' ], order: 3 })
  TypeFranchise = 'Own organization';

  constructor(init: Partial<DepartmentCompanyHistory>) {
    super(init);
    Object.assign(this, init);


  }
}
