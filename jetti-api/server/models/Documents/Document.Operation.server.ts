import { MSSQL } from '../../mssql';
import { lib } from '../../std.lib';
import { PatchValue } from '../api';
import { CatalogCompany } from '../Catalogs/Catalog.Company';
import { CatalogOperation } from '../Catalogs/Catalog.Operation';
import { createDocumentServer } from '../documents.factory.server';
import { RegisterInfoSettings } from '../Registers/Info/Settings';
import { ServerDocument } from '../ServerDocument';
import { JQueue } from '../Tasks/tasks';
import { PostResult } from './../post.interfaces';
import { DocumentOperation } from './Document.Operation';

export class DocumentOperationServer extends DocumentOperation implements ServerDocument {

  async onValueChanged(prop: string, value: any, tx: MSSQL): Promise<PatchValue | {} | { [key: string]: any }> {
    if (!value) { return {}; }
    switch (prop) {
      case 'company':
        const company = await lib.doc.byIdT<CatalogCompany>(value.id, tx);
        if (!company) { return {}; }
        const currency = await lib.doc.formControlRef(company.currency!, tx);
        return { currency };
      case 'Operation':
        const Operation = await lib.doc.byIdT<CatalogOperation>(value.id, tx);
        if (!Operation) { return {}; }
        const Group = await lib.doc.formControlRef(Operation.Group!, tx);
        return { Group };
      default:
        return {};
    }
  }

  async onCommand(command: string, args: any, tx: MSSQL) {
    switch (command) {
      case 'company':
        return {};
      default:
        return {};
    }
  }

  async onPost(tx: MSSQL) {
    const Registers: PostResult = { Account: [], Accumulation: [], Info: [] };

    if (this.posted && !this.deleted) {
      const query = `
        SELECT (SELECT "script" FROM OPENJSON(doc) WITH ("script" NVARCHAR(MAX) '$."script"')) "script"
        FROM "Documents" WHERE id = '${this.Operation}'`;
      const Operation = await tx.oneOrNone<{ script: string }>(query);
      const exchangeRate = await lib.info.exchangeRate(this.date, this.company, this.currency, tx);
      const settings = await lib.info.sliceLast<RegisterInfoSettings>('Settings', this.date, this.company, {}, tx) || {};
      const accountingCurrency = settings.accountingCurrency || this.currency;
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

    const oldInventory = ((this['deletedRegisterAccumulation'] && <any[]>this['deletedRegisterAccumulation']()) || [])
      .filter(r => r.type === 'Register.Accumulation.Inventory' && r.kind === true);

    const newInventory = (Registers.Accumulation || [])
      .filter(r => r.type === 'Register.Accumulation.Inventory' && r.kind === true)
      .map(r => ({...r, date: r.date ? r.date : this.date}));

    if (!(oldInventory.length || newInventory.length)) return Registers;

    await JQueue.add({
      job: { id: 'cost', description: `${this.description}` },
      doc: this,
      Inventory: [oldInventory, newInventory],
    });
    return Registers;
  }

  async baseOn(source: string, tx: MSSQL) {
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
        case 'Catalog.Operation':
          this.Operation = (sourceDoc as CatalogOperation).id;
          this.Group = (sourceDoc as CatalogOperation).Group;
          break;
        default:
          break;
      }
    }
    return this;
  }

}
