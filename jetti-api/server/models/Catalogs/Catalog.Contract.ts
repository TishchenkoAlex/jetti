import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.Contract',
  description: 'Договор контрагента',
  icon: 'fa fa-list',
  menu: 'Договоры контрагента',
  prefix: 'CONTR-',
  dimensions: [
    { company: 'Catalog.Company' }
  ]
})
export class CatalogContract extends DocumentBase {

  @Props({ type: 'Catalog.Contract', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Catalog.Counterpartie', required: true, order: 1, isProtected: true })
  owner: Ref = null;

  @Props({ type: 'Catalog.Company', order: 4, required: true, style: { width: '250px' }, isProtected: true })
  company: Ref = null;

  @Props({ type: 'enum', value: ['OPEN', 'CLOSE', 'PENDING'], required: true })
  Status = 'OPEN';

  @Props({ type: 'enum', value: ['AR', 'AP', 'EXPORT', 'COMMISSIONER', 'COMMITENT'], required: true })
  kind = 'AR';

  @Props({ type: 'date', required: true })
  StartDate: Ref = null;

  @Props({ type: 'date', required: false })
  EndDate: Ref = null;

  @Props({ type: 'number', required: false })
  Indulgence = 0;

  @Props({ type: 'number', required: false })
  Amount = 0;

  @Props({ type: 'Catalog.BusinessDirection', required: true })
  BusinessDirection: Ref = null;

  @Props({ type: 'Catalog.CashFlow', required: false })
  CashFlow: Ref = null;

  @Props({ type: 'Catalog.Currency', required: true, isProtected: true })
  currency: Ref = null;

  @Props({
    type: 'Catalog.Counterpartie.BankAccount',
    owner: [
      { dependsOn: 'owner', filterBy: 'owner' },
      { dependsOn: 'сurrency', filterBy: 'currency' }
    ]
  })
  BankAccount: Ref = null;

  @Props({ type: 'Catalog.Manager', required: false })
  Manager: Ref = null;

  @Props({ type: 'boolean', required: false })
  isDefault = false;

  @Props({ type: 'boolean', label: 'Ф2' })
  notAccounting = false;

  @Props({ type: 'enum', value: ['GRID', 'FIX'], order: 777 })
  RoyaltyArrangements = null;

  @Props({ type: 'date', order: 777 })
  RoyaltyDelayTo = null;

  @Props({ type: 'enum', value: ['INVOICE', 'ROYALTY', 'NONE'], order: 777 })
  PaymentKC = 'NONE';

  @Props({ type: 'number', label: 'Rotalty fix %', order: 777 })
  RoyaltyPercent = 0;

  @Props({ type: 'enum', value: ['INVOICE', 'ROYALTY', 'NONE'], order: 777 })
  PaymentOVM = 'NONE';

  @Props({ type: 'enum', value: ['INVOICE', 'ROYALTY', 'NONE'], order: 777 })
  PaymentOKK = 'NONE';

  @Props({ type: 'enum', value: ['INVOICE', 'ROYALTY', 'NONE'], order: 777 })
  PaymentKRO = 'NONE';

  @Props({ type: 'string', order: 777 })
  OtherServices = '';

}
