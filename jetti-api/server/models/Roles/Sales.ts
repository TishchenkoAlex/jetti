import { RoleObject } from './Base';

export const SalesRoleObjects: RoleObject[] = [
  { type: 'Document.Invoice', read: true, write: true },
  { type: 'Document.PriceList', read: true, write: true },
  { type: 'Catalog.CashRegister', read: true, write: false },
  { type: 'Catalog.Company', read: true, write: false },
];
