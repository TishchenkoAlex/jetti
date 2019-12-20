import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { Task, ProcessParticipants } from 'src/app/UI/BusinessProcesses/task.object';
import { environment } from '../../environments/environment';
import { take } from 'rxjs/operators';

@Injectable({ providedIn: 'root' })
export class BPApi {

  constructor(private http: HttpClient) { }

  GetTasks(CountOfCompleted: number): Observable<Task[]> {
    const query = `${environment.api}/BP/GetUserTasksByMail?CountOfCompleted=${CountOfCompleted}`;
    return this.http.get<Task[]>(query);
  }

  CompleteTask(TaskID: number, UserDecisionID: number, Comment?: string): string {
    // const query = `${environment.api}BP/CompleteTask?`;
    // // ?TaskID=${TaskID}&UserDecision=${UserDecisionID}&Comment=${Comment}`;
    // const b = [
    //   { key: 'TaskID', value: TaskID.toString() },
    //   { key: 'UserDecisionID', value: UserDecisionID.toString() },
    //   { key: 'Comment', value: Comment }
    // ];
    // let result = '';
    // this.http.post<string>(query, b).pipe(take(1)).subscribe(errMessage => { result = errMessage; });
    // return result;
    // let query: any;
    const query = `${environment.api}BP/CompleteTask?TaskID=${TaskID}&UserDecision=${UserDecisionID}&Comment=${Comment}`;
    // query.stringByAddingPercentEncodingWithAllowedCharacters();
    let result = '';
    this.http.get<string>(query).pipe(take(1)).subscribe(errMessage => { result = errMessage; });
    return result;
  }

  GetMapByProcessID(ProcessID): Observable<Blob> {
    // return `${environment.api}/BP/GetMapByProcessID?ProcessID=${ProcessID}`;
    const query = `${environment.api}/BP/GetMapByProcessID?ProcessID=${ProcessID}`;
    return this.http.get<Blob>(query);
  }

  GetParticipantsByProcessID(ProcessID): Observable<ProcessParticipants> {
    const query = `${environment.api}/BP/GetUsersByProcessID?ProcessID=${ProcessID}`;
    return this.http.get<ProcessParticipants>(query);
  }

  StartProcess(BaseDocumentID) {
    const query = `${environment.api}/BP/StartProcess?BaseDocumentID=${BaseDocumentID}`;
    return this.http.get(query);
  }
}
