import { IServerDocument } from './../documents.factory.server';
import { MSSQL } from '../../mssql';
import { lib } from '../../std.lib';
import { CatalogProduct } from './Catalog.Product';
import { CatalogProductKind } from './Catalog.ProductKind';

export class CatalogProductServer extends CatalogProduct implements IServerDocument {


  async onCommand(command: string, args: any, tx: MSSQL) {
    if (this[command]) await this[command](tx);
    return this;
  }

  async SavePropsValuesInChilds(tx: MSSQL) {

    const childs = await lib.doc.Descendants(this.id, tx);
    if (!childs) return;

    const props = this.Props();
    const propNames = Object.keys(props).filter(e => props[e].useIn === 'all');

    for (const child of childs) {
      const ob = await lib.doc.createDocServerById(child.id as any, tx);
      let modify = false;
      for (const propName of propNames) {
        modify = modify || ob![propName] !== this[propName];
        ob![propName] = this[propName];
      }
      if (modify) await lib.doc.saveDoc(ob!, tx);
    }

    // this.PropsAdd('afterSavePropsValuesInChildsText', { value: `Saved in ${childs.length} elements` });

  }


  async onValueChanged(prop: string, value: any, tx: MSSQL) {
    const methodName = `onValueChanged_${prop}`;
    if (this[methodName]) await this[methodName](value.id, tx);
    return this;
  }

  async onCreate(tx: MSSQL) {
    await this.onValueChanged_ProductKind(this.ProductKind, tx);
    return this;
  }


  async onValueChanged_ProductKind(kindId: any, tx: MSSQL) {

    if (!kindId) return this;

    const kind = await lib.doc.byIdT<CatalogProductKind>(kindId, tx);
    const props = this.Props();
    const propNames = Object.keys(props).filter(e => props[e].order === 666);

    for (const propName of propNames) {
      const param = kind!['Parameters'] ? kind!['Parameters'].find(e => e.PropName === propName) : null;
      props[propName].hidden = !param || !param.Visible;
      props[propName].readOnly = !!(param && param.Readonly);
      props[propName].required = !!(param && param.Required && param.Visible);
    }

    this.Props = () => props;

  }
}
