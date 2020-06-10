import { CatalogEmployeeServer } from './Catalogs/Catalog.Employee.server';
import { CatalogStaffingTableServer } from './Catalogs/Catalog.StaffingTable.server';
import { lib } from '../std.lib';
import { createDocument, IFlatDocument, RegisteredDocumentType } from './../models/documents.factory';
import { CatalogOperation } from './Catalogs/Catalog.Operation';
import { CatalogOperationServer } from './Catalogs/Catalog.Operation.server';
import { calculateDescription, RefValue, PatchValue, MenuItem } from './common-types';
import { DocumentBase, DocumentOptions, Ref } from './document';
import { DocTypes } from './documents.types';
import { DocumentExchangeRatesServer } from './Documents/Document.ExchangeRates.server';
import { DocumentInvoiceServer } from './Documents/Document.Invoce.server';
import { DocumentOperation } from './Documents/Document.Operation';
import { DocumentOperationServer } from './Documents/Document.Operation.server';
import { DocumentPriceListServer } from './Documents/Document.PriceList.server';
import { DocumentSettingsServer } from './Documents/Document.Settings.server';
import { DocumentUserSettingsServer } from './Documents/Document.UserSettings.server';
import { MSSQL } from '../mssql';
import { DocumentWorkFlowServer } from './Documents/Document.WorkFlow.server';
import { DocumentCashRequestServer } from './Documents/Document.CashRequest.server';
import { PostResult } from './post.interfaces';
import { DocumentCashRequestRegistryServer } from './Documents/Document.CashRequestRegistry.server';

export interface IServerDocument {
  onCreate?(tx: MSSQL): Promise<DocumentBaseServer>;
  onCopy?(tx: MSSQL): Promise<DocumentBaseServer>;

  beforeSave?(tx: MSSQL): Promise<DocumentBaseServer>;
  afterSave?(tx: MSSQL): Promise<DocumentBaseServer>;

  beforePost?(tx: MSSQL): Promise<DocumentBaseServer>;
  onUnPost?(tx: MSSQL): Promise<DocumentBaseServer>;
  onPost?(tx: MSSQL): Promise<PostResult>;
  afterPost?(tx: MSSQL): Promise<DocumentBaseServer>;

  beforeDelete?(tx: MSSQL): Promise<DocumentBaseServer>;
  afterDelete?(tx: MSSQL): Promise<DocumentBaseServer>;

  onValueChanged?(prop: string, value: any, tx: MSSQL): Promise<DocumentBaseServer>;
  onCommand?(command: string, args: any, tx: MSSQL): Promise<any>;

  baseOn?(id: Ref, tx: MSSQL, params?: any): Promise<DocumentBaseServer>;
}

export type DocumentBaseServer = DocumentBase & IServerDocument;

export const RegisteredServerDocument: RegisteredDocumentType[] = [
  { type: 'Catalog.Operation', Class: CatalogOperationServer },
  { type: 'Catalog.StaffingTable', Class: CatalogStaffingTableServer },
  { type: 'Catalog.Employee', Class: CatalogEmployeeServer },
  { type: 'Document.Operation', Class: DocumentOperationServer },
  { type: 'Document.Invoice', Class: DocumentInvoiceServer },
  { type: 'Document.ExchangeRates', Class: DocumentExchangeRatesServer },
  { type: 'Document.PriceList', Class: DocumentPriceListServer },
  { type: 'Document.Settings', Class: DocumentSettingsServer },
  { type: 'Document.UserSettings', Class: DocumentUserSettingsServer },
  { type: 'Document.CashRequest', Class: DocumentCashRequestServer },
  { type: 'Document.WorkFlow', Class: DocumentWorkFlowServer },
  { type: 'Document.CashRequestRegistry', Class: DocumentCashRequestRegistryServer }
];

export async function createDocumentServer<T extends DocumentBaseServer>
  (type: DocTypes, document: IFlatDocument | undefined, tx: MSSQL) {
  let result: T;
  const doc = RegisteredServerDocument.find(el => el.type === type);
  if (doc) {
    const serverResult = <T>new doc.Class;
    const ArrayProps = Object.keys(serverResult).filter(k => Array.isArray(serverResult[k]));
    ArrayProps.forEach(prop => serverResult[prop].length = 0);
    if (document) serverResult.map(document);
    result = serverResult;
  } else {
    result = createDocument<T>(type, document);
  }
  result['serverModule'] = {};

  const Props = Object.assign({}, result.Props());
  // if (document && document.isfolder) {
    // упрощенные метаданные формы для Папки
    // Object.keys(Props).;
    // Props = {
    //   id: Props.id,
    //   type: Props.type,
    //   date: Props.date,
    //   code: Props.code,
    //   description: Props.description,
    //   company: Props.company,
    //   user: Props.user,
    //   posted: Props.posted,
    //   deleted: Props.deleted,
    //   parent: Props.parent,
    //   isfolder: Props.isfolder,
    //   info: Props.info,
    //   timestamp: Props.timestamp
    // };
  // }

  const Prop = { ...result.Prop() as DocumentOptions };
  let Operation: CatalogOperation | null = null;
  let Grop: RefValue | null = null;
  if (result instanceof DocumentOperation && document && document.id) {
    result.f1 = null; result.f2 = null; result.f3 = null;
    Prop.commands = [];
    Prop.copyTo = [];
    if (result.Operation) {
      Operation = await lib.doc.byIdT<CatalogOperation>(result.Operation as string, tx);
      if (!Operation) throw new Error(`Operation with id ${result.Operation} not found!`);
      Grop = await lib.doc.formControlRef(Operation!.Group as string, tx);
      result.Group = Operation!.Group;
      Prop['Group'] = Grop;
      let i = 1;
      (Operation && Operation.Parameters || []).sort((a, b) => (a.order || 0) - (b.order || 0)).forEach(c => {
        if (c.type!.startsWith('Catalog.')) result[`f${i++}`] = result[c.parameter];
        Props[c.parameter] = ({
          label: c.label, type: c.type, required: !!c.required, change: c.change, order: (c.order || 0) + 103,
          [c.parameter]: c.tableDef ? JSON.parse(c.tableDef) : null, ...JSON.parse(c.Props ? c.Props : '{}')
        });
        if (result[c.parameter] === undefined) result[c.parameter] = Props[c.parameter].value;
      });

      Prop.commands = [
        ...(Operation && Operation.commandsOnServer || []),
        ...(Operation && Operation.commandsOnClient || []),
      ];

      Prop.copyTo = [];
      for (const o of ((Operation && Operation.CopyTo) || [])) {
        const base = await lib.doc.byIdT<CatalogOperation>(o.Operation, tx);
        if (base) {
          const item = {
            icon: '',
            label: base.description,
            Operation: o.Operation,
            type: result.type,
            order: o.order || 1
          };
          Prop.copyTo.push(item);
        }
      }
      if (Operation && Operation.module) {
        Prop.module = Operation.module;
        const func = new Function('tx', Operation.module);
        result['serverModule'] = func.bind(result, tx)() || {};

        const onCreate: (tx: MSSQL) => Promise<T> = result['serverModule']['onCreate'];
        if (typeof onCreate === 'function') await onCreate(tx);
      }
    }
  }
  // protect against mutate
  result.Props = () => Props;
  result.Prop = () => Prop;

  if (result.isDoc) result.description =
    calculateDescription((result.Prop() as DocumentOptions).description, result.date, result.code, Grop && Grop.value as string || '');
  return result;
}
