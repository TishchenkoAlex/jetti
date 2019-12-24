import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { Task, ProcessParticipants } from 'src/app/UI/BusinessProcesses/task.object';
import { environment } from '../../environments/environment';
import { take } from 'rxjs/operators';
import { DocumentTypes } from '../../../../../jetti-api/server/models/documents.types';

@Injectable({ providedIn: 'root' })
export class BPApi {

  constructor(private http: HttpClient) { }

  GetTasks(CountOfCompleted: number): Observable<Task[]> {
    const query = `${environment.api}/BP/GetUserTasksByMail?CountOfCompleted=${CountOfCompleted}`;
    return this.http.get<Task[]>(query);
  }

  CompleteTask(TaskID: number, UserDecisionID: number, Comment?: string): string {
    const query = `${environment.api}BP/CompleteTask`;
    const body = {
      'TaskID': TaskID,
      'UserDecision': UserDecisionID.toString(),
      'Comment': Comment,
      'UserID': ''};
    let result = '';
    this.http.post<string>(query, body).pipe(take(1)).subscribe(errMessage => { result = errMessage; });
    return result;
  }

  GetMapByProcessID(ProcessID): Observable<Blob> {
    const query = `${environment.api}/BP/GetMapByProcessID?ProcessID=${ProcessID}`;
    return this.http.get<Blob>(query);
  }

  GetParticipantsByProcessID(ProcessID): Observable<ProcessParticipants> {
    const query = `${environment.api}/BP/GetUsersByProcessID?ProcessID=${ProcessID}`;
    return this.http.get<ProcessParticipants>(query);
  }

  StartProcess(Base: any, BaseType: string): Observable<string> {
    const query = `${environment.api}/BP/StartProcess`;
    let body = {};
    if (BaseType === 'Document.CashRequest') {
      body = {
        'SubdivisionID': Base.Department.id,
        'Sum': Base.Amount,
        'ItemID': Base.CashFlow.id,
        'OperationTypeID': Base.Operation,
        'AuthorID': Base.user.code,
        'DocumentID': Base.id,
        'Comment': Base.info
      };
    }
    return this.http.post<string>(query, body);
  }
}
