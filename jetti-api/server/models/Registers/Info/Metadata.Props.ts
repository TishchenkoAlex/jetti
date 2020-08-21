import { Props, Ref } from '../../document';
import { JRegisterInfo, RegisterInfo } from './RegisterInfo';

@JRegisterInfo({
  type: 'Register.Info.Metadata.Props',
  description: 'Метаданные (реквизиты)',
})
export class RegisterInfoMetadataProps extends RegisterInfo {

  @Props({ type: 'string' })
  metadataType = '';

  @Props({ type: 'string' })
  name = '';

  @Props({ type: 'string' })
  options = '';

  @Props({ type: 'string' })
  value = '';

  @Props({ type: 'string' })
  table = '';

  constructor(init: Partial<RegisterInfoMetadataProps>) {
    super(init);
    Object.assign(this, init);
  }
}
