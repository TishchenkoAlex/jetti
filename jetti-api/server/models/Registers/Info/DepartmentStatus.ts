import { Props, Ref } from '../../document';
import { JRegisterInfo, RegisterInfo } from './RegisterInfo';

@JRegisterInfo({
  type: 'Register.Info.DepartmentStatus',
  description: 'Статус подразделения',
})
export class RegisterInfoDepartmentStatus extends RegisterInfo {

  @Props({ type: 'Catalog.Department' })
  Department: Ref = null;

  @Props({ type: 'date' })
  BeginDate = null;

  @Props({ type: 'date' })
  EndDate = null;

  @Props({ type: 'string' })
  Info = '';

  @Props({ type: 'Catalog.Department.StatusReason' })
  StatusReason: Ref = null;

  constructor(init: Partial<RegisterInfoDepartmentStatus>) {
    super(init);
    Object.assign(this, init);


  }
}
