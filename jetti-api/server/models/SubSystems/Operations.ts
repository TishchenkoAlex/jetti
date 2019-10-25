import { ISubSystem } from './SubSystems';

export const OperationsSubSystem: ISubSystem = {
  type: 'Operations',
  icon: 'fa fa-fw fa-sign-in', description: 'Operations', Objects: [
    'Catalog.Operation',
    'Catalog.Operation.Group',
    'Catalog.Catalog',
    'Document.Operation'
  ]
};
