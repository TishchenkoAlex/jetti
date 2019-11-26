import { ISubSystem } from './SubSystems';

export const BudgetingSubSystem: ISubSystem = {
  type: 'Budgeting',
  icon: 'fa fa-fw fa-sign-in', description: 'Budgeting', Objects: [
    'Catalog.Scenario',
    'Catalog.BudgetItem'
  ]
};
