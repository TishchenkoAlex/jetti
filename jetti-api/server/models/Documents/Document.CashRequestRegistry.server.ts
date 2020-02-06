// tslint:disable: max-line-length
import { PostResult } from '../post.interfaces';
import { MSSQL } from '../../mssql';
import { IServerDocument, createDocumentServer, DocumentBaseServer } from '../documents.factory.server';
import { DocumentCashRequestRegistry, CashRequest } from './Document.CashRequestRegistry';
import { RegisterAccumulationCashToPay } from '../Registers/Accumulation/CashToPay';
import { lib } from '../../std.lib';
import { DocumentCashRequest } from './Document.CashRequest';
import { createDocument } from '../documents.factory';
import { insertDocument, updateDocument } from '../../routes/utils/post';
import { BankStatementUnloader } from '../../fuctions/BankStatementUnloader';
import { DocumentOperation } from './Document.Operation';

export class DocumentCashRequestRegistryServer extends DocumentCashRequestRegistry implements IServerDocument {

  async onValueChanged(prop: string, value: any, tx: MSSQL): Promise<DocumentBaseServer> {
    switch (prop) {
      case 'Operation':
        const Props = this.Props() as any;
        Props.CashRequests.CashRequests.BankAccountIn = {
          ...Props.CashRequests.CashRequests.BankAccountIn, hidden: this.Operation !== 'Оплата ДС в другую организацию'
        };
        Props.CashRequests.CashRequests.CashRecipientBankAccount = {
          ...Props.CashRequests.CashRequests.CashRecipientBankAccount, hidden: this.Operation === 'Оплата ДС в другую организацию'
        };
        this.Props = () => Props;
        return this;
      default:
        return this;
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
    await lib.doc.postById(this.id, tx);
    const rowsWithAmount = this.CashRequests.filter(c => (c.Amount > 0));

    let Operation: DocumentOperation | null;
    let BankAccountSupplier, currentCR, addBaseOnParams, LinkedDocument;

    for (const row of rowsWithAmount) {
      if (currentCR === row.CashRequest) continue;
      addBaseOnParams = [];
      LinkedDocument = row.LinkedDocument;
      currentCR = row.CashRequest;
      if (this.Operation === 'Выплата заработной платы') {
        rowsWithAmount.filter(el => (el.CashRequest === currentCR)).forEach(el => {
          addBaseOnParams.push({ CashRecipient: el.CashRecipient, BankAccountPerson: el.BankAccountPerson, Amount: el.Amount });
          if (el.LinkedDocument) LinkedDocument = el.LinkedDocument;
        });
      }
      if (LinkedDocument) {
        Operation = await lib.doc.byIdT<DocumentOperation>(LinkedDocument, tx);
      } else {
        Operation = createDocument<DocumentOperation>('Document.Operation');
      }
      const OperationServer = await createDocumentServer('Document.Operation', Operation!, tx);
      if (!OperationServer.code) OperationServer.code = await lib.doc.docPrefix(OperationServer.type, tx);
      if (this.Operation !== 'Выплата заработной платы') {
        // исключение ошибки при проверке заполненности счета в базеон
        if (row.CashRecipientBankAccount) OperationServer['BankAccountSupplier'] = row.CashRecipientBankAccount;
        if (row.BankAccount) OperationServer['BankAccount'] = row.BankAccount;
        BankAccountSupplier =
          this.Operation === 'Оплата ДС в другую организацию' ? row.BankAccountIn : row.CashRecipientBankAccount;
        if (this.Operation === 'Оплата по кредитам и займам полученным' && row.BankAccount) OperationServer['BankAccount'] = row.BankAccount;
        OperationServer['BankAccountSupplier'] = BankAccountSupplier;
      }
      await OperationServer.baseOn!(row.CashRequest, tx, addBaseOnParams);
      // переопределение счета
      if (this.Operation !== 'Выплата заработной платы' && BankAccountSupplier) OperationServer['BankAccountSupplier'] = BankAccountSupplier;
      if (this.Operation !== 'Выплата заработной платы' && this.Operation !== 'Выплата заработной платы без ведомости') OperationServer['Amount'] = row.Amount;
      if (this.Operation === 'Выплата заработной платы без ведомости' && row.Amount < OperationServer['Amount']) OperationServer['Amount'] = row.Amount;
      if (LinkedDocument) await updateDocument(OperationServer, tx); else await insertDocument(OperationServer, tx);
      await lib.doc.postById(OperationServer.id, tx);
      rowsWithAmount.filter(el => (el.CashRequest === currentCR)).forEach(el => { el.LinkedDocument = OperationServer.id });
    }
    // this.Post(true, tx);
    await updateDocument(this, tx);
    await lib.doc.postById(this.id, tx);
  }

  private async UnloadToText(tx: MSSQL) {
    if (this.Status !== 'APPROVED') throw new Error(`Creating is possible only in the APPROVED document!`);
    const Operations = this.CashRequests.filter(c => (c.LinkedDocument)).map(c => (c.LinkedDocument));
    this.info = await BankStatementUnloader.getBankStatementAsString(Operations, tx);
    await updateDocument(this, tx);
    await lib.doc.postById(this.id, tx);
  }

  private async Fill(tx: MSSQL) {
    if (this.Status !== 'PREPARED') throw new Error(`Filling is possible only in the PREPARED document!`);
    this.CashRequests = [];
    const query = `
    DROP TABLE IF EXISTS #CashRequestBalance;
    DROP TABLE IF EXISTS #SalaryAmount;
    
    SELECT
        Balance.[currency] AS сurrency,
        Balance.[CashRequest] AS CashRequest,
        Balance.[CashRecipient] AS CashRecipient,
        SUM(Balance.[Amount]) AS AmountBalance,
        Balance.[OperationType] as OperationType,
        Balance.[BankAccountPerson] as BankAccountPerson
    INTO #CashRequestBalance
    FROM [dbo].[Register.Accumulation.CashToPay] AS Balance
    WHERE (1 = 1)
        AND (Balance.[company]  IN (SELECT id FROM dbo.[Descendants](@p1, '')) OR @p1 IS NULL)
        AND (Balance.[CashFlow] IN (SELECT id FROM dbo.[Descendants](@p2, '')) OR @p2 IS NULL)
        AND Balance.[OperationType] IN (@p4)
        AND Balance.[currency] = @p3
    GROUP BY
        Balance.[currency], Balance.[CashRequest],Balance.[CashRecipient], Balance.[OperationType],Balance.[BankAccountPerson]
    HAVING SUM(Balance.[Amount]) > 0;
    
    SELECT
        Balance.[CashRequest] AS CashRequest,
        Balance.[CashRecipient] AS CashRecipient,
        Balance.[BankAccountPerson] as BankAccountPerson,
        SUM(Balance.[Amount]) AS Amount
    INTO #SalaryAmount
    FROM [dbo].[Register.Accumulation.CashToPay] AS Balance
    WHERE Balance.document in (SELECT cr.CashRequest 
      FROM #CashRequestBalance cr 
      WHERE cr.OperationType = N'Выплата заработной платы')
    GROUP BY
        Balance.[CashRequest],Balance.[CashRecipient],Balance.[BankAccountPerson] ;
         
    SELECT
        CRT.[CashRequest] AS CashRequest
        , CAST(ISNULL(sa.Amount,DocCR.[Amount]) AS MONEY) AS CashRequestAmount
        , -(CAST(CRT.[AmountBalance] - ISNULL(sa.Amount,DocCR.[Amount]) AS MONEY)) AS AmountPaid
        , CRT.[AmountBalance] AS AmountBalance
        , CRT.OperationType
        , CRT.BankAccountPerson
        , CAST(0 AS MONEY) AS AmountRequest
        , DATEDIFF(DAY, GETDATE(), DocCR.[PayDay]) AS Delayed
        , CAST(0 AS MONEY) AS Amount
        , CAST(0 AS BIT) AS Confirm
        , CRT.[CashRecipient] AS CashRecipient
        , DocCR.[company.id] AS company
        , DocCR.[CashOrBank.id] AS BankAccount
        , DocCR.[CashOrBankIn.id] AS BankAccountIn
        , DocCR.[CashRecipientBankAccount.id] AS CashRecipientBankAccount
        , (SELECT COUNT(*) FROM [dbo].[Catalog.Counterpartie.BankAccount] AS CBA
    WHERE CBA.[owner.id] = DocCR.[CashRecipient.id] 
      AND CBA.[currency.id] = DocCR.[сurrency.id] 
      AND CBA.[deleted] = 0) AS CountOfBankAccountCashRecipient
        , null as LinkedDocument
    FROM #CashRequestBalance AS CRT
      LEFT JOIN #SalaryAmount sa ON CRT.CashRequest = sa.CashRequest and CRT.CashRecipient = sa.CashRecipient and CRT.BankAccountPerson = sa.BankAccountPerson
      INNER JOIN [dbo].[Document.CashRequest] AS DocCR ON DocCR.[id] = CRT.[CashRequest] and DocCR.[CashKind] <> 'CASH'
    ORDER BY Delayed, CashRequest, CashRecipient, AmountBalance DESC`;

    const CashRequests = await tx.manyOrNone<CashRequest>(query,
      [this.company, this.CashFlow, this.сurrency, this.Operation ? this.Operation : 'Оплата поставщику']);
    const rowAmountName = this.Operation === 'Выплата заработной платы' ? 'AmountBalance' : 'Amount';
    for (const row of CashRequests) {
      this.CashRequests.push({
        BankAccountPerson: row.BankAccountPerson,
        Amount: row[rowAmountName],
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
        BankAccountIn: row.BankAccountIn,
        CashRecipientBankAccount: row.CashRecipientBankAccount,
        CountOfBankAccountCashRecipient: row.CountOfBankAccountCashRecipient,
        LinkedDocument: null
      });
    }
    this.CashRequests.forEach(row => this.Amount += row.Amount);
  }
  async onCopy(tx: MSSQL) {
    this.Status = 'PREPARED';
    this.CashRequests = [];
    this.Amount = 0;
    this.info = '';
    return this;
  }

  async onPost(tx: MSSQL) {
    const Registers: PostResult = { Account: [], Accumulation: [], Info: [] };

    if (this.Status === 'REJECTED' || this.Status === 'APPROVED') return Registers;

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
        BankAccountPerson: row.BankAccountPerson,
        currency: this.сurrency,
        CashFlow: this.CashFlow,
        OperationType: CashRequestObject.Operation,
      }));
    }
    Registers.Accumulation = Registers.Accumulation.filter((r: RegisterAccumulationCashToPay) => r.Amount > 0);
    return Registers;
  }

}
