import { Props, Ref } from '../../document';
import { JRegisterInfo, RegisterInfo } from './RegisterInfo';

@JRegisterInfo({
  type: 'Register.Info.BusinessCalendar',
  description: 'Business calendar',
})
export class RegisterInfoBusinessCalendar extends RegisterInfo {

  @Props({ type: 'Catalog.BusinessCalendar', required: true, dimension: true })
  BusinessCalendar: Ref = null;

  @Props({ type: 'enum', value: ['WORK', 'HOLIDAY', 'SATURDAY', 'SUNDAY'], required: true, dimension: true })
  DayType = '';

  @Props({ type: 'date', dimension: true })
  DayTransfer = '';

  @Props({ type: 'number', dimension: true })
  Year = '';

  constructor(init: Partial<RegisterInfoBusinessCalendar>) {
    super(init);
    Object.assign(this, init);
  }
}


