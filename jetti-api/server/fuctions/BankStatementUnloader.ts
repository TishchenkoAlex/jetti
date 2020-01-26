import { MSSQL } from '../mssql';

export class BankStatementUnloader {

  private static async getCashRequestsData(docsID: string[], tx: MSSQL) {

    let query = `
    SELECT
        N'Платежное поручение' as N'СекцияДокумент'
        ,Obj.[code] as N'Номер'
        ,FORMAT (Obj.[date], 'dd.MM.yyyy') as N'Дата'
        ,CAST(JSON_VALUE(Obj.doc, '$.Amount') as money) as N'Сумма'
        ,BAComp.[code] as N'ПлательщикСчет'
        ,N'ИНН ' + JSON_VALUE(Comp.doc, '$.Code1') + ' ' + JSON_VALUE(Comp.doc, '$.FullName') as N'Плательщик'
        ,JSON_VALUE(Comp.doc, '$.Code1') as N'ПлательщикИНН'
        ,JSON_VALUE(Comp.doc, '$.FullName') as N'Плательщик1'
        ,BAComp.[code] as N'ПлательщикРасчСчет'
        ,BankComp.description as N'ПлательщикБанк1'
        ,JSON_VALUE(BankComp.doc, '$.Address') as N'ПлательщикБанк2'
        ,BankComp.[code] as N'ПлательщикБИК'
        ,JSON_VALUE(BankComp.doc, '$.KorrAccount') as N'ПлательщикКорсчет'
        ,BASupp.[code] as N'ПолучательСчет'
        ,N'ИНН ' + Supp.[code] + ' ' + JSON_VALUE(Supp.doc, '$.FullName') as N'Получатель'
        ,Supp.[code] as N'ПолучательИНН'
        ,JSON_VALUE(Supp.doc, '$.FullName') as N'Получатель1'
        ,BASupp.[code] as N'ПолучательРасчСчет'
        ,BankSupp.description as N'ПолучательБанк1'
        ,JSON_VALUE(BankSupp.doc, '$.Address') as N'ПолучательБанк2'
        ,BankSupp.[code] as N'ПолучательБИК'
        ,JSON_VALUE(BankSupp.doc, '$.KorrAccount') as N'ПолучательКорсчет'
        ,'01' as N'ВидОплаты'
        ,JSON_VALUE(Supp.doc, '$.Code2') as N'ПолучательКПП'
        ,5 as N'Очередность'
        ,Obj.[info] as N'НазначениеПлатежа'
        ,FORMAT (Dates.ed, 'dd.MM.yyyy') as N'ДатаКонца_ig'
        ,FORMAT (Dates.bd, 'dd.MM.yyyy') as N'ДатаНачала_ig'
        ,FORMAT (GETDATE(), 'dd.MM.yyyy') as N'ДатаСоздания_ig'
        ,FORMAT (GETDATE(), 'HH:mm:ss') as N'ВремяСоздания_ig'
        ,Obj.company  as Company_ig
        ,Obj.[date] as ObjDate_ig
		    ,null as N'Налоги_СтатусСоставителя'
        ,null  as N'Налоги_ПоказательТипа'
        ,null N'Налоги_ПлательщикКПП'
        ,null as N'Налоги_ПоказательКБК'
        ,null  as N'Налоги_ОКАТО'
        ,null  as N'Налоги_ПоказательОснования'
        ,null  as N'Налоги_ПоказательПериода'
        ,null  as N'Налоги_ПоказательНомера'
        ,null  as N'Налоги_ПоказательДаты'
        ,null  as N'Налоги_Код'
        ,JSON_VALUE(Obj.doc, '$.Operation') as Oper_ig
        FROM [dbo].[Documents] as Obj
        LEFT JOIN (
        SELECT
        MAX(docs.[date]) as ed,
        MIN(docs.[date]) as bd,
        docs.company as company
        FROM [dbo].[Documents] as docs
        WHERE docs.[id] in (@p1)
        GROUP BY company) as Dates on Dates.company = Obj.company
        LEFT JOIN [dbo].[Documents] as Comp on Comp.id = Obj.company and Comp.[type] = 'Catalog.Company'
        LEFT JOIN [dbo].[Documents] as BAComp on BAComp.id = JSON_VALUE(Obj.doc, '$.BankAccount') and BAComp.[type] = 'Catalog.BankAccount'
        LEFT JOIN [dbo].[Documents] as BankComp on BankComp.id = JSON_VALUE(BAComp.doc, '$.Bank') and BankComp.[type] = 'Catalog.Bank'
        LEFT JOIN [dbo].[Documents] as Supp on Supp.id = JSON_VALUE(Obj.doc, '$.Supplier') and Supp.[type] = 'Catalog.Counterpartie'
        LEFT JOIN [sm].[dbo].[Documents] as BASupp on BASupp.id = JSON_VALUE(Obj.doc, '$.BankAccountSupplier') and BASupp.[type] = 'Catalog.Counterpartie.BankAccount'
        LEFT JOIN [dbo].[Documents] as BankSupp on BankSupp.id = JSON_VALUE(BASupp.doc, '$.Bank') and BankComp.[type] = 'Catalog.Bank'
        WHERE Obj.[id] in (@p1) and JSON_VALUE(Obj.doc, '$.Operation') = '68FA31F0-BDB0-11E7-9C95-E3F9522E1FC9' -- С р/с -  оплата поставщику

      UNION

      SELECT
        N'Платежное поручение' as N'СекцияДокумент'
        ,Obj.[code] as N'Номер'
        ,FORMAT (Obj.[date], 'dd.MM.yyyy') as N'Дата'
        ,CAST(JSON_VALUE(Obj.doc, '$.Amount') as money) as N'Сумма'
        ,BAComp.[code] as N'ПлательщикСчет'
        ,N'ИНН ' + JSON_VALUE(Comp.doc, '$.Code1') + ' ' + JSON_VALUE(Comp.doc, '$.FullName') as N'Плательщик'
        ,JSON_VALUE(Comp.doc, '$.Code1') as N'ПлательщикИНН'
        ,JSON_VALUE(Comp.doc, '$.FullName') as N'Плательщик1'
        ,BAComp.[code] as N'ПлательщикРасчСчет'
        ,BankComp.description as N'ПлательщикБанк1'
        ,JSON_VALUE(BankComp.doc, '$.Address') as N'ПлательщикБанк2'
        ,BankComp.[code] as N'ПлательщикБИК'
        ,JSON_VALUE(BankComp.doc, '$.KorrAccount') as N'ПлательщикКорсчет'
        ,BAIn.[code] as N'ПолучательСчет'
        ,N'ИНН ' + JSON_VALUE(CompIn.doc, '$.Code1') + ' ' + JSON_VALUE(CompIn.doc, '$.FullName') as N'Получатель'
        ,JSON_VALUE(CompIn.doc, '$.Code1') as N'ПолучательИНН'
        ,JSON_VALUE(CompIn.doc, '$.FullName') as N'Получатель1'
        ,BAIn.[code] as N'ПолучательРасчСчет'
        ,BankIn.description as N'ПолучательБанк1'
        ,JSON_VALUE(BankIn.doc, '$.Address') as N'ПолучательБанк2'
        ,BankIn.[code] as N'ПолучательБИК'
        ,JSON_VALUE(BankIn.doc, '$.KorrAccount') as N'ПолучательКорсчет'
        ,'01' as N'ВидОплаты'
        ,JSON_VALUE(CompIn.doc, '$.Code2') as N'ПолучательКПП'
        ,5 as N'Очередность'
        ,Obj.[info] as N'НазначениеПлатежа'
        ,FORMAT (Dates.ed, 'dd.MM.yyyy') as N'ДатаКонца_ig'
        ,FORMAT (Dates.bd, 'dd.MM.yyyy') as N'ДатаНачала_ig'
        ,FORMAT (GETDATE(), 'dd.MM.yyyy') as N'ДатаСоздания_ig'
        ,FORMAT (GETDATE(), 'HH:mm:ss') as N'ВремяСоздания_ig'
        ,Obj.company
        ,Obj.[date]
        ,null
        ,null
        ,null N'Налоги_ПлательщикКПП'
        ,null as N'Налоги_ПоказательКБК'
        ,null  as N'Налоги_ОКАТО'
        ,null  as N'Налоги_ПоказательОснования'
        ,null  as N'Налоги_ПоказательПериода'
        ,null  as N'Налоги_ПоказательНомера'
        ,null  as N'Налоги_ПоказательДаты'
        ,null  as N'Налоги_Код'
        ,JSON_VALUE(Obj.doc, '$.Operation')
        FROM [dbo].[Documents] as Obj
        LEFT JOIN (
        SELECT
        MAX(docs.[date]) as ed,
        MIN(docs.[date]) as bd,
        docs.company as company
        FROM [dbo].[Documents] as docs
        WHERE docs.[id] in (@p1)
        GROUP BY company) as Dates on Dates.company = Obj.company
        LEFT JOIN [dbo].[Documents] as Comp on Comp.id = Obj.company and Comp.[type] = 'Catalog.Company'
        LEFT JOIN [dbo].[Documents] as BAComp on BAComp.id = JSON_VALUE(Obj.doc, '$.BankAccountOut') and BAComp.[type] = 'Catalog.BankAccount'
        LEFT JOIN [dbo].[Documents] as BankComp on BankComp.id = JSON_VALUE(BAComp.doc, '$.Bank') and BankComp.[type] = 'Catalog.Bank'
        LEFT JOIN [dbo].[Documents] as BAIn on BAIn.id = JSON_VALUE(Obj.doc, '$.BankAccountTransit') and BAIn.[type] = 'Catalog.BankAccount'
        LEFT JOIN [dbo].[Documents] as CompIn on CompIn.id = BAIn.company and CompIn.[type] = 'Catalog.Company'
        LEFT JOIN [dbo].[Documents] as BankIn on BankIn.id = JSON_VALUE(BAIn.doc, '$.Bank') and BankComp.[type] = 'Catalog.Bank'
        WHERE Obj.[id] in (@p1) and JSON_VALUE(Obj.doc, '$.Operation') = '433D63DE-D849-11E7-83D2-2724888A9E4F' -- С р/с - на расчетный счет  (в путь)

        UNION

        SELECT
        N'Платежное поручение' as N'СекцияДокумент'
        ,Obj.[code] as N'Номер'
        ,FORMAT (Obj.[date], 'dd.MM.yyyy') as N'Дата'
        ,CAST(JSON_VALUE(Obj.doc, '$.Amount') as money) as N'Сумма'
        ,BAComp.[code] as N'ПлательщикСчет'
        ,N'ИНН ' + JSON_VALUE(Comp.doc, '$.Code1') + ' ' + JSON_VALUE(Comp.doc, '$.FullName') as N'Плательщик'
        ,JSON_VALUE(Comp.doc, '$.Code1') as N'ПлательщикИНН'
        ,JSON_VALUE(Comp.doc, '$.FullName') as N'Плательщик1'
        ,BAComp.[code] as N'ПлательщикРасчСчет'
        ,BankComp.description as N'ПлательщикБанк1'
        ,JSON_VALUE(BankComp.doc, '$.Address') as N'ПлательщикБанк2'
        ,BankComp.[code] as N'ПлательщикБИК'
        ,JSON_VALUE(BankComp.doc, '$.KorrAccount') as N'ПлательщикКорсчет'
        ,BASupp.[code] as N'ПолучательСчет'
        ,N'ИНН ' + Supp.[code] + ' ' + JSON_VALUE(Supp.doc, '$.FullName') as N'Получатель'
        ,Supp.[code] as N'ПолучательИНН'
        ,JSON_VALUE(Supp.doc, '$.FullName') as N'Получатель1'
        ,BASupp.[code] as N'ПолучательРасчСчет'
        ,BankSupp.description as N'ПолучательБанк1'
        ,JSON_VALUE(BankSupp.doc, '$.Address') as N'ПолучательБанк2'
        ,BankSupp.[code] as N'ПолучательБИК'
        ,JSON_VALUE(BankSupp.doc, '$.KorrAccount') as N'ПолучательКорсчет'
        ,'01' as N'ВидОплаты'
        ,JSON_VALUE(Supp.doc, '$.Code2') as N'ПолучательКПП'
        ,5 as N'Очередность'
        ,Obj.[info] as N'НазначениеПлатежа'	  
        ,FORMAT (Dates.ed, 'dd.MM.yyyy') as N'ДатаКонца_ig'
        ,FORMAT (Dates.bd, 'dd.MM.yyyy') as N'ДатаНачала_ig'
        ,FORMAT (GETDATE(), 'dd.MM.yyyy') as N'ДатаСоздания_ig'
        ,FORMAT (GETDATE(), 'HH:mm:ss') as N'ВремяСоздания_ig'
        ,Obj.company  as Company_ig
        ,Obj.[date] as ObjDate_ig
        ,null
        ,null
        ,null N'Налоги_ПлательщикКПП'
        ,null as N'Налоги_ПоказательКБК'
        ,null  as N'Налоги_ОКАТО'
        ,null  as N'Налоги_ПоказательОснования'
        ,null  as N'Налоги_ПоказательПериода'
        ,null  as N'Налоги_ПоказательНомера'
        ,null  as N'Налоги_ПоказательДаты'
        ,null  as N'Налоги_Код'
        ,JSON_VALUE(Obj.doc, '$.Operation')
        FROM [dbo].[Documents] as Obj
        LEFT JOIN (
        SELECT
        MAX(docs.[date]) as ed,
        MIN(docs.[date]) as bd,
        docs.company as company
        FROM [dbo].[Documents] as docs
        WHERE docs.[id] in (@p1)
        GROUP BY company) as Dates on Dates.company = Obj.company
        LEFT JOIN [dbo].[Documents] as Comp on Comp.id = Obj.company and Comp.[type] = 'Catalog.Company'
        LEFT JOIN [dbo].[Documents] as BAComp on BAComp.id = JSON_VALUE(Obj.doc, '$.BankAccount') and BAComp.[type] = 'Catalog.BankAccount'
        LEFT JOIN [dbo].[Documents] as BankComp on BankComp.id = JSON_VALUE(BAComp.doc, '$.Bank') and BankComp.[type] = 'Catalog.Bank'
        LEFT JOIN [dbo].[Documents] as Supp on Supp.id = JSON_VALUE(Obj.doc, '$.Counterpartie') and Supp.[type] = 'Catalog.Counterpartie'
        LEFT JOIN [sm].[dbo].[Documents] as BASupp on BASupp.id = JSON_VALUE(Obj.doc, '$.BankAccountSupplier') and BASupp.[type] = 'Catalog.Counterpartie.BankAccount'
        LEFT JOIN [dbo].[Documents] as BankSupp on BankSupp.id = JSON_VALUE(BASupp.doc, '$.Bank') and BankComp.[type] = 'Catalog.Bank'
        WHERE Obj.[id] in (@p1) and JSON_VALUE(Obj.doc, '$.Operation') = '54AA5310-102E-11EA-AA50-31ECFB22CD33' -- С р/с - Выдача/Возврат кредитов и займов (Контрагент)

        UNION

        SELECT
        N'Платежное поручение' as N'СекцияДокумент'
        ,Obj.[code] as N'Номер'
        ,FORMAT (Obj.[date], 'dd.MM.yyyy') as N'Дата'
        ,CAST(JSON_VALUE(Obj.doc, '$.Amount') as money) as N'Сумма'
        ,BAComp.[code] as N'ПлательщикСчет'
        ,N'ИНН ' + JSON_VALUE(Comp.doc, '$.Code1') + ' ' + JSON_VALUE(Comp.doc, '$.FullName') as N'Плательщик'
        ,JSON_VALUE(Comp.doc, '$.Code1') as N'ПлательщикИНН'
        ,JSON_VALUE(Comp.doc, '$.FullName') as N'Плательщик1'
        ,BAComp.[code] as N'ПлательщикРасчСчет'
        ,BankComp.description as N'ПлательщикБанк1'
        ,JSON_VALUE(BankComp.doc, '$.Address') as N'ПлательщикБанк2'
        ,BankComp.[code] as N'ПлательщикБИК'
        ,JSON_VALUE(BankComp.doc, '$.KorrAccount') as N'ПлательщикКорсчет'
        ,BASupp.[code] as N'ПолучательСчет'
        ,N'ИНН ' + Supp.[code] + ' ' + JSON_VALUE(Supp.doc, '$.FullName') as N'Получатель'
        ,Supp.[code] as N'ПолучательИНН'
        ,JSON_VALUE(Supp.doc, '$.FullName') as N'Получатель1'
        ,BASupp.[code] as N'ПолучательРасчСчет'
        ,BankSupp.description as N'ПолучательБанк1'
        ,JSON_VALUE(BankSupp.doc, '$.Address') as N'ПолучательБанк2'
        ,BankSupp.[code] as N'ПолучательБИК'
        ,JSON_VALUE(BankSupp.doc, '$.KorrAccount') as N'ПолучательКорсчет'
        ,'01' as N'ВидОплаты'
        ,JSON_VALUE(Supp.doc, '$.Code2') as N'ПолучательКПП'
        ,5 as N'Очередность'
        ,Obj.[info] as N'НазначениеПлатежа'	    
        ,FORMAT (Dates.ed, 'dd.MM.yyyy') as N'ДатаКонца_ig'
        ,FORMAT (Dates.bd, 'dd.MM.yyyy') as N'ДатаНачала_ig'
        ,FORMAT (GETDATE(), 'dd.MM.yyyy') as N'ДатаСоздания_ig'
        ,FORMAT (GETDATE(), 'HH:mm:ss') as N'ВремяСоздания_ig'
        ,Obj.company  as Company_ig
        ,Obj.[date] as ObjDate_ig
		    ,'02' as N'Налоги_СтатусСоставителя'
        ,'' as N'Налоги_ПоказательТипа'
        ,ISNULL(JSON_VALUE(Comp.doc, '$.Code2'), '0')  as N'Налоги_ПлательщикКПП'
        ,TaxPaymentCode.code as N'Налоги_ПоказательКБК'
        ,JSON_VALUE(Obj.doc, '$.TaxOfficeCode2') as N'Налоги_ОКАТО'
        ,TaxBasisPayment.code as N'Налоги_ПоказательОснования'
        ,TaxPaymentPeriod.code as N'Налоги_ПоказательПериода'
        ,JSON_VALUE(Obj.doc, '$.TaxDocNumber') as N'Налоги_ПоказательНомера'
        ,FORMAT (CAST(JSON_VALUE(Obj.doc, '$.TaxDocDate') as date), 'dd.MM.yyyy') as N'Налоги_ПоказательДаты'
        ,'0' as N'Налоги_Код'
        ,JSON_VALUE(Obj.doc, '$.Operation')
        FROM [dbo].[Documents] as Obj
        LEFT JOIN (
        SELECT
        MAX(docs.[date]) as ed,
        MIN(docs.[date]) as bd,
        docs.company as company
        FROM [dbo].[Documents] as docs
        WHERE docs.[id] in (@p1)
        GROUP BY company) as Dates on Dates.company = Obj.company
        LEFT JOIN [dbo].[Documents] as Comp on Comp.id = Obj.company and Comp.[type] = 'Catalog.Company'
        LEFT JOIN [dbo].[Documents] as BAComp on BAComp.id = JSON_VALUE(Obj.doc, '$.BankAccount') and BAComp.[type] = 'Catalog.BankAccount'
        LEFT JOIN [dbo].[Documents] as BankComp on BankComp.id = JSON_VALUE(BAComp.doc, '$.Bank') and BankComp.[type] = 'Catalog.Bank'
        LEFT JOIN [dbo].[Documents] as Supp on Supp.id = JSON_VALUE(Obj.doc, '$.Supplier') and Supp.[type] = 'Catalog.Counterpartie'
        LEFT JOIN [sm].[dbo].[Documents] as BASupp on BASupp.id = JSON_VALUE(Obj.doc, '$.BankAccountSupplier') and BASupp.[type] = 'Catalog.Counterpartie.BankAccount'
        LEFT JOIN [dbo].[Documents] as BankSupp on BankSupp.id = JSON_VALUE(BASupp.doc, '$.Bank') and BankComp.[type] = 'Catalog.Bank'
        LEFT JOIN [dbo].[Documents] as TaxPaymentCode on TaxPaymentCode.id = JSON_VALUE(Obj.doc, '$.TaxPaymentCode') and TaxPaymentCode.[type] = 'Catalog.TaxPaymentCode'
        LEFT JOIN [dbo].[Documents] as TaxBasisPayment on TaxBasisPayment.id = JSON_VALUE(Obj.doc, '$.TaxBasisPayment') and TaxBasisPayment.[type] = 'Catalog.TaxBasisPayment'
        LEFT JOIN [dbo].[Documents] as TaxPaymentPeriod on TaxPaymentPeriod.id = JSON_VALUE(Obj.doc, '$.TaxPaymentPeriod') and TaxPaymentPeriod.[type] = 'Catalog.TaxPaymentPeriod'
		
        WHERE Obj.[id] in (@p1) and JSON_VALUE(Obj.doc, '$.Operation') = '8D128C20-3E20-11EA-A722-63A01E818155' -- перечисление налогов и взносов

        order by Obj.company, BAComp.[code], Obj.[date] `;

    const DocIds = docsID.map(el => '\'' + el + '\'').join(',');
    query = query.replace(/@p1/g, DocIds);

    return await tx.manyOrNone<[{ key: string, value }]>(query, []);

  }

