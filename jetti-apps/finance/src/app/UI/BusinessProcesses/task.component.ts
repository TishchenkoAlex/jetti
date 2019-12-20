import { Component, OnInit, Input } from '@angular/core';
import { BPApi } from 'src/app/services/bpapi.service';
import { take } from 'rxjs/operators';
import { Task, ProcessParticipants, FieldProp } from './task.object';

@Component({
  templateUrl: 'task.component.html',
  styles: ['task.component.css'],
  selector: 'bp-task'
})
export class TaskComponent implements OnInit {

  @Input() Task: Task;
  mapImgSrc = '';
  ProcessParticipants: {} = [];
  ProcessParticipantsFields: FieldProp[];
  ProcessParticipantsLoaded = false;

  ngOnInit() {
    this.loadProcessParticipants();
  }

  constructor(public bpAPI: BPApi) {
  }

  loadMap() {
    this.mapImgSrc = `http://35.204.78.79/JettiProcesses/hs/Processes/pwd/GetMapByProcessID/CashApplication?ProcessID=${this.Task.ProcessID}`;
  }

  public loadProcessParticipants() {

    this.ProcessParticipantsFields = ProcessParticipants.getFields();
    this.bpAPI.GetParticipantsByProcessID(this.Task.ProcessID).pipe(take(1)).subscribe(
      res => {
        this.ProcessParticipants = res;
        this.ProcessParticipantsLoaded = true;
      });

  }

  handleTabChange(e) {
    if (e.index === 2 && this.mapImgSrc.length === 0) { this.loadMap(); }
    if (e.index === 1 && !this.ProcessParticipantsLoaded) { this.loadProcessParticipants(); }
  }

}
