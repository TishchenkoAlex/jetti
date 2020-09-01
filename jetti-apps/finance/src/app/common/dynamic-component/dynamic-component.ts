import { AuthService } from './../../auth/auth.service';
// tslint:disable-next-line:max-line-length
import { AfterViewInit, ChangeDetectionStrategy, ChangeDetectorRef, Component, ComponentFactoryResolver, ComponentRef, Directive, Input, OnInit, Type, ViewChild, ViewContainerRef } from '@angular/core';
import { getFormComponent, getListComponent } from '../../UI/userForms';

export class BaseDynamicComponent {
  constructor(public component: Type<any>) { }
}

@Directive({
  // tslint:disable-next-line:directive-selector
  selector: '[component-host]',
})
export class DynamicComponentDirective {
  constructor(public viewContainerRef: ViewContainerRef) { }
}

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'dynamic-component',
  template: `<ng-template component-host></ng-template>`,
})
export class DynamicComponent implements OnInit, AfterViewInit {
  @Input() id: string;
  @Input() type: string;
  @Input() data: any;
  @Input() kind: 'list' | 'form';
  component: BaseDynamicComponent;
  componentRef: ComponentRef<any>;

  @ViewChild(DynamicComponentDirective) host: DynamicComponentDirective;

  constructor(private componentFactoryResolver: ComponentFactoryResolver, private cd: ChangeDetectorRef) { }

  ngOnInit() {
    if (this.kind === 'list') {
      this.component = new BaseDynamicComponent(getListComponent(this.type));
    } else {
      this.component = new BaseDynamicComponent(getFormComponent(this.type));
    }
  }

  ngAfterViewInit() {
    const componentFactory = this.componentFactoryResolver.resolveComponentFactory(this.component.component);
    const viewContainerRef = this.host.viewContainerRef;
    viewContainerRef.clear();
    this.componentRef = viewContainerRef.createComponent(componentFactory);
    this.componentRef.instance.id = this.id;
    this.componentRef.instance.type = this.type;
    this.componentRef.instance.data = this.data;
    this.cd.detectChanges();
  }

}
