import { lib } from '../../std.lib';
import { createDocumentServer, IServerDocument } from '../documents.factory.server';
import { MSSQL } from '../../mssql';
import { DocumentWorkFlow } from './Document.WokrFlow';
import { DocumentOperation } from './Document.Operation';
import { PostResult } from '../post.interfaces';
import { Ref } from '../document';
import { DocumentCashRequest } from './Document.CashRequest';
import { RegisterAccumulationAP } from '../Registers/Accumulation/AP';
import { RegisterAccumulationCashToPay } from '../Registers/Accumulation/CashToPay';
import { CatalogCompany } from '../Catalogs/Catalog.Company';
import { CatalogCurrency } from '../Catalogs/Catalog.Currency';
import { CatalogBankAccount } from '../Catalogs/Catalog.BankAccount';
import { CatalogContract } from '../Catalogs/Catalog.Contract';
import { RefValue } from '../common-types';
import { CatalogCounterpartieBankAccount } from '../Catalogs/Catalog.Counterpartie.BankAccount';

export class DocumentCashRequestServer extends DocumentCashRequest implements IServerDocument {

  async onValueChanged(prop: string, value: any, tx: MSSQL): Promise<{ [x: string]: any }> {
    switch (prop) {
      case 'company':
        const company = await lib.doc.byIdT<CatalogCompany>(value.id, tx);
        if (!company) { return {}; }
        const currency = await lib.doc.formControlRef(company.currency!, tx);
        return { currency };
      case 'CashFlow':
        return {};
      case 'CashRecipient':
        const emptyContract: RefValue = { code: '', id: '', type: 'Catalog.Contract', value: '' };
        if (!value.id) { return { Contract: emptyContract }; }
        const query = `
          SELECT TOP 1 id
          FROM dbo.[Catalog.Contract]
          WHERE
          [owner.id] = '${value.id}'
          and [currency.id] = '${this.сurrency}'
          and [company.id] = '${this.company}'
          ORDER BY isDefault desc`;
        const contractId = await tx.oneOrNone<{ id: string }>(query);
        if (!contractId) { return { Contract: emptyContract }; }
        const Contract = await lib.doc.formControlRef(contractId!.id, tx);
        return { Contract };
      case 'Contract':
        const emptyCatalogContract: RefValue = { code: '', id: '', type: 'Catalog.Counterpartie.BankAccount', value: '' };
        const CatalogContractObject = await lib.doc.byIdT<CatalogContract>(value.id, tx);
        if (!CatalogContractObject) { return { CashRecipientBankAccount: emptyCatalogContract }; }
        const CashRecipientBankAccount = await lib.doc.formControlRef(CatalogContractObject.BankAccount, tx);
        if (!CashRecipientBankAccount) { return { CashRecipientBankAccount: emptyCatalogContract }; }
        return { CashRecipientBankAccount };
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
        kind: false,
        CashRecipient: this.CashRecipient,
        Amount: this.Amount,
        PayDay: this.PayDay,
        CashRequest: this.id,
        currency: сurrency,
        CashFlow: this.CashFlow,
        Contract: this.Contract,
        CashOrBank: this.CashOrBank,
        Loan: this.Loan,
        OperationType: this.Operation,
        Department: this.Department,
        ExpenseAnalytics: this.ExpenseAnalytics,
        ExpenseOrBalance: this.ExpenseOrBalance,
        BalanceAnalytics: this.BalanceAnalytics
      }));
    }

    return Registers;
  }

}
