import { LightningElement, api } from "lwc";

export default class GoogleAction extends LightningElement
{
    @api recordId;
    @api invoke() {
        console.log("Quick Action invoked for recordId:", this.recordId);
        window.open("https://google.com", "_blank");
    }
}