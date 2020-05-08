import { DocumentBase, JDocument, Props, Ref } from './../document';

export interface IAttachmentsSettings {
  AttachmentType: string;
  AttachmentTypeDescription: string;
  StorageType: 'URL' | 'FILE';
  MaxFileSize: number;
  FileFilter: string;
  Tags: string[];
}

@JDocument({
  type: 'Catalog.Attachment',
  description: 'Вложение',
  icon: 'fa fa-list',
  menu: 'Вложения',
  hierarchy: 'folders'
})

export class CatalogAttachment extends DocumentBase {

  @Props({ type: 'Catalog.Attachment', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Types.Object', required: true, order: 1 })
  owner: Ref = null;

  @Props({ type: 'datetime', label: 'Modify', hidden: false })
  timestamp: Date | null = null;

  @Props({ type: 'Catalog.User', hiddenInList: false })
  user: Ref = null;

  @Props({ type: 'datetime', label: 'Created', hidden: false })
  date = new Date();

  @Props({ type: 'Catalog.Attachment.Type', required: true })
  AttachmentType: Ref = null;

  @Props({ type: 'string' })
  Storage = '';

  @Props({ type: 'string' })
  Tags = '';

  @Props({ type: 'number', label: 'File size, bytes' })
  FileSize = '';

  @Props({ type: 'string', label: 'File name' })
  FileName = '';

  @Props({ type: 'string', label: 'MIME-type' })
  MIMEType = '';

}

