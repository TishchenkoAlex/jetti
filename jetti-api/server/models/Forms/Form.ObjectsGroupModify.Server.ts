import { filterBuilder } from './../../fuctions/filterBuilder';
import { FormListOrder } from './../user.settings';
import { DocumentBaseServer } from './../documents.factory.server';
import { DocTypes } from './../documents.types';
import { DocumentBase, DocumentOptions, StorageType } from './../document';
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
// tslint:disable: max-line-length
// tslint:disable: no-shadowed-variable
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

  async Modify() {
    this.createTransaction();
    for (const row of this['FilterResult']) {
      const servDoc = await lib.doc.createDocServerById(row.id, this.tx);
      if (!servDoc) throw new Error('Doc not exist ' + row.id);
      let saveDoc = false;

      const modFields = this['ModifyFields'].map(e => e.Field);
      for (const propName of modFields) {
        if (servDoc[propName] === this[propName + '_value']) continue;
        servDoc[propName] = this[propName + '_value'];
        saveDoc = true;
      }
      if (saveDoc) try {
        await lib.doc.saveDoc(servDoc, this.tx);
      } catch (e) {
        throw new Error(`On save doc ${row.id}:\n${e}`);
      }
    }
  }

  async buildModifyControls() {

    const setId = 'buildModifyControls';
    const filterProps = await this.getRecieverProps();
    // const enumValues: string[] = [];
    this.RecieverProps = [];
    const enumValues = Object.keys(filterProps).filter(key => filterProps[key].type !== 'table').map(e => e);
    // Object.keys(filterProps).filter(key => filterProps[key].type !== 'table').forEach(key => {
    //   const prop = filterProps[key];
    //   const label = prop['label'] ? prop['label'] : key;
    //   this.RecieverProps.push({ Key: key, Type: prop.type.toString(), Label: label });
    //   enumValues.push(label);
    // });
    this.DynamicPropsClearSet(setId);
    this.DynamicPropsPush('add', 'type', 'table', '', 'FilterFields', setId);
    this.DynamicPropsPush('add', 'type', 'enum', 'Field', 'FilterFields', setId);
    this.DynamicPropsPush('add', 'value', enumValues, 'Field', 'FilterFields', setId);

    this.DynamicPropsPush('add', 'type', 'table', '', 'ModifyFields', setId);
    this.DynamicPropsPush('add', 'type', 'enum', 'Field', 'ModifyFields', setId);
    this.DynamicPropsPush('add', 'value', enumValues, 'Field', 'ModifyFields', setId);

  }

  async createFilterElements() {

    const setId = 'createFilterElements';
    const filterFields = [...new Set(this['FilterFields'].map(e => e.Field))] as string[];
    const matchOperator = ['=', '>=', '<=', '<', '>', 'like', 'in', 'beetwen', 'is null'];
    const storageType = !!filterFields.includes('parent') &&
      Type.isCatalog(await this.getRecieverType()) &&
      (await this.getRecieverProp()).hierarchy || null;

    const props = await this.getRecieverProps();

    this.DynamicPropsClearSet(setId);
    for (const filterField of filterFields) {
      const prop = { ...props[filterField] as PropOptions, key: filterField };
      this.DynamicPropsPush('add', 'type', 'enum', `${prop.key}_center`, '', setId);
      this.DynamicPropsPush('add', 'value', matchOperator, `${prop.key}_center`, '', setId);

      this.DynamicPropsPush('add', 'type', prop.type, `${prop.key}_right`, '', setId);
      this.DynamicPropsPush('add', 'label', prop.label || prop.key, `${prop.key}_right`, '', setId);
      if (storageType || prop.storageType) {
        this.DynamicPropsPush('add', 'storageType', storageType || prop.storageType, `${prop.key}_right`, '', setId);
      }
    }

  }


  async createModifyElements() {

    const setId = 'createModifyElements';
    const modFields = [...new Set(this['ModifyFields'].map(e => e.Field))] as string[];
    const storageType = !!modFields.includes('parent') &&
      Type.isCatalog(await this.getRecieverType()) &&
      (await this.getRecieverProp()).hierarchy || null;

    const props = await this.getRecieverProps();

    this.DynamicPropsClearSet(setId);

    for (const modField of modFields) {
      const prop = { ...props[modField] as PropOptions, key: modField };

      this.DynamicPropsPush('add', 'type', prop.type, `${prop.key}_value`, '', setId);
      this.DynamicPropsPush('add', 'label', prop.label || prop.key, `${prop.key}_value`, '', setId);
      if (storageType || prop.storageType) {
        this.DynamicPropsPush('add', 'storageType', storageType || prop.storageType, `${prop.key}_value`, '', setId);
      }
    }

  }

  async selectFilter() {

    const setId = 'selectFilter';
    const filterFields = [...new Set(this['FilterFields'].map(e => e.Field))] as string[];
    const listFilter: FormListFilter[] = [];
    const props = await this.getRecieverProps();
    this.DynamicPropsClearSet(setId);
    this.DynamicPropsPush('add', 'type', 'table', '', 'FilterResult', setId);
    for (const filterField of filterFields) {
      const prop = props[filterField] as PropOptions;
      if (!prop) continue;
      listFilter.push({ left: filterField, center: this[`${filterField}_center`], right: this[`${filterField}_right`] });
    }

    if (this.OperationType) listFilter.push({
      left: 'Operation',
      center: '=',
      right: this.OperationType
    });

    const complexProps: string[] = ['Object'];
    this.DynamicPropsPush('add', 'type', await this.getRecieverType(), 'Object', 'FilterResult', setId);
    this.DynamicPropsPush('add', 'label', 'Object', 'Object', 'FilterResult', setId);
    Object.keys(props)
      .filter(propKey => props[propKey].type !== 'table')
      .forEach(propName => {
        const prop = props[propName] as PropOptions;
        if (Type.isRefType(prop.type.toString())) complexProps.push(propName);
        this.DynamicPropsPush('add', 'type', prop.type, propName, 'FilterResult', setId);
        this.DynamicPropsPush('add', 'label', prop.label || propName, propName, 'FilterResult', setId);
        if (prop.type === 'enum') {
          this.DynamicPropsPush('add', 'value', prop.value || [], propName, 'FilterResult', setId);
        }
      });

    let resData;

    if (Type.isCatalog(await this.getRecieverType())) {
      const filterBody = {
        id: '',
        type: await this.getRecieverType() as DocTypes,
        command: 'first',
        count: 100,
        offset: 0,
        filter: listFilter,
        order: [new FormListOrder('description')]
      };
      resData = (await List(filterBody, this.getTX())).data
        .map(e => {
          const res = { ...e, Object: e.id };
          complexProps
            .filter(colName => e[colName] && e[colName].id)
            .forEach(cp => {
              res[cp] = e[cp].id;
            });
          return res;
        });
    } else {
      const query = this.getSelectQueryText(props, listFilter);
      resData = await this.getTX().manyOrNone(query);
    }
    this['FilterResult'] = resData;
  }

  getSelectQueryText(schema: { [x: string]: PropOptions }, listFilter: FormListFilter[]) {

    const jsonProp = (prop: string, type: string) => {
      if (type === 'boolean') { return `ISNULL(CAST(JSON_VALUE(d.doc, N'$."${prop}"') AS BIT), 0) "${prop}"`; }
      if (type === 'number') { return `CAST(JSON_VALUE(d.doc, N'$."${prop}"') AS MONEY) "${prop}"`; }
      return `JSON_VALUE(d.doc, N'$."${prop}"') "${prop}"`;
    };

    const leftJoin = (prop: string, type: string) =>
      ` LEFT JOIN "Documents" "${prop}" ON "${prop}".id = CAST(JSON_VALUE(d.doc, N'$."${prop}"') AS UNIQUEIDENTIFIER)`;

    const simlePropertyField = (prop: string, type: string, isCommon: boolean) => {
      if (isCommon) return `d.${prop}`;
      if (type === 'boolean') { return `ISNULL(CAST(JSON_VALUE(d.doc, N'$."${prop}"') AS BIT), 0)`; }
      if (type === 'number') { return `CAST(JSON_VALUE(d.doc, N'$."${prop}"') AS MONEY)`; }
      return `JSON_VALUE(d.doc, N'$."${prop}"')`;
    };

    const complexPropertyField = (prop: string, isCommon: boolean) => isCommon ? `d.${prop}` : `JSON_VALUE(d.doc, N'$."${prop}"')`;

    const queryOb: { fields: string[], joins: string[] } = { fields: [], joins: [] };
    const commonProps = Object.keys(new DocumentBase);
    commonProps.push('type');

    const props = Object.keys(schema)
      .filter(key => schema[key].type !== 'table' && key !== 'workflow')
      .map(key => ({
        key: key,
        type: schema[key].type.toString(),
        isCommon: commonProps.includes(key),
        isComplex: Type.isRefType(schema[key].type.toString()),
        filter: listFilter.find(filter => filter.left === key)
      }));

    for (const prop of props) {
      if (prop.filter) prop.filter.left = prop.isComplex ? complexPropertyField(prop.key, prop.isCommon) : simlePropertyField(prop.key, prop.type, prop.isCommon);
      if (prop.isCommon) queryOb.fields.push(`d."${prop.key}" "${prop.key}"`);
      else queryOb.fields.push(jsonProp(prop.key, prop.type));
      if (prop.isComplex) queryOb.joins.push(leftJoin(prop.key, prop.type));
    }

    return `
    SELECT
    d.id "Object",
    ${queryOb.fields.join(`,\n`)}
    FROM "Documents" d
    ${queryOb.joins.join(`\n`)}
    WHERE ${filterBuilder(listFilter, '').where}`.trim();
  }

  async getRecieverType(): Promise<DocTypes | string> {
    if (this.OperationType) return 'Document.Operation';
    let result = '';
    if (this.CatalogType) {
      const ob = await lib.doc.byId(this.CatalogType, this.getTX());
      if (ob) result = ob.type;
    }
    return result;
  }

  getRecieverProps = async (): Promise<{ [x: string]: PropOptions }> => (await this.getRecieverServDoc()).Props();
  getRecieverProp = async (): Promise<DocumentOptions> => (await this.getRecieverServDoc()).Prop() as DocumentOptions;

  async getRecieverServDoc(): Promise<DocumentBaseServer> {
    const type = await this.getRecieverType() as DocTypes;
    const Operation: string | undefined = this.OperationType || undefined;
    if (!type) throw new Error('Не задан тип приемника');
    const sdbl = new MSSQL(TASKS_POOL, this.user);
    const doc = (Operation ?
      { ...createDocument(type), Operation } :
      createDocument(type)) as DocumentBase;
    const ServerDoc = await createDocumentServer(type, doc, sdbl);
    if (!ServerDoc) throw new Error(`wrong type ${type}`);
    return ServerDoc;
  }

  async ReadRecieverStructure() {

    const type = await this.getRecieverType() as DocTypes;
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
    // this.user.isAdmin = this.SaveInAdminMode;
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
