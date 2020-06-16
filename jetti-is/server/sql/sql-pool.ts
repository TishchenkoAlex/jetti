import { Connection, ConnectionError } from 'tedious';
import { Pool } from 'tarn';
import { SQLConnectionConfig } from './interfaces';

export class SQLPool {

  constructor(public config: SQLConnectionConfig) { }

  pool = new Pool<Connection>({
    create: () => {
      return new Promise<Connection>((resolve, reject) => {
        const connection = new Connection(this.config);
        connection.once('connect', ((error: ConnectionError) => {
          if (error) {
            console.error(`create: connection.on('connect') event, ConnectionError: ${error}`);
            return reject(error);
          }
          return resolve(connection);
        }));
        connection.on('error', ((error: ConnectionError) => {
          console.error(`create: connection.on('error') event, Error: ${error}`);
          if (error.code === 'ESOCKET') connection['hasError'] = true;
          return reject(error);
        }));
      });
    },
    validate: connecion => !connecion['closed'] && !connecion['hasError'],
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
