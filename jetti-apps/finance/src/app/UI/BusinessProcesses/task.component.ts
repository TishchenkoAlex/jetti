import { Component, OnInit, Input } from '@angular/core';
import { BPApi } from 'src/app/services/bpapi.service';
import { Task, ProcessParticipants, FieldProp } from './task.object';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';

@Component({
  templateUrl: 'task.component.html',
  selector: 'bp-task'
})
export class TaskComponent implements OnInit {

  @Input() Task: Task;
  @Input() ProcessID: string;

  get showProp() { return false; }
  get getProcessID() {
    return this.ProcessID === '' || this.ProcessID === undefined ? this.Task.ProcessID : this.ProcessID;
  }

  mapImgSrc = '';
  ProcessParticipantsFields: FieldProp[];
  _ProcessParticipants$: Observable<ProcessParticipants>;

  ngOnInit() {
    this.loadProcessParticipants();
  }

  constructor(public bpAPI: BPApi) {
  }

  loadMap() {
    this.mapImgSrc = `${environment.BPAPI}/Processes/pwd/GetMapByProcessID/CashApplication?ProcessID=${this.getProcessID}`;
  }

  async loadProcessParticipants() {
    this.ProcessParticipantsFields = ProcessParticipants.getFields();
    this._ProcessParticipants$ = this.bpAPI.GetParticipantsByProcessID(this.getProcessID);
  }

  handleTabChange(e) {
    if (e.index === 1 && this.mapImgSrc.length === 0) { this.loadMap(); }

  }

}
