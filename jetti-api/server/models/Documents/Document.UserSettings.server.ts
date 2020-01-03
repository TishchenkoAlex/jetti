import { lib } from '../../std.lib';
import { PostResult } from '../post.interfaces';
import { RegisterInfoRLS } from '../Registers/Info/RLS';
import { DocumentUserSettings } from './Document.UserSettings';
import { MSSQL } from '../../mssql';
import { IServerDocument } from '../documents.factory.server';

export class DocumentUserSettingsServer extends DocumentUserSettings implements IServerDocument {

  async AddDescendantsCompany(tx: MSSQL) {
    if (!this.company) throw new Error(`Empty company!`);
    const query = `SELECT id company FROM dbo.[Descendants](@p1, '')`;
    const companyItems = await tx.manyOrNone<{company: string}>(query, [this.company]);
    for (const CompanyItem of companyItems) {
      if (this.CompanyList.filter(ci => (ci.company === CompanyItem.company)).length === 0) {
        this.CompanyList.push(CompanyItem);
      }
    }
  }

  async onValueChanged(prop: string, value: any, tx: MSSQL) {
    switch (prop) {
      case 'company':
        return {};
      default:
        return {};
    }
  }

  async onCommand(command: string, args: any, tx: MSSQL) {
    switch (command) {
      case 'company':
        return {};
      case 'AddDescendantsCompany':
        await this.AddDescendantsCompany(tx);
        return this;
      default:
        return {};
    }
  }

  async beforeDelet(tx: MSSQL) {
    await tx.none(`DELETE FROM[rls].[company] WHERE [document] = @p1`, [this.id]);
    return this;
  }

  async onUnPost(tx: MSSQL) {
    await tx.none(`DELETE FROM[rls].[company] WHERE [document] = @p1`, [this.id]);
    return this;
  }

  async onPost(tx: MSSQL) {
    const Registers: PostResult = { Account: [], Accumulation: [], Info: [] };

    await lib.util.postMode(true, tx);

    await tx.none(`DELETE FROM[rls].[company] WHERE [document] = @p1`, [this.id]);
    const Users = await tx.manyOrNone<{ code: string }>(`
      SELECT code FROM  Documents WHERE deleted = 0 AND id IN (
        SELECT @p1 id
        UNION ALL
        SELECT [UsersGroup.User] id FROM Documents
        CROSS APPLY OPENJSON (doc, N'$.Users')
        WITH
        (
          [UsersGroup.User] UNIQUEIDENTIFIER N'$.User'
        ) AS Users
        WHERE (1=1) AND
        [posted] = 1 AND
        [type] = N'Catalog.UsersGroup' AND
        [id] = @p1
      );`, [this.UserOrGroup]
    );

    for (const user of Users) {
      for (const row of this.CompanyList) {
        Registers.Info.push(new RegisterInfoRLS({
          company: row.company,
          user: user.code,
        }));
        await tx.none(`INSERT INTO [rls].[company]([user],[company],[document]) VALUES(@p1, @p2, @p3)`,
          [user.code, row.company, this.id]);
      }
    }

    await lib.util.postMode(false, tx);

    return Registers;
  }
}

