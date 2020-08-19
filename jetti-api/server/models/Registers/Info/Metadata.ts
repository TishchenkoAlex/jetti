import { Props, Ref } from '../../document';
import { JRegisterInfo, RegisterInfo } from './RegisterInfo';

@JRegisterInfo({
  type: 'Register.Info.Metadata',
  description: 'Метаданные (объекты)',
})
export class RegisterInfoMetadata extends RegisterInfo {

  @Props({ type: 'string' })
  metadataType = '';

  @Props({ type: 'string' })
  description = '';

  @Props({ type: 'string' })
  icon = '';

  @Props({ type: 'string' })
  menu = '';

  @Props({ type: 'string' })
  prefix = '';

  @Props({ type: 'string' })
  hierarchy = '';

  @Props({ type: 'string' })
  module = '';

  constructor(init: Partial<RegisterInfoMetadata>) {
    super(init);
    Object.assign(this, init);
  }
}