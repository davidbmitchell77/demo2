import { LightningElement       } from 'lwc';
import { subscribe, unsubscribe } from 'lightning/empApi';
import { onError                } from 'lightning/empApi';
import { showToast              } from 'c/utils';

export default class PlatformEventDemo extends LightningElement {

    channelName   = '/event/LightningWebComponent__e';
    subDisabled   = true;
    unsubDisabled = true;
    subscription  = {};

    handleChange(event) {
        if (event.target.label == 'Channel Name') {
            this.channelName = event.target.values;
        }
    }

    connectedCallback() {
        this.registerErrorListener();
        this.subDisabled = false;
    }

    sub() {
        subscribe(this.channelName, -1, null)
       .then((response) => {
            console.info({ ...response });
            this.subscription = { ...response };
            this.toggle();
            showToast(this, 'Success', `You have subscribed to the "${this.channelName}" platform event!`, 'success');
        })
       .catch((error) => {
            console.error({ ...error });
            showToast(this, 'Error!', `Error subscribing to "${this.channelName}" platform event!`, 'error', 'sticky');
       });
    }

    unsub() {
        unsubscribe(this.subscription, (response) => { console.info({ ...response }); })
       .then(() => {
            this.toggle();
            showToast(this, 'Unsubscribed', `You have unsubscribed from the "${this.channelName}" platform event!`, 'warning');
        })
       .catch((error) => {
            console.error({ ...error });
            showToast(this, 'Error!', `Error unsubscribing from "${this.channelName}" platform event!`, 'error', 'sticky');
        });
    }

    toggle() {
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
        console.error(error);
        console.error(stack);
        showToast(this, 'Error!', 'Lightning web component error (PlatformEventDemo).', 'error', 'sticky');
    }
}
