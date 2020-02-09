import { Props, Ref } from '../../document';
import { JRegisterInfo, RegisterInfo } from './RegisterInfo';

@JRegisterInfo({
  type: 'Register.Info.SettlementsReconciliation',
  description: 'Сверки взаиморасчетов',
})
export class RegisterInfoSettlementsReconciliation extends RegisterInfo {

  @Props({ type: 'Catalog.Counterpartie', required: true, unique: true, order: 1, dimension: true  })
  Customer: Ref = null;

  @Props({ type: 'Catalog.Contract', unique: true, order: 2, dimension: true  })
  Contract: Ref = null;

  @Props({ type: 'Catalog.Company', required: true, unique: true, order: 3, dimension: true  })
  company: Ref = null;

  @Props({ type: 'enum', required: true, value: ['PREPARED', 'AWAITING', 'APPROVED'], dimension: true, order: 4 })
  Status = 'APPROVED';

  @Props({ type: 'Catalog.Currency', required: true, dimension: true, order: 5  })
  currency: Ref = null;

  @Props({ type: 'date' })
  Period = null;

  @Props({ type: 'Document.Operation' })
  Operation: Ref = null;

  @Props({ type: 'string' })
  OperationDescription = '';

  @Props({ type: 'string' })
  Comment = 0;

  @Props({ type: 'number', resource: true })
  Amount = 0;

  @Props({ type: 'number', resource: true })
  AmountPaid = 0;

  @Props({ type: 'number', resource: true })
  AmountBalance = 0;



  constructor(init: Partial<RegisterInfoSettlementsReconciliation>) {
    super(init);
    Object.assign(this, init);

  }
}
