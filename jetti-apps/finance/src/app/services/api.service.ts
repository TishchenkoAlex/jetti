import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';
import { map, catchError, take, filter } from 'rxjs/operators';
import { AccountRegister } from '../../../../../jetti-api/server/models/account.register';
// tslint:disable:max-line-length
import { DocListRequestBody, DocListResponse, IJob, IJobs, ISuggest, ITree, IViewModel, PatchValue, RefValue, MenuItem, DocListOptions } from '../../../../../jetti-api/server/models/common-types';
import { DocumentBase, Ref, StorageType } from '../../../../../jetti-api/server/models/document';
import { AllDocTypes, DocTypes } from '../../../../../jetti-api/server/models/documents.types';
import { RegisterAccumulation } from '../../../../../jetti-api/server/models/Registers/Accumulation/RegisterAccumulation';
import { RegisterInfo } from '../../../../../jetti-api/server/models/Registers/Info/RegisterInfo';
import { FormListFilter, FormListOrder, FormListSettings, IUserSettings } from '../../../../../jetti-api/server/models/user.settings';
import { environment } from '../../environments/environment';
import { IComplexObject } from '../common/dynamic-form/dynamic-form-base';
import { LoadingService } from '../common/loading.service';
import { viewModelToFlatDocument } from '../common/mapping/document.mapping';
import { FormTypes } from '../../../../../jetti-api/server/models/Forms/form.types';
import { FormBase } from '../../../../../jetti-api/server/models/Forms/form';
import { CatalogAttachment, IAttachmentsSettings } from '../../../../../jetti-api/server/models/Catalogs/Catalog.Attachment';

@Injectable({ providedIn: 'root' })
export class ApiService {

  constructor(private http: HttpClient, public lds: LoadingService) { }

  getAttachmentStorageById(attachmentId: string): Promise<string> {
    const query = `${environment.api}attachments/getAttachmentStorageById/${attachmentId}`;
    return this.http.get<string>(query).toPromise();
  }

  getAttachmentsByOwner(ownerId: string, withDeleted: boolean): Promise<any[]> {
    const query = `${environment.api}attachments/getByOwner/${ownerId}/${withDeleted}`;
    return this.http.get<any[]>(query).toPromise();
  }

  getAttachmentsSettingsByOwner(ownerId: string): Promise<IAttachmentsSettings[]> {
    const query = `${environment.api}attachments/getAttachmentsSettingsByOwner/${ownerId}`;
    return this.http.get<IAttachmentsSettings[]>(query).toPromise();
  }

  addAttachments(attach: CatalogAttachment[]): Promise<any[]> {
    const query = `${environment.api}attachments/add`;
    return this.http.post<any[]>(query, attach).toPromise();
  }

  delAttachments(attachmentsId: string[]): Promise<void> {
    const query = `${environment.api}attachments/del`;
    return this.http.post<void>(query, attachmentsId).toPromise();
  }

  byId<T extends DocumentBase>(id: Ref): Promise<T> {
    const query = `${environment.api}byId/${id}`;
    return (this.http.get<T>(query)).toPromise();
  }

  ancestors(id: string, level: number): Promise<Ref | null> {
    const query = `${environment.api}ancestors/${id}/${level}`;
    return (this.http.get<Ref | null>(query)).toPromise();
  }

  descendants(id: string, level: number): Promise<{ id: Ref, parent: Ref }[]> {
    const query = `${environment.api}descendants/${id}/${level}`;
    return (this.http.get<{ id: Ref, parent: Ref }[]>(query)).toPromise();
  }

  haveDescendants(id: string): Promise<boolean> {
    const query = `${environment.api}haveDescendants/${id}`;
    return (this.http.get<boolean>(query)).toPromise();
  }

  isCountryByCompany(companyId: string, countryCode: string): Promise<boolean> {
    return this.getObjectPropertyById(companyId, 'Country.code').then(code => {
      return code && code === countryCode;
    });
  }

  getObjectPropertyById(id: string, valuePath: string): Promise<any> {
    const query = `${environment.api}getObjectPropertyById/${id}/${valuePath}`;
    return (this.http.get(query)).toPromise();
  }

  getDocPropValuesByType(type: string, propNames: string[]): Promise<{ propName: string, propValue: any }[]> {
    const query = `${environment.api}getDocPropValuesByType`;
    return (this.http.post<{ propName: string, propValue: any }[]>(query, { type: type, propNames: propNames })).toPromise();
  }

  getDocMetaByType(type: string): Promise<{ Prop, Props }> {
    const query = `${environment.api}getDocMetaByType/${type}`;
    return (this.http.get<{ Prop, Props }>(query)).toPromise();
  }

