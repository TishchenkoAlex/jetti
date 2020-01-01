import { PostResult } from '../post.interfaces';
import { MSSQL } from '../../mssql';
import { IServerDocument } from '../documents.factory.server';
import { DocumentCashRequestRegistry, CashRequest } from './Document.CashRequestRegistry';
import { buildViewModel } from '../../routes/documents';

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
      default:
        return this;
    }
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
      FROM [sm].[dbo].[Register.Accumulation.CashToPay] AS Balance -- WITH (NOEXPAND)
      WHERE (1 = 1)
        AND (Balance.[company]  IN (SELECT id FROM dbo.[Descendants](@p1, '')) OR @p1 IS NULL)
        AND (Balance.[CashFlow] IN (SELECT id FROM dbo.[Descendants](@p2, '')) OR @p2 IS NULL)
        -- AND Balance.[OperationType] IN (@p4)
        AND Balance.[currency] = @p3
      GROUP BY
        Balance.[currency], Balance.[CashRequest]
      SELECT
        CRT.[CashRequest] AS CashRequest
       , CAST(DocCR.[Amount] AS MONEY) AS CashRequestAmount
       , CAST(CRT.[AmountBalance] - DocCR.[Amount] AS MONEY) AS AmountPaid
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
        AmountRequest: row.AmountRequest,
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
    for (const row of this.CashRequests) {
    }
    return Registers;
  }

}
