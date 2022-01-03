import { LightningElement, wire } from 'lwc';
import { MessageContext, publish } from 'lightning/messageService';
import SAMPLEMC from '@salesforce/messageChannel/SampleMessageChannel__c';

export default class LmsComponentA extends LightningElement
{
    @wire(MessageContext)
    context;

    inputValue;
    noInput = true;

    inputHandler(event) {
        this.inputValue = event.target.value.trim();
        this.noInput = ((this.inputValue > "") ? false : true);
    }

    publishMessage()
    {
        const message =
        {
            lmsData: {
                value: this.inputValue
            }
        }

        try
        {
            publish(this.context, SAMPLEMC, message);
        }
        catch(e) {
            console.error(e);
        }
    }
}