  async getIndexedOperationType(operationId: string): Promise<DocTypes> {
    const query = `${environment.api}getIndexedOperationType/${operationId}`;
    return (this.http.get<DocTypes>(query)).toPromise();
  }

  formControlRef(id: string): Promise<RefValue> {
    const query = `${environment.api}formControlRef/${id}`;
    return (this.http.get<RefValue>(query)).toPromise();
  }

  getDocList(type: AllDocTypes, id: string, command: string,
    count = 10, offset = 0, order: FormListOrder[] = [],
    _filter: FormListFilter[] = [],
    listOptions: DocListOptions = { withHierarchy: false, hierarchyDirectionUp: false }): Observable<DocListResponse> {
    const query = `${environment.api}list`;
    const body: DocListRequestBody = { id, type, command, count, offset, order, filter: _filter, listOptions };
    return this.http.post<DocListResponse>(query, body);
  }

  getView(type: string, group: string): Observable<IViewModel> {
    const query = `${environment.api}view`;
    return this.http.post<IViewModel>(query, { type, group });
  }

  getViewModel(type: string, id = '', params: { [key: string]: any } = {}): Observable<IViewModel> {
    const query = `${environment.api}view`;
    return this.http.post<IViewModel>(query, { type, id, ...params }, { params });
  }

  getSuggests(docType: string, _filter: string, filters: FormListFilter[]): Observable<ISuggest[]> {
    const query = `${environment.api}suggest/${docType}?filter=${_filter}`;
    return this.http.post<ISuggest[]>(query, { filters });
  }

  postDoc(doc: DocumentBase): Observable<DocumentBase> {
    const apiDoc = viewModelToFlatDocument(doc);
    const query = `${environment.api}post`;
    return (this.http.post<DocumentBase>(query, apiDoc));
  }

  unpostDocById(id: Ref): Observable<DocumentBase> {
    const query = `${environment.api}unpost/${id}`;
    return this.http.get<DocumentBase>(query);
  }

  startWorkFlow(id: Ref) {
    const query = `${environment.api}startWorkFlow/${id}`;
    return this.http.get<DocumentBase>(query);
  }

  saveDoc(doc: DocumentBase): Observable<DocumentBase> {
    const apiDoc = viewModelToFlatDocument(doc);
    const query = `${environment.api}save`;
    return (this.http.post<DocumentBase>(query, apiDoc));
  }

  savePostDoc(doc: DocumentBase): Observable<DocumentBase> {
    const apiDoc = viewModelToFlatDocument(doc);
    const query = `${environment.api}savepost`;
    return (this.http.post<DocumentBase>(query, apiDoc));
  }

  postDocById(id: string): Observable<DocumentBase> {
    const query = `${environment.api}post/${id}`;
    return (this.http.get(query) as Observable<DocumentBase>);
  }

  deleteDoc(id: string): Observable<DocumentBase> {
    const query = `${environment.api}${id}`;
    return (this.http.delete<DocumentBase>(query));
  }

  getDocRegisterMovementsList(id: string): Observable<[{ records: number, kind: string, type: string }]> {
    const query = `${environment.api}register/movements/list/${id}`;
    return (this.http.get(query) as Observable<[{ records: number, kind: string, type: string }]>);
  }

  getDocAccountMovementsView(id: string): Observable<AccountRegister[]> {
    const query = `${environment.api}register/account/movements/view/${id}`;
    return (this.http.get<AccountRegister[]>(query));
  }

  getDocRegisterAccumulationList(id: string): Observable<string[]> {
    const query = `${environment.api}register/accumulation/list/${id}`;
    return (this.http.get(query) as Observable<string[]>);
  }

  getDocTransformedMovements(id: string): Observable<RegisterAccumulation[]> {
    const query = `${environment.api}register/movements/transformed/${id}`;
    return (this.http.get(query) as Observable<RegisterAccumulation[]>);
  }

  getDocRegisterInfoList(id: string): Observable<string[]> {
    const query = `${environment.api}register/info/list/${id}`;
    return (this.http.get(query) as Observable<string[]>);
  }

  getDocAccumulationMovements(type: string, id: string) {
    const query = `${environment.api}register/accumulation/${type}/${id}`;
    return (this.http.get(query) as Observable<RegisterAccumulation[]>);
  }

  getDocInfoMovements(type: string, id: string) {
    const query = `${environment.api}register/info/${type}/${id}`;
    return (this.http.get(query) as Observable<RegisterInfo[]>);
  }

