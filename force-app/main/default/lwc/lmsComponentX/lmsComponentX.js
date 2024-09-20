import { LightningElement, wire            } from 'lwc';
import { APPLICATION_SCOPE, MessageContext } from 'lightning/messageService';
import { subscribe, unsubscribe            } from 'lightning/messageService';
import { days, months, right               } from 'c/utils';

import MESSAGE_CHANNEL from '@salesforce/messageChannel/SampleMessageChannel__c';

export default class LmsComponentX extends LightningElement {

    @wire(MessageContext)
    messageContext;

    receivedMessage;
    subscription;
    today;
    isListening;

    connectedCallback() {
        this.subscribeMessage();
        this.status = `Today is ${this.currentDate()}.`;
    }

    subscribeButtonHandler() {
        this.subscribeMessage();
    }

    subscribeMessage() {
        this.subscripion = subscribe(this.messageContext, MESSAGE_CHANNEL, (message) => { this.handleMessage(message); }, { scope: APPLICATION_SCOPE });
        this.isListening = true;
    }

    unsubscribeButtonHandler() {
        this.isListening = false;
        this.receivedMessage = '';
        this.status = `Today is ${this.currentDate()}.`;
    }

    unSubscribeMessage() {
        this.isListening = false;
    }

    handleMessage(message) {
        if (this.isListening) {
            console.info(message);
            this.receivedMessage = (message.lmsData.value ? message.lmsData.value : 'Message is empty.');
            this.status = `Message received on ${this.currentDate()} at ${this.currentTime()}).`;
        }
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
        let ms = right('00' + today.getMilliseconds(), 3);
        let offset = right('0' + (today.getTimezoneOffset() / -60), 2);
        return (`${hr}:${mi}:${ss}.${ms} (UTC ${offset}:00`);
    }

    disconnectedCallback() {
        if (this.subscription) {
            unsubscribe(this.subscription);
        }
        this.subscription = null;
    }

    get isActive() {
        return (this.isListening);
    }

    get isNotActive() {
        return !(this.isListening);
    }
}