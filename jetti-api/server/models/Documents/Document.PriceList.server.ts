import { lib } from '../../std.lib';
import { CatalogPriceType } from '../Catalogs/Catalog.PriceType';
import { createDocumentServer, IServerDocument } from '../documents.factory.server';
import { RegisterInfoPriceList } from '../Registers/Info/PriceList';
import { PostResult } from './../post.interfaces';
import { DocumentInvoice } from './Document.Invoice';
import { DocumentPriceList } from './Document.PriceList';
import { MSSQL } from '../../mssql';

export class DocumentPriceListServer extends DocumentPriceList implements IServerDocument {

  async onValueChanged(prop: string, value: any, tx: MSSQL) {
    switch (prop) {
      case 'company':
        return this;
      case 'PriceType':
        const priceType = await lib.doc.byIdT<CatalogPriceType>(value.id, tx);
        if (priceType) this.TaxInclude = priceType.TaxInclude;
        return this;
      default:
        return this;
    }
  }

  async onCommand(command: string, args: any, tx: MSSQL): Promise<{ [x: string]: any }> {
    switch (command) {
      case 'company':
        return {};
      default:
        return {};
    }
  }

  async baseOn(source: string, tx: MSSQL): Promise<this> {
    const ISource = await lib.doc.byId(source, tx);
    if (!ISource) return this;
    switch (ISource.type) {
      case 'Document.Invoice':
        const documentInvoice = await createDocumentServer<DocumentInvoice>(ISource.type, ISource, tx);
        const unitID = await lib.doc.byCode('Catalog.Unit', 'bottle', tx);
        this.parent = ISource.id;
        this.Items = documentInvoice.Items.map(r => ({ SKU: r.SKU, Price: r.Price, Unit: unitID }));
        this.TaxInclude = true;
        this.company = documentInvoice.company;
        this.PriceType = documentInvoice.Items[0].PriceType;
        this.posted = false;
        return this;
      default:
        return this;
    }
  }

  async onPost(tx: MSSQL) {
    const Registers: PostResult = { Account: [], Accumulation: [], Info: [] };

    const priceType = await lib.doc.byIdT<CatalogPriceType>(this.PriceType as string, tx);
    for (const row of this.Items) {
      Registers.Info.push(new RegisterInfoPriceList({
        currency: priceType!.currency,
        PriceType: this.PriceType,
        Product: row.SKU,
        Price: row.Price,
        Unit: row.Unit
      }));
    }
    return Registers;
  }

}
