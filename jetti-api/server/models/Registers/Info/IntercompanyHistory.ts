import { Props, Ref } from '../../document';
import { JRegisterInfo, RegisterInfo } from './RegisterInfo';

@JRegisterInfo({
  type: 'Register.Info.IntercompanyHistory',
  description: 'История Интеркомпани',
})
export class RegisterInfoIntercompanyHistory extends RegisterInfo {

  @Props({ type: 'Catalog.Company' })
  Intercompany: Ref = null;

  constructor(init: Partial<RegisterInfoIntercompanyHistory>) {
    super(init);
    Object.assign(this, init);


  }
}
