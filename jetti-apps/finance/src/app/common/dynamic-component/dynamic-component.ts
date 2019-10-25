// tslint:disable-next-line:max-line-length
import { AfterViewInit, ChangeDetectionStrategy, ChangeDetectorRef, Component, ComponentFactoryResolver, ComponentRef, Directive, Input, OnInit, Type, ViewChild, ViewContainerRef } from '@angular/core';
import { getFormComponent, getListComponent } from '../../UI/userForms';

export class BaseDynamicCompoment {
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
  @Input() kind: 'list' | 'form';
  component: BaseDynamicCompoment;
  componentRef: ComponentRef<any>;

  @ViewChild(DynamicComponentDirective, {static: false}) host: DynamicComponentDirective;

  constructor(private componentFactoryResolver: ComponentFactoryResolver, private cd: ChangeDetectorRef) { }

  ngOnInit() {
    this.component = this.kind === 'list' ?
      new BaseDynamicCompoment(getListComponent(this.type)) :
      new BaseDynamicCompoment(getFormComponent(this.type));
  }

  ngAfterViewInit() {
    const componentFactory = this.componentFactoryResolver.resolveComponentFactory(this.component.component);
    const viewContainerRef = this.host.viewContainerRef;
    viewContainerRef.clear();
    this.componentRef = viewContainerRef.createComponent(componentFactory);
    this.cd.detectChanges();
  }

}
