import { LightningElement } from 'lwc';

export default class ShadowDomStyling extends LightningElement
{
    isNotLoaded = true;

    renderedCallback()
    {
        console.log("renderedCallback called.");
        if (this.isNotLoaded)
        {
            const style = document.createElement('style');
            style.innerText = `c-shadow-dom-styling .slds-button {
                background: #9b7653;
                color: white;
                font-weight: bold;
            }
            .slds-button:hover {
                background: #9b7653;
                color: white;
                font-weight: bold;
            }
            .slds-button:not(:hover) {
                background: #9b7653;
                color: white;
                font-weight: bold;
            }`;
            this.template.querySelector('lightning-button').appendChild(style);
            this.isNotLoaded = false;
        }
    }

    disconnectedCallback() {
        console.log("disconnectedCallback called.");
    }
}