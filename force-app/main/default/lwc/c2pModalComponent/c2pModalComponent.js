import { LightningElement } from 'lwc';

export default class C2pModalComponent extends LightningElement
{
    closeHandler() {
        this.dispatchEvent(new CustomEvent("close", { bubbles: true, detail: { msg: "Modal closed successfully!" } }));
    }

    footerHandler() {
        console.log("Child footerHandler() called.");
    }
}