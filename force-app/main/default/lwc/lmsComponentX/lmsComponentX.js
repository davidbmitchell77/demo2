import { LightningElement, wire            } from 'lwc';
import { APPLICATION_SCOPE, MessageContext } from 'lightning/messageService';
import { subscribe, unsubscribe            } from 'lightning/messageService';
import { currentDate, currentTime          } from 'c/utils';

import MESSAGE_CHANNEL from '@salesforce/messageChannel/SampleMessageChannel__c';

export default class LmsComponentX extends LightningElement {

    @wire(MessageContext)
    messageContext;

    receivedMessage;
    subscription;
    today;
    isListening;
    from;

    connectedCallback() {
        this.subscribeMessage();
        this.status = `Today is ${currentDate()}.`;
        this.from = 'Message:';
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
        this.status = `Today is ${currentDate()}.`;
    }

    unSubscribeMessage() {
        this.isListening = false;
    }

    handleMessage(message) {
        if (this.isListening) {
            console.info(message);
            this.receivedMessage = (message.lmsData.value ? message.lmsData.value : 'Message is empty.');
            this.from = `Message received from: ${message.senderAlias.value} (${message.senderUsername.value})`;
            this.status = `Message received on ${currentDate()} at ${currentTime()}).`;
        }
    }

    get isActive() {
        return (this.isListening);
    }

    get isNotActive() {
        return !(this.isListening);
    }

    disconnectedCallback() {
        if (this.subscription) {
            unsubscribe(this.subscription);
        }
        this.subscription = null;
    }
}