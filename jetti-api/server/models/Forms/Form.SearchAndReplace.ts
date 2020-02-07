import { FormBase, JForm } from './form';
import { Props, Ref } from '../document';

@JForm({
  type: 'Form.SearchAndReplace',
  description: 'Search and replace',
  icon: 'fab fa-searchengin',
  menu: 'Search & replace',
})
export class FormSearchAndReplace extends FormBase {

  @Props({ type: 'Types.Catalog', label: 'Searched value' })
  OldValue: Ref = null;

  @Props({ type: 'string', label: 'Old value exchange code', readOnly: true })
  OldValueExchangeCode = '';

  @Props({ type: 'string', label: 'Old value exchange base', readOnly: true })
  OldValueExchangeBase = '';

  @Props({ type: 'Types.Catalog', label: 'New value' })
  NewValue: Ref = null;

  @Props({ type: 'string', label: 'New value exchange code', readOnly: true })
  NewValueExchangeCode = '';

  @Props({ type: 'string', label: 'New value exchange base', readOnly: true })
  NewValueExchangeBase = '';

  @Props({
    type: 'table',  label: 'Search result', readOnly: true,
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

