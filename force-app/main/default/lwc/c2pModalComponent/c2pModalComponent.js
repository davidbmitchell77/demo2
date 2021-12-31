import { LightningElement } from 'lwc';

export default class C2pModalComponent extends LightningElement
{
    closeHandler() {
        this.dispatchEvent(new CustomEvent("close", { detail: { msg: "Modal closed successfully!" }}));
    }
}