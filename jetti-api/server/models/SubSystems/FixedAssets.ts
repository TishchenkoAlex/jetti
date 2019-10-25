import { ISubSystem } from './SubSystems';

export const FixedAssetsSubSystem: ISubSystem = {
  type: 'FixedAssets',
  icon: 'fa fa-fw fa-sign-in', description: 'Внеоборотные активы', Objects: [
    'Catalog.GroupObjectsExploitation',
    'Catalog.ObjectsExploitation',
  ]
};
