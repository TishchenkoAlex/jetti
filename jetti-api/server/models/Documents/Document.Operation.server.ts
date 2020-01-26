import { lib } from '../../std.lib';
import { CatalogCompany } from '../Catalogs/Catalog.Company';
import { CatalogOperation } from '../Catalogs/Catalog.Operation';
import { createDocumentServer, IServerDocument, DocumentBaseServer } from '../documents.factory.server';
import { RegisterInfoSettings } from '../Registers/Info/Settings';
import { PostResult } from './../post.interfaces';
import { DocumentOperation } from './Document.Operation';
import { MSSQL } from '../../mssql';
import { DocumentCashRequestServer } from './Document.CashRequest.server';
import { Ref } from '../document';

export class DocumentOperationServer extends DocumentOperation implements IServerDocument {

  async onValueChanged(prop: string, value: any, tx: MSSQL): Promise<DocumentBaseServer> {
    switch (prop) {
      case 'company':
        const company = await lib.doc.byIdT<CatalogCompany>(value.id, tx);
        if (company) this.currency = company.currency;
        return this;
      case 'Operation':
        const Operation = await lib.doc.byIdT<CatalogOperation>(value.id, tx);
        if (Operation) this.Group = Operation.Group!;
        return this;
      default:
        return this;
    }
  }

  async beforePost(tx: MSSQL) {
    if (!this.parent || this.posted) return this;
    const parentDoc = (await lib.doc.byId(this.parent, tx));
    if (!parentDoc) return this;
    switch (parentDoc.type) {
      case 'Document.CashRequest':
        const CashRequestServer = await createDocumentServer<DocumentCashRequestServer>('Document.CashRequest', parentDoc, tx);
        await this.beforePostCashRequest(CashRequestServer, tx);
        break;
      default:
        break;
    }
    return this;
  }

  async beforePostCashRequest(CashRequest: DocumentCashRequestServer, tx: MSSQL) {
    const rest = await CashRequest.getAmountBalance(tx);
    if (rest < this.Amount) throw new Error(`${this.description} не может быть проведен: сумма ${this.Amount} превышает остаток ${rest} на ${this.Amount - rest} по ${CashRequest.description}`);
  }

  async onPost(tx: MSSQL) {
    const Registers: PostResult = { Account: [], Accumulation: [], Info: [] };

    if (this.posted && !this.deleted) {
      const query = `
        SELECT (SELECT "script" FROM OPENJSON(doc) WITH ("script" NVARCHAR(MAX) '$."script"')) "script"
        FROM "Documents" WHERE id = @p1`;
      const Operation = await tx.oneOrNone<{ script: string }>(query, [this.Operation]);
      const exchangeRate = await lib.info.exchangeRate(this.date, this.company, this.currency, tx);
      const settings = await lib.info.sliceLast<RegisterInfoSettings>('Settings', this.date, this.company, {}, tx);
      const accountingCurrency = settings && settings.accountingCurrency || this.currency;
      const exchangeRateAccounting = await lib.info.exchangeRate(this.date, this.company, accountingCurrency, tx);
      const script = `
      let exchangeRateBalance = exchangeRate;
      let AmountInBalance = doc.Amount / exchangeRate;
      let AmountInAccounting = doc.Amount / exchangeRateAccounting;
      ${ Operation!.script
          .replace(/\$\./g, 'doc.')
          .replace(/tx\./g, 'await tx.')
          .replace(/lib\./g, 'await lib.')
          .replace(/\'doc\./g, '\'$.')}
      `;
      const AsyncFunction = Object.getPrototypeOf(async function () { }).constructor;
      const func = new AsyncFunction('doc, Registers, tx, lib, settings, exchangeRate, exchangeRateAccounting', script);
      await func(this, Registers, tx, lib, settings, exchangeRate, exchangeRateAccounting);
    }

    return Registers;
  }

  async baseOn(source: string, tx: MSSQL) {

    const rawDoc = await lib.doc.byId(source, tx);
    if (!rawDoc) return this;

    const sourceDoc = await createDocumentServer(rawDoc.type, rawDoc, tx);

    if (sourceDoc instanceof DocumentOperationServer) {
      const Operation = await lib.doc.byIdT<CatalogOperation>(sourceDoc.Operation as string, tx);
      const Rule = Operation!.CopyTo.find(c => c.Operation === this.Operation);
      if (Rule) {
        const script = `
        this.company = doc.company;
        this.currency = doc.currency;
        this.parent = doc.id;
        ${ Rule.script
            .replace(/\$\./g, 'doc.')
            .replace(/tx\./g, 'await tx.')
            .replace(/lib\./g, 'await lib.')
            .replace(/\'doc\./g, '\'$.')}
          `;
        const AsyncFunction = Object.getPrototypeOf(async function () { }).constructor;
        const func = new AsyncFunction('doc, tx, lib', script) as Function;
        await func.bind(this, sourceDoc, tx, lib)();
      }
    } else {
      switch (sourceDoc.type) {
        case 'Catalog.Counterpartie':
          break;
        case 'Document.CashRequest':
          await this.baseOnCashRequest(sourceDoc as DocumentCashRequestServer, tx);
          break;
        case 'Catalog.Operation':
          this.Operation = (sourceDoc as CatalogOperation).id;
          this.Group = (sourceDoc as CatalogOperation).Group;
          break;
        default:
          break;
      }
    }
    const doc = await (createDocumentServer(this.type, this, tx));
    const Props = doc.Props();
    const Prop = doc.Prop();
    this.description = doc.description;
    this.Props = () => Props;
    this.Prop = () => Prop;
    return this;
  }

