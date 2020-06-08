import { MSSQL } from '../mssql';
import { lib } from '../std.lib';
import { Ref } from '../models/document';

export class BankStatementUnloader {

  static docsIdsString = '';
  static docsIds: string[];
  static tx: MSSQL;
  static isSalaryProject = false;
  static country = '';
  static operation = '';
  static operationTypes: string[];
  static docsByTypes: { id: string, operation: string }[];

  private static isUKRAINE(): boolean {
    return this.country === 'E04BAF30-4D6A-11EA-9419-5B6F020710B8';
  }

  private static isKAZAKHSTAN(): boolean {
    return this.country === '381AA090-4D6B-11EA-9419-5B6F020710B8';
  }

  private static getQueryTextSalaryProjectCommon() {

    if (this.isUKRAINE()) {
      return `
      select
        sp.code N'N_D',
        BankAccount.code N'COUNT_A',
        doc.[info] as N_P,
        ISNULL(JSON_QUERY(doc.doc,'$.PayRolls'),'') ig_PayRolls
      from [dbo].[Documents] doc
        inner join [dbo].[Documents] sp on JSON_VALUE(doc.doc,N'$.SalaryProject') = sp.id
        inner join [dbo].[Documents] BankAccount on JSON_VALUE(doc.doc,N'$.BankAccount') = BankAccount.id
      where doc.id in (@p1)`;
    }
    return `
    select
      doc.id N'ИдПервичногоДокумента',
      doc.date ig_DocDate,
      FORMAT (doc.date, 'dd.MM.yyyy') N'ДатаРеестра',
      bank.code N'БИК',
      ISNULL(JSON_VALUE(comp.doc,'$.Code1'),'') N'ИНН',
      comp.description N'НаименованиеОрганизации',
      BankAccount.code N'РасчетныйСчетОрганизации',
      FORMAT (CAST(JSON_VALUE(sp.doc,'$.OpenDate') as date), 'dd.MM.yyyy') N'ДатаДоговора',
      sp.code N'НомерДоговора',
      FORMAT (doc.date, 'dd.MM.yyyy') N'ДатаФормирования',
      doc.id ig_Id,
      JSON_VALUE(doc.doc,'$.SalaryProject') ig_SalaryProject,
      currency.code ig_КодВалюты,
      ISNULL(JSON_VALUE(doc.doc,'$.EnforcementProceedings'),'') ig_ВидДохода,
      ISNULL(JSON_QUERY(doc.doc,'$.PayRolls'),'') ig_PayRolls,
      ISNULL(JSON_VALUE(sp.doc,'$.BankBranch'),'') ig_ОтделениеБанка,
      ISNULL(JSON_VALUE(sp.doc,'$.BankBranchOffice'),'') ig_BankBranchOffice
    from [dbo].[Documents] doc
      inner join [dbo].[Documents] sp on JSON_VALUE(doc.doc,N'$.SalaryProject') = sp.id
      inner join [dbo].[Documents] BankAccount on JSON_VALUE(doc.doc,N'$.BankAccount') = BankAccount.id
      inner join [dbo].[Documents] comp on sp.company = comp.id
      inner join [dbo].[Documents] bank on JSON_VALUE(sp.doc,N'$.bank') = bank.id
      inner join [dbo].[Documents] currency on JSON_VALUE(doc.doc,N'$.currency') = currency.id
    where doc.id in (@p1)`;
  }

  private static getQueryTextSalaryEmployees() {
    return `
    DROP TABLE IF EXISTS #PayRolls;
    SELECT *
    INTO #PayRolls
    FROM OPENJSON(@p1, N'$.PayRolls')
    WITH (
        Employee VARCHAR(200) N'$.Employee',
        BankAccount VARCHAR(200) N'$.BankAccount',
        AmountPenalty VARCHAR(200) N'$.AmountPenalty',
        Amount MONEY N'$.Amount');
    SELECT
      ISNULL(JSON_VALUE(person.doc,'$.LastName'),'') N'Фамилия',
      ISNULL(JSON_VALUE(person.doc,'$.FirstName'),'') N'Имя',
      ISNULL(JSON_VALUE(person.doc,'$.MiddleName'),'') N'Отчество',
      N'ig_ОтделениеБанка' N'rp_ОтделениеБанка',
      ba.code N'ЛицевойСчет',
      pr.Amount N'Сумма',
      pr.AmountPenalty N'ОбщаяСуммаУдержаний',
      N'ig_КодВалюты' N'rp_КодВалюты'
    FROM #PayRolls pr
      left join [dbo].[Documents] person on person.id = pr.Employee
      left join [dbo].[Documents] ba on ba.id = pr.BankAccount;`;
  }

  private static getQueryTextSalaryEmployeesUKRAINE() {
    return `
    DROP TABLE IF EXISTS #PayRolls;
    SELECT *
    INTO #PayRolls
    FROM OPENJSON(@p1, N'$.PayRolls')
    WITH (
        Employee VARCHAR(200) N'$.Employee',
        BankAccount VARCHAR(200) N'$.BankAccount',
        Amount MONEY N'$.Amount');
    SELECT
      ISNULL(person.description,'') N'NAME_B',
      ba.code N'COUNT_B',
      pr.Amount N'SUMMA',
      JSON_VALUE(Person.doc, '$.Code1') as OKPO_B
    FROM #PayRolls pr
      left join [dbo].[Documents] person on person.id = pr.Employee
      left join [dbo].[Documents] ba on ba.id = pr.BankAccount;`;
  }

