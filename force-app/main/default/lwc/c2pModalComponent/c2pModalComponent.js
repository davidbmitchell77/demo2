import { LightningElement } from 'lwc';

export default class C2pModalComponent extends LightningElement
{
    closeHandler() {
        this.dispatchEvent(new CustomEvent("close", { bubbles: false, detail: { msg: "Modal closed successfully!" } }));
    }
}