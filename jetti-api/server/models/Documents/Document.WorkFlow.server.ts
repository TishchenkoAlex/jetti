import { lib } from '../../std.lib';
import { createDocumentServer, IServerDocument } from '../documents.factory.server';
import { MSSQL } from '../../mssql';
import { DocumentWorkFlow } from './Document.WokrFlow';
import { DocumentOperation } from './Document.Operation';
import { PostResult } from '../post.interfaces';
import { Ref } from '../document';

export class DocumentWorkFlowServer extends DocumentWorkFlow implements IServerDocument {

  async onValueChanged(prop: string, value: any, tx: MSSQL): Promise<{ [x: string]: any }> {
    switch (prop) {
      case 'company':
        return {};
      default:
        return {};
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

  async baseOn(source: Ref, tx: MSSQL): Promise<this> {
    const ISource = await lib.doc.byId(source, tx);
    if (!ISource) return this;
    const documentOperation = await createDocumentServer(ISource.type, ISource, tx);
    this.parent = ISource.id;
    this.Document = ISource.id;
    this.company = documentOperation.company;
    this.user = documentOperation.user;
    this.Status = 'PREPARED';
    this.posted = false;
    return this;
  }

  async onPost(tx: MSSQL) {
    const Registers: PostResult = { Account: [], Accumulation: [], Info: [] };
    return Registers;
  }

}
