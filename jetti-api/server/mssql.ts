import * as sql from 'mssql';
import { dateReviverUTC } from './fuctions/dateReviver';
import { IJWTPayload } from './models/common-types';

export class MSSQL {

  private pool: sql.ConnectionPool | sql.Transaction;

  constructor(private user: IJWTPayload, private GLOBAL_POOL: sql.ConnectionPool, transaction?: sql.Transaction) {
    if (transaction instanceof sql.Transaction) this.pool = transaction;
    else this.pool = GLOBAL_POOL;
  }

  private async setSession(request: sql.Request, query: string) {
    return await request.query(`
      SET NOCOUNT ON;
      EXEC sys.sp_set_session_context N'user_id', N'${this.user.email}';
      EXEC sys.sp_set_session_context N'isAdmin', N'${this.user.isAdmin}';
      EXEC sys.sp_set_session_context N'roles', N'${JSON.stringify(this.user.roles)}';
      SET NOCOUNT OFF;
      ${query}
    `);
  }

  private toJSON(value: any): any {
    if (typeof value === 'string' && (
      (value[0] === '{' && value[value.length - 1] === '}') ||
      (value[0] === '[' && value[value.length - 1] === ']')
    ))
      try { return JSON.parse(value, dateReviverUTC); } catch { return value; }
    else
      return value;
  }

  private complexObject<T>(data: any) {
    if (!data) return data;
    const row: T = Object.assign({});
    // tslint:disable-next-line:forin
    for (const k in data) {
      const value = this.toJSON(data[k]);
      if (k.includes('.')) {
        const keys = k.split('.');
        row[keys[0]] = { ...row[keys[0]], [keys[1]]: value };
      } else
        row[k] = value;
    }
    return row;
  }

  private setParams(params: any[], request: sql.Request) {
    for (let i = 0; i < params.length; i++) {
      if (params[i] instanceof Date) {
        request.input(`p${i + 1}`, sql.DateTime, params[i]);
      } else
        request.input(`p${i + 1}`, params[i]);
    }
  }

  async oneOrNone<T>(text: string, params: any[] = []): Promise<T | null> {
    const request = new sql.Request(<any>(this.pool));
    this.setParams(params, request);
    const response = await this.setSession(request, text);
    return response.recordset.length ? this.complexObject<T>(response.recordset[0]) : null;
  }

  async manyOrNone<T>(text: string, params: any[] = []): Promise<T[]> {
    const request = new sql.Request(<any>(this.pool));
    this.setParams(params, request);
    const response = await this.setSession(request, text);
    if (response.recordset) {
      return response.recordset.map(el => this.complexObject<T>(el)) || [];
    } else return [];
  }

  async manyOrNoneFromJSON<T>(text: string, params: any[] = []): Promise<T[]> {
    const request = new sql.Request(<any>(this.pool));
    this.setParams(params, request);
    const response = await request.query(`${text} FOR JSON PATH, INCLUDE_NULL_VALUES;`);
    const data = response.recordset[0]['JSON_F52E2B61-18A1-11d1-B105-00805F49916B'];
    return data ? JSON.parse(data, dateReviverUTC) : [];
  }

  async none(text: string, params: any[] = []) {
    const request = new sql.Request(<any>(this.pool));
    this.setParams(params, request);
    await this.setSession(request, text);
  }

  async tx<T>(func: (tx: MSSQL) => Promise<T>) {
    let transaction: sql.Transaction;
    if (this.pool instanceof sql.ConnectionPool) {
      transaction = new sql.Transaction(this.pool);
    } else {
      transaction = this.pool;
    }
    try {
      await transaction.begin(sql.ISOLATION_LEVEL.READ_COMMITTED);
      await func(new MSSQL(this.user, this.GLOBAL_POOL, transaction));
      await transaction.commit();
    } catch (err) {
      console.log('SQL: error', err);
      try {
        await transaction.rollback();
      } catch {
        console.log('SQL: ROLLBACK error', err);
      }
      throw new Error(err);
    }
  }
}
