import { Props, Ref } from '../../document';
import { JRegisterInfo, RegisterInfo } from './RegisterInfo';

@JRegisterInfo({
  type: 'Register.Info.CounterpartiePriceList',
  description: 'Цены контрагентов',
})
export class RegisterInfoCounterpartiePriceList extends RegisterInfo {

  @Props({
    type: 'enum', required: true, value: [
      'PLAN',
      'ACTUAL',
    ]
  })
  Scenario = 'ACTUAL';

  @Props({ type: 'Catalog.Counterpartie', required: true, unique: true, order: 1 })
  Counterpartie: Ref = null;

  @Props({ type: 'Catalog.Company', required: true, unique: true, order: 2 })
  company: Ref = null;

  @Props({ type: 'Catalog.Product', required: true, dimension: true })
  Product: Ref = null;

  @Props({ type: 'number', resource: true })
  Price = 0;

  @Props({ type: 'Catalog.Currency', required: true, dimension: true })
  currency: Ref = null;

  constructor(init: Partial<RegisterInfoCounterpartiePriceList>) {
    super(init);
    Object.assign(this, init);
  }
}
