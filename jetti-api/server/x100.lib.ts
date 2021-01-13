import { CatalogAttachment } from './models/Catalogs/Catalog.Attachment';
import { x100DATA_POOL } from './sql.pool.x100-DATA';
import { Ref } from './models/document';
import { MSSQL } from './mssql';
import { EXCHANGE_POOL } from './sql.pool.exchange';
import { lib } from './std.lib';
import { BankStatementUnloader } from './fuctions/BankStatementUnloader';
import {
  updateOperationTaxCheck,
  getTaxCheckFromURL,
  ITaxCheck,
  IUpdateOperationTaxCheckResponse,
  findTaxCheckAttachmentsByOperationId
} from './x100/functions/taxCheck';
import { TRANSFORMED_REGISTER_MOVEMENTS_TABLE } from './env/environment';

export interface Ix100Lib {
  account: {
  };
  register: {
    getTransformedRegisterMovementsByDocId: (docId) => Promise<any>
  };
  catalog: {
    counterpartieByINNAndKPP: (INN: string, KPP: string, tx: MSSQL) => Promise<Ref | null>
  };
  doc: {
  };
  info: {
    companyByDepartment: (department: Ref, date: Date, tx: MSSQL) => Promise<Ref | null>
    company2ByDepartment: (department: Ref, date: Date, tx: MSSQL) => Promise<Ref | null>
    IntercompanyByCompany: (company: Ref, date: Date, tx: MSSQL) => Promise<Ref | null>
  };
  salary: {
    personFIFO: (date: Date, person: Ref, currency: Ref, amount: number, tx: MSSQL) => Promise<any>
  };
  util: {
    updateOperationTaxCheck: (taxCheck: ITaxCheck) => Promise<IUpdateOperationTaxCheckResponse>,
    getTaxCheckFromURL: (taxCheckURL: string) => Promise<ITaxCheck>,
    findTaxCheckAttachmentsByOperationId: (operId: string, tx: MSSQL) => Promise<any[]>,
    salaryCompanyByCompany: (company: Ref, tx: MSSQL) => Promise<string | null>
    bankStatementUnloadById: (docsID: string[], tx: MSSQL) => Promise<string>,
    closeMonthErrors: (company: Ref, date: Date, tx: MSSQL) => Promise<{ Storehouse: Ref; SKU: Ref; Cost: number }[] | null>,
    exchangeDB: () => MSSQL,
    x100DataDB: () => MSSQL
  };
}

export const x100: Ix100Lib = {
  account: {
  },
  register: {
    getTransformedRegisterMovementsByDocId
  },
  catalog: {
    counterpartieByINNAndKPP
  },
  doc: {
  },
  info: {
    companyByDepartment,
    company2ByDepartment,
    IntercompanyByCompany,
  },
  salary: {
    personFIFO
  },
  util: {
    updateOperationTaxCheck,
    getTaxCheckFromURL,
    findTaxCheckAttachmentsByOperationId,
    salaryCompanyByCompany,
    bankStatementUnloadById,
    closeMonthErrors,
    exchangeDB,
    x100DataDB
  }
};

async function getTransformedRegisterMovementsByDocId(docID: string): Promise<any> {
  return await x100DataDB().manyOrNone(`
  SELECT r.id, r.parent, r.date, r."kind", r.calculated,
    "company".id "company.id", "company".description "company.value", "company".code "company.code", 'Catalog.Company' "company.type"

    , [ResponsibilityCenter].id [ResponsibilityCenter.id], [ResponsibilityCenter].description [ResponsibilityCenter.value], 'Catalog.ResponsibilityCenter' [ResponsibilityCenter.type], [ResponsibilityCenter].code [ResponsibilityCenter.code]
    , [Department].id [Department.id], [Department].description [Department.value], 'Catalog.Department' [Department.type], [Department].code [Department.code]
    , [Balance].id [Balance.id], [Balance].description [Balance.value], 'Catalog.Balance' [Balance.type], [Balance].code [Balance.code]
    , [Analytics].id [Analytics.id], [Analytics].description [Analytics.value], 'Types.Catalog' [Analytics.type], [Analytics].code [Analytics.code]
    , [Analytics2].id [Analytics2.id], [Analytics2].description [Analytics2.value], 'Types.Catalog' [Analytics2.type], [Analytics2].code [Analytics2.code]
    , [Currency].id [Currency.id], [Currency].description [Currency.value], 'Catalog.Currency' [Currency.type], [Currency].code [Currency.code]
    , ISNULL(TRY_CONVERT(MONEY, r.Amount), 0) * IIF(kind = 1, 1, -1) [Amount]
    , ISNULL(TRY_CONVERT(MONEY, r.AmountRC), 0) * IIF(kind = 1, 1, -1) [AmountRC]
    , r.Info "Info"
  FROM ${TRANSFORMED_REGISTER_MOVEMENTS_TABLE} r
    LEFT JOIN dbo.[Documents] company ON company.id = r.company
    LEFT JOIN dbo.[Documents] [ResponsibilityCenter] ON [ResponsibilityCenter].id = r.ResponsibilityCenter
    LEFT JOIN dbo.[Documents] [Department] ON [Department].id = r.Department
    LEFT JOIN dbo.[Documents] [Balance] ON [Balance].id = r.Balance
    LEFT JOIN dbo.[Documents] [Analytics] ON [Analytics].id = r.Analytics
    LEFT JOIN dbo.[Documents] [Analytics2] ON [Analytics2].id = r.Analytics2
    LEFT JOIN dbo.[Documents] [Currency] ON [Currency].id = r.Currency
  WHERE r.document = @p1`, [docID]);
}

