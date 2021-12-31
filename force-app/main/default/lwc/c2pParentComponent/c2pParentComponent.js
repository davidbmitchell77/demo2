import { LightningElement } from 'lwc';

export default class C2pParentComponent extends LightningElement
{
    msg = "";
    showModal = false;

    clickHandler() {
        this.showModal = true;
        this.msg = "";
    }

    closeHandler(event)
    {
        this.msg = event.detail.msg;
        this.showModal = false;
        console.log(JSON.stringify(event));
    }
}