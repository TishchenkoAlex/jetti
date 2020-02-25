import { Props, Ref } from '../../document';
import { JRegisterAccumulation, RegisterAccumulation } from './RegisterAccumulation';

@JRegisterAccumulation({
  type: 'Register.Accumulation.Intercompany',
  description: 'Интеркомпани'
})
export class RegisterAccumulationIntercompany extends RegisterAccumulation {

  @Props({ type: 'Catalog.Company', dimension: true })
  Intercompany: Ref = null;

  @Props({ type: 'Catalog.Company', dimension: true })
  LegalCompanySender: Ref = null;

  @Props({ type: 'Catalog.Company', dimension: true })
  LegalCompanyRecipient: Ref = null;

  @Props({ type: 'Catalog.Contract.Intercompany' })
  Contract: Ref = null;

  @Props({ type: 'Catalog.Operation.Type' })
  OperationType: Ref = null;

  @Props({ type: 'Catalog.Currency' })
  currency: Ref = null;

  @Props({ type: 'number', resource: true })
  Amount = 0;

  @Props({ type: 'number', resource: true })
  AmountInBalance = 0;

  @Props({ type: 'number', resource: true })
  AmountInAccounting = 0;

  constructor (init: Partial<RegisterAccumulationIntercompany>) {
    super(init);
    Object.assign(this, init);
  }
}