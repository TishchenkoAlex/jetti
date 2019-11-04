import { RoleObject } from '../../models/Roles/Base';
import { DocumentBase, DocumentOptions } from '../document';
import { FormOptions } from '../Forms/form';
import { createForm } from '../Forms/form.factory';
import { FormTypes } from '../Forms/form.types';
import { createDocument } from './../../models/documents.factory';
import { DocTypes } from './../../models/documents.types';
import { CatalogsSubSystem } from './Catalogs';
import { CommonSubSystem } from './Common';
import { FinanceSubSystem } from './Finance';
import { FixedAssetsSubSystem } from './FixedAssets';
import { ManufacturingSubSystem } from './Manufacturing';
import { OperationsSubSystem } from './Operations';
import { SalesSubSystem } from './Sales';

export type SubSystem =
  'Common' |
  'Sales' |
  'Finance' |
  'Catalogs' |
  'Operations' |
  'FixedAssets' |
  'Manufacturing' |
  'FixedAssets';

export interface ISubSystem {
  type: SubSystem;
  icon: string;
  description: string;
  Objects: (DocTypes | FormTypes)[];
}

export const SubSystems: ISubSystem[] = [
  CommonSubSystem,
  CatalogsSubSystem,
  SalesSubSystem,
  FinanceSubSystem,
  OperationsSubSystem,
  ManufacturingSubSystem,
  FixedAssetsSubSystem
];

export interface MenuItem { type: string; icon: string; label: string; items?: MenuItem[]; routerLink?: string[]; }

export function SubSystemsMenu(filter: RoleObject[] = []) {
  const menu: MenuItem[] = [];
  for (const s of SubSystems) {
    const menuItem: MenuItem = { type: s.type, icon: s.icon, label: s.description, items: [] };
    for (const o of s.Objects) {
      if (!filter.find(f => f.type === o)) { continue; }
      try {
        const prop = createDocument(o as DocTypes).Prop() as DocumentOptions;
        const subMenuItem: MenuItem = { type: prop.type, icon: prop.icon, label: prop.menu, routerLink: ['/' + prop.type] };
        menuItem.items!.push(subMenuItem);
        continue;
      } catch (err) {  }
      try {
        const prop = createForm({type: o as FormTypes}).Prop() as FormOptions;
        const subMenuItem: MenuItem = { type: prop.type, icon: prop.icon, label: prop.menu, routerLink: ['/' + prop.type] };
        menuItem.items!.push(subMenuItem);
      } catch (err) {  }
    }
    menu.push(menuItem);
  }
  return menu;
}
