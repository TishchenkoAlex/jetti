export class UserSettings {
  formListSettings: { [x: string]: FormListSettings } = { '': new FormListSettings() };
  defaults = new UserDefaultsSettings();
}

export class UserDefaultsSettings {
  company: string;
  department: string;
}

export class FilterInterval {
  start: number | string | boolean;
  end: number | string | boolean;
}

export type FilterList = number[] | string[];

export type matchOperator = '=' | '>=' | '<=' | '<' | '>' | 'like' | 'in' | 'beetwen' | 'is null';

export class FormListFilter {
  constructor(
    public left: string,
    public center: matchOperator = '=',
    public right: any = null,
    public isFixed?: boolean) { }
}

export class FormListOrder {
  order: 'asc' | 'desc' | '' = '';

  constructor(public field: string) { }
}

export class FormListSettings {
  filter: FormListFilter[] = [];
  order: FormListOrder[] = [];
}
