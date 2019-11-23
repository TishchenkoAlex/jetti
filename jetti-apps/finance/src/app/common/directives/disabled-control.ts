import { NgControl } from '@angular/forms';
import { Directive, Input } from '@angular/core';

@Directive({
    // tslint:disable-next-line: directive-selector
    selector: '[disableControl]'
})
export class DisableControlDirective {

    @Input() set disableControl(condition: boolean) {
        const action = condition ? 'disable' : 'enable';
        this.ngControl.control[action]({emitEvent: false});
    }

    constructor(private ngControl: NgControl) {
    }

}
