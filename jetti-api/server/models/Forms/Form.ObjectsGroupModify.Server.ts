import { FormListOrder } from './../user.settings';
import { DocumentBaseServer } from './../documents.factory.server';
import { AllTypes, DocTypes } from './../documents.types';
import { DocumentBase } from './../document';
import { Type } from './../common-types';
import { IServerForm } from './form.factory.server';
import { FormObjectsGroupModify, ColumnMatching, errorKind } from './Form.ObjectsGroupModify';
import { MSSQL } from '../../mssql';
import { TASKS_POOL } from '../../sql.pool.tasks';
import { createDocument } from '../documents.factory';
import { createDocumentServer } from '../documents.factory.server';
import { PropOptions } from '../document';
import { lib } from '../../std.lib';
import { List } from '../../routes/utils/list';
import { FormListFilter } from '../user.settings';

export default class FormObjectsGroupModifyServer extends FormObjectsGroupModify implements IServerForm {

  tx: MSSQL;
  compareMode: false;
  checkedOnTypes: { value: any, type: string, correct: boolean }[] = [];
  propMatching: {
    Head: ColumnMatching[], Tables: { [x: string]: ColumnMatching[] }
  };

  async Execute() {
    return this;
  }

  async buildFilter() {

    const setId = 'buildFilterProps';
    const filterProps = await this.getRecieverProps();
    const enumValues: string[] = [];
    this.RecieverProps = [];

    Object.keys(filterProps).filter(key => filterProps[key].type !== 'table').forEach(key => {
      const prop = filterProps[key];
      const label = prop['label'] ? prop['label'] : key;
      this.RecieverProps.push({ Key: key, Type: prop.type.toString(), Label: label });
      enumValues.push(label);
    });
    this.DynamicPropsClearSet(setId);
    this.DynamicPropsPush('add', 'type', 'table', '', 'Filter', setId);
    this.DynamicPropsPush('add', 'type', 'enum', 'Field', 'Filter', setId);
    this.DynamicPropsPush('add', 'value', enumValues, 'Field', 'Filter', setId);
  }

  async createFilterElements() {

    const setId = 'createFilterElements';
    const filterFields = [...new Set(this['Filter'].map(e => e.Field))] as string[];
    const matchOperator = ['=', '>=', '<=', '<', '>', 'like', 'in', 'beetwen', 'is null'];
    this.DynamicPropsClearSet(setId);
    for (const filterField of filterFields) {
      const prop = this.RecieverProps.find(e => e.Label === filterField);
      if (!prop) continue;
      this.DynamicPropsPush('add', 'type', prop.Type, `${prop.Key}_right`, '', setId);
      this.DynamicPropsPush('add', 'label', prop.Label, `${prop.Key}_right`, '', setId);
      this.DynamicPropsPush('add', 'type', 'enum', `${prop.Key}_center`, '', setId);
      this.DynamicPropsPush('add', 'value', matchOperator, `${prop.Key}_center`, '', setId);
    }

  }

  async selectFilter() {

    const setId = 'selectFilter';
    const filterFields = [...new Set(this['Filter'].map(e => e.Field))] as string[];
    const listFilter: FormListFilter[] = [];
    this.DynamicPropsClearSet(setId);
    this.DynamicPropsPush('add', 'type', 'table', '', 'FilterResult', setId);
    for (const filterField of filterFields) {
      const prop = this.RecieverProps.find(e => e.Label === filterField);
      if (!prop) continue;
      listFilter.push({ left: prop.Key, center: this[`${prop.Key}_center`], right: this[`${prop.Key}_right`] });
      this.DynamicPropsPush('add', 'type', prop.Type, prop.Key, 'FilterResult', setId);
      this.DynamicPropsPush('add', 'label', prop.Label, prop.Label, 'FilterResult', setId);
    }

    const filterBody = {
      id: '',
      type: await this.getType() as DocTypes,
      command: 'first',
      count: 100,
      offset: 0,
      filter: listFilter,
      order: [new FormListOrder('description')]
    };

    this['FilterResult'] = (await List(filterBody, this.getTX())).data;
  }


  async getType(): Promise<DocTypes | string> {
    if (this.OperationType) return 'Document.Operation';
    let result = '';
    if (this.CatalogType) {
      const ob = await lib.doc.byId(this.CatalogType, this.getTX());
      if (ob) result = ob.type;
    }
    return result;
  }

  async getRecieverProps() {

    const type = await this.getType() as DocTypes;
    const Operation: string | undefined = this.OperationType || undefined;
    if (!type) throw new Error('Не задан тип приемника');
    const sdbl = new MSSQL(TASKS_POOL, this.user);
    const doc = (Operation ?
      { ...createDocument(type), Operation } :
      createDocument(type)) as DocumentBase;
    const ServerDoc = await createDocumentServer(type, doc, sdbl);
    if (!ServerDoc) throw new Error(`wrong type ${type}`);
    return ServerDoc.Props();

  }

