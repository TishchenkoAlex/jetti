import { CatalogCounterpartie } from '../../models/Catalogs/Catalog.Counterpartie';
import { DocumentBase } from '../../models/document';
import { MSSQL } from '../../mssql';
import { lib } from '../../std.lib';
import { CatalogCompany } from '../Catalogs/Catalog.Company';
import { createDocumentServer } from '../documents.factory.server';
import { RegisterAccumulationAR } from '../Registers/Accumulation/AR';
import { RegisterAccumulationBalance } from '../Registers/Accumulation/Balance';
import { RegisterAccumulationInventory } from '../Registers/Accumulation/Inventory';
import { RegisterAccumulationPL } from '../Registers/Accumulation/PL';
import { RegisterAccumulationSales } from '../Registers/Accumulation/Sales';
import { ServerDocument } from '../ServerDocument';
import { PostResult } from './../post.interfaces';
import { DocumentInvoice } from './Document.Invoice';

export class DocumentInvoiceServer extends DocumentInvoice implements ServerDocument {

  async GetPrice(args: any, tx: MSSQL): Promise<{ doc: DocumentBase, result: any }> {
    this.Amount = 0;
    for (const row of this.Items) {
      row.Price = 100;
      row.Amount = row.Qty * row.Price;
      this.Amount += row.Amount;
    }
    return { doc: this, result: {} };
  }

  async onValueChanged(prop: string, value: any, tx: MSSQL): Promise<{ [x: string]: any }> {
    switch (prop) {
      case 'company':
        if (!value) { return {}; }
        const company = await lib.doc.byIdT<CatalogCompany>(value.id, tx);
        if (!company) { return {}; }
        const currency = await lib.doc.formControlRef(company.currency as string, tx);
        this.currency = currency ? currency.id : null;
        return { currency };
      default:
        return {};
    }
  }

  async onCommand(command: string, args: any, tx: MSSQL) {
    switch (command) {
      case 'company':
        return args;
      default:
        return {};
    }
  }

  async baseOn(source: string, tx: MSSQL): Promise<DocumentBase> {
    const ISource = await lib.doc.byId(source, tx);
    if (!ISource) return this;
    switch (ISource.type) {
      case 'Catalog.Counterpartie':
        const catalogCounterpartie = await createDocumentServer<CatalogCounterpartie>(ISource.type, ISource, tx);
        this.Customer = catalogCounterpartie.id;
        return this;
      default:
        return this;
    }
  }

  async onPost(tx: MSSQL): Promise<PostResult> {
    const Registers: PostResult = { Account: [], Accumulation: [], Info: [] };

    const acc90 = await lib.account.byCode('90.01', tx);
    const acc41 = await lib.account.byCode('41.01', tx);
    const acc62 = await lib.account.byCode('62.01', tx);
    const ExpenseCOST = await lib.doc.byCode('Catalog.Expense', 'OUT.COST', tx);
    const IncomeSALES = await lib.doc.byCode('Catalog.Income', 'SALES', tx);
    const PL = await lib.doc.byCode('Catalog.Balance', 'PL', tx);
    const AR = await lib.doc.byCode('Catalog.Balance', 'AR', tx);
    const INVENTORY = await lib.doc.byCode('Catalog.Balance', 'INVENTORY', tx);

    const exchangeRate = await lib.info.exchangeRate(this.date, this.company, this.currency, tx) || 1;

    // AR
    Registers.Accumulation.push(new RegisterAccumulationAR(true, {
      AO: this.id,
      Department: this.Department,
      Customer: this.Customer,
      AR: this.Amount,
      AmountInBalance: this.Amount / exchangeRate,
      AmountInAccounting: this.Amount,
      PayDay: this.PayDay,
      currency: this.currency
    }));

    Registers.Account.push({
      debit: { account: acc62, subcounts: [this.Customer] },
      kredit: { account: acc90, subcounts: [] },
      sum: this.Amount,
    });

    let totalCost = 0;

    let batchRows: any[] = [];
    for (const row of this.Items) {

      batchRows = await lib.inventory.batchRows(this.date, this.company, this.Storehouse, row.SKU, row.Qty, batchRows, tx);
      for (const batchRow of batchRows) {

        Registers.Accumulation.push(new RegisterAccumulationInventory(false, {
          Expense: ExpenseCOST,
          Storehouse: this.Storehouse,
          batch: batchRow.batch,
          SKU: batchRow.SKU,
          Cost: batchRow.Cost,
          Qty: batchRow.Qty
        }));

        totalCost += batchRow.Cost;

        // Account
        Registers.Account.push({
          debit: { account: acc90, subcounts: [] },
          kredit: { account: acc41, subcounts: [this.Storehouse, row.SKU], qty: row.Qty },
          sum: batchRow.Cost,
        });

        Registers.Accumulation.push(new RegisterAccumulationSales(true, {
          AO: this.id,
          Department: this.Department,
          Customer: this.Customer,
          Product: row.SKU,
          Manager: this.Manager,
          Storehouse: this.Storehouse,
          Qty: row.Qty,
          Amount: row.Amount / exchangeRate * batchRow.rate,
          AmountInAR: row.Amount * batchRow.rate,
          AmountInDoc: row.Amount * batchRow.rate,
          Cost: batchRow.Cost,
          Discount: 0,
          Tax: row.Tax / exchangeRate * batchRow.rate,
          currency: this.currency
        }));

        Registers.Accumulation.push(new RegisterAccumulationPL(true, {
          Department: this.Department,
          PL: IncomeSALES,
          Analytics: row.SKU,
          Amount: row.Amount * batchRow.rate / exchangeRate,
        }));

        Registers.Accumulation.push(new RegisterAccumulationPL(false, {
          Department: this.Department,
          PL: ExpenseCOST,
          Analytics: row.SKU,
          Amount: batchRow.Cost,
        }));
      }
    }

    Registers.Accumulation.push(new RegisterAccumulationBalance(true, {
      Department: this.Department,
      Balance: AR,
      Analytics: this.Customer,
      Amount: this.Amount / exchangeRate
    }));

    Registers.Accumulation.push(new RegisterAccumulationBalance(false, {
      Department: this.Department,
      Balance: INVENTORY,
      Analytics: this.Storehouse,
      Amount: totalCost
    }));

    Registers.Accumulation.push(new RegisterAccumulationBalance(true, {
      Department: this.Department,
      Balance: PL,
      Analytics: ExpenseCOST,
      Amount: totalCost
    }));

    Registers.Accumulation.push(new RegisterAccumulationBalance(false, {
      Department: this.Department,
      Balance: PL,
      Analytics: IncomeSALES,
      Amount: this.Amount / exchangeRate,
    }));

    return Registers;
  }

}