  async baseOnCashRequest(sourceDoc: DocumentCashRequestServer, tx: MSSQL) {
    this.company = sourceDoc.company;
    this.currency = sourceDoc.сurrency;
    this.parent = sourceDoc.id;
    this.Amount = sourceDoc.Amount;
    this['CashFlow'] = sourceDoc.CashFlow;
    this['Department'] = sourceDoc.Department;
    this.info = sourceDoc.info; // .replace(/\r?\n/g, ' ');
    let CashOrBank;

    if (this['BankAccount']) {
      CashOrBank = { id: this['BankAccount'], type: 'Catalog.BankAccount' };
    } else {
      CashOrBank = (await lib.doc.byId(sourceDoc.CashOrBank, tx));
    }

    let CashRecipientBankAccount;
    switch (sourceDoc.Operation) {
      case 'Оплата поставщику':
        this['Contract'] = sourceDoc.Contract;
        CashRecipientBankAccount = sourceDoc.CashRecipientBankAccount;
        if (!CashRecipientBankAccount) {
          const query = `
            SELECT TOP 1 id FROM dbo.[Catalog.Counterpartie.BankAccount] WHERE [owner.id] = '${sourceDoc.CashRecipient}'`;
          const queryResult = await tx.oneOrNone<{ id: Ref }>(query);
          if (queryResult) CashRecipientBankAccount = queryResult.id;
        }
        if (!CashRecipientBankAccount) throw new Error(`Расчетный счет получателя не определен`);
        this['Supplier'] = sourceDoc.CashRecipient;
        this['BankConfirm'] = false;

        if (!CashOrBank) throw new Error('Источник оплат не заполнен в заявке на ДС');
        if (CashOrBank.type === 'Catalog.CashRegister') {
          this.Operation = '770FA450-BB58-11E7-8996-53A59C675CDA'; // касса
          this.Group = '42512520-BE7A-11E7-A145-CF5C65BC8F97';
          this['CashRegister'] = CashOrBank.id;
          this.f1 = this['CashRegister'];
          this.f2 = this['Supplier'];
          this.f3 = this['CashFlow'];
        } else {
          this.Operation = '68FA31F0-BDB0-11E7-9C95-E3F9522E1FC9'; // С р/с -  оплата поставщику (БЕЗНАЛИЧНЫЕ)
          this.Group = '269BBFE8-BE7A-11E7-9326-472896644AE4';
          this['BankAccountSupplier'] = CashRecipientBankAccount;
          this['BankAccount'] = CashOrBank.id;
          this.f1 = this['BankAccount'];
          this.f2 = this['Supplier'];
          this.f3 = this['CashFlow'];
        }
        break;
      case 'Перечисление налогов и взносов':
        this.Group = '269BBFE8-BE7A-11E7-9326-472896644AE4';
        this.Operation = '8D128C20-3E20-11EA-A722-63A01E818155';
        `TaxPaymentCode 
        TaxOfficeCode2
        TaxPayerStatus
        TaxBasisPayment
        TaxDocNumber
        TaxDocDate
        TaxPaymentPeriod`.split('\n').forEach(el => { this[el.trim()] = sourceDoc[el.trim()] });
        this['Supplier'] = sourceDoc.CashRecipient;
        this['BankAccount'] = CashOrBank.id;
        this.f1 = this['CashRegister'];
        this.f2 = this['Supplier'];
        this.f3 = this['CashFlow'];
        break;
      case 'Оплата по кредитам и займам полученным':
        if (!CashOrBank) throw new Error(`Не указан источник ДС в ${sourceDoc.description}`);
        if (CashOrBank.type === 'Catalog.CashRegister') {
          // касса
          this.Operation = 'DBBCB3D0-1749-11EA-92AC-8B4BF8464BD9';
          this.Group = '42512520-BE7A-11E7-A145-CF5C65BC8F97';
          this['Counterpartie'] = sourceDoc.CashRecipient;
          this['CashRegister'] = sourceDoc.CashOrBank;
          this['PaymentKind'] = sourceDoc.PaymentKind;
          this['Loan'] = sourceDoc.Loan;
          this.f1 = this['CashRegister'];
          this.f2 = this['Counterpartie'];
          this.f3 = this['Loan'];
        } else { // bank
          CashRecipientBankAccount = sourceDoc.CashRecipientBankAccount;
          if (!CashRecipientBankAccount) {
            const query = `
              SELECT TOP 1 id FROM dbo.[Catalog.Counterpartie.BankAccount] WHERE [owner.id] = '${sourceDoc.CashRecipient}'`;
            const queryResult = await tx.oneOrNone<{ id: Ref }>(query);
            if (queryResult) CashRecipientBankAccount = queryResult.id;
          }
          if (!CashRecipientBankAccount) throw new Error(`Расчетный счет получателя не определен`);
          if (!CashOrBank) throw new Error(`Источник оплат не заполнен в ${sourceDoc.description}`);

          this['BankConfirm'] = false;
          this.Group = '269BBFE8-BE7A-11E7-9326-472896644AE4';
          this.Operation = '54AA5310-102E-11EA-AA50-31ECFB22CD33';
          this['Counterpartie'] = sourceDoc.CashRecipient;
          this['BankAccount'] = CashOrBank.id;
          this['BankAccountSupplier'] = CashRecipientBankAccount;
          this['PaymentKind'] = sourceDoc.PaymentKind;
          this['Loan'] = sourceDoc.Loan;
          this.f1 = this['BankAccount'];
          this.f2 = this['Counterpartie'];
          this.f3 = this['Loan'];
        }
        break;
      case 'Оплата ДС в другую организацию':
        const CashOrBankIn = (await lib.doc.byId(sourceDoc.CashOrBankIn, tx));
        if (!CashOrBankIn) throw new Error('Приемник оплат не заполнен в заявке на ДС');
        if (this['BankAccount']) {
          CashOrBank = { id: this['BankAccount'], type: 'Catalog.BankAccount' };
        } else {
          CashOrBank = (await lib.doc.byId(sourceDoc.CashOrBank, tx));
        }
        if (!CashOrBank) throw new Error(`Источник оплат не заполнен в ${sourceDoc.description}`);

        if (CashOrBank.type === 'Catalog.CashRegister') throw new Error('Создание платежного документа из кассы не поддерживается, обратитесь к разработчику');
        // this.Group = '42512520-BE7A-11E7-A145-CF5C65BC8F97'; // Расходный кассовый ордер
        //   if (CashOrBankIn!.type === 'Catalog.CashRegister') {
        //     this.Operation = '1B411A80-DBF6-11E9-9DD5-EB2F495F92A0'; // Из кассы - в другую кассу (в путь)
        //     this['CashRegisterOUT'] = CashOrBank.id;
        //     this['CashRegisterIN'] = CashOrBankIn.id;
        //     this.f1 = this['CashRegisterOUT'];
        //     this.f2 = this['CashRegisterIN'];
        //     // const CashRecipient = (await lib.doc.byId(sourceDoc.CashRecipient, tx));
        //     // if (CashRecipient!.type = 'Catalog.Person') {
        //     //   this['Person'] = CashRecipient!.id;
        //     //   this.f3 = this['Person'];
        //     // }
        //   } else {
        //     this.Operation = 'A6D6678C-BBA3-11E7-8E9F-1B4E8C03A1F5'; // Из кассы - на расчетный счет (в путь)
        //     this['BankAccount'] = CashOrBankIn.id;
        //     this['CashRegister'] = CashOrBank.id;
        //     this.f1 = this['CashRegister'];
        //     this.f2 = this['BankAccount'];
        //   }
        // } else {
        this.Group = '269BBFE8-BE7A-11E7-9326-472896644AE4'; // Списание безналичных ДС
        if (CashOrBankIn!.type === 'Catalog.CashRegister') throw new Error('Создание платежного документа в кассу не поддерживается, обратитесь к разработчику');
        //   this.Operation = '369E2910-36CA-11EA-A774-7FBAF34E4AFA'; // С р/с - в кассу (в путь)
        //   this['BankAccountOut'] = CashOrBank.id;
        //   this['CashRegisterIn'] = CashOrBankIn.id;
        //   this['BankConfirm'] = false;
        //   this.f1 = this['BankAccountOut'];
        //   this.f2 = this['CashRegisterIn'];
        // } else {
        this.Operation = '433D63DE-D849-11E7-83D2-2724888A9E4F'; // С р/с - на расчетный счет  (в путь)
        this['BankAccountOut'] = CashOrBank.id;
        this['BankAccountTransit'] = CashOrBankIn.id;
        this['BankConfirm'] = false;
        this.f1 = this['BankAccountOut'];
        this.f2 = this['BankAccountTransit'];
        // }
        // }
        break;
      default:
        break;
    }
  }
}