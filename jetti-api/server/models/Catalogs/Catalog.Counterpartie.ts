import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.Counterpartie',
  description: 'Контрагент',
  icon: 'fa fa-list',
  menu: 'Контрагенты',
  prefix: 'CPE-',
  relations: [
    { name: 'Contracts', type: 'Catalog.Contract', field: 'owner' },
    { name: 'Bank accounts', type: 'Catalog.Counterpartie.BankAccount', field: 'owner' },
    { name: 'Loan contracts', type: 'Catalog.Loan', field: 'owner' }
  ],
  hierarchy: 'folders'
})
export class CatalogCounterpartie extends DocumentBase {

  @Props({ type: 'Catalog.Counterpartie', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'enum', required: true, value: ['ЮрЛицо', 'ФизЛицо', 'ИндПред', 'Нерез', 'Обособ'] })
  kind = 'ЮрЛицо';

  @Props({ type: 'string', required: true })
  FullName = '';

  @Props({ type: 'Catalog.Department', required: false })
  Department: Ref = null;

  @Props({ type: 'boolean', required: true })
  Client = false;

  @Props({ type: 'boolean', required: true })
  Supplier = false;

  @Props({ type: 'boolean' })
  isInternal = false;

  @Props({ type: 'string', required: false })
  AddressShipping: Ref = null;

  @Props({ type: 'string', required: false })
  AddressBilling: Ref = null;

  @Props({ type: 'string', required: false })
  Phone: Ref = null;

  @Props({ type: 'string', required: false, isUnique: true })
  Code1: Ref = null;

  @Props({ type: 'string', required: false })
  Code2: Ref = null;

  @Props({ type: 'string', required: false })
  Code3: Ref = null;

  @Props({ type: 'string', required: false })// Код Бенефициара (для Казахастана)
  BC = '';

  @Props({ type: 'string', readOnly: true, isAdditional: true })
  GLN = '';

}