  private static async getQueryTextCommon(): Promise<string> {

    if (this.isUKRAINE()) {
      switch (this.operation) {
        case 'E47A8910-4599-11EA-AAE2-A1796B9A826A': // С р/с - выплата зарплаты (СОТРУДНИКУ без ведомости) (RUSSIA)
          return this.getQueryTextCommonUKRAINEВыплатаЗарплаты();
        case '433D63DE-D849-11E7-83D2-2724888A9E4F': // С р/с - на расчетный счет  (в путь)
          return this.getQueryTextCommonUKRAINEНаРасчетныйСчетВПуть();
        case '54AA5310-102E-11EA-AA50-31ECFB22CD33': // С р/с - Выдача/Возврат кредитов и займов (Контрагент)
          return this.getQueryTextCommonUKRANEВозвратКредитовИЗаймов();
        case '8D128C20-3E20-11EA-A722-63A01E818155': // перечисление налогов и взносов
        case '68FA31F0-BDB0-11E7-9C95-E3F9522E1FC9': // С р/с -  оплата поставщику
          return this.getQueryTextCommonUKRAINEОплатаПоставщику();
      }
    } else {
      switch (this.operation) {
        case 'E47A8910-4599-11EA-AAE2-A1796B9A826A': // С р/с - выплата зарплаты (СОТРУДНИКУ без ведомости) (RUSSIA)
          return this.getQueryTextCommonRUSSIAВыплатаЗарплаты();
        case 'BF4B4126-D835-11E7-9D5E-E7807DB3B488': // С р/с - подотчетному
          return this.getQueryTextCommonRUSSIAВыдачаДСПодотчетнику();
        case '8D128C20-3E20-11EA-A722-63A01E818155': // перечисление налогов и взносов
          return this.getQueryTextCommonRUSSIAперечислениеНалоговИВзносов();
        case '54AA5310-102E-11EA-AA50-31ECFB22CD33': // С р/с - Выдача/Возврат кредитов и займов (Контрагент)
          return this.getQueryTextCommonRUSSIAВозвратКредитовИЗаймов();
        case '433D63DE-D849-11E7-83D2-2724888A9E4F': // С р/с - на расчетный счет  (в путь)
          return this.getQueryTextCommonRUSSIAНаРасчетныйСчетВПуть();
        case '68FA31F0-BDB0-11E7-9C95-E3F9522E1FC9': // С р/с -  оплата поставщику
          if (this.isKAZAKHSTAN()) return this.getQueryTextCommonKAZAKHSTANОплатаПоставщику();
          else return this.getQueryTextCommonRUSSIAОплатаПоставщику();
      }
    }
    const operation = await lib.doc.byId(this.operation, this.tx);
    throw new Error(`Не реализована выгрузка для операции ${operation?.description}`);
  }

  private static getQueryTextCommonUKRAINEОплатаПоставщику() {
    return `SELECT
    Obj.[code] as N_D
    ,CONVERT(MONEY, JSON_VALUE(Obj.doc, '$.Amount')) as SUMMA
    ,BAComp.[code] as COUNT_A
    ,Supp.[description] as NAME_B
    ,BASupp.[code] as COUNT_B
    ,Obj.[info] as N_P
	  ,JSON_VALUE(Supp.doc, '$.Code1') as OKPO_B

    FROM [dbo].[Documents] as Obj
    LEFT JOIN [dbo].[Documents] as BAComp on BAComp.id = JSON_VALUE(Obj.doc, '$.BankAccount') and BAComp.[type] = 'Catalog.BankAccount'
    LEFT JOIN [dbo].[Documents] as Supp on Supp.id = JSON_VALUE(Obj.doc, '$.Supplier') and Supp.[type] = 'Catalog.Counterpartie'
    LEFT JOIN [dbo].[Documents] as BASupp on BASupp.id = JSON_VALUE(Obj.doc, '$.BankAccountSupplier') and BASupp.[type] = 'Catalog.Counterpartie.BankAccount'

    WHERE Obj.[id] in (@p1) and JSON_VALUE(Obj.doc, '$.Operation') IN ('68FA31F0-BDB0-11E7-9C95-E3F9522E1FC9','54AA5310-102E-11EA-AA50-31ECFB22CD33','8D128C20-3E20-11EA-A722-63A01E818155') -- С р/с -  оплата поставщику
    order by Obj.company, BAComp.[code], Obj.[date]`;
  }

  private static getQueryTextCommonUKRAINEНаРасчетныйСчетВПуть() {
    return `SELECT
        Obj.[code] as N_D
        ,CONVERT(MONEY, JSON_VALUE(Obj.doc, '$.Amount')) as SUMMA
        ,BAComp.[code] as COUNT_A
        ,JSON_VALUE(CompIn.doc, '$.FullName') as NAME_B
        ,BAIn.[code] as COUNT_B
        ,Obj.[info] as N_P
      ,JSON_VALUE(CompIn.doc, '$.Code1') as OKPO_B
        FROM [dbo].[Documents] as Obj
        LEFT JOIN [dbo].[Documents] as BAComp on BAComp.id = JSON_VALUE(Obj.doc, '$.BankAccountOut') and BAComp.[type] = 'Catalog.BankAccount'
        LEFT JOIN [dbo].[Documents] as BAIn on BAIn.id = JSON_VALUE(Obj.doc, '$.BankAccountTransit') and BAIn.[type] = 'Catalog.BankAccount'
        LEFT JOIN [dbo].[Documents] as CompIn on CompIn.id = BAIn.company and CompIn.[type] = 'Catalog.Company'
        WHERE Obj.[id] in (@p1) and JSON_VALUE(Obj.doc, '$.Operation') = '433D63DE-D849-11E7-83D2-2724888A9E4F' -- С р/с - на расчетный счет  (в путь)
        order by Obj.company, BAComp.[code], Obj.[date]`;

  }

