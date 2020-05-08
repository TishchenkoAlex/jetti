import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.Attachment.Type',
  description: 'Тип вложения',
  icon: 'fa fa-list',
  menu: 'Типы вложений',
  hierarchy: 'folders'
})
export class CatalogAttachmentType extends DocumentBase {

  @Props({ type: 'Catalog.Attachment.Type', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'boolean' })
  AllDocuments = false;

  @Props({ type: 'boolean' })
  AllCatalogs = false;

  @Props({ type: 'number', label: 'Max file size in bytes' }) // Maximum file size allowed in bytes.
  MaxFileSize = 1000000;

  @Props({ type: 'string' }) // http://www.w3schools.com/tags/att_input_accept.asp
  FileFilter = 'image/*';

  @Props({ type: 'enum', value: ['URL', 'FILE'], required: true })
  StorageType = false;

  @Props({ type: 'string' })
  IconURL = '';

  @Props({ type: 'string', label: 'Tags (string splitted by ";")'  }) // string splitted by ','
  Tags = '';

  @Props({ type: 'boolean' }) // load data to client on component init (for pictures in FILE)
  LoadDataOnInit = false;

  @Props({ type: 'table' })
  Owners: OwnerType[] = [new OwnerType()];

}

class OwnerType {
  @Props({ type: 'Catalog.Subcount', required: true })
  OwnerType = '';

  @Props({ type: 'Catalog.Operation.Group', style: { width: '100%' }})
  Group: Ref = null;
}

