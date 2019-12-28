import { PostResult } from '../post.interfaces';
import { MSSQL } from '../../mssql';
import { IServerDocument } from '../documents.factory.server';
import { DocumentCashRequestRegistry, CashRequest } from './Document.CashRequestRegistry';

export class DocumentCashRequestRegistryServer extends DocumentCashRequestRegistry implements IServerDocument {

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
      case 'Fill':
        this.CashRequests.push({
          Amount: 1,
          AmountBalance: 1,
          AmountPaid: 2,
          AmountRequest: 3,
          BankAccount: null,
          CashRecipient: null,
          CashRequest: null,
          CashRequestAmount: 22,
          Confirm: true,
          Delayed: 2,
          company: this.company,
        });
        this.Amount = 1;
        return {
          ...this
        };
      default:
        return {};
    }
  }

  async onPost(tx: MSSQL) {
    const Registers: PostResult = { Account: [], Accumulation: [], Info: [] };
    for (const row of this.CashRequests) {
    }
    return Registers;
  }

}
