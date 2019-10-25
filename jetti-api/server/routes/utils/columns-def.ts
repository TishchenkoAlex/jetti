import { ColumnDef } from '../../models/column';
import { PropOptions } from '../../models/document';
import { FormListFilter, FormListOrder, FormListSettings } from './../../models/user.settings';

export let NUMBER_STYLE = { 'width': '100px', 'text-align': 'right' };
export let BOOLEAN_STYLE = { 'width': '90px', 'text-align': 'center' };
export let DATETIME_STYLE = { 'width': '135px', 'text-align': 'center' };
export let DEFAULT_STYLE = { 'width': '200px', 'min-width': '200px', 'max-width': '200px' };
export let ENUM_STYLE = { 'width': '170px' };

export function buildColumnDef(view: { [x: string]: PropOptions; }, settings: FormListSettings): ColumnDef[] {

  const columnDef: ColumnDef[] = [];
  Object.keys(view).filter(property => view[property] && view[property]['type'] !== 'table').map((field) => {
    const prop: PropOptions = view[field];
    const hidden = !!prop['hiddenInList'] || !!prop['hidden'];
    const order = hidden ? -1 : prop['order']! * 1 || 999;
    const label = (prop['label'] || field.toString()).toLowerCase();
    const type = prop['type'] || 'string';
    const readOnly = !!prop['readOnly'];
    const required = !!prop['required'];
    const owner = prop['owner']! || null;
    const totals = prop['totals']! * 1;

    let style = prop['style'];
    if (type === 'number' && !style) style = NUMBER_STYLE;
    else if (type === 'boolean' && !style) style = BOOLEAN_STYLE;
    else if (type === 'datetime' && !style) style = DATETIME_STYLE;
    else if (type === 'enum' && !style) style = ENUM_STYLE;

    let value = prop['value'];
    if (type === 'enum') {
      value = [{ label: '', value: null }, ...(value || [] as string[]).map((el: any) => ({ label: el, value: el }))];
    }
    style = style || DEFAULT_STYLE;

    columnDef.push({
      field, type, label, hidden, order, style, required, readOnly, totals, owner, value,
      filter: settings.filter.find(f => f.left === field) || new FormListFilter(field),
      sort: settings.order.find(f => f.field === field) || new FormListOrder(field)
    });
  });
  columnDef.filter(c => c.type === 'string').forEach(c => c.filter!.center = 'like');
  return columnDef.sort((a, b) => a.order - b.order);
}
