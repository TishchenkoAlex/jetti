import { CatalogPersonBankAccount } from './../Catalogs/Catalog.Person.BankAccount';
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
import { CatalogTaxOffice } from '../Catalogs/Catalog.TaxOffice';
import { TypesCashRecipient } from '../Types/Types.CashRecipient';

export class DocumentCashRequestServer extends DocumentCashRequest implements IServerDocument {

  async onValueChanged(prop: string, value: any, tx: MSSQL): Promise<DocumentBaseServer> {
    switch (prop) {
      case 'company':
        this.CashOrBank = null;
        this.tempCompanyParent = null;
        this.TaxBasisPayment = null;
        this.TaxDocDate = null as any;
        this.TaxOfficeCode2 = '';
        this.TaxDocNumber = '';
        this.TaxPaymentPeriod = null;
        this.TaxPayerStatus = null;
        this.TaxPaymentCode = null;
        this.CashRecipient = null;
        this.CashRecipientBankAccount = null;
        this.Contract = null;
        this.Department = null;
        this.TaxKPP = '';
        const company = await lib.doc.byIdT<CatalogCompany>(value.id, tx);

        if (company) {
          this.сurrency = company.currency;
          this.tempCompanyParent = company.parent;
          const TaxOffice = await lib.doc.byIdT<CatalogTaxOffice>(company.TaxOffice, tx);
          this.TaxOfficeCode2 = (TaxOffice ? TaxOffice.Code2 : null) as any;
          this.TaxKPP = company.Code2 as any;
        }
        return this;
      case 'CashRecipient':
        this.Contract = null;
        this.CashRecipientBankAccount = null;
        if (this.Operation === 'Оплата ДС в другую организацию') { this.CashOrBankIn = null; return this; }
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
        if (!value.id) { this.CashRecipientBankAccount = null; return this; }
        const CatalogContractObject = await lib.doc.byIdT<CatalogContract>(value.id, tx);
        if (!CatalogContractObject || !CatalogContractObject.BankAccount) { this.CashRecipientBankAccount = null; return this; }
        if (this.Operation === 'Оплата ДС в другую организацию') {
          this.CashOrBankIn = CatalogContractObject.BankAccount;
        } else {
          this.CashRecipientBankAccount = CatalogContractObject.BankAccount;
        }
        return this;
      default:
        return this;
    }
  }

  async onCommand(command: string, args: any, tx: MSSQL): Promise<{ [x: string]: any }> {
    switch (command) {
      case 'returnToStatusPrepared':
        await this.returnToStatusPrepared(tx);
        return this;
      case 'FillSalaryBalanceByPersons':
        await this.FillSalaryBalanceByPersons(tx);
        return this;
      default:
        return {};
    }
  }

  async baseOn(source: Ref, tx: MSSQL): Promise<this> {
    return this;
  }

  async returnToStatusPrepared(tx: MSSQL) {
    if (this.Status === 'PREPARED') return;
    if (!this.user) throw new Error(`Не заполнен автор документа`);
    const mail = tx.user.email;
    if (!mail) throw new Error(`Не заполнен адрес электронной почты текущего пользователя`);
    const currentUser = await lib.doc.byCode('Catalog.User', mail, tx);
    if (!currentUser) throw new Error(`Не удалось опеределить текущего пользователя`);
    if (currentUser !== this.user) throw new Error(`Операция разрешена только автору документа`);
    const relatedDocs = await this.getRelatedDocuments(tx);
    if (relatedDocs.length) {
      let relatedDocsString = '';
      relatedDocs.forEach(doc => { relatedDocsString += '\n' + doc.description; });
      throw new Error(`Операция не может быть выполнена, есть связанные документы: \n ${relatedDocsString}`);
    }
    if (this.workflowID) {
      await DeleteProcess(this.workflowID);
      this.workflowID = '';
    }
    this.Status = 'PREPARED';
    await updateDocument(this, tx);
  }

  async FillSalaryBalanceByPersons(tx: MSSQL) {
    if (this.Status !== 'PREPARED') throw new Error(`Заполнение возможно только в статусе \"PREPARED\"`);
    const query = `DROP TABLE IF EXISTS #Person;

    SELECT id personId INTO #Person FROM
      [dbo].[Catalog.Person] 
    WHERE [Department.id] = @p1;
    SELECT 
      Person
      ,SUM(Amount) Salary
    FROM [dbo].[Register.Accumulation.Salary] register 
    WHERE Person in (select personId from #Person) 
      and currency = @p2
      and date <= @p3
      AND company = @p4
    group BY Person 
    HAVING SUM(Amount) > 0`;
    const CompanyEmployee = await lib.util.salaryCompanyByCompany(this.company, tx);
    const salaryBalance = await tx.manyOrNone<{ Person, Salary }>(query, [this.Department, this.сurrency, this.date, CompanyEmployee]);
    this.PayRolls = [];
    this.Amount = 0;
    salaryBalance.forEach(el => {
      this.PayRolls.push({ Employee: el.Person, Salary: el.Salary, Tax: 0, BankAccount: null });
      this.Amount += el.Salary;
    })
    
  }

