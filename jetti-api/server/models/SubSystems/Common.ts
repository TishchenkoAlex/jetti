import { ISubSystem } from './SubSystems';

export const CommonSubSystem: ISubSystem = {
  type: 'Common',
  icon: 'fa fa-fw fa-sign-in', description: 'Common', Objects: [
    'Catalog.User',
    'Catalog.Department',
    'Catalog.Company',
    'Catalog.Currency',
    'Document.ExchangeRates',
  ]
};
