import { Props, Ref } from '../../document';
import { JRegisterAccumulation, RegisterAccumulation } from './RegisterAccumulation';

@JRegisterAccumulation({
  type: 'Register.Accumulation.EmployeeTimekeeping',
  description: 'Данные табельного учета рабочего времени сотрудника'
})
export class RegisterAccumulationEmployeeTimekeeping extends RegisterAccumulation {

  @Props({ type: 'boolean', required: true, dimension: true })
  isActive = false;

  @Props({ type: 'date', required: true, dimension: true })
  PeriodMonth = new Date();

  @Props({ type: 'enum', value: ['WORKING', 'HOLIDAY'], required: true, dimension: true })
  KindTimekeeping = null;

  @Props({ type: 'Catalog.Employee', dimension: true })
  Employee: Ref = null;

  @Props({ type: 'Catalog.Person', dimension: true })
  Person: Ref = null;

  @Props({ type: 'Catalog.StaffingTable', dimension: true })
  StaffingTable: Ref = null;

  @Props({ type: 'number', resource: true })
  Days = 0;

  @Props({ type: 'number', resource: true })
  Hours = 0;

  constructor(init: Partial<RegisterAccumulationEmployeeTimekeeping>) {
    super(init);
    Object.assign(this, init);
  }
}