  private static getQueryTextCommonUKRANEВозвратКредитовИЗаймов() {
    return `SELECT
    Obj.[code] as N_D
    ,CONVERT(MONEY, JSON_VALUE(Obj.doc, '$.Amount')) as SUMMA
    ,BAComp.[code] as COUNT_A
    ,Supp.[description] as NAME_B
    ,BASupp.[code] as COUNT_B
    ,Obj.[info] as N_P
	  ,JSON_VALUE(Supp.doc, '$.Code1') as OKPO_B
  FROM [dbo].[Documents] as Obj
  LEFT JOIN [dbo].[Documents] as BAComp on BAComp.id = JSON_VALUE(Obj.doc, '$.BankAccount') and BAComp.[type] = 'Catalog.BankAccount'
	LEFT JOIN [dbo].[Documents] as Supp on Supp.id = JSON_VALUE(Obj.doc, '$.Counterpartie') and Supp.[type] = 'Catalog.Counterpartie'
  LEFT JOIN [dbo].[Documents] as BASupp on BASupp.id = JSON_VALUE(Obj.doc, '$.BankAccountSupplier') and BASupp.[type] = 'Catalog.Counterpartie.BankAccount'
  WHERE Obj.[id] in (@p1) and JSON_VALUE(Obj.doc, '$.Operation') = '54AA5310-102E-11EA-AA50-31ECFB22CD33' -- С р/с - Выдача/Возврат кредитов и займов (Контрагент)
  order by Obj.company, BAComp.[code], Obj.[date]`;
  }

  private static getQueryTextCommonUKRAINEВыплатаЗарплаты() {
    return `SELECT
    Obj.[code] as N_D
    ,CONVERT(MONEY, JSON_VALUE(Obj.doc, '$.Amount')) as SUMMA
    ,BAComp.[code] as COUNT_A
    ,Person.description as NAME_B
    ,BAEmp.[code] as COUNT_B
    ,Obj.[info] as N_P
	,JSON_VALUE(Person.doc, '$.Code1') as OKPO_B

    FROM [dbo].[Documents] as Obj
    LEFT JOIN [dbo].[Documents] as BAComp on BAComp.id = JSON_VALUE(Obj.doc, '$.BankAccount') and BAComp.[type] = 'Catalog.BankAccount'
    LEFT JOIN [dbo].[Documents] as BAEmp on BAEmp.id = JSON_VALUE(Obj.doc, '$.BankAccountPerson') and BAEmp.[type] = 'Catalog.Counterpartie.BankAccount'
	LEFT JOIN [dbo].[Documents] as Person on Person.id = JSON_VALUE(Obj.doc, '$.Employee') and Person.[type] = 'Catalog.Person'

    WHERE Obj.[id] in (@p1) and JSON_VALUE(Obj.doc, '$.Operation') = 'E47A8910-4599-11EA-AAE2-A1796B9A826A' -- С р/с - выплата зарплаты (СОТРУДНИКУ без ведомости) (RUSSIA)
    order by Obj.company, BAComp.[code], Obj.[date]`;

  }
  private static getQueryTextCommonRUSSIAОплатаПоставщику() {
    return `     SELECT
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
    ,Obj.company  as Company_ig
    ,JSON_VALUE(Comp.doc, '$.FullName') as N'Плательщик_ig'
    ,Obj.[date] as ObjDate_ig
    ,JSON_VALUE(Obj.doc, '$.Operation') as Oper_ig
    FROM [dbo].[Documents] as Obj
    LEFT JOIN [dbo].[Documents] as Comp on Comp.id = Obj.company and Comp.[type] = 'Catalog.Company'
    LEFT JOIN [dbo].[Documents] as BAComp on BAComp.id = JSON_VALUE(Obj.doc, '$.BankAccount') and BAComp.[type] = 'Catalog.BankAccount'
    LEFT JOIN [dbo].[Documents] as BankComp on BankComp.id = JSON_VALUE(BAComp.doc, '$.Bank') and BankComp.[type] = 'Catalog.Bank'
    LEFT JOIN [dbo].[Documents] as Supp on Supp.id = JSON_VALUE(Obj.doc, '$.Supplier') and Supp.[type] = 'Catalog.Counterpartie'
    LEFT JOIN [dbo].[Documents] as BASupp on BASupp.id = JSON_VALUE(Obj.doc, '$.BankAccountSupplier') and BASupp.[type] = 'Catalog.Counterpartie.BankAccount'
    LEFT JOIN [dbo].[Documents] as BankSupp on BankSupp.id = JSON_VALUE(BASupp.doc, '$.Bank') and BankComp.[type] = 'Catalog.Bank'
    WHERE Obj.[id] in (@p1) and JSON_VALUE(Obj.doc, '$.Operation') = '68FA31F0-BDB0-11E7-9C95-E3F9522E1FC9' -- С р/с -  оплата поставщику
    order by Obj.company, BAComp.[code], Obj.[date]`;
  }

