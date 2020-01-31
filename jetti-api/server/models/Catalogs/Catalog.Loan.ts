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

  @Props({ type: 'Catalog.Company', required: true, onChangeServer: true , style: { width: '250px' }})
  company: Ref = null;

  @Props({ type: 'date', hiddenInForm: false,  hiddenInList: false, hidden: false, order: 1 })
  date = new Date();

  @Props({ type: 'Types.CounterpartieOrPerson', required: true })
  owner: Ref = null;

  @Props({
    type: 'enum', required: true, value: [
      'IN',
      'OUT'
    ]
  })
  kind = 'IN';

  @Props({ type: 'Catalog.Currency', required: true, style: { width: '100px' } })
  currency: Ref = null;

  @Props({ type: 'Catalog.LoanTypes'})
  loanType: Ref = null;

  @Props({ type: 'Catalog.Department'})
  Department: Ref = null;

  @Props({ type: 'date' })
  PayDay: Date | null = null;

  @Props({ type: 'date' })
  CloseDay: Date | null = null;

}
