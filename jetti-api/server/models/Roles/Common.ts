import { RoleObject } from './Base';

export const CommonRoleObject: RoleObject[] = [
  { type: 'Document.Settings', read: true, write: true },
  { type: 'Document.UserSettings', read: true, write: true },
  { type: 'Document.WorkFlow', read: true, write: true },
];
