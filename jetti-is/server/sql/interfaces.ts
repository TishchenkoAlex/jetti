import { ConnectionConfig } from 'tedious';

export type SQLConnectionConfig =
    ConnectionConfig &
    {
        pool: { min: number, max: number, idleTimeoutMillis: number }
    } & {
        batch: { min: number, max: number }
    };
