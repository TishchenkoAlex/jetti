import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Document.Invoice',
  description: 'Invoice',
  dimensions: [
    { Customer: 'Catalog.Counterpartie' },
    { Manager: 'Catalog.Manager' },
    { Amount: 'number' },
  ],
  icon: 'far fa-file-alt',
  menu: 'Invoices',
  prefix: 'INV-',
  commands: [
    { method: 'test', icon: 'fa fa-plus', label: 'test', order: 1 }
  ],
  copyTo: [
    { type: 'Document.PriceList', icon: '', label: 'PriceList', order: 1 }
  ],
  relations: [
    { name: 'Operations', type: 'Document.Operation', field: 'parent' }
  ]
})
export class DocumentInvoice extends DocumentBase {
  @Props({ type: 'Types.Document', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Catalog.Department', required: true, hiddenInList: true, order: 10 })
  Department: Ref = null;

  @Props({ type: 'Catalog.Storehouse', hiddenInList: true, required: true, order: 11 })
  Storehouse: Ref = null;

  @Props({
    type: 'Catalog.Counterpartie', required: true, order: 12,
    style: { width: '250px', 'min-width': '250px', 'max-width': '250px', }
  })
  Customer: Ref = null;

  @Props({
    type: 'Catalog.Manager', order: 13,
    style: { width: '250px', 'min-width': '250px', 'max-width': '250px' }
  })
  Manager: Ref = null;

  @Props({ type: 'string', required: true, order: 14, style: { width: '80px', 'min-width': '80px', 'max-width': '80px' } })
  Status = 'PREPARED';

  @Props({ type: 'date', hiddenInList: true, order: 15 })
  PayDay = new Date();

  @Props({ type: 'number', readOnly: true, order: 16 })
  Amount = 0;

  @Props({ type: 'number', readOnly: true, order: 17 })
  Tax = 0;

  @Props({ type: 'Catalog.Currency', required: true, order: 18, style: { width: '100px', 'min-width': '100px', 'max-width': '100px' } })
  currency: Ref = null;

  @Props({
    type: 'table', required: true, order: 1,
    onChange: function (doc: DocumentInvoiceItem, value: DocumentInvoiceItem[]) {
      let Amount = 0, Tax = 0; value.forEach(el => { Amount += el.Amount; Tax += el.Tax; });
      return { Amount: Math.round(Amount * 100) / 100, Tax: Math.round(Tax * 100) / 100 };
    }
  })
  Items: DocumentInvoiceItem[] = [new DocumentInvoiceItem()];

  @Props({ type: 'table', order: 2 })
  Comments: DocumentInvoiceComment[] = [new DocumentInvoiceComment()];
}

export class DocumentInvoiceItem {
  @Props({ type: 'Catalog.Product', required: true, order: 1, style: { width: '400px' } })
  SKU: Ref = null;

  @Props({
    type: 'number', totals: 3, required: true, order: 3,
    onChange: function (doc: DocumentInvoiceItem, value: number) {
      return { Amount: Math.round(doc.Price * (value || 0) * 10000) / 10000, Tax: doc.Price * (value || 0) * 0.18 };
    }
  })
  Qty = 0;

  @Props({ type: 'Catalog.PriceType', required: true, order: 5, style: { width: '120px', 'min-width': '120px', 'max-width': '120px' } })
  PriceType: Ref = null;

  @Props({
    type: 'number', required: true, order: 4,
    onChange: function (doc: DocumentInvoiceItem, value: number) {
      return { Amount: Math.round(doc.Qty * (value || 0) * 100) / 100, Tax: doc.Qty * (value || 0) * 0.18 };
    }
  })
  Price = 0;

  @Props({
    type: 'number', required: true, order: 10, totals: 3,
    onChange: function (doc: DocumentInvoiceItem, value: number) {
      return { Price: Math.round(value / doc.Qty * 10000) / 10000, Tax: value * 0.18 };
    }
  })
  Amount = 0;

  @Props({ type: 'number', readOnly: true, totals: 9 })
  Tax = 0;
}

export class DocumentInvoiceComment {
  @Props({ type: 'date', style: { width: '195px' } })
  Date = new Date();

  @Props({ type: 'Catalog.User' })
  User: Ref = null;

  @Props({ type: 'string' })
  Comment = '';
}