  async ReadRecieverStructure() {

    const type = await this.getType() as DocTypes;
    const recieverProps = await this.getRecieverProps();
    this.ColumnsMatching = [];

    const getСolumnMatching = (propName: string, prop: PropOptions, tablePartTo = ''): ColumnMatching => {
      let Role = '';
      if (propName === 'id' && !tablePartTo) {
        prop.type = type;
        Role = 'Object id';
      }
      return {
        LoadEmptyValues: false,
        LoadIfEmptyInObject: false,
        ColumnRole: Role,
        ColumnTo: propName,
        ColumnToLabel: prop.label || propName,
        TablePartTo: tablePartTo,
        ColumnFrom: '',
        ColumnToType: prop.type as string
      };

    };

    Object.keys(recieverProps).forEach(key => {
      const prop = recieverProps[key];
      if (prop.type === 'table')
        Object.keys(prop[key]).forEach(tableCol => this.ColumnsMatching.push(getСolumnMatching(tableCol, prop[key][tableCol], key)));
      else this.ColumnsMatching.push(getСolumnMatching(key, prop));
    });

    await this.fillColumnsFrom();

    return this;

  }

  loadingTable = () => this['LoadingTable'];

  getTX = (): MSSQL => {
    if (!this.tx) this.createTransaction();
    return this.tx;
  }

  createTransaction = () => {
    if (this.tx) return;
    this.user.isAdmin = this.SaveInAdminMode;
    this.tx = new MSSQL(TASKS_POOL, this.user);
  }

  isGUID = (value: string): boolean => {
    return value.length === 36 && value.split('-').length === 5 && value.split('-')[0].length === 8;
  }

  checkType = async (value: any, type: string): Promise<boolean> => {
    if (!value || type === 'string') return true;
    const checked = this.checkedOnTypes.find(e => e.value === value);
    if (checked && checked.type === type) return checked.correct;
    const correct = await this.isValueTypeOf(value, type);
    this.checkedOnTypes.push({ value: value, type: type, correct: correct });
    return correct;
  }

  // TODO check ENUM!
  isValueTypeOf = async (value: any, type: string): Promise<boolean> => {
    if (!value || type === 'string') return true;
    if (Type.isRefType(type)) {
      if (!this.isGUID(value)) return false;
      const ob = await lib.doc.byId(value, this.getTX());
      return !!ob && ob.type === type;
    }
    switch (type) {
      case 'number':
        return value.trim() === '0' || Number.parseFloat(value) !== 0;
      case 'date':
      case 'datetime':
      case 'time':
        return Date.parse(value) > 0;
      default:
        return true;
    }
  }

  private fillPropMatching = () => {
    const head = this.ColumnsMatching.filter(e => e.ColumnFrom && e.ColumnTo && !e.TablePartTo);
    const tablesCol = this.ColumnsMatching.filter(e => e.ColumnFrom && e.ColumnTo && e.TablePartTo);
    const tables = {};
    const tableNames = [...tablesCol.map(e => e.TablePartTo)] as string[];
    for (const tableName of tableNames) {
      tables[tableName] = tablesCol.filter(e => e.TablePartTo === tableName);
    }
    this.propMatching = { Head: head, Tables: tables };
  }

  addError = (kind: errorKind, text: string, rowNumber = 0, objectId = '') => {
    this.Errors.push({ RowNumber: rowNumber, ErrorKind: kind, Text: text, Time: new Date, ObjectId: objectId });
  }

  async saveDataIntoDB() {
    await this.createComparedTable();
    const objectIdCol = this.ColumnsMatching.find(e => e.ColumnRole === 'Object id');
    if (!objectIdCol) throw new Error('Не задана колонка - идентфикатор объекта (Column role = "Object id")');
    this.fillPropMatching();
    this.createTransaction();
    const objects = [...new Set(this['LoadingTable'].filter(e => e[objectIdCol.ColumnTo]).map(e => e[objectIdCol.ColumnTo]))] as string[];
    for (const ob of objects) {
      const servDoc = await lib.doc.createDocServerById(ob, this.tx);
      const rows = this['LoadingTable'].filter(e => e[objectIdCol.ColumnTo] === ob);
      const rowNumber = this['LoadingTable'].indexOf(rows[0]);
      if (!servDoc) {
        this.addError('ObjectNotFound', `Не удалось получить объект по ${ob}`, rowNumber, ob);
        continue;
      }
      if (servDoc.type !== objectIdCol.ColumnToType) {
        this.addError('IncorrectType', `Тип полученного объекта ${servDoc.type}, ожидается тип ${objectIdCol.ColumnToType}`, rowNumber, ob);
        continue;
      }
      try {
        if (await this.fillDocument(servDoc, rows)) await lib.doc.saveDoc(servDoc, this.tx);
      } catch (error) {
        this.addError('OnSave', JSON.stringify(error), rowNumber, ob);
      }

    }
  }

