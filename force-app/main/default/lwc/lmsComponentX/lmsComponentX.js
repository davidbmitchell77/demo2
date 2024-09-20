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
        let today = new Date();
        let month = months.get(today.getMonth());
        let day = days.get(today.getDay());
        let date = today.getDate();
        let year = today.getFullYear();
        this.status = `Today is ${day}, ${month} ${date}, ${year}.`;
    }

    subscribeMessage() {
        this.subscripion = subscribe(
            this.messageContext,
            MESSAGE_CHANNEL,
            (message) => {
                this.handleMessage(message);
            },
            { scope: APPLICATION_SCOPE }
        );
        this.isListening = true;
    }

    unSubscribeMessage() {
        this.isListening = false;
    }

    handleMessage(message) {
        if (this.isListening) {
            console.info(message);
            let today = new Date();
            let mm = months.get(today.getMonth());
            let day = days.get(today.getDay());
            let dd = today.getDate();
            let yyyy = today.getFullYear();
            let hr = right('0' + today.getHours(), 2);
            let mi = right('0' + today.getMinutes(), 2);
            let ss = right('0' + today.getSeconds(), 2);
            let offset = right('0' + (today.getTimezoneOffset() / -60), 2);
            this.receivedMessage = (message.lmsData.value ? message.lmsData.value : 'Message is empty.');
            this.status = `Message received on ${day}, ${mm} ${dd}, ${yyyy} at ${hr}:${mi}:${ss} (UTC ${offset}:00).`;
        }
    }

    subscribeButtonHandler() {
        this.subscribeMessage();
    }

    unsubscribeButtonHandler() {
        this.isListening = false;
        this.receivedMessage = '';
        let today = new Date();
        let month = this.months.get(today.getMonth());
        let day = this.days.get(today.getDay());
        let date = today.getDate();
        let year = today.getFullYear();
        this.status = `Today is ${day}, ${month} ${date}, ${year}.`;
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