import { ISubSystem } from './SubSystems';

export const ManufacturingSubSystem: ISubSystem = {
  type: 'Operations',
  icon: 'fa fa-fw fa-sign-in', description: 'Manufacturing', Objects: [
    'Catalog.Product',
  ]
};
