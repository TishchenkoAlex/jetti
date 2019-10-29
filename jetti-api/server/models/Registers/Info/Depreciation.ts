import { Props, Ref } from '../../document';
import { JRegisterInfo, RegisterInfo } from './RegisterInfo';

@JRegisterInfo({
  type: 'Register.Info.Depreciation',
  description: 'Настройки атортизации ОЭ',
})
export class RegisterInfoDepreciation extends RegisterInfo {

  @Props({ type: 'Catalog.ObjectsExploitation' })
  OE: Ref = null;

  @Props({ type: 'date', required: true })
  StartDate: Date = new Date();

  @Props({ type: 'number', required: true })
  Period = 0;

  @Props({ type: 'number', required: true })
  StartCost = 0;

  @Props({ type: 'number' })
  EndCost = 0;

  @Props({ type: 'string', value: ['LIN', 'PROP'] })
  Method = 'LIN';

  constructor(init: Partial<RegisterInfoDepreciation>) {
    super(init);
    Object.assign(this, init);
  }
}

