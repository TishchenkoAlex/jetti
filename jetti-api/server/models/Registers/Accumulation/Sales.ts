import { Props, Ref } from '../../document';
import { JRegisterAccumulation, RegisterAccumulation } from './RegisterAccumulation';

@JRegisterAccumulation({
  type: 'Register.Accumulation.Sales',
  description: 'Выручка и себестоимость продаж'
})
export class RegisterAccumulationSales extends RegisterAccumulation {

  @Props({ type: 'Catalog.Currency', required: true })
  currency: Ref = null;

  @Props({ type: 'Catalog.Department' })
  Department: Ref = null;

  @Props({ type: 'Catalog.Counterpartie', required: true })
  Customer: Ref = null;

  @Props({ type: 'Catalog.Product', required: true })
  Product: Ref = null;

  @Props({ type: 'Catalog.Manager' })
  Manager: Ref = null;

  @Props({ type: 'Types.Document' })
  AO: Ref = null;

  @Props({ type: 'Catalog.Storehouse', required: true })
  Storehouse: Ref = null;

  @Props({ type: 'number' })
  Cost = 0;

  @Props({ type: 'number' })
  Qty = 0;

  @Props({ type: 'number' })
  Amount = 0;

  @Props({ type: 'number' })
  Discount = 0;

  @Props({ type: 'number' })
  Tax = 0;

  @Props({ type: 'number' })
  AmountInDoc = 0;

  @Props({ type: 'number' })
  AmountInAR = 0;

  constructor(kind: boolean, public data: {
    currency: Ref,
    AO: Ref,
    Department: Ref,
    Customer: Ref,
    Product: Ref,
    Manager: Ref,
    Storehouse: Ref,
    Qty: number,
    Amount: number,
    AmountInAR: number,
    AmountInDoc: number,
    Cost: number,
    Discount: number,
    Tax: number,
  }) {
    super(kind, data);
  }
}
