import { animate, state, style, transition, trigger } from '@angular/animations';
import { Component, Input } from '@angular/core';
import { AuthService } from '../auth/auth.service';
import { SafeUrl, DomSanitizer } from '@angular/platform-browser';

@Component({
  selector: 'app-inline-profile',
  templateUrl: './app.profile.component.html',
  animations: [
    trigger('menu', [
      state('hidden', style({
        height: '0px'
      })),
      state('visible', style({
        height: '*'
      })),
      transition('visible => hidden', animate('400ms cubic-bezier(0.86, 0, 0.07, 1)')),
      transition('hidden => visible', animate('400ms cubic-bezier(0.86, 0, 0.07, 1)'))
    ])
  ]
})
export class AppProfileComponent {

  active: boolean;
  image: SafeUrl = '';
  @Input() inline = true;

  constructor(public appAuth: AuthService, private sanitizer: DomSanitizer) {
    appAuth.userProfile$.subscribe(data => {
      const photo = localStorage.getItem('photo');
      if (photo) this.image = this.sanitizer.bypassSecurityTrustUrl(`data:image/jpg;base64,${photo}`);
    });
  }

  onClick(event) {
    this.active = !this.active;
    event.preventDefault();
  }

}
