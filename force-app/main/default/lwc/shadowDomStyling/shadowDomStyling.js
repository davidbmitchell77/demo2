import { LightningElement } from 'lwc';

export default class ShadowDomStyling extends LightningElement
{
    isNotLoaded = true;

    renderedCallback()
    {
        if (this.isNotLoaded)
        {
            const style = document.createElement('style');
            style.innerText = `c-shadow-dom-styling .slds-button {
                background: red;
                color: white;
                font-weight: bold;
            }
            .slds-button:hover {
                background: red;
                color: white;
                font-weight: bold;
            }
            .slds-button:not(:hover) {
                background: red;
                color: white;
                font-weight: bold;
            }`;
            this.template.querySelector('lightning-button').appendChild(style);
            this.isNotLoaded = false;
        }
    }
}