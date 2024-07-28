import { LightningElement       } from 'lwc';
import { subscribe, unsubscribe } from 'lightning/empApi';
import { onError                } from 'lightning/empApi';
import { showToast              } from 'c/utils';

import AuraError from '@salesforce/apex/AuraLogger.error';
import AuraInfo  from '@salesforce/apex/AuraLogger.info' ;

const PLATFORM_EVENT_CHANNELS = [
    { label: 'ABC News',                 value: '/event/ABC__e'                   },
    { label: 'Al Jazeera',               value: '/event/AlJazeera__e'             },
    { label: 'Associated Press',         value: '/event/AssociatedPress__e'       },
    { label: 'Breitbart',                value: '/event/Breitbart__e'             },
    { label: 'CBS News',                 value: '/event/CBSNews__e'               },
    { label: 'CNN',                      value: '/event/CNN__e'                   },
    { label: 'Fox News',                 value: '/event/FoxNews__e'               },
    { label: 'Huffington Post',          value: '/event/HuffingtonPost__e'        },
    { label: 'Lightning Web Components', value: '/event/LightningWebComponent__e' },
    { label: 'MSNBC',                    value: '/event/MSNBC__e'                 },
    { label: 'NBC News',                 value: '/event/NBCNews__e'               },
    { label: 'Reuters',                  value: '/event/Reuters__e'               },
    { label: 'Sky News',                 value: '/event/SkyNews__e'               }
];

export default class PlatformEventDemo extends LightningElement {

    channelName   = undefined;
    showMessages  = false;
    inpDisabled   = true;
    subDisabled   = true;
    unsDisabled   = true;
    listener      = false;
    subscription  = {};
    messages      = '';

    options = PLATFORM_EVENT_CHANNELS;

    connectedCallback() {
        this.registerErrorListener();
        this.inpDisabled = false;
    }

    sub() {
        subscribe(this.channelName, -1, (response) => {
            console.info(JSON.parse(JSON.stringify(response)));
            this.messages += (JSON.stringify(response.data.payload) + '\n');
        })
       .then((response) => {
            console.info({ ...response });
            this.subscription = { ...response };
            this.toggle();
            this.listener = true;
            AuraInfo({ msg: JSON.stringify(response) });
            setTimeout(() => {
                if (this.listener) {
                    showToast(this, 'Success', `You have subscribed to the "${this.channelName}" platform event!`, 'success');
                }
            }, 1000);
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
            this.toggle();
            this.listener = false;
            showToast(this, 'Unsubscribed', `You have unsubscribed from the "${this.channelName}" platform event!`, 'warning');
        })
       .catch((error) => {
            console.error({ ...error });
            this.listener = false;
            AuraError({ msg: JSON.stringify(error), tags: [ 'lwc', 'plaftformEventDemo', 'unsubscribe' ] });
            showToast(this, 'Unsubscribe Error!', this.getMessage(error), 'error', 'sticky');
        });
    }

    handleChange(event) {
        switch (event.target.label) {
            case 'Channel':
                this.channelName = event.target.value;
                this.subDisabled = false;
                break;
        }
    }

    toggle() {
         this.toggleButtons();
         this.toggleInput();
         this.toggleMessages();
    }

    toggleButtons() {
        this.subDisabled = !this.subDisabled;
        this.unsDisabled = !this.unsDisabled;
    }

    toggleInput() {
        this.inpDisabled = !this.inpDisabled;
    }

    toggleMessages() {
        this.showMessages = !this.showMessages;
    }

    validateInput(event) {
        this.subDisabled  = ((event.target.value.length === 0) ? true : !this.unsDisabled);
        this.showMessages = ((event.target.value.length === 0) ? false : this.showMessages);
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
            this.listener = false;
            AuraError({ msg: JSON.stringify(error), tags: [ 'lwc', 'plaftformEventDemo', 'registerErrorListener' ] });
            showToast(this, 'Error!', this.getMessage(error), 'error', 'sticky');
        });
    }
}
