import { Props, Ref } from '../../document';
import { JRegisterInfo, RegisterInfo } from './RegisterInfo';

@JRegisterInfo({
  type: 'Register.Info.RLS.Period',
  description: 'Row level security (period)',
})
export class RegisterInfoRLSPeriod extends RegisterInfo {

  @Props({ type: 'string', required: true, unique: true, order: 1 })
  user = '';

  @Props({ type: 'Catalog.Company', required: true, unique: true, order: 2 })
  company: Ref = null;

  constructor(init: Partial<RegisterInfoRLSPeriod>) {
    super(init);
    Object.assign(this, init);
  }
}