  async fillDocument(doc: DocumentBaseServer, data: any[]): Promise<boolean> {
    let result = await this.fillDocumentHead(doc, data);
    for (const tableName of Object.keys(this.propMatching.Tables)) {
      result = await this.fillDocumentTablePart(doc, data, tableName) || result;
    }
    return result;
  }

  async fillDocumentHead(doc: DocumentBaseServer, data: any[]): Promise<boolean> {
    let result = false;

    for (const col of this.propMatching['Head']) {
      for (const row of data) {
        result = await this.setDocPropValue(doc, col, row[col.ColumnTo]) || result;
      }
    }
    return result;
  }

  async fillDocumentTablePart(doc: DocumentBaseServer, data: any[], tablePartName = ''): Promise<boolean> {
    let result = false;
    const table = doc[tablePartName];
    if (this.ClearTableParts) {
      if (table.length) { table.length = 0; result = true; }
      for (let rowIndex = 0; rowIndex < data.length; rowIndex++) {
        const docRow = {};
        for (const col of this.propMatching[tablePartName]) {
          result = await this.setDocPropValue(docRow[col.ColumnTo], col, data[rowIndex][col.ColumnTo]) || result;
        }
        table.push(docRow);
      }
    } else {
      const findRowById = this.propMatching[tablePartName].find(e => e.ColumnRole === 'Table part row id'); // find by row nomber
      if (findRowById) {
        if (table.length < data.length) {
          this.addError('IncorrectTablePartLength'
            , `Количество строк ТЧ ${tablePartName} - ${table.length}, не меньше количества загружаемых строк ${data.length}`
            , 0
            , doc.id);
          return false;
        }
        for (let rowIndex = 0; rowIndex < data.length; rowIndex++) {
          for (const col of this.propMatching[tablePartName]) {
            result = await this.setDocPropValue(table[rowIndex][col.ColumnTo], col, data[rowIndex][col.ColumnTo]) || result;
          }
        }
      }
    }
    doc[tablePartName] = table;
    return result;
  }

  async setDocPropValue(doc: DocumentBaseServer, col: ColumnMatching, value: any): Promise<boolean> {

    if (col.ColumnRole
      || doc[col.ColumnTo] === value
      || (!value && !col.LoadEmptyValues)
      || (doc[col.ColumnTo] && col.LoadIfEmptyInObject))
      return false;

    if (this.CheckTypes && !await this.checkType(value, col.ColumnToType)) return false;
    doc[col.ColumnTo] = value;
    return true;

  }

  async prepareToLoading() {
    await this.ReadRecieverStructure();
    await this.matchColumnsByName();
    await this.loadToTempTable();
    await this.fillLoadingTable();
  }

  async compareLoadingDataWithCurrent() {
    await this.createComparedTable();

  }

  async createComparedTable() {

    const machCol = this.ColumnsMatching.filter(e => e.ColumnFrom && e.ColumnTo);
    if (!machCol.length) throw new Error('Не задано соответствие колонок');
    const setId = 'createComparedTable';
    this.DynamicPropsClearSet(setId);
    this.DynamicPropsPush('add', 'type', 'table', '', 'ComparedTable', setId);
    this.DynamicPropsPush('add', 'label', 'Compare', '', 'ComparedTable', setId);

    for (const col of machCol) {
      this.DynamicPropsPush('add', 'type', col.ColumnToType, `${col.ColumnTo}Current`, 'ComparedTable', setId);
      this.DynamicPropsPush('add', 'type', col.ColumnToType, `${col.ColumnTo}New`, 'ComparedTable', setId);
    }

    this['ComparedTable'] = [];

  }


  async fillLoadingTable() {
    this['LoadingTable'] = this['TempTable'];
    if (!this['LoadingTable'].length) return;
    const cols = Object.keys(this['LoadingTable'][0]).filter(e => e !== 'Errors');
    const refColumns = this.ColumnsMatching.filter(e => e.ColumnFrom && e.ColumnTo && Type.isRefType(e.ColumnToType)).map(e => e.ColumnTo);
    for (let index = 0; index < this['TempTable'].length; index++) {
      const rowTemp = this['TempTable'][index];
      const rowLoad = this['LoadingTable'][index];
      rowTemp.Errors = 0;
      for (const col of cols) {
        if (rowTemp[col] && !rowLoad[col]) rowTemp.Errors++;
        if (rowLoad[col] && refColumns.includes(col) && !this.isGUID(rowLoad[col])) rowLoad[col] = null;
      }
      rowLoad.Errors = rowTemp.Errors;
    }
  }

