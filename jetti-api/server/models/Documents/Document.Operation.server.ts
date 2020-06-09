import { lib } from '../../std.lib';
import { CatalogCompany } from '../Catalogs/Catalog.Company';
import { CatalogOperation } from '../Catalogs/Catalog.Operation';
import { createDocumentServer, IServerDocument, DocumentBaseServer } from '../documents.factory.server';
import { RegisterInfoSettings } from '../Registers/Info/Settings';
import { PostResult } from './../post.interfaces';
import { DocumentOperation } from './Document.Operation';
import { MSSQL } from '../../mssql';
import { DocumentCashRequestServer } from './Document.CashRequest.server';

export class DocumentOperationServer extends DocumentOperation implements IServerDocument {

  async onValueChanged(prop: string, value: any, tx: MSSQL): Promise<DocumentBaseServer> {
    switch (prop) {
      case 'company':
        const company = await lib.doc.byIdT<CatalogCompany>(value.id, tx);
        if (company) this.currency = company.currency;
        return this;
      case 'Operation':
        const Operation = await lib.doc.byIdT<CatalogOperation>(value.id, tx);
        if (Operation) this.Group = Operation.Group!;
        return this;
      default:
        return this;
    }
  }

  async onCopy(tx: MSSQL) {
    this.parent = null;
    return this;
  }

  async beforePost(tx: MSSQL) {
    // запрет проведения с 0 суммой для группы 1.0 - Приобретение товаров и услуг
    if ((!this.Amount || this.Amount < 0.01) && this.Group === 'E74FF926-C149-11E7-BD8F-43B2F3011722') throw new Error(`${this.description} не может быть проведен: не заполнена сумма документа`);
    if (!this.parent) return this;
    const parentDoc = (await lib.doc.byId(this.parent, tx));
    if (!parentDoc) return this;
    switch (parentDoc.type) {
      case 'Document.CashRequest':
        const CashRequestServer = await createDocumentServer<DocumentCashRequestServer>('Document.CashRequest', parentDoc, tx);
        await CashRequestServer.beforePostDocumentOperation(this, tx);
        break;
      default:
        break;
    }
    return this;
  }

  async onPost(tx: MSSQL) {
    const Registers: PostResult = { Account: [], Accumulation: [], Info: [] };

    if (this.posted && !this.deleted) {
      const query = `
        SELECT (SELECT "script" FROM OPENJSON(doc) WITH ("script" NVARCHAR(MAX) '$."script"')) "script"
        FROM "Documents" WHERE id = @p1`;
      const Operation = await tx.oneOrNone<{ script: string }>(query, [this.Operation]);
      const exchangeRate = await lib.info.exchangeRate(this.date, this.company, this.currency, tx);
      const settings = await lib.info.sliceLast<RegisterInfoSettings>('Settings', this.date, this.company, {}, tx);
      const accountingCurrency = settings && settings.accountingCurrency || this.currency;
      const exchangeRateAccounting = await lib.info.exchangeRate(this.date, this.company, accountingCurrency, tx);
      const script = `
      let exchangeRateBalance = exchangeRate;
      let AmountInBalance = doc.Amount / exchangeRate;
      let AmountInAccounting = doc.Amount / exchangeRateAccounting;
      ${ Operation!.script
          .replace(/\$\./g, 'doc.')
          .replace(/tx\./g, 'await tx.')
          .replace(/lib\./g, 'await lib.')
          .replace(/\'doc\./g, '\'$.')}
      `;
      const AsyncFunction = Object.getPrototypeOf(async function () { }).constructor;
      const func = new AsyncFunction('doc, Registers, tx, lib, settings, exchangeRate, exchangeRateAccounting', script);
      await func(this, Registers, tx, lib, settings, exchangeRate, exchangeRateAccounting);
    }

    return Registers;
  }

  async baseOn(source: string, tx: MSSQL, params?: any) {

    const rawDoc = await lib.doc.byId(source, tx);
    if (!rawDoc) return this;

    const sourceDoc = await createDocumentServer(rawDoc.type, rawDoc, tx);

    if (sourceDoc instanceof DocumentOperationServer) {
      const Operation = await lib.doc.byIdT<CatalogOperation>(sourceDoc.Operation as string, tx);
      const Rule = Operation!.CopyTo.find(c => c.Operation === this.Operation);
      if (Rule) {
        const script = `
        this.company = doc.company;
        this.currency = doc.currency;
        this.parent = doc.id;
        ${ Rule.script
            .replace(/\$\./g, 'doc.')
            .replace(/tx\./g, 'await tx.')
            .replace(/lib\./g, 'await lib.')
            .replace(/\'doc\./g, '\'$.')}
          `;
        const AsyncFunction = Object.getPrototypeOf(async function () { }).constructor;
        const func = new AsyncFunction('doc, tx, lib', script) as Function;
        await func.bind(this, sourceDoc, tx, lib)();
      }
    } else {
      switch (sourceDoc.type) {
        case 'Catalog.Counterpartie':
          break;
        case 'Document.CashRequest':
          await (sourceDoc as DocumentCashRequestServer).FillDocumentOperation(this, tx, params);
          break;
        case 'Catalog.Operation':
          this.Operation = (sourceDoc as CatalogOperation).id;
          this.Group = (sourceDoc as CatalogOperation).Group;
          break;
        default:
          break;
      }
    }
    const doc = await (createDocumentServer(this.type, this, tx));
    const Props = doc.Props();
    const Prop = doc.Prop();
    this.description = doc.description;
    this.Props = () => Props;
    this.Prop = () => Prop;
    return this;
  }
}
