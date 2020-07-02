import { Connection, Request, ColumnValue, RequestError, ISOLATION_LEVEL, TYPES } from 'tedious';
import { dateReviverUTC } from '../fuctions/dateReviver';
import { SQLPool } from './sql-pool';

export class SQLClient {

  constructor(private sqlPool: SQLPool, public user?: { [key: string]: any }, private connection?: Connection) {
    this.user = { email: '', isAdmin: false, env: {}, description: '', roles: [], ...user };
  }

  private setParams(params: any[], request: Request) {
    for (let i = 0; i < params.length; i++) {
      if (params[i] instanceof Date) {
        request.addParameter(`p${i + 1}`, TYPES.DateTime2, params[i]);
      } else if (typeof params[i] === 'number') {
        request.addParameter(`p${i + 1}`, TYPES.Numeric, params[i]);
      } else if (typeof params[i] === 'boolean') {
        request.addParameter(`p${i + 1}`, TYPES.Bit, params[i]);
      } else
        request.addParameter(`p${i + 1}`, TYPES.NVarChar, params[i]);
    }
  }

  private DateToString(dt: Date): string {
    let res: string = dt.getFullYear().toString();
    if (dt.getMonth() < 9) res += `0${dt.getMonth() + 1}`;
    else res += `${dt.getMonth() + 1}`;
    if (dt.getDate() < 10) res += `0${dt.getDate()}`;
    else res += `${dt.getDate()}`;
    return res;
  }

  private parsingParamsSQL(sql: string, params: any[]) {
    let result: string = sql;
    for (let i = 0; i < params.length; i++) {
      let ps = '';
      if (params[i] instanceof Date) {
        ps = `'${this.DateToString(params[i])}'`;
      } else if (typeof params[i] === 'number') {
        ps = `${params[i].toString()}`;
      } else if (typeof params[i] === 'boolean') {
        if (params[i]) ps = 'cast(1 as bit)'; else ps = 'cast(0 as bit)'; // ???
      } else
        ps = `'${params[i].toString()}'`;
      result = result.replace(new RegExp(`@p${i + 1}`, 'g'), ps);
    }
    return result;
  }

  async manyOrNone<T>(sql: string, params: any[] = []): Promise<T[]> {
    return (new Promise<T[]>(async (resolve, reject) => {
      try {
        const result: any[] = [];
        const connection = this.connection ? this.connection : await this.sqlPool.pool.acquire().promise;
        const request = new Request(sql, (error: RequestError, rowCount: number, rows: ColumnValue[][]) => {
          if (!this.connection) this.sqlPool.pool.release(connection);
          if (error) return reject(error);
          if (!rowCount) return resolve([]);
        });
        request.on('row', (row) => {
          const data = {} as T;
          row.forEach(col => data[col.metadata.colName] = col.value);
          result.push(this.complexObject(data));
        });
        request.on('done', (rowCount: number, more: boolean, rows: any[]) => resolve(result));
        request.on('requestCompleted', () => resolve(result));
        request.on('error', (err) => reject(err));
        this.setParams(params, request);
        connection.execSql(request);
      } catch (error) { return reject(error); }
    }));
  }

  async manyOrNoneStream(sql: string, params: any[] = [], onRow: Function, onDone: Function): Promise<void> {
    return new Promise(async (resolve, reject) => {
      try {
        const connection = this.connection ? this.connection : await this.sqlPool.pool.acquire().promise;
        const parsingParamsSQL = this.parsingParamsSQL(sql, params);
        const request: Request = new Request(parsingParamsSQL, error => { if (error) return reject(error); });
        request.on('row', (row) => onRow(row, request));
        request.on('done', async (rowCount: number, more: boolean) => { await onDone(rowCount, more); resolve(); });
        connection.execSqlBatch(request);
      } catch (error) { reject(error); }
    });
  }

  async oneOrNone<T>(sql: string, params: any[] = []): Promise<T | null> {
    return new Promise(async (resolve, reject) => {
      try {
        let result: any = null;
        const connection = this.connection ? this.connection : await this.sqlPool.pool.acquire().promise;
        const request = new Request(sql, (error: RequestError, rowCount: number) => {
          if (!this.connection) this.sqlPool.pool.release(connection);
          if (error) return reject(error);
          if (!rowCount) return resolve(null);
        });
        request.on('row', (row) => {
          const data = {} as T;
          row.forEach(col => data[col.metadata.colName] = col.value);
          result = this.complexObject(data);
        });
        request.on('done', () => resolve(result));
        request.on('requestCompleted', () => resolve(result));
        request.on('error', (err) => reject(err));
        this.setParams(params, request);
        connection.execSql(request);
      } catch (error) { return reject(error); }
    });
  }

  none(sql: string, params: any[] = []): Promise<void> {
    return new Promise(async (resolve, reject) => {
      try {
        const connection = this.connection ? this.connection : await this.sqlPool.pool.acquire().promise;
        const request = new Request(sql, (error: RequestError, rowCount: number, rows: ColumnValue[][]) => {
          if (!this.connection) this.sqlPool.pool.release(connection);
          if (error) return reject(error);
          return resolve();
        });
        this.setParams(params, request);
        connection.execSql(request);
      } catch (error) { return reject(error); }
    });
  }

  async tx(func: (tx: SQLClient, name?: string, isolationLevel?: ISOLATION_LEVEL) => Promise<void>,
    name?: string, isolationLevel = ISOLATION_LEVEL.READ_COMMITTED) {
    const connection = this.connection ? this.connection : await this.sqlPool.pool.acquire().promise;
    await this.beginTransaction(connection, name, isolationLevel);
    try {
      await func(new SQLClient(this.sqlPool, this.user, connection), name, isolationLevel);
      await this.commitTransaction(connection);
    } catch (error) {
      try { await this.rollbackTransaction(connection); } catch { }
      throw new Error(error);
    } finally {
      if (!this.connection) this.sqlPool.pool.release(connection);
    }
  }

  private beginTransaction(connection: Connection,
    name?: string, isolationLevel: ISOLATION_LEVEL = ISOLATION_LEVEL.READ_COMMITTED): Promise<this> {
    return new Promise(async (resolve, reject) => {
      connection.beginTransaction(error => {
        if (error) return reject(error);
        return resolve(this);
      }, name, isolationLevel);
    });
  }

  private commitTransaction(connection: Connection): Promise<this> {
    return new Promise(async (resolve, reject) => {
      connection.commitTransaction(error => {
        if (error) return reject(error);
        return resolve(this);
      });
    });
  }

  private rollbackTransaction(connection: Connection): Promise<this> {
    return new Promise(async (resolve, reject) => {
      connection.rollbackTransaction(error => {
        if (error) return reject(error);
        return resolve(this);
      });
    });
  }

  private complexObject<T>(data: any) {
    if (!data) return data;
    const row = {};
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

  private toJSON(value: any): any {
    if (typeof value === 'string' && (
      (value[0] === '{' && value[value.length - 1] === '}') ||
      (value[0] === '[' && value[value.length - 1] === ']')
    ))
      try { return JSON.parse(value, dateReviverUTC); } catch { return value; }
    else
      return value;
  }
}
