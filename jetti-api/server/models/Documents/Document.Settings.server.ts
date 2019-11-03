import { RegisterInfoSettings } from '../Registers/Info/Settings';
import { ServerDocument } from '../ServerDocument';
import { PostResult } from './../post.interfaces';
import { DocumentSettings } from './Document.Settings';
import { MSSQL } from '../../mssql';

export class DocumentSettingsServer extends DocumentSettings implements ServerDocument {

  async onValueChanged(prop: string, value: any, tx: MSSQL) {
    switch (prop) {
      case 'company':
        return {};
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
    Registers.Info.push(new RegisterInfoSettings({
      accountingCurrency: this.accountingCurrency,
      balanceCurrency: this.balanceCurrency,
    }));
    return Registers;
  }

}