  private static getQueryTextCommonRUSSIAВыдачаДСПодотчетнику() {
    return `     SELECT
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
    ,BAPers.[code] as N'ПолучательСчет'
    ,N'ИНН ' + Pers.[code] + ' ' + Pers.[description] as N'Получатель'
    ,Pers.[code] as N'ПолучательИНН'
    ,Pers.description as N'Получатель1'
    ,BAPers.[code] as N'ПолучательРасчСчет'
    ,BankPers.description as N'ПолучательБанк1'
    ,JSON_VALUE(BankPers.doc, '$.Address') as N'ПолучательБанк2'
    ,BankPers.[code] as N'ПолучательБИК'
    ,JSON_VALUE(BankPers.doc, '$.KorrAccount') as N'ПолучательКорсчет'
    ,'01' as N'ВидОплаты'
    ,5 as N'Очередность'
    ,Obj.[info] as N'НазначениеПлатежа'
    ,Obj.company  as Company_ig
    ,JSON_VALUE(Comp.doc, '$.FullName') as N'Плательщик_ig'
    ,Obj.[date] as ObjDate_ig
    ,JSON_VALUE(Obj.doc, '$.Operation') as Oper_ig
    FROM [dbo].[Documents] as Obj
    LEFT JOIN [dbo].[Documents] as Comp on Comp.id = Obj.company
    LEFT JOIN [dbo].[Documents] as BAComp on BAComp.id = JSON_VALUE(Obj.doc, '$.BankAccount')
    LEFT JOIN [dbo].[Documents] as BankComp on BankComp.id = JSON_VALUE(BAComp.doc, '$.Bank')
    LEFT JOIN [dbo].[Documents] as Pers on Pers.id = JSON_VALUE(Obj.doc, '$.Person')
    LEFT JOIN [dbo].[Documents] as BAPers on BAPers.id = JSON_VALUE(Obj.doc, '$.BankAccountPerson')
    LEFT JOIN [dbo].[Documents] as BankPers on BankPers.id = JSON_VALUE(BAPers.doc, '$.Bank')
    WHERE Obj.[id] in (@p1) and JSON_VALUE(Obj.doc, '$.Operation') = 'BF4B4126-D835-11E7-9D5E-E7807DB3B488' -- С р/с - подотчетному
    order by Obj.company, BAComp.[code], Obj.[date]`;
  }

  private static getQueryTextCommonRUSSIAНаРасчетныйСчетВПуть() {
    return `      SELECT
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
        ,N'Платежное поручение' as N'Документ_ig_head'
        ,Obj.company  as Company_ig
        ,JSON_VALUE(Comp.doc, '$.FullName') as N'Плательщик_ig'
        ,Obj.[date] as ObjDate_ig
        ,JSON_VALUE(Obj.doc, '$.Operation') as Oper_ig
        FROM [dbo].[Documents] as Obj
        LEFT JOIN [dbo].[Documents] as Comp on Comp.id = Obj.company and Comp.[type] = 'Catalog.Company'
        LEFT JOIN [dbo].[Documents] as BAComp on BAComp.id = JSON_VALUE(Obj.doc, '$.BankAccountOut') and BAComp.[type] = 'Catalog.BankAccount'
        LEFT JOIN [dbo].[Documents] as BankComp on BankComp.id = JSON_VALUE(BAComp.doc, '$.Bank') and BankComp.[type] = 'Catalog.Bank'
        LEFT JOIN [dbo].[Documents] as BAIn on BAIn.id = JSON_VALUE(Obj.doc, '$.BankAccountTransit') and BAIn.[type] = 'Catalog.BankAccount'
        LEFT JOIN [dbo].[Documents] as CompIn on CompIn.id = BAIn.company and CompIn.[type] = 'Catalog.Company'
        LEFT JOIN [dbo].[Documents] as BankIn on BankIn.id = JSON_VALUE(BAIn.doc, '$.Bank') and BankComp.[type] = 'Catalog.Bank'
        WHERE Obj.[id] in (@p1) and JSON_VALUE(Obj.doc, '$.Operation') = '433D63DE-D849-11E7-83D2-2724888A9E4F' -- С р/с - на расчетный счет  (в путь)
    order by Obj.company, BAComp.[code], Obj.[date]`;

  }

  private static getQueryTextCommonRUSSIAВозвратКредитовИЗаймов() {
    return `     SELECT
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
    FROM [dbo].[Documents] as Obj
    LEFT JOIN [dbo].[Documents] as Comp on Comp.id = Obj.company and Comp.[type] = 'Catalog.Company'
    LEFT JOIN [dbo].[Documents] as BAComp on BAComp.id = JSON_VALUE(Obj.doc, '$.BankAccount') and BAComp.[type] = 'Catalog.BankAccount'
    LEFT JOIN [dbo].[Documents] as BankComp on BankComp.id = JSON_VALUE(BAComp.doc, '$.Bank') and BankComp.[type] = 'Catalog.Bank'
    LEFT JOIN [dbo].[Documents] as Supp on Supp.id = JSON_VALUE(Obj.doc, '$.Counterpartie') and Supp.[type] = 'Catalog.Counterpartie'
    LEFT JOIN [dbo].[Documents] as BASupp on BASupp.id = JSON_VALUE(Obj.doc, '$.BankAccountSupplier') and BASupp.[type] = 'Catalog.Counterpartie.BankAccount'
    LEFT JOIN [dbo].[Documents] as BankSupp on BankSupp.id = JSON_VALUE(BASupp.doc, '$.Bank') and BankComp.[type] = 'Catalog.Bank'
    WHERE Obj.[id] in (@p1) and JSON_VALUE(Obj.doc, '$.Operation') = '54AA5310-102E-11EA-AA50-31ECFB22CD33' -- С р/с - Выдача/Возврат кредитов и займов (Контрагент)
    order by Obj.company, BAComp.[code], Obj.[date]`;
  }

