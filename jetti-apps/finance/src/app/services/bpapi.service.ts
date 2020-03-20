import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { ITask, ProcessParticipants, ITaskCompleteResult } from 'src/app/UI/BusinessProcesses/task.object';
import { environment } from '../../environments/environment';

@Injectable({ providedIn: 'root' })
export class BPApi {

  constructor(private http: HttpClient) { }

  GetTasks(CountOfCompleted: number): Observable<ITask[]> {
    const query = `${environment.api}/BP/GetUserTasksByMail?CountOfCompleted=${CountOfCompleted}`;
    return this.http.get<ITask[]>(query);
  }

  CompleteTask(Task: ITask): Observable<ITaskCompleteResult> {
    const query = `${environment.api}BP/CompleteTask`;
    const body = {
      'TaskID': Task.TaskID,
      'UserDecision': Task.DecisionID.toString(),
      'Comment': Task.DecisionComment,
      'UserID': ''};
    return this.http.post<ITaskCompleteResult>(query, body);
  }

  GetMapByProcessID(ProcessID): Observable<Blob> {
    const query = `${environment.api}/BP/GetMapByProcessID?ProcessID=${ProcessID}`;
    return this.http.get<Blob>(query);
  }

  DeleteProcess(ProcessID): Observable<{Deleted: boolean, ErrorMessage: string}> {
    const query = `${environment.api}/BP/DeleteProcess?ProcessID=${ProcessID}`;
    return this.http.get<{Deleted: boolean, ErrorMessage: string}>(query);
  }

  GetParticipantsByProcessID(ProcessID): Observable<ProcessParticipants> {
    const query = `${environment.api}/BP/GetUsersByProcessID?ProcessID=${ProcessID}`;
    return this.http.get<ProcessParticipants>(query);
  }

  StartProcess(Base: any, BaseType: string, userMail: string): Observable<string> {
    const query = `${environment.api}/BP/StartProcess`;
    let body = {};
    if (BaseType === 'Document.CashRequest') {
      body = {
        'CompanyDescription': Base.company.value,
        'CompanyID': Base.company.id,
        'CashRecipientDescription': Base.CashRecipient ? Base.CashRecipient.value : '',
        'SubdivisionID': Base.Department.id,
        'Sum': Base.Amount,
        'ItemID': Base.CashFlow.id,
        'OperationTypeID': Base.Operation,
        'AuthorID': Base.user.code,
        'DocumentID': Base.id,
        'Comment': Base.info,
        'BaseType': BaseType,
        'userMail': userMail
      };
    }
    return this.http.post<string>(query, body);
  }

 ModifyProcess(Base: any, BaseType: string, userMail: string, processCode: string): Observable<string> {
    const query = `${environment.api}/BP/ModifyProcess`;
    let body = {};
    if (BaseType === 'Document.CashRequest') {
      body = {
        'CompanyDescription': Base.company.value,
        'CompanyID': Base.company.id,
        'CashRecipientDescription': Base.CashRecipient ? Base.CashRecipient.value : '',
        'SubdivisionID': Base.Department.id,
        'Sum': Base.Amount,
        'ItemID': Base.CashFlow.id,
        'OperationTypeID': Base.Operation,
        'AuthorID': Base.user.code,
        'DocumentID': Base.id,
        'Comment': Base.info,
        'BaseType': BaseType,
        'userMail': userMail,
        'processCode': processCode
      };
    }
    return this.http.post<string>(query, body);
  }

  isUserCurrentExecutant(ProcessID: string): Promise<boolean | string> {
    const query = `${environment.api}BP/isUserCurrentExecutant?ProcessID=${ProcessID}`;
    return this.http.get<boolean | string>(query).toPromise();
  }

  CashRequestDesktop(): Observable<any[]> {
    const query = `${environment.api}/CashRequestDesktop`;
    return this.http.get<any[]>(query);
  }

  CashRequestCreateBaseOn(baseOn: string[]): Observable<any[]> {
    const query = `${environment.api}/CashRequestCreateBaseOn`;
    return this.http.post<any[]>(query, baseOn);
  }
}
