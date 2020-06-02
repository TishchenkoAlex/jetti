import { Props, Ref } from '../../document';
import { JRegisterAccumulation, RegisterAccumulation } from './RegisterAccumulation';

@JRegisterAccumulation({
  type: 'Register.Accumulation.Salary',
  description: 'Расчеты с сотрудниками'
})
export class RegisterAccumulationSalary extends RegisterAccumulation {

  @Props({ type: 'Catalog.Currency', required: true, dimension: true })
  currency: Ref = null;

  @Props({ type: 'Catalog.Company', required: true, dimension: true })
  KorrCompany: Ref = null;

  @Props({ type: 'Catalog.Department' })
  Department: Ref = null;

  @Props({ type: 'Catalog.Person', required: true, dimension: true })
  Person: Ref = null;

  @Props({ type: 'Catalog.Person', required: true, dimension: true })
  Employee: Ref = null;

  @Props({ type: 'enum', resource: true, value: ['INCOME', 'EXPENSE', 'PAID'] })
  SalaryKind = 'INCOME';

  @Props({ type: 'Catalog.Salary.Analytics', required: true, dimension: true })
  Analytics: Ref = null;

  @Props({ type: 'Types.Catalog', required: false, dimension: true })
  PL: Ref = null;

  @Props({ type: 'Types.Catalog', required: false, dimension: true })
  PLAnalytics: Ref = null;

  @Props({ type: 'enum', value: ['APPROVED', 'PREPARED'], resource: true })
  Status = 'APPROVED';

  @Props({ type: 'boolean', resource: true })
  IsPortal = false;

  @Props({ type: 'number', resource: true })
  Amount = 0;

  @Props({ type: 'number', resource: true })
  AmountInBalance = 0;

  @Props({ type: 'number', resource: true })
  AmountInAccounting = 0;

  constructor(init: Partial<RegisterAccumulationSalary>) {
    super(init);
    Object.assign(this, init);
  }
}
