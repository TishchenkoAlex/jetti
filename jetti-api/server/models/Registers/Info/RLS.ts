import { Props, Ref } from '../../document';
import { JRegisterInfo, RegisterInfo } from './RegisterInfo';

@JRegisterInfo({
  type: 'Register.Info.RLS',
  description: 'Row level security',
})
export class RegisterInfoRLS extends RegisterInfo {

  @Props({ type: 'string', required: true, unique: true, order: 1 })
  user: string | null = null;

  @Props({ type: 'Catalog.Company', required: true, unique: true, order: 2 })
  company: Ref = null;

  constructor(public data: {
    user: string,
    company: Ref,
  }) {
    super(data);
  }
}
