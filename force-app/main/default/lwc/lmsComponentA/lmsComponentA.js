import { LightningElement, wire  } from 'lwc';
import { MessageContext, publish } from 'lightning/messageService';
import { left, mid, right        } from 'c/utils';

import SAMPLEMC from '@salesforce/messageChannel/SampleMessageChannel__c';

export default class LmsComponentA extends LightningElement {

    @wire(MessageContext)
    context;

    inputValue;
    noInput = true;
    status;

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
        let today = new Date();
        let mm = this.months.get(today.getMonth());
        let day = this.days.get(today.getDay());
        let dd = today.getDate();
        let yyyy = today.getFullYear();
        this.status = `Today is ${day}, ${mm} ${dd}, ${yyyy}.`;
    }

    inputHandler(event){
        this.inputValue = event.target.value.trim();
        this.noInput = ((this.inputValue > '') ? false : true);

        let today = new Date();
        let mm = this.months.get(today.getMonth());
        let day = this.days.get(today.getDay());
        let dd = today.getDate();
        let yyyy = today.getFullYear();
        this.status = `Today is ${day}, ${mm} ${dd}, ${yyyy}.`;
    }

    publishMessage() {
        const message = {
            lmsData: {
                value: this.inputValue
            }
        }

        publish(this.context, SAMPLEMC, message);

        let today = new Date();
        let mm = this.months.get(today.getMonth());
        let day = this.days.get(today.getDay());
        let dd = today.getDate();
        let yyyy = today.getFullYear();
        let hr = right('0' + today.getHours(), 2);
        let mi = right('0' + today.getMinutes(), 2);
        let ss = right('0' + today.getSeconds(), 2);
        let offset = right('0' + (today.getTimezoneOffset() / -60), 2);

        this.template.querySelector('lightning-input').value = null;
        this.noInput = true;
        this.status = `Message published on ${day}, ${mm} ${dd}, ${yyyy} at ${hr}:${mi}:${ss} (UTC ${offset}:00).`;
    }
}