  async beforeSave(tx: MSSQL): Promise<this> {
    if (this.Amount < 0.01) throw new Error(`${this.description} неверно указана сумма`);
    return this;
  }

  async beforeDelete(tx: MSSQL): Promise<this> {
    if (this.Status === 'APPROVED' && this.posted) {
      const rest = await this.getAmountBalance(tx);
      if (this.Amount !== rest) throw new Error(`${this.description} не может быть удален:\n оплачено ${this.Amount - rest}`);
    }
    if (this.workflowID) {
      await DeleteProcess(this.workflowID);
      this.workflowID = '';
    }
    this.Status = 'PREPARED';
    await updateDocument(this, tx);
    return this;
  }

  async onPost(tx: MSSQL) {

    const Registers: PostResult = { Account: [], Accumulation: [], Info: [] };

    if (this.Operation && this.Operation === 'Оплата ДС в другую организацию' && this.company === this.CashRecipient) {
      throw new Error(`${this.description} не может быть проведен:\n организация-оправитель не может совпадать с организацией-получателем`);
    }
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

    if (this.Status !== 'APPROVED') return Registers;
    // CashToPay
    if (this.Operation === 'Выплата заработной платы') {
      this.PayRolls.forEach(el => {
        Registers.Accumulation.push(new RegisterAccumulationCashToPay({
          kind: true,
          CashRecipient: el.Employee,
          BankAccountPerson: el.BankAccount,
          Amount: el.Salary,
          date: this.PayDay,
          PayDay: this.PayDay,
          CashRequest: this.id,
          currency: сurrency,
          CashFlow: this.CashFlow,
          OperationType: this.Operation
        })
        );
      });
    } else {
      Registers.Accumulation.push(new RegisterAccumulationCashToPay({
        kind: true,
        CashRecipient: this.CashRecipient,
        Amount: this.Amount,
        date: this.PayDay,
        PayDay: this.PayDay,
        CashRequest: this.id,
        currency: сurrency,
        CashFlow: this.CashFlow,
        OperationType: this.Operation
      })
      );
    }

    return Registers;
  }
  // возвращает остаток по заявке
  async  getAmountBalance(tx: MSSQL): Promise<number> {
    if (this.Status !== 'APPROVED') return 0;
    const query = `
      SELECT
        SUM(Balance.[Amount]) AS AmountBalance
      FROM [dbo].[Register.Accumulation.CashToPay] AS Balance -- WITH (NOEXPAND)
      WHERE Balance.[CashRequest] = @p1`;
    const queryRes = await tx.manyOrNone<{ AmountBalance: number }>(query, [this.id]);
    if (queryRes.length) return queryRes[0].AmountBalance;
    return 0;
  }

  // возвращает остаток по заявке в разрезе получателей и счетов
  // todo: обратится в базу х100
  public async  getAmountBalanceWithCashRecipientsAndBankAccounts(
    tx: MSSQL): Promise<{ CashRecipient: TypesCashRecipient, BankAccountPerson: CatalogPersonBankAccount, Amount: number }[]> {
    const query = `
    SELECT
        Balance.[CashRecipient] AS CashRecipient,
        Balance.[BankAccountPerson] AS BankAccountPerson,
        SUM(Balance.[Amount]) AS Amount
    FROM [dbo].[Register.Accumulation.CashToPay] AS Balance
    WHERE Balance.[CashRequest] = @p1
    GROUP BY
        Balance.[CashRecipient],Balance.[BankAccountPerson]
    HAVING SUM(Balance.[Amount]) > 0`;
    return await tx.manyOrNone<{ CashRecipient: TypesCashRecipient, BankAccountPerson: CatalogPersonBankAccount, Amount: number }>
      (query, [this.id]);
  }

  // возвращает связанные документы
  async  getRelatedDocuments(tx: MSSQL): Promise<{ id: string, description: string }[]> {
    const query = `
    select
    id,
      description
    from Documents
    where contains(doc, @p1)
    union
    select
    id,
      description
    from Documents
    where parent =  @p1`;
    return await tx.manyOrNone<{ id: string, description: string }>(query, [this.id]);
  }
}
