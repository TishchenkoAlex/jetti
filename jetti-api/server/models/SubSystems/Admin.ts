import { ISubSystem } from './SubSystems';

export const AdminSubSystem: ISubSystem = {
  type: 'Admin',
  icon: 'fa fa-fw fa-sign-in', description: 'Admin', Objects: [
    'Catalog.Role',
    'Catalog.SubSystem',
    'Catalog.UsersGroup',
    'Catalog.SubSystem',
    'Catalog.User',
    'Form.PostAfterEchange',
    'Document.UserSettings',
    'Document.Settings'
  ]
};