  private static getQueryTextCommonRUSSIAперечислениеНалоговИВзносов() {
    return `SELECT
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
    ,'02' as N'СтатусСоставителя'
    ,'' as N'ПоказательТипа'
    ,CASE WHEN JSON_VALUE(Obj.doc, '$.TaxKPP') = '' THEN '0' ELSE ISNULL(JSON_VALUE(Obj.doc, '$.TaxKPP'),'0') END as N'ПлательщикКПП'
    ,TaxPaymentCode.code as N'ПоказательКБК'
    ,JSON_VALUE(Obj.doc, '$.TaxOfficeCode2') as N'ОКАТО'
    ,TaxBasisPayment.code as N'ПоказательОснования'
    ,TaxPaymentPeriod.code as N'ПоказательПериода'
    ,CASE WHEN JSON_VALUE(Obj.doc, '$.TaxDocNumber') = '' THEN '0' ELSE ISNULL(JSON_VALUE(Obj.doc, '$.TaxDocNumber'),'0') END as N'ПоказательНомера'
    ,CASE WHEN JSON_VALUE(Obj.doc, '$.TaxDocDate') = '' THEN '0' ELSE ISNULL(FORMAT (CAST(JSON_VALUE(Obj.doc, '$.TaxDocDate') as date), 'dd.MM.yyyy'),'0') END as N'ПоказательДаты'
    ,'0' as N'Код'
    FROM [dbo].[Documents] as Obj
    LEFT JOIN [dbo].[Documents] as Comp on Comp.id = Obj.company and Comp.[type] = 'Catalog.Company'
    LEFT JOIN [dbo].[Documents] as BAComp on BAComp.id = JSON_VALUE(Obj.doc, '$.BankAccount') and BAComp.[type] = 'Catalog.BankAccount'
    LEFT JOIN [dbo].[Documents] as BankComp on BankComp.id = JSON_VALUE(BAComp.doc, '$.Bank') and BankComp.[type] = 'Catalog.Bank'
    LEFT JOIN [dbo].[Documents] as Supp on Supp.id = JSON_VALUE(Obj.doc, '$.Supplier') and Supp.[type] = 'Catalog.Counterpartie'
    LEFT JOIN [dbo].[Documents] as BASupp on BASupp.id = JSON_VALUE(Obj.doc, '$.BankAccountSupplier') and BASupp.[type] = 'Catalog.Counterpartie.BankAccount'
    LEFT JOIN [dbo].[Documents] as BankSupp on BankSupp.id = JSON_VALUE(BASupp.doc, '$.Bank') and BankComp.[type] = 'Catalog.Bank'
    LEFT JOIN [dbo].[Documents] as TaxPaymentCode on TaxPaymentCode.id = JSON_VALUE(Obj.doc, '$.TaxPaymentCode') and TaxPaymentCode.[type] = 'Catalog.TaxPaymentCode'
    LEFT JOIN [dbo].[Documents] as TaxBasisPayment on TaxBasisPayment.id = JSON_VALUE(Obj.doc, '$.TaxBasisPayment') and TaxBasisPayment.[type] = 'Catalog.TaxBasisPayment'
    LEFT JOIN [dbo].[Documents] as TaxPaymentPeriod on TaxPaymentPeriod.id = JSON_VALUE(Obj.doc, '$.TaxPaymentPeriod') and TaxPaymentPeriod.[type] = 'Catalog.TaxPaymentPeriod'
    WHERE Obj.[id] in (@p1) and JSON_VALUE(Obj.doc, '$.Operation') = '8D128C20-3E20-11EA-A722-63A01E818155' -- перечисление налогов и взносов
    order by Obj.company, BAComp.[code], Obj.[date]`;

  }

  private static getQueryTextCommonRUSSIAВыплатаЗарплаты() {

    return `SELECT
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
    ,BAEmp.[code] as N'ПолучательСчет'
    ,N'ИНН ' + JSON_VALUE(Person.doc, '$.Code1') + ' ' + Person.description  as N'Получатель'
    ,JSON_VALUE(Person.doc, '$.Code1') as N'ПолучательИНН'
    ,Person.description N'Получатель1'--(Person.doc, '$.FullName') as N'Получатель1'
    ,BAEmp.[code] as N'ПолучательРасчСчет'
    ,BankPers.description as N'ПолучательБанк1'
    ,ISNULL(JSON_VALUE(BankPers.doc, '$.Address'),'') as N'ПолучательБанк2'
    ,BankPers.[code] as N'ПолучательБИК'
    ,JSON_VALUE(BankPers.doc, '$.KorrAccount') as N'ПолучательКорсчет'
    ,'01' as N'ВидОплаты'
    ,ISNULL(JSON_VALUE(Comp.doc, '$.Code2'),'') as N'ПлательщикКПП'
    ,3 as N'Очередность'
    ,Obj.[info] as N'НазначениеПлатежа'
    FROM [dbo].[Documents] as Obj
    LEFT JOIN [dbo].[Documents] as Comp on Comp.id = Obj.company and Comp.[type] = 'Catalog.Company'
    LEFT JOIN [dbo].[Documents] as BAComp on BAComp.id = JSON_VALUE(Obj.doc, '$.BankAccount') and BAComp.[type] = 'Catalog.BankAccount'
    LEFT JOIN [dbo].[Documents] as BankComp on BankComp.id = JSON_VALUE(BAComp.doc, '$.Bank') and BankComp.[type] = 'Catalog.Bank'
    LEFT JOIN [dbo].[Documents] as Person on Person.id = JSON_VALUE(Obj.doc, '$.Employee') and Person.[type] = 'Catalog.Person'
    LEFT JOIN [dbo].[Documents] as BAEmp on BAEmp.id = JSON_VALUE(Obj.doc, '$.BankAccountPerson') and BAEmp.[type] = 'Catalog.Counterpartie.BankAccount'
    LEFT JOIN [dbo].[Documents] as BankPers on BankPers.id = JSON_VALUE(BAEmp.doc, '$.Bank') and BankComp.[type] = 'Catalog.Bank'
    WHERE Obj.[id] in (@p1) and JSON_VALUE(Obj.doc, '$.Operation') = 'E47A8910-4599-11EA-AAE2-A1796B9A826A' -- С р/с - выплата зарплаты (СОТРУДНИКУ без ведомости) (RUSSIA)

    order by Obj.company, BAComp.[code], Obj.[date]`;
  }

