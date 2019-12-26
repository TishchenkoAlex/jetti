import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';
import { map, catchError } from 'rxjs/operators';
import { AccountRegister } from '../../../../../jetti-api/server/models/account.register';
// tslint:disable:max-line-length
import { DocListRequestBody, DocListResponse, IJob, IJobs, ISuggest, ITree, IViewModel, PatchValue, RefValue, MenuItem } from '../../../../../jetti-api/server/models/common-types';
import { DocumentBase, Ref, StorageType } from '../../../../../jetti-api/server/models/document';
import { AllDocTypes } from '../../../../../jetti-api/server/models/documents.types';
import { RegisterAccumulation } from '../../../../../jetti-api/server/models/Registers/Accumulation/RegisterAccumulation';
import { RegisterInfo } from '../../../../../jetti-api/server/models/Registers/Info/RegisterInfo';
import { getRoleObjects, RoleType } from '../../../../../jetti-api/server/models/Roles/Base';
import { FormListFilter, FormListOrder, FormListSettings, UserDefaultsSettings } from '../../../../../jetti-api/server/models/user.settings';
import { environment } from '../../environments/environment';
import { IComplexObject } from '../common/dynamic-form/dynamic-form-base';
import { LoadingService } from '../common/loading.service';
import { mapToApi } from '../common/mapping/document.mapping';
import { FormTypes } from '../../../../../jetti-api/server/models/Forms/form.types';
import { FormBase } from '../../../../../jetti-api/server/models/Forms/form';

@Injectable({ providedIn: 'root' })
export class ApiService {

  constructor(private http: HttpClient, public lds: LoadingService) { }

  byId<T extends DocumentBase>(id: Ref): Promise<T> {
    const query = `${environment.api}byId/${id}`;
    return (this.http.get<T>(query)).toPromise();
  }

  formControlRef(id: string): Promise<RefValue> {
    const query = `${environment.api}formControlRef/${id}`;
    return (this.http.get<RefValue>(query)).toPromise();
  }

  getDocList(type: AllDocTypes, id: string, command: string,
    count = 10, offset = 0, order: FormListOrder[] = [], filter: FormListFilter[] = []): Observable<DocListResponse> {
    const query = `${environment.api}list`;
    const body: DocListRequestBody = { id, type, command, count, offset, order, filter };
    return this.http.post<DocListResponse>(query, body);
  }

  getView(type: string): Observable<IViewModel> {
    const query = `${environment.api}view`;
    return this.http.post<IViewModel>(query, { type });
  }

  getViewModel(type: string, id = '', params: { [key: string]: any } = {}): Observable<IViewModel> {
    const query = `${environment.api}view`;
    return this.http.post<IViewModel>(query, { type, id, ...params }, { params });
  }

  getSuggests(docType: string, filter: string, storageType: StorageType): Observable<ISuggest[]> {
    const query = `${environment.api}suggest/${docType}?filter=${filter}&storageType=${storageType}`;
    return this.http.get<ISuggest[]>(query);
  }

  postDoc(doc: DocumentBase): Observable<DocumentBase> {
    const apiDoc = mapToApi(doc);
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
    const apiDoc = mapToApi(doc);
    const query = `${environment.api}save`;
    return (this.http.post<DocumentBase>(query, apiDoc));
  }

  savePostDoc(doc: DocumentBase): Observable<DocumentBase> {
    const apiDoc = mapToApi(doc);
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

  getDocAccountMovementsView(id: string): Observable<AccountRegister[]> {
    const query = `${environment.api}register/account/movements/view/${id}`;
    return (this.http.get<AccountRegister[]>(query));
  }

  getDocRegisterAccumulationList(id: string): Observable<string[]> {
    const query = `${environment.api}register/accumulation/list/${id}`;
    return (this.http.get(query) as Observable<string[]>);
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

  getOperationsGroups(): Observable<IComplexObject[]> {
    const query = `${environment.api}operations/groups`;
    return (this.http.get<IComplexObject[]>(query));
  }

  getUserFormListSettings(type: string): Observable<FormListSettings> {
    const query = `${environment.api}user/settings/${type}`;
    return (this.http.get(query) as Observable<FormListSettings>);
  }

  setUserFormListSettings(type: string, formListSettings: FormListSettings) {
    const query = `${environment.api}user/settings/${type}`;
    return (this.http.post(query, formListSettings) as Observable<boolean>);
  }

  getUserDefaultsSettings() {
    const query = `${environment.api}user/settings/defaults`;
    return (this.http.get(query) as Observable<UserDefaultsSettings>);
  }

  setUserDefaultsSettings(value: UserDefaultsSettings) {
    const query = `${environment.api}user/settings/defaults`;
    return (this.http.post(query, value) as Observable<boolean>);
  }

  getDocDimensions(type: string) {
    const query = `${environment.api}${type}/dimensions`;
    return (this.http.get<any[]>(query));
  }

  getUserRoles() {
    const query = `${environment.api}user/roles`;
    return this.http.get<RoleType[]>(query).pipe(
      map(data => ({ roles: data as RoleType[] || [], Objects: getRoleObjects(data) }))
    );
  }

  valueChanges(doc: DocumentBase, property: string, value: string) {
    const apiDoc = mapToApi(doc);
    const query = `${environment.api}valueChanges/${doc.type}/${property}`;
    const callConfig = { doc: apiDoc, value: value };
    return this.http.post<PatchValue>(query, callConfig).toPromise();
  }

  onCommand(doc: DocumentBase, command: string, args: { [x: string]: any }) {
    const apiDoc = mapToApi(doc);
    const query = `${environment.api}command/${doc.type}/${command}`;
    const callConfig = { doc: apiDoc, args: args };
    return this.http.post<PatchValue>(query, callConfig).toPromise();
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

  execute(type: FormTypes, method: string, doc: FormBase) {
    const apiDoc = mapToApi(doc as any);
    const query = `${environment.api}form/${type}/${method}`;
    return this.http.post<FormBase>(query, apiDoc);
  }

  batchActual() {
    const query = `${environment.api}batch/actual`;
    return this.http.get<any[]>(query);
  }

  SubSystemsMenu() {
    const query = `${environment.auth}subsystems/menu`;
    // tslint:disable-next-line: deprecation
    return this.http.get<MenuItem[]>(query);
  }
}
