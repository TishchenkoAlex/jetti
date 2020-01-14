import { lib } from '../../std.lib';
import { IServerDocument, DocumentBaseServer } from '../documents.factory.server';
import { MSSQL } from '../../mssql';
import { PostResult } from '../post.interfaces';
import { Ref } from '../document';
import { DocumentCashRequest } from './Document.CashRequest';
import { RegisterAccumulationAP } from '../Registers/Accumulation/AP';
import { RegisterAccumulationCashToPay } from '../Registers/Accumulation/CashToPay';
import { CatalogCompany } from '../Catalogs/Catalog.Company';
import { CatalogBankAccount } from '../Catalogs/Catalog.BankAccount';
import { CatalogContract } from '../Catalogs/Catalog.Contract';
import { DeleteProcess } from '../../routes/bp';
import { updateDocument } from '../../routes/utils/post';

export class DocumentCashRequestServer extends DocumentCashRequest implements IServerDocument {

  async onValueChanged(prop: string, value: any, tx: MSSQL): Promise<DocumentBaseServer> {
    switch (prop) {
      case 'company':
        const company = await lib.doc.byIdT<CatalogCompany>(value.id, tx);
        if (!company) return this;
        this.сurrency = company.currency;
        return this;
      case 'CashRecipient':
        if (!value.id || value.type !== 'Catalog.Counterpartie') { this.Contract = null; return this; }
        const query = `
          SELECT TOP 1 id
          FROM dbo.[Catalog.Contract]
          WHERE
          [owner.id] = @p1
          and [currency.id] = @p2
          and [company.id] = @p3
          ORDER BY isDefault desc`;
        const contractId = await tx.oneOrNone<{ id: string }>(query, [value.id, this.сurrency, this.company]);
        if (!contractId) { this.Contract = null; return this; }
        this.Contract = contractId!.id;
        return this;
      case 'Contract':
        if (!value.id) {this.CashRecipientBankAccount = null; return this; }
        const CatalogContractObject = await lib.doc.byIdT<CatalogContract>(value.id, tx);
        if (!CatalogContractObject || !CatalogContractObject.BankAccount) { this.CashRecipientBankAccount = null; return this; }
        this.CashRecipientBankAccount = CatalogContractObject.BankAccount;
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

  async baseOn(source: Ref, tx: MSSQL): Promise<this> {
    return this;
  }

  async beforeDelete(tx: MSSQL): Promise<this> {
    if (this.Status  === 'APPROVED') {
      throw new Error('Утвержденный документ не может быть удален');
    }
    if (this.workflowID) {
      await DeleteProcess(this.workflowID);
      this.workflowID  = '';
      this.Status  = 'PREPARED';
      await updateDocument(this, tx);
    }
    return this;
  }

  async onPost(tx: MSSQL) {

    const Registers: PostResult = { Account: [], Accumulation: [], Info: [] };

    if (this.Status === 'PREPARED' || this.Status === 'REJECTED') {
      return Registers;
    }

    const cashOrBank = await lib.doc.byId(this.CashOrBank, tx);
    const сurrency = cashOrBank ? (<CatalogBankAccount>cashOrBank).currency : this.сurrency;
    // const exchangeRate = await lib.info.exchangeRate(this.date, this.company, сurrency, tx) || 1;

    switch (this.Operation) {
      case 'Оплата поставщику':
        // AP
        Registers.Accumulation.push(new RegisterAccumulationAP({
          kind: false,
          AO: this.Contract,
          Department: this.Department,
          Supplier: this.CashRecipient,
          AmountIsPaid: (this.Status === 'APPROVED' ? this.Amount : 0),
          AmountToPay: (this.Status === 'AWAITING' ? this.Amount : 0),
          PayDay: this.PayDay,
          currency: сurrency,
          company: this.company
        }));
        break;
      default:
        break;
    }

    if (this.Status === 'APPROVED') {
      // CashToPay
      Registers.Accumulation.push(new RegisterAccumulationCashToPay({
        kind: true,
        CashRecipient: this.CashRecipient,
        Amount: this.Amount,
        date: this.PayDay,
        PayDay: this.PayDay,
        CashRequest: this.id,
        currency: сurrency,
        CashFlow: this.CashFlow,
        // Contract: this.Contract,
        // CashOrBank: this.CashOrBank,
        // Loan: this.Loan,
        OperationType: this.Operation,
        // Department: this.Department,
        // ExpenseAnalytics: this.ExpenseAnalytics,
        // ExpenseOrBalance: this.ExpenseOrBalance,
        // BalanceAnalytics: this.BalanceAnalytics
      }));
    }

    return Registers;
  }

}
