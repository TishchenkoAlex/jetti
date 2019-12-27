import { lib } from '../../std.lib';
import { CatalogCompany } from '../Catalogs/Catalog.Company';
import { CatalogOperation } from '../Catalogs/Catalog.Operation';
import { PatchValue } from '../common-types';
import { createDocumentServer, IServerDocument, DocumentBaseServer } from '../documents.factory.server';
import { RegisterInfoSettings } from '../Registers/Info/Settings';
import { PostResult } from './../post.interfaces';
import { DocumentOperation } from './Document.Operation';
import { MSSQL } from '../../mssql';
import { DocumentCashRequestServer } from './Document.CashRequest.server';
import { createDocument } from '../documents.factory';

export class DocumentOperationServer extends DocumentOperation implements IServerDocument {

  async onValueChanged(prop: string, value: any, tx: MSSQL): Promise<PatchValue | {} | { [key: string]: any }> {
    if (!value) { return {}; }
    switch (prop) {
      case 'company':
        const company = await lib.doc.byIdT<CatalogCompany>(value.id, tx);
        if (!company) { return {}; }
        const currency = await lib.doc.formControlRef(company.currency!, tx);
        return { currency };
      case 'Operation':
        const Operation = await lib.doc.byIdT<CatalogOperation>(value.id, tx);
        if (!Operation) { return {}; }
        const Group = await lib.doc.formControlRef(Operation.Group!, tx);
        return { Group };
      default:
        return {};
    }
  }

  async onCommand(command: string, args: any, tx: MSSQL) {
    switch (command) {
      case 'company':
        return {};
      default:
        return {};
    }
  }

  async onPost(tx: MSSQL) {
    const Registers: PostResult = { Account: [], Accumulation: [], Info: [] };

    if (this.posted && !this.deleted) {
      const query = `
        SELECT (SELECT "script" FROM OPENJSON(doc) WITH ("script" NVARCHAR(MAX) '$."script"')) "script"
        FROM "Documents" WHERE id = '${this.Operation}'`;
      const Operation = await tx.oneOrNone<{ script: string }>(query);
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
          await this.CashRequestbaseOn(sourceDoc as DocumentCashRequestServer, tx);
          break;
        case 'Catalog.Operation':
          this.Operation = (sourceDoc as CatalogOperation).id;
          this.Group = (sourceDoc as CatalogOperation).Group;
          break;
        default:
          break;
      }
    }
    return this;
  }

  async CashRequestbaseOn(sourceDoc: DocumentCashRequestServer, tx: MSSQL) {
    this.company = sourceDoc.company;
    this.currency = sourceDoc.сurrency;
    this['CashFlow'] = sourceDoc.CashFlow;
    this.parent = sourceDoc.id;
    this.Amount = sourceDoc.Amount;
    this['Department'] = sourceDoc.Department;
    this['Contract'] = sourceDoc.Contract;
    this.info = `На основании ${sourceDoc.description}`;

    const BankAccountSupplier = await tx.oneOrNone<{ id: string }>(`
      SELECT TOP 1 id FROM dbo.[Catalog.Counterpartie.BankAccount] WHERE [owner.id] = '${sourceDoc.CashRecipient}'`);

    switch (sourceDoc.Operation) {
      case 'Оплата поставщику':
        this['Supplier'] = sourceDoc.CashRecipient;
        this['BankConfirm'] = false;

        const CashOrBank = (await lib.doc.byId(sourceDoc.CashOrBank, tx))!;
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
          this['BankAccountSupplier'] = BankAccountSupplier?.id;
          this['BankAccount'] = CashOrBank.id;
          this.f1 = this['BankAccount'];
          this.f2 = this['Supplier'];
          this.f3 = this['CashFlow'];

        }
        break;
      case 'Перечисление налогов и взносов':
      default:
        break;
    }
    const Props = (await (createDocumentServer(this.type, this, tx))).Props();
    this.Props = () => Props;
  }
}

// Operation = 'Оплата поставщику';

//   @Props({ type: 'Catalog.Department' })
//   Department: Ref = null;

//   @Props({ type: 'Types.CashRecipient', required: true })
//   CashRecipient: Ref = null;

//   @Props({ type: 'Catalog.Contract', owner: [{ dependsOn: 'CashRecipient', filterBy: 'owner' }] })
//   Contract: Ref = null;

//   @Props({ type: 'Catalog.CashFlow', required: true })
//   CashFlow: Ref = null;

//   @Props({ type: 'Catalog.Loan'})
//   Loan: Ref = null;

//   @Props({ type: 'Types.CashOrBank',
//   owner: [
//       { dependsOn: 'company', filterBy: 'company' },
//       { dependsOn: 'сurrency', filterBy: 'currency' }
//   ]
// })
//   CashOrBank: Ref = null;

//   @Props({ type: 'date' })
//   PayDay = new Date();

//   @Props({ type: 'number', required: true })
//   Amount = 0;

//   @Props({ type: 'Catalog.Currency', required: true })
//   сurrency: Ref = null;

//   @Props({ type: 'Types.ExpenseOrBalance'})
//   ExpenseOrBalance: Ref = null;

//   @Props({ type: 'Catalog.Expense.Analytics' })
//   ExpenseAnalytics: Ref = null;

//   @Props({ type: 'Catalog.Balance.Analytics' })
//   BalanceAnalytics: Ref = null;

//   @Props({ type: 'string' })
//   workflowID = '';
      // 770FA450-BB58-11E7-8996-53A59C675CDA - Из кассы -  оплата поставщику (НАЛИЧНЫЕ)
      // 68FA31F0-BDB0-11E7-9C95-E3F9522E1FC9 - С р/с -  оплата поставщику (БЕЗНАЛИЧНЫЕ)

// 'Оплата поставщику',
// 'Перечисление налогов и взносов',
// 'Оплата ДС в другую организацию',
// 'Выдача ДС подотчетнику',
// 'Оплата по кредитам и займам полученным',
// 'Выплата по ведомости',
// 'Прочий расход ДС',
// 'Выдача займа контрагенту',
// 'Возврат оплаты клиенту'
// DocumentOperationServer {
//   id: '67b18bc0-2813-11ea-a430-e1105a7d7435',
//   date: 2019-12-26T19:10:39.740Z,
//   code: '',
//   description: 'Operation (Списание безналичных ДС) #, 2019-12-26T19:10:39.740Z',
//   company: null,
//   user: null,
//   posted: false,
//   deleted: false,
//   parent: null,
//   isfolder: false,
//   info: '',
//   timestamp: null,
//   workflow: null,
//   Group: '269BBFE8-BE7A-11E7-9326-472896644AE4',
//   Operation: '68FA31F0-BDB0-11E7-9C95-E3F9522E1FC9',
//   Amount: 0,
//   currency: null,
//   f1: undefined,
//   f2: undefined,
//   f3: undefined,
//   type: 'Document.Operation',
//   serverModule: {},
//   Props: [Function],
//   BankDocNumber: undefined,
//   BankConfirmDate: undefined,
//   BankConfirm: undefined,
//   Department: undefined,
//   BankAccount: undefined,
//   Supplier: undefined,
//   f4: undefined,
//   Contract: undefined,
//   f5: undefined,
//   CashFlow: undefined,
//   f6: undefined,
//   BankAccountSupplier: undefined
// }
