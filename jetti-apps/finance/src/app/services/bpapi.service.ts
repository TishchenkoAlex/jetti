// import { HttpClient } from '@angular/common/http';
// import { Injectable } from '@angular/core';
// import { Observable, of } from 'rxjs';

// @Injectable({ providedIn: 'root' })
// export class BPApi {

    // GetTasks(Username: string, CountOfCompleted: number): Observable<TaskComponent>{
    //     const httpOptions = {headers: this.headers, withCredentials: true};
    //     const url = this.baseurl + '/Query/' + this.token + '/GetUserTasksByMail?UserMail=' + Username + ' &CountOfCompleted=' + CountOfCompleted;
    //     return this.http.get<TaskComponent>(url, httpOptions).pipe(retry(1), catchError(this.errorHandl));
    //   }
// }