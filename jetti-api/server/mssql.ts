import * as sql from 'mssql';
import { sqlConfig, sqlConfigAccounts } from './env/environment';
import { dateReviverUTC } from './fuctions/dateReviver';
import { IJWTPayload } from './routes/auth';

export class MSSQL {
  private POOL: sql.ConnectionPool | sql.Transaction;

  constructor(private config, private transaction?: sql.Transaction) {
    if (transaction) this.POOL = transaction;
    else {
      if (process.env.NODE_ENV === 'production')
        setInterval(() => {
          (<sql.ConnectionPool>this.POOL).connect()
            .then(() => console.log('reconnected', this.config.database))
            .catch(err => { });
        }, 20000);

      this.POOL = new sql.ConnectionPool(this.config);
      (<sql.ConnectionPool>this.POOL).connect()
        .then(() => console.log('connected', this.config.database))
        .catch(err => console.log('connection error', err));
    }
  }

  public async close() {
    if (this.POOL instanceof sql.ConnectionPool)
      await this.POOL.close();
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
    const request = new sql.Request(<any>(this.POOL));
    this.setParams(params, request);
    const response = await request.query(text);
    return response.recordset.length ? this.complexObject<T>(response.recordset[0]) : null;
  }

  async manyOrNone<T>(text: string, params: any[] = []): Promise<T[]> {
    const request = new sql.Request(<any>(this.POOL));
    this.setParams(params, request);
    const response = await request.query(text);
    return response.recordset.map(el => this.complexObject<T>(el)) || [];
  }

  async manyOrNoneFromJSON<T>(text: string, params: any[] = []): Promise<T[]> {
    const request = new sql.Request(<any>(this.POOL));
    this.setParams(params, request);
    const response = await request.query(`${text} FOR JSON PATH, INCLUDE_NULL_VALUES;`);
    const data = response.recordset[0]['JSON_F52E2B61-18A1-11d1-B105-00805F49916B'];
    return data ? JSON.parse(data, dateReviverUTC) : [];
  }

  async none<T>(text: string, params: any[] = []) {
    const request = new sql.Request(<any>(this.POOL));
    this.setParams(params, request);
    await request.query(text);
  }

  async tx<T>(func: (tx: MSSQL) => Promise<T>, user: IJWTPayload) {
    const transaction = new sql.Transaction(this.POOL as sql.ConnectionPool);
    await transaction.begin(sql.ISOLATION_LEVEL.READ_COMMITTED);
    try {
      const request = new sql.Request(transaction);
      await request.query(`
        EXEC sys.sp_set_session_context N'user_id', N'${user.email}';
        EXEC sys.sp_set_session_context N'isAdmin', N'${user.isAdmin}';
        EXEC sys.sp_set_session_context N'roles', N'${JSON.stringify(user.roles)}'
      `);
      await func(new MSSQL(this.config, transaction));
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

export const sdb = new MSSQL(sqlConfig);
export const sdbq = new MSSQL({ ...sqlConfig, requestTimeout: 1000 * 60 * 60 });
export const sdba = new MSSQL(sqlConfigAccounts);

process.on('SIGTERM', async () => {
  await sdb.close();
  await sdbq.close();
  await sdba.close();
});
