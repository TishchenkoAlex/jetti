import { Props, Ref } from '../../document';
import { JRegisterInfo, RegisterInfo } from './RegisterInfo';

@JRegisterInfo({
  type: 'Register.Info.BusinessCalendar.Months',
  description: 'Business calendar (months)',
})
export class RegisterInfoBusinessCalendarMonths extends RegisterInfo {

  @Props({ type: 'Catalog.BusinessCalendar', required: true, dimension: true })
  BusinessCalendar: Ref = null;

  @Props({ type: 'number', required: true, resource: true })
  TotalDay = '';

  @Props({ type: 'number', required: true, resource: true })
  WorkDay = '';

  @Props({ type: 'number', resource: true })
  WorkHours40 = '';

  @Props({ type: 'number', resource: true })
  WorkHours36 = '';

  @Props({ type: 'number', resource: true })
  WorkHours24 = '';

  constructor(init: Partial<RegisterInfoBusinessCalendarMonths>) {
    super(init);
    Object.assign(this, init);
  }
}


