import { ISubSystem } from './SubSystems';

export const SalesSubSystem: ISubSystem = {
  type: 'Sales',
  icon: 'fa fa-fw fa-sign-in', description: 'Sales', Objects: [
    'Document.Invoice',
    'Document.PriceList',
    'Catalog.Counterpartie',
    'Catalog.Product',
    'Catalog.Manager',
    'Catalog.PriceType',
  ]
};
