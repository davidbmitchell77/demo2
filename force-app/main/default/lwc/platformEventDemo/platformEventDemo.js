import { LightningElement       } from 'lwc';
import { subscribe, unsubscribe } from 'lightning/empApi';
import { onError                } from 'lightning/empApi';
import { showToast              } from 'c/utils';

import AuraError from '@salesforce/apex/AuraLogger.error';
import AuraInfo  from '@salesforce/apex/AuraLogger.info' ;

export default class PlatformEventDemo extends LightningElement {

    channelName   = '/event/LightningWebComponent__e';
    subDisabled   = true;
    unsDisabled = true;
    subscription  = {};
    messages      = '';

    connectedCallback() {
        this.registerErrorListener();
        this.subDisabled = false;
    }

    sub() {
        subscribe(this.channelName, -1, (response) => {
            let platformEvent = JSON.parse(JSON.stringify(response));
            console.info(platformEvent);
            let payload = { ...platformEvent.data.payload };
            this.messages += (JSON.stringify(payload) + '\n');
        })
       .then((response) => {
            console.info({ ...response });
            this.subscription = { ...response };
            this.toggleButtons();
            AuraInfo({ msg: JSON.stringify(response) });
            showToast(this, 'Success', `You have subscribed to the "${this.channelName}" platform event!`, 'success');
        })
       .catch((error) => {
            console.error({ ...error });
            AuraError({ msg: JSON.stringify(error), tags: [ 'lwc', 'plaftformEventDemo', 'subscribe' ] });
            showToast(this, 'Subscribe Error!',  this.getMessage(error), 'error', 'sticky');
       });
    }

    uns() {
        unsubscribe(this.subscription, (response) => {
            console.info({ ...response });
        })
       .then(() => {
            this.messages = '';
            this.toggleButtons();
            showToast(this, 'Unsubscribed', `You have unsubscribed from the "${this.channelName}" platform event!`, 'warning');
        })
       .catch((error) => {
            console.error({ ...error });
            AuraError({ msg: JSON.stringify(error), tags: [ 'lwc', 'plaftformEventDemo', 'unsubscribe' ] });
            showToast(this, 'Unsubscribe Error!', this.getMessage(error), 'error', 'sticky');
        });
    }

    handleChange(event) {
        switch (event.target.label) {
            case 'Channel':
                this.channelName = event.target.value;
                break;
        }
    }

    toggleButtons() {
        this.subDisabled = !this.subDisabled;
        this.unsDisabled = !this.unsDisabled;
    }

    validateInput(event) {
        this.subDisabled = ((event.target.value.length === 0) ? true : !this.unsDisabled);
    }

    getMessage(error) {
        let message = (typeof(error) === 'object' ? JSON.stringify(error) : error);
        if (error.hasOwnProperty('body.message')) { message = error.body.message; } else
        if (error.hasOwnProperty('message'     )) { message = error.message;      } else
        if (error.hasOwnProperty('error'       )) { message = error.error;        }
        return message;
    }

    registerErrorListener() {
        onError((error) => {
            console.error({ ...error });
            AuraError({ msg: JSON.stringify(error), tags: [ 'lwc', 'plaftformEventDemo', 'registerErrorListener' ] });
            showToast(this, 'Error!', this.getMessage(error), 'error', 'pester');
        });
    }
}
