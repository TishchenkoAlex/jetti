import { IAccount } from '../../models/common-types';
import { sdba } from '../../mssql';

export namespace Accounts {

  export async function get(id: string): Promise<IAccount> {
    const data = await sdba.oneOrNone<any>(`SELECT JSON_QUERY(data) data FROM "accounts" WHERE id = @p1`, [id.toLowerCase()]);
    return data ? data.data : null;
  }

  export async function set(account: IAccount): Promise<IAccount | null> {
    account.email = account.email.toLowerCase();
    let existing = await sdba.oneOrNone<{data: any}>(`SELECT JSON_QUERY(data) data FROM "accounts" WHERE id = @p1`, [account.email]);
    existing = existing ? existing.data : null;
    if (!existing) {
      const data = await sdba.oneOrNone<IAccount>(`
        INSERT INTO "accounts" (id, data) OUTPUT inserted.* VALUES (@p1, JSON_QUERY(@p2))`,
        [account.email, JSON.stringify(account)]);
      return data;
    } else {
      const data = await sdba.oneOrNone<IAccount>(`
        UPDATE "accounts" SET data = $2 OUTPUT inserted.* WHERE id = @p1 `, [account.email, account]);
      return data;
    }
  }

  export async function del(id: string): Promise<IAccount | null> {
    const data = await sdba.oneOrNone<IAccount>(`DELETE FROM "accounts" OUTPUT deleted.* WHERE id = @p1;`, [id.toLowerCase()]);
    return data;
  }

}
