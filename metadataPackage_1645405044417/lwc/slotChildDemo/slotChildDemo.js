import { LightningElement } from 'lwc';

export default class SlotChildDemo extends LightningElement
{
    footerHandler(event)
    {
        const footer = this.template.querySelector(".slds-card__footer");
        const year = new Date().getFullYear();

        if (year >= 2022) {
            footer.classList.remove("slds-hide");
        }
    }
}