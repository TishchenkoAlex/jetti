import { RoleObject } from './Base';

export const BudgetingRoleObjects: RoleObject[] = [
  { type: 'Catalog.Scenario', read: true, write: false },
  { type: 'Catalog.BudgetItem', read: true, write: false },
];
