import { JQueue } from '../Tasks/tasks';
import { IServerForm } from './form.factory.server';
import { lib } from '../../std.lib';
import { CatalogCompany } from '../Catalogs/Catalog.Company';
import { MSSQL } from '../../mssql';
import { TASKS_POOL } from '../../sql.pool.tasks';
import { Ref } from '../document';
import { CashRequestDesktop } from './Form.CashRequestDesktop';
import { DocumentCashRequest } from '../Documents/Document.CashRequest';
import { createDocumentServer } from '../documents.factory.server';
import { createDocument } from '../documents.factory';
import { DocumentOperation } from '../Documents/Document.Operation';
import { insertDocument, postDocument } from '../../routes/utils/post';

export default class CashRequestDesktopServer extends CashRequestDesktop implements IServerForm {
  async Execute() {
    return this;
  }


  async Create() {
    this.user.isAdmin  = true;
    const sdbq = new MSSQL(this.user, TASKS_POOL);
    for (const cashRequest of this.CashRequests) {
      // const casheRequestObject = await lib.doc.byIdT<DocumentCashRequest>(cashRequest.CashRequest, sdbq);
      const OperationObject = createDocument<DocumentOperation>('Document.Operation');
      // 770FA450-BB58-11E7-8996-53A59C675CDA - Из кассы -  оплата поставщику (НАЛИЧНЫЕ)
      // 68FA31F0-BDB0-11E7-9C95-E3F9522E1FC9 - С р/с -  оплата поставщику (БЕЗНАЛИЧНЫЕ)
      OperationObject.Operation = '68FA31F0-BDB0-11E7-9C95-E3F9522E1FC9';
      const OperationObjectServer = await createDocumentServer('Document.Operation', OperationObject, sdbq);
      await OperationObjectServer.baseOn!(cashRequest.CashRequest, sdbq);
      const code = await lib.doc.docPrefix(OperationObject.type, sdbq);
      OperationObjectServer.code = code;
      await insertDocument(OperationObjectServer, sdbq);
      await postDocument(OperationObjectServer, sdbq);
    }
  }
}
