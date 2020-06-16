import { config as dotenv } from 'dotenv';
dotenv();

export const REDIS_DB_HOST = process.env.REDIS_DB_HOST!;
export const REDIS_DB_AUTH = process.env.REDIS_DB_AUTH;
export const JTW_KEY = process.env.JTW_KEY!;
export const DB_NAME = process.env.DB_NAME!;
