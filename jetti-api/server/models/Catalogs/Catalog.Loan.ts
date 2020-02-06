import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.Loan',
  description: 'Договор кредита/займа',
  icon: 'fa fa-list',
  menu: 'Договоры кредита/займа',
  prefix: 'LOAN-'
})
export class CatalogLoan extends DocumentBase {

  @Props({ type: 'Catalog.Loan', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Catalog.Company', required: true, onChangeServer: true, style: { width: '250px' } })
  company: Ref = null;

  @Props({ type: 'date', hiddenInForm: false, hiddenInList: false, hidden: false, order: 1 })
  date = new Date();

  @Props({ type: 'date', order: 2, label: 'Open date' })
  PayDay: Date | null = null;

  @Props({ type: 'date', label: 'Close date' })
  CloseDay: Date | null = null;

  @Props({ type: 'Types.CounterpartieOrPerson', required: true })
  owner: Ref = null;

  @Props({
    type: 'Catalog.Counterpartie.BankAccount',
    owner: [
      { dependsOn: 'owner', filterBy: 'owner' },
      { dependsOn: 'currency', filterBy: 'currency' }]
  })
  OwnerBankAccount: Ref = null;

  @Props({
    type: 'enum', style: { width: '140px' },
    value: [
      'BANK',
      'CASH',
      'ANY',
    ]
  })
  CashKind = 'ANY';

  @Props({
    type: 'enum', required: true, value: [
      'IN',
      'IN BANK',
      'OUT',
      'OUT BANK',
    ]
  })
  kind = 'IN';

  @Props({
    type: 'enum', required: true, value: [
      'PREPARED',
      'ACTIVE',
      'CLOSED',
    ]
  })
  Status = 'PREPARED';

  @Props({ type: 'number' })
  InterestRate = 0;

  @Props({ type: 'date', label: 'Interest deadline' })
  InterestDeadline: Date | null = null;

  @Props({ type: 'Catalog.LoanTypes' })
  loanType: Ref = null;

  @Props({ type: 'Catalog.Department' })
  Department: Ref = null;

  @Props({ type: 'number' })
  AmountLoan = 0;

  @Props({ type: 'Catalog.Currency', required: true, style: { width: '100px' } })
  currency: Ref = null;

  @Props({ type: 'Catalog.Country' })
  Country: Ref = null;

  @Props({ type: 'Catalog.LoanRepaymentProcedure' })
  LoanRepaymentProcedure: Ref = null;

  @Props({ type: 'date', label: 'Pay deadline' })
  PayDeadline: Date | null = null;

  @Props({
    type: 'table', required: false, label: 'Agreements'
  })
  Agreements: Agreement[] = [new Agreement()];
}
export class Agreement {

  @Props({ type: 'string', label: 'Code' })
  AgreementCode = '';

  @Props({ type: 'date', label: 'Date' })
  AgreementDate: Date | null = null;

  @Props({ type: 'date', label: 'Deadline' })
  AgreementDeadline: Date | null = null;

  @Props({
    type: 'enum', label: 'Status', value: [
      '0 не определен',
      '1 заведен договор займа',
      '2 подписан договор займа',
      '3 частично оплачен договор займа',
      '4 оплачен договор займа',
      '5 опцион выписан',
      '6 опцион подписан',
      '7 заведен агентский договор',
      '8 подписан агентский договор',
      '9 частично олачен агентский договор',
      '10 олачен агентский договор',
      '11 отправлен',
      '12 оформлен',
      '13 расторгнут',
      '14 смена вида вложения'
    ]
  })
  AgreementStatus = '0 не определен';

  @Props({ type: 'number', label: 'Company cost', style: { width: '100px', textAlign: 'right', background: 'lightgoldenrodyellow', color: 'black' }, totals: 1 })
  AgreementCostCompany = 0;

  @Props({ type: 'Catalog.Company', label: 'Seller' })
  AgreementSeller: Ref = null;

  @Props({ type: 'Catalog.Counterpartie', label: 'Buyer' })
  AgreementBuyer: Ref = null;

  @Props({ type: 'Catalog.Company', label: 'Company share' })
  AgreementShareCompany: Ref = null;

  @Props({ type: 'string', label: 'Hologram №' })
  AgreementHologram = '';

  @Props({ type: 'number', label: 'Amount ', style: { width: '100px', textAlign: 'right', background: 'lightgoldenrodyellow', color: 'black' }, totals: 1 })
  AgreementAmount = 0;

  @Props({ type: 'number', label: 'Interest', style: { width: '100px', textAlign: 'right', background: 'lightgoldenrodyellow', color: 'black' } })
  AgreementInterest = 0;

}
