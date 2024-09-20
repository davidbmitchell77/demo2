import { LightningElement, wire  } from 'lwc';
import { MessageContext, publish } from 'lightning/messageService';
import { days, months, right     } from 'c/utils';

import MESSAGE_CHANNEL from '@salesforce/messageChannel/SampleMessageChannel__c';
import USER_ID         from '@salesforce/user/Id';

export default class LmsComponentA extends LightningElement {

    @wire(MessageContext)
    messageContext;

    inputValue;
    noInput = true;
    status;

    connectedCallback() {
        let today = new Date();
        let mm = months.get(today.getMonth());
        let day = days.get(today.getDay());
        let dd = today.getDate();
        let yyyy = today.getFullYear();
        this.status = `Today is ${day}, ${mm} ${dd}, ${yyyy}.`;
    }

    inputHandler(event){
        this.inputValue = event.target.value.trim();
        this.noInput = ((this.inputValue > '') ? false : true);

        let today = new Date();
        let mm = months.get(today.getMonth());
        let day = days.get(today.getDay());
        let dd = today.getDate();
        let yyyy = today.getFullYear();
        this.status = `Today is ${day}, ${mm} ${dd}, ${yyyy}.`;
    }

    publishMessage() {
        const message = {
            lmsData: {
                value: this.inputValue
            },
            recordId: {
                value: USER_ID
            }
        }

        publish(this.messageContext, MESSAGE_CHANNEL, message);

        let today = new Date();
        let mm = this.months.get(today.getMonth());
        let day = this.days.get(today.getDay());
        let dd = today.getDate();
        let yyyy = today.getFullYear();
        let hr = right('0' + today.getHours(), 2);
        let mi = right('0' + today.getMinutes(), 2);
        let ss = right('0' + today.getSeconds(), 2);
        let offset = right('0' + (today.getTimezoneOffset() / -60), 2);

        this.template.querySelector('lightning-input').value = null;
        this.noInput = true;
        this.status = `Message published on ${day}, ${mm} ${dd}, ${yyyy} at ${hr}:${mi}:${ss} (UTC ${offset}:00).`;
    }
}