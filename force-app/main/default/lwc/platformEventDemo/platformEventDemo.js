import { LightningElement           } from 'lwc';
import { subscribe, unsubscribe     } from 'lightning/empApi';
import { onError                    } from 'lightning/empApi';
import { hash, parse                } from 'c/utils';
import { stringify, stringifyPretty } from 'c/utils';
import { logger, showToast          } from 'c/utils';

const PLATFORM_EVENT_CHANNELS = [
    { label: 'ABC News',                 value: '/event/ABCNews__e'               },
    { label: 'Al Jazeera',               value: '/event/AlJazeera__e'             },
    { label: 'Associated Press',         value: '/event/AssociatedPress__e'       },
    { label: 'BBC News',                 value: '/event/BBCNews__e'               },
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
    errors        = new Set();
    timer         = undefined;

    options = PLATFORM_EVENT_CHANNELS;

    connectedCallback() {
        this.registerErrorListener();
        this.inpDisabled = false;
    }

    sub() {
        this.subDisabled = true;
        this.inpDisabled = true;
        subscribe(this.channelName, -1, (response) => {
            console.info(parse(response));
            this.messages += (stringify(response.data.payload) + '\n');
        })
       .then((response) => {
            this.listener = true;
            this.timer = setTimeout(() => {
                if (this.listener) {
                    console.info(parse(response));
                    this.subscription = parse(response);
                    this.inpDisabled = false;
                    this.subDisabled = false;
                    this.toggle();
                    logger.info(stringify(response));
                    showToast(this, 'Success', `You have subscribed to the "${this.channelName}" event channel!`, 'success', 'pester');
                }
            }, 1250);
       })
       .catch((error) => {
            this.subDisabled = false;
            console.error(parse(error));
            logger.error(stringifyPretty(error), [ 'lwc', 'plaftformEventDemo', 'subscribe' ]);
            showToast(this, 'Subscribe Error!',  this.getMessage(error), 'error', 'sticky');
       });
    }

    uns() {
        this.toggle();
        this.subDisabled = true;
        unsubscribe(this.subscription, (response) => {
            console.info(parse(response));
        })
       .then(() => {
            this.messages = '';
            this.listener    = false;
            this.timer = window.setTimeout(() => { this.subDisabled = false; }, 3500);
            this.unsDisabled = true;
            showToast(this, 'Unsubscribed', `You have unsubscribed from the "${this.channelName}" event channel!`, 'warning');
        })
       .catch((error) => {
            console.error(parse(error));
            this.listener    = false;
            this.unsDisabled = false;
            logger.error(stringify(error), [ 'lwc', 'plaftformEventDemo', 'unsubscribe' ]);
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
        this.timer = this.unsDisabled = !this.unsDisabled;
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
        let message = (typeof(error) === 'object' ? stringify(error) : error.toString());
        if (error.hasOwnProperty('body.message')) { message = error.body.message; } else
        if (error.hasOwnProperty('message'     )) { message = error.message;      } else
        if (error.hasOwnProperty('error'       )) { message = error.error;        }
        return message;
    }

    registerErrorListener() {
        onError((error) => {
            if (!this.errors.has(hash(error))) {
                console.error(parse(error));
                this.errors.add(hash(error));
                this.subDisabled = true;
                this.listener = false;
                logger.error(stringifyPretty(error), [ 'lwc', 'plaftformEventDemo', 'registerErrorListener' ]);
                showToast(this, 'Error!', this.getMessage(error), 'error', 'pester');
                this.timer = window.setTimeout(() => { this.inpDisabled = false; }, 4500);
            }
        });
    }

    disconnectedCallback() {
        if (this.timer) {
            this.timer = null;
        }
    }
}