async function counterpartieByINNAndKPP(INN: string, KPP: string, tx: MSSQL): Promise<Ref | null> {
  const query = `SELECT TOP 1 cp.id FROM [dbo].[Catalog.Counterpartie.v] cp WHERE cp.Code1 = @p1 and (cp.Code2 = @p2 or @p2 is NULL)`;
  const res = await tx.oneOrNone<{ id }>(query, [INN, KPP ? KPP : null]);
  return res ? res.id : null;
}

async function bankStatementUnloadById(docsID: string[], tx: MSSQL): Promise<string> {
  return await BankStatementUnloader.getBankStatementAsString(docsID, tx);
}

async function salaryCompanyByCompany(company: Ref, tx: MSSQL): Promise<string | null> {
  if (!company) return null;
  const CompanyParentId = await lib.doc.Ancestors(company, tx, 1);
  let CodeCompanySalary = '';
  switch (CompanyParentId) {
    case 'E5850830-02D2-11EA-A524-E592E08C23A5': // RUSSIA
      CodeCompanySalary = 'SALARY-RUSSIA';
      break;
    case '608F90F0-5480-11EA-8766-41CC929689CC': // RUSSIA (UKRAINE Branch)
      CodeCompanySalary = 'SALARY-UKRAINE';
      break;
    case 'FE302460-0489-11EA-941F-EBDB19162587': // UKRAINE - Украина
      CodeCompanySalary = 'SALARY-UKRAINE';
      break;
    case '7585EDB0-3626-11EA-A819-EB0BBE912314': // КРАУДИВЕСТИНГ
      CodeCompanySalary = 'SALARY-CRAUD';
      break;
    case '9C226AA0-FAFA-11E9-B75B-A35013C043AE': // KAZAKHSTAN
      CodeCompanySalary = 'SALARY-KAZAKHSTAN';
      break;
    case 'D3B08C60-3F5E-11EA-AD91-F1F1060B7833': // JETTY
      CodeCompanySalary = 'JETTI-COMPANY';
      break;
    case 'A1D8B8E0-F8FD-11E9-8CC0-4361F9AEA805': // HUNGARY
      CodeCompanySalary = 'SALARY-HUNGARY';
      break;
    case 'D5B9D1D0-F8FD-11E9-8CC0-4361F9AEA805': // POLAND
      CodeCompanySalary = 'SALARY-POLAND';
      break;
    case 'FB954970-F8FD-11E9-8CC0-4361F9AEA805': // ROMANIA
      CodeCompanySalary = 'SALARY-ROMANIA';
      break;
    default:
      return company;
  }
  return await lib.doc.byCode('Catalog.Company', CodeCompanySalary, tx);
}


async function personFIFO(date: Date, person: Ref, currency: Ref, amount: number, tx: MSSQL): Promise<any> {
  const queryText = `
  EXEC [dbo].[Distribution.Salary.Person.FIFO]
  @EndDate = '${date.getFullYear()}${date.getMonth() + 1}${date.getDate()}',
  @Currency = '${currency}',
  @Person = '${person}',
  @Amount = ${amount}`;
  return await tx.manyOrNone(queryText);
}


async function companyByDepartment(department: Ref, date = new Date(), tx: MSSQL): Promise<Ref | null> {
  let result: Ref | null = null;
  const queryText = `
    SELECT TOP 1 company FROM [Register.Info.DepartmentCompanyHistory] WITH (NOEXPAND)
    WHERE (1=1)
      AND date <= @p1
      AND Department = @p2
    ORDER BY date DESC`;
  const res = await tx.oneOrNone<{ company: string }>(queryText, [date, department]);
  if (res) result = res.company;
  return result;
}

async function company2ByDepartment(department: Ref, date = new Date(), tx: MSSQL): Promise<Ref | null> {
  let result: Ref | null = null;
  const queryText = `
    SELECT TOP 1 company2 FROM [Register.Info.DepartmentCompanyHistory] WITH (NOEXPAND)
    WHERE (1=1)
      AND date <= @p1
      AND Department = @p2
    ORDER BY date DESC`;
  const res = await tx.oneOrNone<{ company2: string }>(queryText, [date, department]);
  if (res) result = res.company2;
  return result;
}

async function IntercompanyByCompany(company: Ref, date = new Date(), tx: MSSQL): Promise<Ref | null> {
  let result: Ref | null = null;
  const queryText = `
    SELECT TOP 1 Intercompany FROM [Register.Info.IntercompanyHistory] WITH (NOEXPAND)
    WHERE (1=1)
      AND date <= @p1
      AND company = @p2
    ORDER BY date DESC`;
  const res = await tx.oneOrNone<{ Intercompany: string }>(queryText, [date, company]);
  if (res) result = res.Intercompany;
  return result;
}

async function closeMonthErrors(company: Ref, date: Date, tx: MSSQL) {
  const result = await tx.manyOrNone<{ Storehouse: Ref, SKU: Ref, Cost: number }>(`
    SELECT q.*, Storehouse.Department Department FROM (
      SELECT Storehouse, SKU, SUM([Cost]) [Cost]
      FROM [dbo].[Register.Accumulation.Inventory] r
      WHERE date < DATEADD(DAY, 1, EOMONTH(@p1)) AND company = @p2
      GROUP BY Storehouse, SKU
      HAVING SUM([Qty]) = 0 AND SUM([Cost]) <> 0) q
    LEFT JOIN [Catalog.Storehouse.v] Storehouse WITH (NOEXPAND) ON Storehouse.id = q.Storehouse`, [date, company]);
  return result;
}

function exchangeDB() {
  return new MSSQL(EXCHANGE_POOL);
}

function x100DataDB() {
  return new MSSQL(x100DATA_POOL);
}
