import { MSSQL } from '../mssql';

export class BankStatementUnloader {

  private static async getCashRequestsData(docsID: string[], tx: MSSQL) {

    let query = `
    SELECT
      N'Платежное поручение' as N'СекцияДокумент'
      ,Obj.[code] as N'Номер'
      ,FORMAT (Obj.[date], 'dd.MM.yyyy')  as N'Дата'
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
      ,'01' as N'ВидОплаты'
      ,JSON_VALUE(Supp.doc, '$.Code2') as N'ПолучательКПП'
      ,5 as N'Очередность'
      ,Obj.[info] as N'НазначениеПлатежа'
      ,'' as N'НазначениеПлатежа1'
      ,'' as N'НазначениеПлатежа2'
      ,FORMAT (Dates.ed, 'dd.MM.yyyy') as N'ДатаКонца_ig'
      ,FORMAT (Dates.bd, 'dd.MM.yyyy') as N'ДатаНачала_ig'
      ,FORMAT (GETDATE(), 'dd.MM.yyyy') as N'ДатаСоздания_ig'
      ,FORMAT (GETDATE(), 'HH:mm:ss') as N'ВремяСоздания_ig'
    FROM [dbo].[Documents] as Obj
      LEFT JOIN (
        SELECT
          MAX(docs.[date]) as ed,
          MIN(docs.[date]) as bd
        FROM [dbo].[Documents] as docs
        WHERE docs.[id] in (@p1)) as Dates on 1=1
    LEFT JOIN [dbo].[Documents] as Comp on Comp.id = Obj.company and Comp.[type] = 'Catalog.Company'
    LEFT JOIN [dbo].[Documents] as BAComp on BAComp.id = JSON_VALUE(Obj.doc, '$.BankAccount') and BAComp.[type] = 'Catalog.BankAccount'
    LEFT JOIN [dbo].[Documents] as BankComp on BankComp.id = JSON_VALUE(BAComp.doc, '$.Bank') and BankComp.[type] = 'Catalog.Bank'
    LEFT JOIN [dbo].[Documents] as Supp on Supp.id = JSON_VALUE(Obj.doc, '$.Supplier') and Supp.[type] = 'Catalog.Counterpartie'
    LEFT JOIN [dbo].[Documents] as BASupp on JSON_VALUE(BASupp.doc, '$.owner') = Supp.id and BASupp.[type] = 'Catalog.Counterpartie.BankAccount'
    LEFT JOIN [dbo].[Documents] as BankSupp on BankSupp.id = JSON_VALUE(BASupp.doc, '$.Bank') and BankComp.[type] = 'Catalog.Bank'
    WHERE Obj.[id] in (@p1)
    order by BAComp.[code], Obj.[date] ;`;

    const DocIds =  docsID.map(el => '\'' + el + '\'').join(',');
    query = query.replace('@p1', DocIds).replace('@p1', DocIds);
    // .replace('@p1', DocIds);
    // query = query.replace(/[sm-i]\./g, `[sm-i]`)

    return await tx.manyOrNone<[{ key: string, value }]>(query, [docsID]);

  }

  static async getBankStatementAsString(docsID: any[], tx: MSSQL): Promise<string> {

    const CashRequestsData = await this.getCashRequestsData(docsID, tx);

    if (!CashRequestsData.length) {
      return '';
    }

    let result = '';
    const spliter = '\n';

    for (const row of CashRequestsData) {
      for (const prop of Object.keys(row)) {
        if (prop.search('_ig') === -1) {
          result += `${ spliter }${ prop }=${ row[prop] }`;
        }
      }
      result += spliter + 'КонецДокумента';
    }

    const headFields = [
    { key: 'ВерсияФормата', value: '1.02' },
    { key: 'Кодировка', value: 'Windows' },
    { key: 'Отправитель', value: '1С:ERP Управление предприятием 2' },
    { key: 'Получатель', value: '' },
    { key: 'ДатаСоздания', value: CashRequestsData[0]['ДатаСоздания_ig'] },
    { key: 'ВремяСоздания', value: CashRequestsData[0]['ВремяСоздания_ig'] },
    { key: 'ДатаНачала', value: CashRequestsData[0]['ДатаНачала_ig'] },
    { key: 'ДатаКонца', value: CashRequestsData[0]['ДатаКонца_ig'] },
    { key: 'РасчСчет', value:  CashRequestsData[0]['ПлательщикСчет'] },
    { key: 'Документ', value: 'Платежное поручение' }];

    return '1CClientBankExchange\n' + headFields.map(el => `${el.key}=${el.value}`).join(spliter) + result + '\nКонецФайла';
  }

}