  static async getBankStatementAsString(docsID: any[], tx: MSSQL): Promise<string> {
    if (!docsID.length) return '';
    const CashRequestsData = await this.getCashRequestsData(docsID, tx);
    if (!CashRequestsData.length) return '';
    let result = '';
    const companySpliter = `---------------------------------------------------------------------`;
    let currentCompany = '';
    let companyCount = 0;
    const naznMaxLength = 210;
    let addFieldsPrefix = '';

    for (const row of CashRequestsData) {

      switch (row['Oper_ig']) {
        case '8D128C20-3E20-11EA-A722-63A01E818155':
          addFieldsPrefix = 'Налоги_';// перечисление налогов и взносов)
          break;
        default:
          addFieldsPrefix = '';
          break;
      }
      if (currentCompany !== String(row['Плательщик'])) {
        if (result.length) {
          result += '\nКонецФайла';
        }
        currentCompany = String(row['Плательщик']);
        companyCount++;
        if (companyCount > 1) {
          result += `\n\n${companySpliter}\n${currentCompany}\n${companySpliter}\n\n`;
        }
        result += `${this.getHeaderText(row)}`;
      }
      for (const prop of Object.keys(row)) {

        if (prop.search('_ig') === -1) {
          let val = row[prop];
          if (addFieldsPrefix && prop.search(addFieldsPrefix) !== -1) {
            result += `\n${prop.replace(addFieldsPrefix, '')}=${val}`;
            continue;
          } else if (!addFieldsPrefix && prop.search('_') !== -1) continue;
          switch (prop) {
            case 'Номер':
              val = this.getShortDocNumber(val);
              break;
            case 'НазначениеПлатежа':
              // НазначениеПлатежа1
              const nazn = String(val).split('\n');
              val = val.replace(/\r?\n/g, ' ');
              const naznStrings = ['', ''];
              if (nazn.length > 1) {
                naznStrings[0] = nazn[0];
                naznStrings[1] = nazn[1];
              } else {
                naznStrings[0] = val;
              }
              const comNazn = `${naznStrings[0]} ${naznStrings[1]}`;
              if (comNazn.length > naznMaxLength) throw new Error(`Превышена максимально допустимая длина назначения платежа в документе №${row['Номер']} на ${comNazn.length - naznMaxLength} символов`);
              result += `\nНазначениеПлатежа=${comNazn}`;
              result += `\nНазначениеПлатежа1=${naznStrings[0]}`;
              result += `\nНазначениеПлатежа2=${naznStrings[1]}`;
              continue;
            case 'ПолучательИНН':
              if ((String(val).length < 10) || (String(val).length > 12)) {
                throw new Error(`Неверно заполнен ИНН получателя ${row['Получатель']} в документе ${row['Номер']}`);
              }
              break;
          }
          result += `\n${prop}=${val}`;
        }
        if (addFieldsPrefix) {

        }
      }
      result += '\nКонецДокумента';
    }

    if (result.length) {
      result += '\nКонецФайла';
    }

    if (companyCount > 1) {
      result = `${companySpliter}\n${CashRequestsData[0]['Плательщик']}\n${companySpliter}\n\n${result.trim()}`;
    }

    return result.trim();

  }

  private static getHeaderText(StatementData): string {

    const headFields = [
      { key: 'ВерсияФормата', value: '1.02' },
      { key: 'Кодировка', value: 'Windows' },
      { key: 'Отправитель', value: '1С:ERP Управление предприятием 2' },
      { key: 'Получатель', value: '' },
      { key: 'ДатаСоздания', value: StatementData['ДатаСоздания_ig'] },
      { key: 'ВремяСоздания', value: StatementData['ВремяСоздания_ig'] },
      { key: 'ДатаНачала', value: StatementData['ДатаНачала_ig'] },
      { key: 'ДатаКонца', value: StatementData['ДатаКонца_ig'] },
      { key: 'РасчСчет', value: StatementData['ПлательщикСчет'] },
      { key: 'Документ', value: 'Платежное поручение' }];

    return '1CClientBankExchange\n' + headFields.map(el => `${el.key}=${el.value}`).join('\n');
  }

  private static getShortDocNumber(docNumber: string): string {
    if (docNumber.split('-').length === 2) {
      const docNumberArr = docNumber.split('-');
      return Number(docNumberArr[1]).toString();
    }
    return docNumber;
  }

}
