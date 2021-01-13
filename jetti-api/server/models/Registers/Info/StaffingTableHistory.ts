import { Props, Ref } from '../../document';
import { JRegisterInfo, RegisterInfo } from './RegisterInfo';

@JRegisterInfo({
  type: 'Register.Info.StaffingTableHistory',
  description: 'История штатного расписания'
})
export class RegisterInfoStaffingTableHistory extends RegisterInfo {

  @Props({ type: 'Catalog.Department' })
  Department: Ref = null;

  @Props({ type: 'Catalog.Department.Company' })
  DepartmentCompany: Ref = null;

  @Props({ type: 'Catalog.StaffingTable' })
  StaffingPosition: Ref = null;

  @Props({ type: 'Catalog.Salary.Analytics' })
  SalaryAnalytic: Ref = null;

  @Props({ type: 'Catalog.Currency' })
  Currency: Ref = null;

  @Props({ type: 'enum', value: ['FIXED', 'PER_HOURS_RATE'] })
  AccrualType = null;

  @Props({ type: 'date' })
  ActivationDate = null;

  @Props({ type: 'date' })
  CloseDate = null;

  @Props({ type: 'number' })
  Qty = 0;

  @Props({ type: 'number' })
  Cost = 0;

  constructor(init: Partial<RegisterInfoStaffingTableHistory>) {
    super(init);
    Object.assign(this, init);
  }
}
