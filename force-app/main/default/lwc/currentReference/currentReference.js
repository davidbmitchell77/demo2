import { LightningElement, wire } from 'lwc';
import { CurrentPageReference   } from 'lightning/navigation';

export default class CurrentReference extends LightningElement
{
    @wire(CurrentPageReference)
    psgeRef;

    get pageReference() {
        return ((this.pageRef) ? JSON.stringify(pageRef, null, 2) : "");
    }
}