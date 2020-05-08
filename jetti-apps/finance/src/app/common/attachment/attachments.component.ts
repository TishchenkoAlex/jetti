import {
  ChangeDetectionStrategy,
  Component,
  Input,
  OnInit,
  OnDestroy,
  ViewEncapsulation,
} from '@angular/core';
import { ApiService } from '../../services/api.service';
import { Subject } from 'rxjs';
import { DomSanitizer } from '@angular/platform-browser';
import { MessageService } from 'primeng/api';

const fileToBase64 = (file) =>
  new Promise<{ MIMEType, Storage }>((resolve, reject) => {
    const reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = () => {
      const readerRes = (reader.result as string).split(',');
      resolve({ MIMEType: readerRes[0].replace(';base64', '').replace('data:', ''), Storage: readerRes[1] });
    };
    reader.onerror = (error) => reject(error);
  });

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'j-attachments',
  templateUrl: './attachments.component.html',
  styleUrls: ['attachments.component.scss'],
  encapsulation: ViewEncapsulation.None,
})
export class AttachmentsComponent implements OnInit, OnDestroy {
  @Input() owner: string;
  selection: any;
  displayDialog = false;
  editMode = false;
  selectedAttachment;
  selectedTags: { value: string; name: string }[];
  attachmets$ = new Subject<any[]>();
  attachments = [];
  dataview = true;
  error = false;
  settings = [];
  settings$ = new Subject<any[]>();
  selectedSettings;
  selectedFile;
  responsiveOptions = [
    {
      breakpoint: '1024px',
      numVisible: 3,
      numScroll: 3,
    },
    {
      breakpoint: '768px',
      numVisible: 2,
      numScroll: 2,
    },
    {
      breakpoint: '560px',
      numVisible: 1,
      numScroll: 1,
    },
  ];

  constructor(
    private apiService: ApiService,
    private sanitizer: DomSanitizer,
    private messageService: MessageService
  ) { }

  async ngOnInit() {
    await this.fillSettings();
    await this.getAttachments();
  }

  async fillSettings() {
    this.settings = await this.apiService.getAttachmentsSettingsByOwner(this.owner);
    this.settings.forEach((element) => {
      element.Tags = element.Tags.map((tag) => ({ value: tag, name: tag }));
      element.isFile = element.StorageType === 'FILE';
      element.isURL = element.StorageType === 'URL';
    });
    if (this.settings.length) this.selectedSettings = this.settings[0];
  }

  fillAdditionalAttachmentFileds(attach) {
    attach.newFile = false;
    attach.isFile = attach.StorageType === 'FILE';
    attach.isURL = attach.StorageType === 'URL';
    attach.hasData = !!(attach.isFile && attach.Storage);
    attach.TagsString = attach.Tags.split(';').filter(e => e).join(', ');
    if (attach.isURL) attach.URL = attach.Storage;
    else if (attach.IconURL) attach.URL = attach.IconURL;
    else if (attach.hasData)
      attach.URL = this.sanitizer.bypassSecurityTrustUrl(`data:${attach.MIMEType};base64,${attach.Storage}`);
  }

  async getAttachments() {
    const attachments = await this.apiService.getAttachmentsByOwner(this.owner, false);
    attachments.forEach(attach => this.fillAdditionalAttachmentFileds(attach));
    this.attachments = attachments;
    this.attachmets$.next(attachments);
  }

  async delAttachment(attachmentId: string) {
    this.onDialogHide();
    await this.apiService.delAttachments([attachmentId]);
    this.attachments = this.attachments.filter(e => e.id !== attachmentId);
    this.attachmets$.next(this.attachments);
  }

  onDialogHide() {
    this.displayDialog = false;
    this.editMode = false;
    this.selectedAttachment = null;
  }

  ngOnDestroy() { this.attachmets$.complete(); }

  showError(summary: string, detail = '') {
    this.messageService.add({ severity: 'error', summary, detail, key: '1' });
    this.error = true;
  }

  showMessage(summary: string, detail = '') {
    this.messageService.add({ severity: 'success', summary, detail, key: '1' });
  }

  async downloadAttachment(attach) {
    if (!attach.Storage) attach.Storage = await this.apiService.getAttachmentStorageById(attach.id);
    if (!attach.Storage) { this.showError('Missing data!'); return; }
    const a = document.createElement('a');
    const url = `data:${attach.FileType};base64,${attach.Storage}`;
    a.href = url;
    a.download = attach.FileName;
    document.body.appendChild(a);
    a.click();
    setTimeout(function () {
      document.body.removeChild(a);
      window.URL.revokeObjectURL(url);
    });
  }

  async saveAttachment() {
    this.error = false;
    let attach = this.selectedAttachment;
    if (!attach.id && this.selectedSettings.isFile && !attach.newFile)
      this.showError('No file selected!');
    if (this.selectedSettings.isURL && !attach.Storage)
      this.showError('URL is empty!');
    if (!attach.description)
      this.showError('Description is empty!');
    if (this.error) return;

    this.displayDialog = false;
    this.editMode = false;

    attach = {
      ...attach,
      AttachmentType: this.selectedSettings.AttachmentType,
      AttachmentTypeDescription: this.selectedSettings.AttachmentTypeDescription,
      StorageType: this.selectedSettings.StorageType,
      IconURL: this.selectedSettings.IconURL,
      Tags: this.selectedTags
        ? this.selectedTags.map((e) => e.value).join(';') : '',
    };
    const tmpStorage = attach.Storage;
    if (attach.StorageType === 'FILE' && !attach.newFile) delete attach.Storage;
    this.apiService.addAttachments([attach as any]).then(attachArr => {
      attach = attachArr[0];
      attach.Storage = tmpStorage;
      this.fillAdditionalAttachmentFileds(attach);
      this.selectedAttachment = null;
      this.selectedTags = [];
      this.attachments = this.attachments.filter(e => e.id !== attach.id);
      this.attachments.unshift(attach);
      this.attachmets$.next(this.attachments);
    });
  }

  showDialog(event: Event, edit = false, attachment?) {
    if (attachment) {
      this.selectedSettings = this.settings.find(e => e.AttachmentType === attachment.AttachmentType);
      if (edit) this.selectedTags = attachment.Tags.split(';').map(tag => ({ value: tag, name: tag }));
    }
    if (!this.selectedSettings) this.selectedSettings = this.settings[0];
    this.selectedFile = null;
    this.editMode = edit;
    this.selectedAttachment = { ...attachment, owner: this.owner };
    this.displayDialog = true;
  }

  async onSelectFiles(event) {
    const file = event.files[0];
    if (file.size > this.selectedSettings.MaxFileSize) {
      this.showError(`OVERSIZE! Selected file is ${(file.size / 1024).toFixed(0)} kByte, maximum size is ${(this.selectedSettings.MaxFileSize / 1024).toFixed(0)} kByte `);
      return;
    }
    this.selectedFile = file;
    this.selectedAttachment.newFile = true;
    this.selectedAttachment = {
      ...this.selectedAttachment,
      StorageType: this.selectedSettings.StorageType,
      FileSize: file.size,
      FileName: file.name,
      ...await fileToBase64(file)
    };
  }
}