  private static getQueryTextCommonKAZAKHSTANОплатаПоставщику() {
    return `SELECT
    N'ПлатежноеПоручение' as N'СекцияДокумент'
    ,Obj.[code] as N'НомерДокумента'
    ,FORMAT (Obj.[date], 'dd.MM.yyyy') as N'ДатаДокумента'
    ,CAST(JSON_VALUE(Obj.doc, '$.Amount') as money) as N'Сумма'
    ,JSON_VALUE(Comp.doc, '$.FullName') as N'ПлательщикНаименование'
    ,JSON_VALUE(Comp.doc, '$.Code1') as N'ПлательщикБИН_ИИН'
    ,JSON_VALUE(Comp.doc, '$.BC')  as N'ПлательщикКБЕ'
    ,BAComp.[code] as N'ПлательщикИИК'
    ,BankComp.description as N'ПлательщикБанкНаименование'
    ,JSON_VALUE(BankComp.doc, '$.Code1') as N'ПлательщикБанкБИН_ИИН'
    ,BankComp.Code as N'ПлательщикБанкБИК'
    ,JSON_VALUE(Supp.doc, '$.FullName') as N'ПолучательНаименование'
    ,JSON_VALUE(Supp.doc, '$.Code1') as N'ПолучательБИН_ИИН'
    ,JSON_VALUE(Supp.doc, '$.BC') as N'ПолучательКБЕ'
    ,BASupp.[code] as N'ПолучательИИК'
    ,BankSupp.description as N'ПолучательБанкНаименование'
    ,JSON_VALUE(BankSupp.doc, '$.Code1') as N'ПолучательБанкБИН_ИИН'
    ,BankSupp.Code as N'ПолучательБанкБИК'
    ,Obj.[info] as N'НазначениеПлатежа'
    ,TaxAssignmentCode.Code as N'КодНазначенияПлатежа'
    ,FORMAT (Obj.[date], 'dd.MM.yyyy') as N'ДатаВалютирования'
    ,ISNULL(Curr.description,'') as N'Валюта'
    FROM [dbo].[Documents] as Obj
    LEFT JOIN [dbo].[Documents] as Comp on Comp.id = Obj.company and Comp.[type] = 'Catalog.Company'
    LEFT JOIN [dbo].[Documents] as TaxAssignmentCode on TaxAssignmentCode.id = JSON_VALUE(Obj.doc, '$.TaxAssignmentCode') and TaxAssignmentCode.[type] = 'Catalog.TaxAssignmentCode'
    LEFT JOIN [dbo].[Documents] as Curr on Curr.id = JSON_VALUE(Obj.doc, '$.currency') and Curr.[type] = 'Catalog.Currency'
    LEFT JOIN [dbo].[Documents] as BAComp on BAComp.id = JSON_VALUE(Obj.doc, '$.BankAccount') and BAComp.[type] = 'Catalog.BankAccount'
    LEFT JOIN [dbo].[Documents] as BankComp on BankComp.id = JSON_VALUE(BAComp.doc, '$.Bank') and BankComp.[type] = 'Catalog.Bank'
    LEFT JOIN [dbo].[Documents] as Supp on Supp.id = JSON_VALUE(Obj.doc, '$.Supplier') and Supp.[type] = 'Catalog.Counterpartie'
    LEFT JOIN [dbo].[Documents] as BASupp on BASupp.id = JSON_VALUE(Obj.doc, '$.BankAccountSupplier') and BASupp.[type] = 'Catalog.Counterpartie.BankAccount'
    LEFT JOIN [dbo].[Documents] as BankSupp on BankSupp.id = JSON_VALUE(BASupp.doc, '$.Bank') and BankComp.[type] = 'Catalog.Bank'
    WHERE Obj.[id] in (@p1) and JSON_VALUE(Obj.doc, '$.Operation') = '68FA31F0-BDB0-11E7-9C95-E3F9522E1FC9' -- С р/с -  оплата поставщику
    order by Obj.company, BAComp.[code], Obj.[date]`;
  }

  private static async executeQuery(query: string, params: any[] = []) {
    query = query.replace(/@p1/g, this.docsIdsString);
    return await this.tx.manyOrNone<{ key: string, value }>(query, params);
  }

  private static async getSalaryProjectEmployeesDataFromJSON(EmployeesDataJSON: string): Promise<{ key: string, value }[]> {
    return await this.tx.manyOrNone<{ key: string, value }>(this.getQueryTextSalaryEmployees(), [EmployeesDataJSON]);
  }