  getRegisterInfoMovementsByFilter(type: string, _filter: { key: string, value: any }[]) {
    const query = `${environment.api}/register/info/byFilter/${type}`;
    return (this.http.post(query, _filter) as Observable<RegisterInfo[]>);
  }

  getOperationsGroups(): Observable<IComplexObject[]> {
    const query = `${environment.api}operations/groups`;
    return (this.http.get<IComplexObject[]>(query));
  }

  getUserSettings(type: string, user: string): Observable<IUserSettings[]> {
    const query = `${environment.api}user/settings/${type}/${user}`;
    return (this.http.get<IUserSettings[]>(query)) as Observable<IUserSettings[]>;
  }

  saveUserSettings(settings: IUserSettings[]): Promise<IUserSettings[]> {
    if (!settings || !settings.length) return Promise.resolve([]);
    const query = `${environment.api}user/settings`;
    return (this.http.post<IUserSettings[]>(query, { command: 'save', settings }).toPromise());
  }

  deleteUserSettings(id: string): Promise<void> {
    const query = `${environment.api}user/settings`;
    return this.http.post<void>(query, { command: 'delete', id }).toPromise<void>();
  }

  getDocDimensions(type: string) {
    const query = `${environment.api}${type}/dimensions`;
    return (this.http.get<any[]>(query));
  }

  valueChanges(doc: DocumentBase, property: string, value: string) {
    const apiDoc = viewModelToFlatDocument(doc);
    const query = `${environment.api}valueChanges/${doc.type}/${property}`;
    const callConfig = { doc: apiDoc, value: value };
    return this.http.post<IViewModel>(query, callConfig).toPromise();
  }

  onCommand(doc: DocumentBase | FormBase, command: string, args: { [x: string]: any }) {
    const apiDoc = viewModelToFlatDocument(doc);
    const query = `${environment.api}command/${doc.type}/${command}`;
    const callConfig = { doc: apiDoc, args: args };
    return this.http.post<{ [x: string]: any }>(query, callConfig).toPromise();
  }

  documentsDataAsJSON(documents: string[]): Promise<string> {
    const query = `${environment.api}documentsDataAsJSON`;
    return this.http.post<string>(query, documents).toPromise();
  }

  jobAdd(data: any, opts?: any) {
    const query = `${environment.api}jobs/add`;
    return this.http.post<IJob>(query, { data: data, opts: opts });
  }

  jobs() {
    const query = `${environment.api}jobs`;
    return this.http.get<IJobs>(query);
  }

  jobById(id: string) {
    const query = `${environment.api}jobs/${id}`;
    return this.http.get<IJob>(query);
  }

  tree(type: AllDocTypes) {
    const query = `${environment.api}tree/${type}`;
    return this.http.get<ITree[]>(query);
  }

  hierarchyList(type: AllDocTypes, id: string = 'top', columns: any[] = []) {
    const query = `${environment.api}hierarchyList/${type}/${id}`;
    const result = this.http.get<any[]>(query);
    if (columns.length) {
      result.pipe(take(1)).subscribe(hierarchyList => {
        this.getDocList(type, '', 'first').toPromise().then(docList => {
        });
      });
    }

    return result;
  }

  async getBankStatementTextByDocsId(id: Ref[]): Promise<string> {
    const query = `${environment.api}getBankStatementTextByDocsId`;
    return await this.http.post<string>(query, { id }, { headers: { charset: 'windows-1251' } }).toPromise();
  }


  execute(type: FormTypes, method: string, doc: FormBase) {
    const apiDoc = viewModelToFlatDocument(doc);
    const query = `${environment.api}form/${type}/${method}`;
    return this.http.post<{ [x: string]: any }>(query, apiDoc);
  }

  batchActual() {
    const query = `${environment.api}batch/actual`;
    return this.http.get<any[]>(query);
  }

  getHistoryById(id: Ref): Observable<any[]> {
    const query = `${environment.api}getHistoryById/${id}`;
    return (this.http.get(query) as Observable<any[]>);
  }

  restoreObjectFromHistory(id: Ref, type: DocTypes): Observable<IViewModel> {
    const query = `${environment.api}restore/${type}/${id}`;
    return (this.http.get(query) as Observable<IViewModel>);
  }

  getDescedantsObjects(id: Ref): Observable<any[]> {
    const query = `${environment.api}getDescedantsObjects/${id}`;
    return (this.http.get(query) as Observable<any[]>);
  }

  SubSystemsMenu() {
    const query = `${environment.auth}subsystems/menu`;
    return this.http.get<MenuItem[]>(query);
  }
}
