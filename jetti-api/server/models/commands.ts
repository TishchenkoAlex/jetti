
export interface ICommand { command: string; label: string; color?: string; icon: string; }

export const stdDocumentListCommands: ICommand[] = [
  { label: 'add', icon: 'fa-plus', color: 'ui-button-success', command: 'add' },
  { label: 'open', icon: 'fa-pencil-square-o', command: 'open' },
  { label: 'copy', icon: 'fa-copy', command: 'copy' },
  { label: 'post', icon: 'fa-check-square', color: 'ui-button-secondary', command: 'post' },
  { label: 'unpost', icon: 'fa-square-o', color: 'ui-button-secondary', command: 'unpost' },
  { label: 'delete', icon: 'fa-minus', color: 'ui-button-danger', command: 'delete' },
  { label: 'refresh', icon: 'fa-refresh', command: 'refresh' }
];

export const stdCatalogListCommands: ICommand[] = [
  { label: 'add', icon: 'fa-plus', color: 'ui-button-success', command: 'add' },
  { label: 'open', icon: 'fa-pencil-square-o', command: 'open' },
  { label: 'copy', icon: 'fa-copy', command: 'copy' },
  { label: 'delete', icon: 'fa-minus', color: 'ui-button-danger', command: 'delete' },
  { label: 'refresh', icon: 'fa-refresh', command: 'refresh' }
];

