import { FormTypes } from '../../models/Forms/form.types';
import { DocTypes } from '../../models/documents.types';

export interface ICallRequest {
    type: FormTypes | DocTypes;
    formView: { [x: string]: any };
    method: string;
    params: any[];
    user: string;
    userID: string;
}
