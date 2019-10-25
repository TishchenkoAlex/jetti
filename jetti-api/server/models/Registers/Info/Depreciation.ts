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
  StartDate = new Date();

  @Props({ type: 'number', required: true })
  Period = 0;

  @Props({ type: 'number', required: true })
  StartCost = 0;

  @Props({ type: 'number' })
  EndCost = 0;

  @Props({ type: 'string', value: ['LIN', 'PROP'] })
  Method = 'LIN';

  constructor(public data: {
    Method: string,
    OE: Ref,
    StartDate: Date,
    Period: number,
    StartCost: number,
    EndCost: number,
  }) {
    super(data);
  }
}

