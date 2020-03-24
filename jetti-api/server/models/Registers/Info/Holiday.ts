import { Props, Ref } from '../../document';
import { JRegisterInfo, RegisterInfo } from './RegisterInfo';

@JRegisterInfo({
  type: 'Register.Info.Holiday',
  description: 'Праздничные дни',
})
export class RegisterInfoHoliday extends RegisterInfo {

  @Props({ type: 'Catalog.Country', required: true })
  Country: Ref = null;

  @Props({ type: 'string' })
  Info = '';

  constructor(init: Partial<RegisterInfoHoliday>) {
    super(init);
    Object.assign(this, init);
  }
}
