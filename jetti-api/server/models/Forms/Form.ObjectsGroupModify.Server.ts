import { Type } from './../common-types';
import { IServerForm } from './form.factory.server';
import { FormObjectsGroupModify, СolumnMatching } from './Form.ObjectsGroupModify';
import { MSSQL } from '../../mssql';
import { TASKS_POOL } from '../../sql.pool.tasks';
import { createDocument } from '../documents.factory';
import { createDocumentServer } from '../documents.factory.server';
import { PropOptions } from '../document';
import { v1 } from 'uuid';

export default class FormObjectsGroupModifyServer extends FormObjectsGroupModify implements IServerForm {

  async Execute() {
    return this;
  }

  async ReadRecieverStructure() {

    const type = this.OperationType ? 'Document.Operation' : this.Catalog;
    const Operation: string | undefined = this.OperationType || undefined;
    if (!type) throw new Error('Не задан тип приемника');
    const sdbl = new MSSQL(TASKS_POOL, this.user);
    const doc = Operation ?
      { ...createDocument(type), Operation } :
      createDocument(type);
    const ServerDoc = await createDocumentServer(type, doc, sdbl);
    if (!ServerDoc) throw new Error(`wrong type ${type}`);
    const recieverProps = ServerDoc.Props();
    this.СolumnsMatching = [];
    this.id = v1().toLocaleUpperCase();

    const getСolumnMatching = (propName: string, prop: PropOptions, tablePartTo = ''): СolumnMatching => {
      return {
        СolumnTo: propName,
        СolumnToLabel: prop.label || propName,
        TablePartTo: tablePartTo,
        СolumnFrom: '',
        СolumnToType: prop.type as string
      };

    };

    Object.keys(recieverProps).forEach(key => {
      const prop = recieverProps[key];
      if (prop.type === 'table')
        Object.keys(prop[key]).forEach(tableCol => this.СolumnsMatching.push(getСolumnMatching(tableCol, prop[key][tableCol], key)));
      else this.СolumnsMatching.push(getСolumnMatching(key, prop));
    });

    const Props = this.Props() as any;
    const cols = this.getColumsFrom();
    Props.СolumnsMatching.СolumnsMatching.СolumnFrom = {
      ...Props.СolumnsMatching.СolumnsMatching.СolumnFrom, value: cols
    };

    this.Props = () => Props;

    return this;
  }

  getColumsFrom(): string[] {
    const pastedValue = this.Text;
    if (!pastedValue) return [];
    const sep = this.getSeparators();
    const rows = pastedValue.split(sep.rows);
    if (!rows.length) throw new Error('Не найден разделитель строк');
    const cols = rows[0].split(sep.columns);
    if (!cols.length) throw new Error('Не найден разделитель колонок');
    return cols;
  }

  getSeparators(): { rows: string, columns: string } {
    return { rows: this.RowsSeparator || '\n', columns: this.ColumnsSeparator || '\t' };
  }

}
