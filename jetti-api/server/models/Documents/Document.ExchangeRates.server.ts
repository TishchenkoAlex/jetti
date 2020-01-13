import { RegisterInfoExchangeRates } from '../Registers/Info/ExchangeRates';
import { PostResult } from './../post.interfaces';
import { DocumentExchangeRates } from './Document.ExchangeRates';
import { MSSQL } from '../../mssql';
import { IServerDocument } from '../documents.factory.server';

export class DocumentExchangeRatesServer extends DocumentExchangeRates implements IServerDocument {

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
    for (const row of this.Rates) {
      Registers.Info.push(new RegisterInfoExchangeRates({
          currency: row.Currency,
          Rate: row.Rate,
          Mutiplicity: row.Mutiplicity
        }));
    }
    return Registers;
  }

}
