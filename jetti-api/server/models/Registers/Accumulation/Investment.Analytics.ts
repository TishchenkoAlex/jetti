import { Props, Ref } from '../../document';
import { JRegisterAccumulation, RegisterAccumulation } from './RegisterAccumulation';

@JRegisterAccumulation({
  type: 'Register.Accumulation.Investment.Analytics',
  description: 'Аналитика инвестиций'
})
export class RegisterAccumulationInvestmentAnalytics extends RegisterAccumulation {

  @Props({ type: 'Catalog.Department' })
  Department: Ref = null;

  @Props({ type: 'enum', dimension: true, value: ['ALLUNIC', 'JETTI', 'X100FINANCE']})
  SourceTransaction = 'JETTI';

  @Props({ type: 'Document.Operation', dimension: true })
  CreditTransaction: Ref = null;

  @Props({ type: 'Catalog.Operation.Type', required: true, dimension: true })
  OperationType: Ref = null;

  @Props({ type: 'Types.CounterpartieOrPerson', required: true, dimension: true })
  Investor: Ref = null;

  @Props({ type: 'Catalog.Company', dimension: true })
  CompanyProduct: Ref = null;

  @Props({ type: 'Catalog.Product', dimension: true })
  Product: Ref = null;

  @Props({ type: 'number', resource: true })
  Qty = 0;

  @Props({ type: 'Catalog.Currency', required: true })
  CurrencyProduct: Ref = null;

  @Props({ type: 'number', resource: true })
  AmountProduct = 0;

  @Props({ type: 'Types.Catalog', dimension: true })
  PaymentSource: Ref = null;

  @Props({ type: 'Catalog.Currency', required: true })
  CurrencySource: Ref = null;

  @Props({ type: 'number', resource: true })
  AmountSource = 0;

  @Props({ type: 'Catalog.Company', dimension: true })
  CompanyLoan: Ref = null;

  @Props({ type: 'Catalog.Loan', dimension: true })
  Loan: Ref = null;

  @Props({ type: 'Catalog.Currency', required: true })
  CurrencyLoan: Ref = null;

  @Props({ type: 'number', resource: true })
  AmountLoan = 0;

  constructor(init: Partial<RegisterAccumulationInvestmentAnalytics>) {
    super(init);
    Object.assign(this, init);
  }
}
