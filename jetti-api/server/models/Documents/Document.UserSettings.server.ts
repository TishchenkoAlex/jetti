import { MSSQL } from '../../mssql';
import { lib } from '../../std.lib';
import { CatalogUser } from '../Catalogs/Catalog.User';
import { PostResult } from '../post.interfaces';
import { RegisterInfoRLS } from '../Registers/Info/RLS';
import { ServerDocument } from '../ServerDocument';
import { DocumentUserSettings } from './Document.UserSettings';

export class DocumentUserSettingsServer extends DocumentUserSettings implements ServerDocument {

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
      default:
        return {};
    }
  }

  async onPost(tx: MSSQL) {
    const Registers: PostResult = { Account: [], Accumulation: [], Info: [] };
    const UserObject = await lib.doc.byIdT<CatalogUser>(this.user, tx);

    for (const row of this.CompanyList) {
      Registers.Info.push(new RegisterInfoRLS({
        company: row.company,
        user: UserObject!.code
      }));
    }
    return Registers;

  }

}

