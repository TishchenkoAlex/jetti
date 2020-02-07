import { Connection, Request, ColumnValue, RequestError, ConnectionError, ISOLATION_LEVEL, TYPES } from 'tedious';
import { Pool } from 'tarn';
import { dateReviverUTC } from './fuctions/dateReviver';
import { ConnectionConfigAndPool } from './env/environment';

export class SqlPool {

  constructor(public config: ConnectionConfigAndPool) { }

  pool = new Pool<Connection>({
    create: () => {
      return new Promise<Connection>((resolve, reject) => {
        const connection = new Connection(this.config);
        connection.on('connect', ((error: ConnectionError) => {
          if (error) {
            console.error(`create: connection.on('connect') event, ConnectionError: ${error}`);
            return reject(error);
          }
          return resolve(connection);
        }));
        connection.on('error', ((error: Error) => {
          console.error(`create: connection.on('error') event, Error: ${error}`);
          return reject(error);
        }));
      });
    },
    validate: connecion => {
      return connecion['loggedIn'];
    },
    destroy: connecion => {
      return new Promise<void>((resolve, reject) => {
        connecion.on('end', () => resolve());
        connecion.on('error', (error: Error) => {
          console.error(`destroy: connection.on('error') event, Error: ${error}`);
          reject(error);
        });
        connecion.close();
      });
    },
    min: this.config.pool.min,
    max: this.config.pool.max,
    idleTimeoutMillis: this.config.pool.idleTimeoutMillis
  });
}

export class MSSQL {

  constructor(private sqlPool: SqlPool, public user?: any, private connection?: Connection) {
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
      EXEC sys.sp_set_session_context N'user_id', N'${this.user.email}';
      EXEC sys.sp_set_session_context N'isAdmin', N'${this.user.isAdmin}';
      EXEC sys.sp_set_session_context N'roles', N'${JSON.stringify(this.user.roles)}';
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

  async tx(func: (tx: MSSQL, name?: string, isolationLevel?: ISOLATION_LEVEL) => Promise<void>,
    name?: string, isolationLevel = ISOLATION_LEVEL.READ_COMMITTED) {
    const connection = this.connection ? this.connection : await this.sqlPool.pool.acquire().promise;
    await this.beginTransaction(connection, name, isolationLevel);
    try {
      await func(new MSSQL(this.sqlPool, this.user, connection), name, isolationLevel);
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


