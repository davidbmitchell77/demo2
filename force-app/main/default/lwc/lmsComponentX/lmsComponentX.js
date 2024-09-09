import { LightningElement, wire            } from 'lwc';
import { APPLICATION_SCOPE, MessageContext } from 'lightning/messageService';
import { subscribe, unsubscribe            } from 'lightning/messageService';

import SAMPLEMC from '@salesforce/messageChannel/SampleMessageChannel__c';

export default class LmsComponentX extends LightningElement
{
    @wire(MessageContext)
    context;

    receivedMessage;
    subscription;
    today;
    isListening;

    months = new Map([
        [ 0,  'January'   ],
        [ 1,  'February'  ],
        [ 2,  'March'     ],
        [ 3,  'April'     ],
        [ 4,  'May'       ],
        [ 5,  'June'      ],
        [ 6,  'July'      ],
        [ 7,  'August'    ],
        [ 8,  'September' ],
        [ 9,  'October'   ],
        [ 10, 'November'  ],
        [ 11, 'December'  ]
    ]);

    days = new Map([
        [ 0, 'Sunday'    ],
        [ 1, 'Monday'    ],
        [ 2, 'Tuesday'   ],
        [ 3, 'Wednesday' ],
        [ 4, 'Thursday'  ],
        [ 5, 'Friday'    ],
        [ 6, 'Saturday'  ]
    ]);

    connectedCallback() {
        this.subscribeMessage();
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

    subscribeMessage() {
        this.subscripion = subscribe(this.context, SAMPLEMC, (message)=>{ this.handleMessage(message); }, { scope: APPLICATION_SCOPE });
        this.isListening = true;
    }

    unSubscribeMessage() {
        this.isListening = true;
    }

    handleMessage(message) {
        if (this.isListening) {
            let today = new Date();
            let mm = this.months.get(today.getMonth());
            let day = this.days.get(today.getDay());
            let dd = today.getDate();
            let yyyy = today.getFullYear();
            let hr = this.right('0' + today.getHours(), 2);
            let mi = this.right('0' + today.getMinutes(), 2);
            let ss = this.right('0' + today.getSeconds(), 2);
            let offset = this.right('0' + (today.getTimezoneOffset() / -60), 2);

            this.receivedMessage = (message.lmsData.value ? message.lmsData.value : 'Message is empty.');
            this.status = `Message received on ${day}, ${mm} ${dd}, ${yyyy} at ${hr}:${mi}:${ss} (UTC ${offset}:00).`;
        }
    }

    subscribeButtonHandler() {
        this.unSubscribeMessage();
    }

    unsubscribeButtonHandler() {
        this.receivedMessage = ' ';
        this.isListening = false;

        let today = new Date();
        let month = this.months.get(today.getMonth());
        let day = this.days.get(today.getDay());
        let date = today.getDate();
        let year = today.getFullYear();
        this.status = `Today is ${day}, ${month} ${date}, ${year}.`;
    }

    right(s, chars) {
        return s.substr((s.length - chars), chars);
    }

    get isActive() {
        return (this.isListening);
    }

    get isNotActive() {
        return !(this.isListening);
    }
}