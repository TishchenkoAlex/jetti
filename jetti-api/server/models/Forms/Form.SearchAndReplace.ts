import { FormBase, JForm } from './form';
import { Props, Ref } from '../document';

@JForm({
  type: 'Form.SearchAndReplace',
  description: 'Search and replace',
  icon: 'fa fa-pencil-square-o',
  menu: 'Search & replace',
})
export class FormSearchAndReplace extends FormBase {

  @Props({ type: 'Types.Catalog', order: 1, label: 'Searched value' })
  OldValue: Ref = null;

  @Props({ type: 'Types.Catalog', order: 1, label: 'New value' })
  NewValue: Ref = null;

  @Props({
    type: 'table', order: 1, label: 'Search result', readOnly: true,
  })
  SearchResult: SearchResult[] = [new SearchResult()];

}

export class SearchResult {

  @Props({ type: 'string' })
  Source = '';

  @Props({ type: 'string', label: 'Type' })
  Type = '';

  @Props({ type: 'number', totals: 1 })
  Records = 0;

}

