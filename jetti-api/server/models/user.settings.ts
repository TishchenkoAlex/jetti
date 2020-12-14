import { MSSQL } from '../mssql';

export class FilterInterval {
  start: number | string | boolean;
  end: number | string | boolean;
}

export type FilterList = number[] | string[];

export type matchOperator = '=' | '>=' | '<=' | '<' | '>' | 'like' | 'in' | 'beetwen' | 'is null';

export const matchOperatorByType: { [x: string]: matchOperator[] } = {
  string: ['like', '='],
  enum: ['='],
  number: ['=', '<=', '<', '>', '>='],
  date: ['=', '<=', '<', '>', '>='],
  datetime: ['=', '<=', '<', '>', '>='],
  default: ['=']
};

export class FormListFilter {
  constructor(
    public left: string,
    public center: matchOperator = '=',
    public right: any = null,
    public isActive?: boolean,
    public isFixed?: boolean) { }
}

export class FormListOrder {
  order: 'asc' | 'desc' | '' = '';

  constructor(public field: string) { }
}

export class FormListSettings {
  filter: FormListFilter[] = [];
  order: FormListOrder[] = [];
  columns?: FormListColumnProps = { color: {}, width: {}, order: [], visibility: {} };
}

export interface FormListColumnProps {
  color: { [field: string]: string };
  width: { [field: string]: string };
  order: string[];
  visibility: { [field: string]: boolean };
}

export interface IUserSettings {
  id?: string;
  type: string;
  kind?: 'filter' | 'columns';
  user?: string;
  description?: string;
  selected?: boolean;
  settings?: FormListSettings;
  isModify?: boolean;
  readonly?: boolean;
  isNew?: boolean;
}
export class UserSettingsManager {

  static async getSettings(settings: IUserSettings, tx: MSSQL): Promise<IUserSettings[] | null> {
    const res = await tx.manyOrNone<IUserSettings>(`
    SELECT *
    FROM [dbo].[UserSettings]
    WHERE
    1 = 1 AND
    ${settings.id ? 'id = @p1' : `[user] = @p1 and [type] = @p2 AND (@p3 = '' OR description = @p3)`}
    ORDER BY description`,
      settings.id ? [settings.id] : [settings.user || '', settings.type, settings.description || '']);
    return res.length ? res : null;
  }

  static async getExistSettingsId(ids: string[], tx: MSSQL): Promise<string[]> {
    const res = await tx.manyOrNone<{ id: string }>(`
    SELECT id
    FROM [dbo].[UserSettings]
    WHERE
    id in (${ids.map(el => '\'' + el + '\'').join(',')})`);
    return res ? res.map(e => e.id) : [];
  }

  static async getSettingsDefault(type: string, tx: MSSQL): Promise<IUserSettings[] | null> {
    return this.getSettings({ type }, tx);
  }

  static async saveSettingsArray(settings: IUserSettings[], tx: MSSQL): Promise<IUserSettings[]> {
    const existId = await this.getExistSettingsId(settings.map(e => e.id || ''), tx);
    const res: IUserSettings[] = [];
    for (const id of existId) { res.push(await this.updateSettings(settings.find(set => set.id === id)!, tx)); }
    const newSettings = settings.filter(e => !e.id || !existId.includes(e.id));
    for (const set of newSettings) { res.push(await this.insertSettings(set, tx)); }
    return res;
  }

  static async saveSettings(settings: IUserSettings, tx: MSSQL) {

    if (!settings.id) {
      const set = await this.getSettings(settings, tx);
      if (set && set.length) settings.id = set[0].id;
    }

    return settings.id ? await this.updateSettings(settings, tx) : await this.insertSettings(settings, tx);
  }

  static async insertSettings(settings: IUserSettings, tx: MSSQL) {
    const id = await tx.oneOrNone<{ id: string }>(`
    INSERT INTO [dbo].[UserSettings]([id],[type],[kind],[user],[description],[selected],[settings])
    OUTPUT inserted.id
    VALUES (@p1,@p2,@p3,@p4,@p5,@p6,@p7)
    `,
      [settings.id,
      settings.type,
      settings.kind,
      settings.user || '',
      settings.description || '',
      settings.selected || false,
      JSON.stringify(settings.settings)]);
    return { ...settings, id: id!.id };
  }

  static async updateSettings(settings: IUserSettings, tx: MSSQL) {
    await tx.none(`
    UPDATE [dbo].[UserSettings]
    SET [type] = @p1,
        [kind] = @p2,
        [user] = @p3,
        [description] = @p4,
        [settings] = @p5,
        [selected] = @p6
    WHERE id = @p7;`,
      [settings.type,
      settings.kind,
      settings.user || '',
      settings.description || '',
      JSON.stringify(settings.settings || ''),
      settings.selected || false,
      settings.id]);
    return settings;
  }

  static async deleteSettingsById(id: string, tx: MSSQL) {
    await tx.none(`DELETE FROM [dbo].[UserSettings] WHERE [id] = @p1`, [id]);
  }

}
