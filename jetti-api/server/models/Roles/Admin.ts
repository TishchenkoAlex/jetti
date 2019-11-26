import { RoleObject } from './Base';
import { FinanceRoleObject } from './Finance';
import { SalesRoleObjects } from './Sales';
import { CommonRoleObject } from './Common';
import { CatalogsRoleObject } from './Catalogs';
import { ManufacturingRoleObjects } from './Manufacturing';
import { BudgetingRoleObjects } from './Budgeting';

export const AdminObjects: RoleObject[] = [
    ...SalesRoleObjects,
    ...FinanceRoleObject,
    ...CommonRoleObject,
    ...CatalogsRoleObject,
    ...ManufacturingRoleObjects,
    ...BudgetingRoleObjects
];