  async loadToTempTable() {

    await this.createLoadingTable();

    const pastedValue = this.Text;
    if (!pastedValue) return new Set;
    const sep = await this.getSeparators();
    const rows = pastedValue.split(sep.rows);
    if (!rows.length) throw new Error('Не найден разделитель строк');
    const cols = rows[0].split(sep.columns);
    if (!cols.length) throw new Error('Не найден разделитель колонок');
    const colsSet = new Set<{ colProp: ColumnMatching, index: number }>();

    for (const col of cols) {
      const matCol = this.ColumnsMatching.find(e => e.ColumnFrom === col && e.ColumnTo);
      if (matCol) colsSet.add({ colProp: matCol, index: cols.indexOf(col) });
    }
    const colSep = sep.columns;
    for (let rowIndex = 1; rowIndex < rows.length; rowIndex++) {
      const row = rows[rowIndex].split(colSep);
      const rowOb = {};
      colsSet.forEach(col => { rowOb[col.colProp.ColumnTo] = row[col.index]; });
      this['TempTable'].push(rowOb);
    }

    // for (let rowIndex = 1; rowIndex < rows.length; rowIndex++) {
    //   const row = rows[rowIndex];
    //   const rowOb = {};
    //   colsSet.forEach(async (col) => {
    //     rowOb[col.colProp.ColumnTo] = await this.getDataFromString(row[col.index], col.colProp.ColumnToType);
    //   });
    //   this['LoadingTable'].push(rowOb);
    // }

  }

  async getDataFromString(value, type) {
    if (!value || !type) return value;
    const res = this['cache'].find(e => value === e.valueIn && type === e.type);
    if (res) return res.valueOut;
    switch (type) {
      case 'boolean':

        break;

      default:
        break;
    }

  }

  async createLoadingTable() {

    const machCol = this.ColumnsMatching.filter(e => e.ColumnFrom && e.ColumnTo);
    if (!machCol.length) throw new Error('Не задано соответствие колонок');
    const setId = 'createLoadingTable';
    this.DynamicPropsClearSet(setId);
    this.DynamicPropsPush('add', 'label', 'Temp table', '', 'TempTable', setId);
    this.DynamicPropsPush('add', 'label', 'Loading table', '', 'LoadingTable', setId);

    for (const col of machCol) {
      this.DynamicPropsPush('add', 'type', 'string', col.ColumnTo, 'TempTable', setId);
      this.DynamicPropsPush('add', 'type', col.ColumnToType, col.ColumnTo, 'LoadingTable', setId);
      this.DynamicPropsPush('add', 'label', col.ColumnToLabel, col.ColumnTo, 'TempTable', setId);
      this.DynamicPropsPush('add', 'label', col.ColumnToLabel, col.ColumnTo, 'LoadingTable', setId);
    }

    this.DynamicPropsPush('add', 'type', 'number', 'Errors', 'TempTable', setId);
    this.DynamicPropsPush('add', 'type', 'number', 'Errors', 'LoadingTable', setId);
    this.DynamicPropsPush('add', 'totals', 1, 'Errors', 'TempTable', setId);
    this.DynamicPropsPush('add', 'totals', 1, 'Errors', 'LoadingTable', setId);

    this['TempTable'] = [];
    this['LoadingTable'] = [];

  }

  async fillColumnsFrom() {
    this.DynamicPropsClearSet('fillColumnsFrom');
    this.DynamicPropsPush('mod', 'value', await this.getColumnsFrom(), 'ColumnFrom', 'ColumnsMatching', 'fillColumnsFrom');
  }

  async matchColumnsByName() {
    if (!this.ColumnsMatching.length) throw new Error('Не загружена структура приемника');
    const columns = await this.getColumnsFrom();
    if (!columns) throw new Error('Не удалось прочитать колонки из текста');
    for (const col of columns) {
      const matchedCol = this.ColumnsMatching.find(e => e.ColumnTo === col);
      if (matchedCol) matchedCol.ColumnFrom = col;
    }
  }

  async getColumnsFrom(): Promise<string[]> {
    const pastedValue = this.Text;
    if (!pastedValue) return [];
    const sep = await this.getSeparators();
    const rows = pastedValue.split(sep.rows);
    if (!rows.length) throw new Error('Не найден разделитель строк');
    const cols = rows[0].split(sep.columns);
    if (!cols.length) throw new Error('Не найден разделитель колонок');
    cols.unshift('');
    return cols;
  }

  getSeparators(): { rows: string, columns: string } {
    return { rows: this.RowsSeparator || '\n', columns: this.ColumnsSeparator || '\t' };
  }

}
