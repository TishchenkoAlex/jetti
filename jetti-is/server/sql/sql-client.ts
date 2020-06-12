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

  private prepareSession(sql: string) {
    return `
      SET NOCOUNT ON;
      EXEC sys.sp_set_session_context N'user_id', N'${this.user!.email}';
      EXEC sys.sp_set_session_context N'isAdmin', N'${this.user!.isAdmin}';
      EXEC sys.sp_set_session_context N'roles', N'${JSON.stringify(this.user!.roles)}';
      SET NOCOUNT OFF;
      ${sql}
    `;
  }

  manyOrNone<T>(sql: string, params: any[] = []): Promise<T[]> {
    return (new Promise<T[]>(async (resolve, reject) => {
      try {
        const connection = this.connection ? this.connection : await this.sqlPool.pool.acquire().promise;
        const request = new Request(this.prepareSession(sql), (error: RequestError, rowCount: number, rows: ColumnValue[][]) => {
          if (!this.connection) this.sqlPool.pool.release(connection);
          if (error) return reject(error);
          if (!rowCount) return resolve([]);
          const result = rows.map(row => {
            const data = {} as T;
            row.forEach(col => data[col.metadata.colName] = col.value);
            return this.complexObject(data);
          });
          return resolve(result);
        });
        this.setParams(params, request);
        connection.execSql(request);
      } catch (error) { return reject(error); }
    }));
  }

  async manyOrNoneStream(sql: string, params: any[] = [], onRow: Function, onDone: Function) {
    try {
      const connection = this.connection ? this.connection : await this.sqlPool.pool.acquire().promise;
      const request: Request = new Request(this.prepareSession(sql), (error: RequestError, rowCount: number, rows: ColumnValue[][]) => {
        if (error) throw new Error(error.message);
      });
      request.on('row', (row: ColumnValue[]) => onRow(row, request));
      request.on('done', (rowCount: number, more: boolean) => onDone(rowCount, more));
      this.setParams(params, request);
      connection.execSqlBatch(request);
    } catch (error) { throw new Error(error); }
  }

  oneOrNone<T>(sql: string, params: any[] = []): Promise<T | null> {
    return new Promise(async (resolve, reject) => {
      try {
        const connection = this.connection ? this.connection : await this.sqlPool.pool.acquire().promise;
        const request = new Request(this.prepareSession(sql), (error: RequestError, rowCount: number, rows: ColumnValue[][]) => {
          if (!this.connection) this.sqlPool.pool.release(connection);
          if (error) return reject(error);
          if (!rowCount) return resolve(null);
          const data = {} as T;
          rows[0].forEach(col => data[col.metadata.colName] = col.value);
          const result = this.complexObject(data);
          return resolve(result);
        });
        this.setParams(params, request);
        connection.execSql(request);
      } catch (error) { return reject(error); }
    });
  }

  none(sql: string, params: any[] = []): Promise<void> {
    return new Promise(async (resolve, reject) => {
      try {
        const connection = this.connection ? this.connection : await this.sqlPool.pool.acquire().promise;
        const request = new Request(this.prepareSession(sql), (error: RequestError, rowCount: number, rows: ColumnValue[][]) => {
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
