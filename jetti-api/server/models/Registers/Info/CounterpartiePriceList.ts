import { Props, Ref } from '../../document';
import { JRegisterInfo, RegisterInfo } from './RegisterInfo';

@JRegisterInfo({
  type: 'Register.Info.CounterpartiePriceList',
  description: 'Цены контрагентов',
})
export class RegisterInfoCounterpartiePriceList extends RegisterInfo {

  @Props({ type: 'Catalog.Company', required: true, unique: true, order: 1 })
  company: Ref = null;

  @Props({
    type: 'enum', required: true, value: [
      'PLAN',
      'ACTUAL',
    ]
  })
  Scenario = 'ACTUAL';

  @Props({ type: 'Catalog.Counterpartie', required: true, unique: true, order: 2 })
  Counterpartie: Ref = null;

  @Props({ type: 'Catalog.Contract', order: 3 })
  Contract: Ref = null;

  @Props({ type: 'string', resource: true, order: 4 })
  DocNumber = '';

  @Props({ type: 'datetime', resource: true, order: 5 })
  DocDate = null;

  @Props({ type: 'Catalog.Department', order: 6 })
  Department: Ref = null;

  @Props({ type: 'Catalog.Storehouse', order: 7 })
  Storehouse: Ref = null;

  @Props({ type: 'Catalog.Product', required: true, dimension: true })
  Product: Ref = null;

  @Props({ type: 'number', resource: true })
  Qty = 0;

  @Props({ type: 'number', resource: true })
  Price = 0;

  @Props({ type: 'number', resource: true })
  Cost = 0;

  @Props({ type: 'Catalog.Currency', required: true, dimension: true })
  currency: Ref = null;

  constructor(init: Partial<RegisterInfoCounterpartiePriceList>) {
    super(init);
    Object.assign(this, init);
  }
}
