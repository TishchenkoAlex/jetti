import { AllDocTypes, CatalogTypes } from './../../documents.types';
import { Props, Ref } from '../../document';
import { JRegisterAccumulation, RegisterAccumulation } from './RegisterAccumulation';

@JRegisterAccumulation({
  type: 'Register.Accumulation.Sales',
  description: 'Выручка и себестоимость продаж'
})
export class RegisterAccumulationSales extends RegisterAccumulation {

  @Props({ type: 'Catalog.Currency', required: true, dimension: true })
  currency: Ref = null;

  @Props({ type: 'Catalog.Department', dimension: true  })
  Department: Ref = null;

  @Props({ type: 'Catalog.Counterpartie', required: true, dimension: true })
  Customer: Ref = null;

  @Props({ type: 'Catalog.Product', required: true, dimension: true })
  Product: Ref = null;

  @Props({ type: 'Types.Catalog', dimension: true })
  Analytic: Ref = null;

  @Props({ type: 'Catalog.Manager', dimension: true  })
  Manager: Ref = null;

  @Props({ type: 'enum', value: ['COURIER', 'CLIENT', 'EXTERNAL'] })
  DeliveryType = '';

  @Props({ type: 'string' })
  OrderSource = '';

  @Props({ type: 'Catalog.RetailClient' })
  RetailClient: Ref = null;

  @Props({ type: 'Types.Document' })
  AO: Ref = null;

  @Props({ type: 'Catalog.Storehouse', required: true, dimension: true })
  Storehouse: Ref = null;

  @Props({ type: 'datetime' })
  OpenTime = null;

  @Props({ type: 'datetime' })
  PrintTime = null;

  @Props({ type: 'datetime' })
  DeliverTime = null;

  @Props({ type: 'datetime' })
  BillTime = null;

  @Props({ type: 'datetime' })
  CloseTime = null;

  @Props({ type: 'number' })
  CashShift = 0;

  @Props({ type: 'number', resource: true })
  Cost = 0;

  @Props({ type: 'number', resource: true })
  Qty = 0;

  @Props({ type: 'number', resource: true })
  Amount = 0;

  @Props({ type: 'number', resource: true })
  Discount = 0;

  @Props({ type: 'number', resource: true })
  Tax = 0;

  @Props({ type: 'number', resource: true })
  AmountInDoc = 0;

  @Props({ type: 'number', resource: true })
  AmountInAR = 0;

  constructor (init: Partial<RegisterAccumulationSales>) {
    super(init);
    Object.assign(this, init);
  }
}
