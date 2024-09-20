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
        this.status = `Today is ${this.currentDate()}.`;
    }

    inputHandler(event){
        this.inputValue = event.target.value.trim();
        this.noInput = ((this.inputValue > '') ? false : true);
        this.status = `Today is ${this.currentDate()}.`;
    }

    publishMessage() {
        const message = { lmsData: { value: this.inputValue }, recordId: { value: USER_ID } };
        publish(this.messageContext, MESSAGE_CHANNEL, message);
        this.template.querySelector('lightning-input').value = null;
        this.noInput = true;
        this.status = `Message published on ${this.currentDate} at ${this.currentTime()}.`;
    }

    currentDate() {
        let today = new Date();
        let mm = months.get(today.getMonth());
        let day = days.get(today.getDay());
        let dd = today.getDate();
        let yyyy = today.getFullYear();
        return (`${day}, ${mm} ${dd}, ${yyyy}`);
    }

    currentTime() {
        let today = new Date();
        let hr = right('0' + today.getHours(), 2);
        let mi = right('0' + today.getMinutes(), 2);
        let ss = right('0' + today.getSeconds(), 2);
        let offset = right('0' + (today.getTimezoneOffset() / -60), 2);
        return (`${hr}:${mi}:${ss} (UTC ${offset}:00`);
    }
}