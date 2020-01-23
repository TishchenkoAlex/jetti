import { FormBase, JForm } from './form';
import { Props, Ref } from '../document';

@JForm({
  type: 'Form.SearchAndReplace',
  description: 'Search and replace',
  icon: 'fa fa-pencil-square-o',
  menu: 'Search & replace',
})
export class FormSearchAndReplace extends FormBase {

  @Props({ type: 'Types.Catalog', order: 1, label: 'Old value'})
  OldValue: Ref = null;

  @Props({ type: 'Types.Catalog', order: 1, label: 'New value' })
  NewValue: Ref = null;

  @Props({ type: 'string', order: 1, label: 'Result' })
  ResultText = '';

  @Props({
    type: 'table', required: false, order: 1, label: 'Search result',
  })
  SearchResult: SearchResultRow[] = [new SearchResultRow()];

}

export class SearchResultRow {

  @Props({ type: 'Types.Catalog', label: 'Searched value'})
  SearchedValue: Ref = null;

  @Props({ type: 'string'})
  Source = '';

  @Props({ type: 'string', label: 'Type'})
  Type = '';

  @Props({ type: 'number', totals: 1 })
  Records = 0;

}

