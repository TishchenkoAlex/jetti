import { Props, Ref } from '../../document';
import { JRegisterInfo, RegisterInfo } from './RegisterInfo';

@JRegisterInfo({
  type: 'Register.Info.IncomeDocumentRegistry',
  description: 'Реестр входящих документов',
})
export class RegisterInfoIncomeDocumentRegistry extends RegisterInfo {

  @Props({ type: 'string' })
  StatusRegistry = '';

  @Props({ type: 'Catalog.Operation.Type' })
  OperationType: Ref = null;

  @Props({ type: 'Catalog.Counterpartie' })
  Counterpartie: Ref = null;

  @Props({ type: 'Catalog.Currency' })
  Currency: Ref = null;

  @Props({ type: 'Catalog.Department' })
  Department: Ref = null;

  @Props({ type: 'string' })
  DocNumber = '';

  @Props({ type: 'Document.Operation' })
  DocJETTI: Ref = null;

  @Props({ type: 'number' })
  AmountIncome = 0;

  @Props({ type: 'number' })
  AmountJETTI = 0;

  @Props({ type: 'Catalog.ReasonTypes' })
  ReasonType: Ref = null;

  constructor(init: Partial<RegisterInfoIncomeDocumentRegistry>) {
    super(init);
    Object.assign(this, init);
  }
}

