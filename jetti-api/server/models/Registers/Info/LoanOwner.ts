import { Props, Ref } from '../../document';
import { JRegisterInfo, RegisterInfo } from './RegisterInfo';

@JRegisterInfo({
  type: 'Register.Info.LoanOwner',
  description: 'Loan owner',
})
export class RegisterInfoLoanOwner extends RegisterInfo {

  @Props({ type: 'Catalog.User', required: true })
  User: Ref = null;

  @Props({ type: 'Types.CounterpartieOrPerson', required: true })
  LoanOwner: Ref = null;

  constructor(init: Partial<RegisterInfoLoanOwner>) {
    super(init);
    Object.assign(this, init);
  }
}


