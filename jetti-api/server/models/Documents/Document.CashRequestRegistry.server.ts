import { PostResult } from '../post.interfaces';
import { MSSQL } from '../../mssql';
import { IServerDocument, createDocumentServer } from '../documents.factory.server';
import { DocumentCashRequestRegistry, CashRequest } from './Document.CashRequestRegistry';
import { RegisterAccumulationCashToPay } from '../Registers/Accumulation/CashToPay';
import { lib } from '../../std.lib';
import { DocumentCashRequest } from './Document.CashRequest';
import { createDocument } from '../documents.factory';
import { insertDocument, updateDocument } from '../../routes/utils/post';
import { BankStatementUnloader } from '../../fuctions/BankStatementUnloader';

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
        await this.Fill(tx);
        return this;
      case 'Create':
        await this.Create(tx);
        return this;
      case 'UnloadToText':
        await this.UnloadToText(tx);
        return this;
      default:
        return this;
    }
  }

  private async Create(tx: MSSQL) {
    if (this.Status !== 'APPROVED') throw new Error(`Creating is possible only in the APPROVED document!`);
    for (const row of this.CashRequests.filter(c => (c.Amount > 0))) {
      let Operation: DocumentCashRequest | null;
      if (row.LinkedDocument) {
        Operation = await lib.doc.byIdT<DocumentCashRequest>(row.LinkedDocument, tx);
      } else {
        Operation = createDocument<DocumentCashRequest>('Document.Operation');
      }
      const OperationServer = await createDocumentServer('Document.Operation', Operation!, tx);
      if (!OperationServer.code) OperationServer.code = await lib.doc.docPrefix(OperationServer.type, tx);
      // исключение ошибки при проверке заполненности счета в базеон
      if (row.CashRecipientBankAccount) OperationServer['BankAccountSupplier'] = row.CashRecipientBankAccount;
      await OperationServer.baseOn!(row.CashRequest, tx);
      // переопределение счета
      if (row.CashRecipientBankAccount) OperationServer['BankAccountSupplier'] = row.CashRecipientBankAccount;
      OperationServer['Amount'] = row.Amount;
      if (row.LinkedDocument) await updateDocument(OperationServer, tx); else await insertDocument(OperationServer, tx);
      await lib.doc.postById(OperationServer.id, tx);
      row.LinkedDocument = OperationServer.id;
    }
    // this.Post(true, tx);
    await updateDocument(this, tx);
    await lib.doc.postById(this.id, tx);
  }

  private async UnloadToText(tx: MSSQL) {
    if (this.Status !== 'APPROVED') throw new Error(`Creating is possible only in the APPROVED document!`);
    const CashRequests = this.CashRequests.filter(c => (c.LinkedDocument!)).map(c => (c.LinkedDocument));
    this.info = await BankStatementUnloader.getBankStatementAsString(CashRequests, tx);
    await updateDocument(this, tx);
    await lib.doc.postById(this.id, tx);
  }

  private async Fill(tx: MSSQL) {
    if (this.Status !== 'PREPARED') throw new Error(`Filling is possible only in the PREPARED document!`);
    this.CashRequests = [];
    const query = `
      SELECT
        Balance.[currency] AS сurrency,
        Balance.[CashRequest] AS CashRequest,
        SUM(Balance.[Amount]) AS AmountBalance
      INTO #CashRequestBalance
      FROM [dbo].[Register.Accumulation.CashToPay] AS Balance -- WITH (NOEXPAND)
      WHERE (1 = 1)
        AND (Balance.[company]  IN (SELECT id FROM dbo.[Descendants](@p1, '')) OR @p1 IS NULL)
        AND (Balance.[CashFlow] IN (SELECT id FROM dbo.[Descendants](@p2, '')) OR @p2 IS NULL)
        -- AND Balance.[OperationType] IN (@p4)
        AND Balance.[currency] = @p3
      GROUP BY
        Balance.[currency], Balance.[CashRequest]
      HAVING SUM(Balance.[Amount]) > 0
      SELECT
        CRT.[CashRequest] AS CashRequest
       , CAST(DocCR.[Amount] AS MONEY) AS CashRequestAmount
       , -(CAST(CRT.[AmountBalance] - DocCR.[Amount] AS MONEY)) AS AmountPaid
       , CRT.[AmountBalance] AS AmountBalance
       , CAST(0 AS MONEY) AS AmountRequest
       , DATEDIFF(DAY, GETDATE(), DocCR.[PayDay]) AS Delayed
       , CAST(0 AS MONEY) AS Amount
       , CAST(0 AS BIT) AS Confirm
       , DocCR.[CashRecipient.id] AS CashRecipient
       , DocCR.[company.id] AS company
       , DocCR.[CashOrBank.id] AS BankAccount
       , DocCR.[CashRecipientBankAccount.id] AS CashRecipientBankAccount
       , (SELECT COUNT(*) FROM [dbo].[Catalog.Counterpartie.BankAccount] AS CBA
          WHERE CBA.[owner.id] = DocCR.[CashRecipient.id] AND CBA.[currency.id] = DocCR.[сurrency.id] AND CBA.[deleted] = 0) AS CountOfBankAccountCashRecipient
       , null as LinkedDocument
      FROM #CashRequestBalance AS CRT
      LEFT JOIN [dbo].[Document.CashRequest] AS DocCR ON DocCR.[id] = CRT.[CashRequest]
      ORDER BY Delayed, AmountBalance DESC;`;

    const CashRequests = await tx.manyOrNone<CashRequest>(query, [this.company, this.CashFlow, this.сurrency]);
    for (const row of CashRequests) {
      this.CashRequests.push({
        Amount: row.Amount,
        AmountBalance: row.AmountBalance,
        AmountPaid: row.AmountPaid,
        AmountRequest: row.AmountBalance,
        BankAccount: row.BankAccount,
        CashRecipient: row.CashRecipient,
        CashRequest: row.CashRequest,
        CashRequestAmount: row.CashRequestAmount,
        Confirm: row.Confirm,
        Delayed: row.Delayed,
        company: row.company,
        CashRecipientBankAccount: row.CashRecipientBankAccount,
        CountOfBankAccountCashRecipient: row.CountOfBankAccountCashRecipient,
        LinkedDocument: null
      });
    }
    CashRequests.forEach(row => this.Amount += row.Amount);
  }

  async onPost(tx: MSSQL) {
    const Registers: PostResult = { Account: [], Accumulation: [], Info: [] };

    if (this.Status === 'REJECTED') return Registers;

    for (const row of this.CashRequests
      .filter(c => (c.AmountRequest > 0 || c.Amount > 0) && !c.LinkedDocument)) {
      if ((row.AmountRequest > row.AmountBalance) ||
        (row.Amount > row.AmountBalance)) {
        throw new Error('field [AmountRequest] or [Amount] is out of [AmountBalance]!');
      }
      const CashRequestObject = (await lib.doc.byIdT<DocumentCashRequest>(row.CashRequest, tx))!;
      Registers.Accumulation.push(new RegisterAccumulationCashToPay({
        kind: false,
        CashRecipient: row.CashRecipient,
        Amount: ['PREPARED', 'AWAITING'].indexOf(this.Status) > -1 ? row.AmountRequest : row.Amount,
        PayDay: CashRequestObject.PayDay,
        CashRequest: row.CashRequest,
        currency: this.сurrency,
        CashFlow: this.CashFlow,
        OperationType: CashRequestObject.Operation,
      }));
    }
    Registers.Accumulation = Registers.Accumulation.filter((r: RegisterAccumulationCashToPay) => r.Amount > 0);
    return Registers;
  }

}
