import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.AllUnic.Lot',
  description: 'AllUnic лот',
  icon: 'fa fa-list',
  menu: 'AllUnic лоты',
  hierarchy: 'folders',
})
export class CatalogAllUnicLot extends DocumentBase {

  @Props({ type: 'Catalog.AllUnic.Lot', hiddenInList: true, order: -1, storageType: 'folders' })
  parent: Ref = null;

  @Props({ type: 'string', required: true, order: 2, style: { width: '135px' }, isProtected: true })
  code = '';

  @Props({ type: 'date', label: 'Дата старта продаж' })
  SalesStartDate = null;

  @Props({ type: 'number', label: 'Стоимость' })
  Cost = 0;

  @Props({ type: 'Catalog.Currency', label: 'Валюта лота', isProtected: true })
  Currency: Ref = null;

  @Props({ type: 'Catalog.Product', label: 'Номенклатура', isProtected: true })
  Product: Ref = null;

  @Props({ type: 'table', label: 'Подразделения' })
  Department: CatalogAllUnicLotDepartment[] = [new CatalogAllUnicLotDepartment()];

}

export class CatalogAllUnicLotDepartment {

  @Props({ type: 'Catalog.Department', label: 'Подразделение' })
  Department = null;

}
