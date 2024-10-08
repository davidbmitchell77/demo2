import { LightningElement, wire            } from 'lwc';
import { APPLICATION_SCOPE, MessageContext } from 'lightning/messageService';
import { subscribe, unsubscribe            } from 'lightning/messageService';
import { currentDate, currentTime          } from 'c/utils';

import MESSAGE_CHANNEL from '@salesforce/messageChannel/SampleMessageChannel__c';

export default class LmsComponentX extends LightningElement {
    receivedMessage;
    subscription;
    today;
    isListening;
    from;

    @wire(MessageContext)
    messageContext;

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

    handleMessage(messageObj) {
        if (this.isListening) {
            console.info(messageObj);
            this.receivedMessage = (messageObj.message.value ? messageObj.message.value : 'Message is empty.');
            this.from = `Message received from: ${messageObj.senderAlias.value} (${messageObj.senderUsername.value})`;
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