  private static async BankStatementDataAsSalaryProjectBankStatementString(): Promise<string> {

    const bankStatementData = await this.executeQuery(this.getQueryTextSalaryProjectCommon());

    if (!bankStatementData.length) return '';

    if (this.isUKRAINE()) {
      return await this.BankStatementDataAsSalaryProjectBankStatementStringUKRAINE(bankStatementData);
    }

    let result = `
    <?xml version="1.0" encoding="UTF-8"?>
<СчетаПК xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://v8.1c.ru/edi/edi_stnd/109" xsi:type="СчетПК"`;

    for (const row of bankStatementData) {
      for (const prop of Object.keys(row)) {
        if (prop.search('ig_') !== -1) continue;
        const val = row[prop].replace(/"/g, '');
        result += ` ${prop}=\"${prop === 'НомерДоговора' ? this.getShortDocNumber(val, true) : val}\"`;
      }
    }

    result += '>\n\t<ЗачислениеЗарплаты>';

    const common = bankStatementData[0];
    const EmployeesInJSON = `{"PayRolls":${JSON.stringify(common['ig_PayRolls'])}}`;
    const employees = await this.getSalaryProjectEmployeesDataFromJSON(EmployeesInJSON);
    let rowIndex = 1;
    let amount = 0;
    for (const row of employees) {
      result += `\n\t\t<Сотрудник Нпп="${rowIndex}">`;
      for (const prop of Object.keys(row)) {
        if (prop.search('ig_') !== -1 || !row[prop] || (prop.search('rp_') !== -1 && !common[row[prop]])) continue;
        if (prop.search('rp_') !== -1) {
          result += `\n\t\t\t<${prop.replace('rp_', '')}>${common[row[prop]]}</${prop.replace('rp_', '')}>`;
        } else {
          result += `\n\t\t\t<${prop}>${row[prop]}</${prop}>`;
        }
      }
      result += `\n\t\t</Сотрудник>`;
      amount += row['Сумма'];
      rowIndex++;
    }
    result += `\n\t</ЗачислениеЗарплаты>`;
    result += `\n\t<ВидЗачисления>01</ВидЗачисления>`;
    if (common['ig_DocDate'] >= new Date(2020, 5, 1) && !!((common['ig_ВидДохода'] as string).substr(1, 1).trim()))
      result += `\n\t<КодВидаДохода>${(common['ig_ВидДохода'] as string).substr(1, 1)}</КодВидаДохода>`;
    result += `\n\t<КонтрольныеСуммы>`;
    result += `\n\t\t<КоличествоЗаписей>${rowIndex - 1}</КоличествоЗаписей>`;
    result += `\n\t\t<СуммаИтого>${amount.toFixed(2)}</СуммаИтого>`;
    result += `\n\t</КонтрольныеСуммы>`;
    result += `\n</СчетаПК>`;
    return result.trim();
  }


  private static async BankStatementDataAsCommonBankStatementStringUKRAINE(bankStatementData: { key: string, value }[]): Promise<string> {
    let result = '';
    for (const prop of Object.keys(bankStatementData[0])) {
      result += prop + ';';
    }
    result += 'SER_PAS_B;NOM_PAS_B';
    let value = '';
    for (const row of bankStatementData) {
      result += '\n';
      for (const prop of Object.keys(row)) {
        switch (prop) {
          case 'N_D':
            value = this.getShortDocNumber(row[prop], false);
            break;
          case 'N_P':
            value = (row[prop] as string).replace(/\r?\n/g, ' ');
            break;
          default:
            value = row[prop];
            break;
        }
        result += `${value};`;
      }
      result += `;`;
    }
    return result;
  }

  // tslint:disable-next-line: max-line-length
  private static async BankStatementDataAsSalaryProjectBankStatementStringUKRAINE(bankStatementData: { key: string, value }[]): Promise<string> {
    let result = 'N_D;SUMMA;COUNT_A;NAME_B;COUNT_B;N_P;OKPO_B;SER_PAS_B;NOM_PAS_B';
    const common = bankStatementData[0];
    const EmployeesInJSON = `{"PayRolls":${JSON.stringify(common['ig_PayRolls'])}}`;
    const employees = await this.tx.manyOrNone<[{ key: string, value }]>(this.getQueryTextSalaryEmployeesUKRAINE(), [EmployeesInJSON]);
    const NP = (common['N_P'] as string).replace(/\r?\n/g, ' ');
    const ND = this.getShortDocNumber(common['N_D'], false);
    for (const employee of employees) {
      // tslint:disable-next-line: max-line-length
      result += `\n${ND};${employee['SUMMA']};${common['COUNT_A']};${employee['NAME_B']};${employee['COUNT_B']};${NP};${employee['OKPO_B']};;`;
    }
    return result;
  }

  private static async BankStatementDataAsCommonBankStatementString(bankStatementData: { key: string, value }[]): Promise<string> {
    if (!bankStatementData.length) return '';
    if (this.isUKRAINE()) {
      return this.BankStatementDataAsCommonBankStatementStringUKRAINE(bankStatementData);
    }
    let result = '';
    const naznMaxLength = 210;
    for (const row of bankStatementData) {

      for (const prop of Object.keys(row)) {

        if (prop.search('_ig') === -1) {
          let val = row[prop] === null ? '' : row[prop];
          switch (prop) {
            case 'Номер':
            case 'НомерДокумента':
              val = this.getShortDocNumber(val, false);
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
            case 'ПолучательБИН_ИИН':
              if ((String(val).trim().length < 10) || (String(val).trim().length > 12)) {
                throw new Error(`Неверно заполнен ИНН получателя ${row['Получатель']} в документе ${row['Номер']}`);
              }
              break;
          }
          result += `\n${prop}=${val}`;
        }
      }
      result += '\nКонецДокумента';
    }

    return result.trim();

  }

  private static async init(docsID: any[], tx: MSSQL): Promise<number> {
    if (!docsID.length) return 0;
    const doc = await lib.doc.byId(docsID[0], tx);
    if (!doc) return 0;
    const parentCompany = await lib.doc.Ancestors(doc.company as Ref, tx, 1) as string;
    const country = await lib.util.getObjectPropertyById(parentCompany, 'Country.id', tx);
    if (!country) throw new Error(`Не удалось определить страну организации ${(await lib.doc.byId(parentCompany, tx))?.description}`);
    this.country = country.id;
    this.tx = tx;
    this.docsIdsString = docsID.map(el => '\'' + el + '\'').join(',');
    const query = `
    SELECT d.id,
      d.Operation operation
    FROM [dbo].[Document.Operation.v] d
    WHERE d.id in (@p1)`;
    this.docsByTypes = await this.executeQuery(query) as any;
    this.operationTypes = [...new Set(this.docsByTypes.map(x => x.operation))];

    return this.operationTypes.length;
  }

  static async getBankStatementAsString(docsID: any[], tx: MSSQL): Promise<string> {
    if (!await this.init(docsID, tx)) return '';
    let result = await this.BankStatementDataAsSalaryProjectBankStatementString();
    if (result) return result;
    result = await this.getHeaderText();
    for (const operationType of this.operationTypes) {
      result += await this.getBankStatementAsStringForOperationType(operationType);
      result += '\n';
    }
    if (result.length) result += 'КонецФайла';
    return result;
  }

  static async getBankStatementAsStringForOperationType(operationType: string): Promise<string> {
    this.operation = operationType;
    this.docsIds = this.docsByTypes.filter(e => e.operation === operationType).map(e => e.id);
    this.docsIdsString = this.docsIds.map(el => '\'' + el + '\'').join(',');
    const BankStatementData = await this.executeQuery(await this.getQueryTextCommon());
    return await this.BankStatementDataAsCommonBankStatementString(BankStatementData);
  }

  private static async getHeaderText(): Promise<string> {
    let result = '1CClientBankExchange';
    const headerFields = await this.getHeaderFields();
    for (const prop of Object.keys(headerFields)) {
      result += `\n${prop}=${headerFields[prop]}`;
    }
    result += '\n';
    result += await this.getBankAccounts();
    result += '\n';
    return result;
  }

  private static async getBankAccounts(): Promise<string> {
    const query = `SELECT DISTINCT
        ba.[code] as BankAccount
    FROM [dbo].[Documents] as oper
        LEFT JOIN [dbo].[Documents] as ba on ba.id = JSON_VALUE(oper.doc, '$.BankAccount')
    WHERE oper.[id] in (@p1) AND JSON_VALUE(oper.doc, '$.Operation') IN ('68FA31F0-BDB0-11E7-9C95-E3F9522E1FC9','54AA5310-102E-11EA-AA50-31ECFB22CD33','8D128C20-3E20-11EA-A722-63A01E818155','E47A8910-4599-11EA-AAE2-A1796B9A826A','BF4B4126-D835-11E7-9D5E-E7807DB3B488')
    -- С р/с -  оплата поставщику,  р/с - Выдача/Возврат кредитов и займов (Контрагент), перечисление налогов и взносов, С р/с - выплата зарплаты (СОТРУДНИКУ без ведомости) (RUSSIA),  С р/с - подотчетному
    UNION
    SELECT DISTINCT
        ba.[code]
    FROM [dbo].[Documents] as oper
        LEFT JOIN [dbo].[Documents] as ba on ba.id = JSON_VALUE(oper.doc, '$.BankAccountOut')
    WHERE oper.[id] in (@p1) and JSON_VALUE(oper.doc, '$.Operation') = '433D63DE-D849-11E7-83D2-2724888A9E4F' -- С р/с - на расчетный счет  (в путь)`;
    const ba = await this.executeQuery(query);
    return ba.filter(e => e).map(e => `РасчСчет=${(e as any).BankAccount}`).join('\n');
  }

  private static async getHeaderFields() {
    const query = `
    SELECT
        IIF(@p2=1,N'2.00',N'1.02') as N'ВерсияФормата'
        , IIF(@p2=1,'UTF8','UTF-8') as N'Кодировка'
        , IIF(@p2=1,N'Бухгалтерия для Казахстана, редакция 3.0',N'1С:ERP Управление предприятием 2')  as N'Отправитель'
        , '' as N'Получатель'
        , FORMAT (GETDATE(), 'dd.MM.yyyy') as N'ДатаСоздания'
        , FORMAT (GETDATE(), 'HH:mm:ss') as N'ВремяСоздания'
        , FORMAT (MIN(docs.[date]), 'dd.MM.yyyy') as N'ДатаНачала'
        , FORMAT (MAX(docs.[date]), 'dd.MM.yyyy') as N'ДатаКонца'
      , N'Платежное поручение' as N'Документ'
    FROM [dbo].[Documents] as docs
    WHERE docs.[id] in (@p1)`;
    const result = await this.executeQuery(query, [null, this.isKAZAKHSTAN() ? 1 : 0]);
    return result ? result[0] : {};
  }

  private static getShortDocNumber(docNumber: string, withZeros: boolean): string {

    if (docNumber.split('-').length === 2) {
      const docNumberArr = docNumber.split('-');
      if (!withZeros || this.isKAZAKHSTAN()) {
        return Number(docNumberArr[1]).toString();  // казахстан без лид. нулей
      }
      return docNumberArr[1];
    }
    return docNumber;
  }

}
