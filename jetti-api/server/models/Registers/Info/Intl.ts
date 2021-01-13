import { Props, Ref } from '../../document';
import { JRegisterInfo, RegisterInfo } from './RegisterInfo';

@JRegisterInfo({
  type: 'Register.Info.Intl',
  description: 'Internationalization',
})
export class RegisterInfoIntl extends RegisterInfo {

  @Props({ type: 'Types.Catalog', required: true, dimension: true })
  Catalog: Ref = null;

  @Props({ type: 'string', required: true, dimension: true })
  Property = '';

  @Props({ type: 'string', required: true, dimension: true })
  Language = '';

  @Props({ type: 'string', required: true, resource: true })
  Value = '';

  constructor(init: Partial<RegisterInfoIntl>) {
    super(init);
    Object.assign(this, init);
  }
}


