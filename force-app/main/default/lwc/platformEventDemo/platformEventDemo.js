import { LightningElement       } from 'lwc';
import { subscribe, unsubscribe } from 'lightning/empApi';
import { onError                } from 'lightning/empApi';
import { showToast              } from 'c/utils';

export default class PlatformEventDemo extends LightningElement {

    channelName   = '/event/LightningWebComponent__e';
    subDisabled   = true;
    unsubDisabled = true;
    subscription  = {};
    messages      = '';

    handleChange(event) {
        switch (event.target.label) {
            case 'Channel Name':
                this.channelName = event.target.value;
                break;
        }
    }

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
            showToast(this, 'Success', `You have subscribed to the "${this.channelName}" platform event!`, 'success');
        })
       .catch((error) => {
            console.error({ ...error });
            showToast(this, 'Error!', `Error subscribing to "${this.channelName}" platform event!`, 'error', 'sticky');
       });
    }

    unsub() {
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
            showToast(this, 'Error!', `Error unsubscribing from "${this.channelName}" platform event!`, 'error', 'sticky');
        });
    }

    toggleButtons() {
        this.subDisabled   = !this.subDisabled;
        this.unsubDisabled = !this.unsubDisabled;
    }

    registerErrorListener() {
        onError((error) => {
            console.error({ ...error });
            showToast(this, 'Error!', 'Lightning web component listener failure (PlatformEventDemo).', 'error', 'pester');
        });
    }

    errorCallback(error, stack) {
        let message = (typeof(error) === 'object' ? JSON.stringify(error) : error);
        if (error.hasOwnProperty('body.message')) { message = error.body.message; }
        if (error.hasOwnProperty('message'     )) { message = error.message;      }
        try {
            const Logger = this.template.querySelector('c-logger');
            Logger.error(message).addTag('lwc').addTag('platformEventDemo');
            Logger.error(stack  ).addTag('lwc').addTag('platformEventDemo');
            Logger.saveLog();
        }
        catch(e) {
            console.warn('Nebula Logger:', e);
            console.error(message);
            console.error(stack);
        }
        showToast(this, 'Web Component Error!', message, 'error', 'sticky');
    }
}
