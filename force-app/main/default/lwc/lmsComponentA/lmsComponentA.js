import { LightningElement, wire } from 'lwc';
import { MessageContext, publish } from 'lightning/messageService';
import SAMPLEMC from '@salesforce/messageChannel/SampleMessageChannel__c';

export default class LmsComponentA extends LightningElement
{
    @wire(MessageContext)
    context;

    inputValue;
    noInput = true;
    status;

    inputHandler(event)
    {
        this.inputValue = event.target.value.trim();
        this.noInput = ((this.inputValue > "") ? false : true);
        this.status = null;
    }

    publishMessage()
    {
        const message =
        {
            lmsData: {
                value: this.inputValue
            }
        }

        publish(this.context, SAMPLEMC, message);
        this.template.querySelector("lightning-input").value = null;
        this.noInput = true;
        this.status = "Your message has been published.";
    }
}