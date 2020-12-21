import { Props, Ref } from '../../document';
import { JRegisterInfo, RegisterInfo } from './RegisterInfo';

@JRegisterInfo({
  type: 'Register.Info.EmploymentType',
  description: 'Виды занятости сотрудников'
})
export class RegisterInfoEmploymentType extends RegisterInfo {

  @Props({ type: 'enum', value: ['MAIN', 'INTERNAL', 'EXTERNAL'] })
  EmploymentType: Ref = null;

  @Props({ type: 'Catalog.Employee' })
  Employee: Ref = null;

  @Props({ type: 'Catalog.Person' })
  Person: Ref = null;

  @Props({ type: 'Catalog.Department' })
  Department: Ref = null;

  @Props({ type: 'Catalog.Department.Company' })
  DepartmentCompany: Ref = null;

  @Props({ type: 'Catalog.JobTitle' })
  JobTitle: Ref = null;

  @Props({ type: 'Catalog.StaffingTable' })
  StaffingPosition: Ref = null;

  @Props({ type: 'number' })
  SalaryRate = 0;

  constructor(init: Partial<RegisterInfoEmploymentType>) {
    super(init);
    Object.assign(this, init);
  }
}
