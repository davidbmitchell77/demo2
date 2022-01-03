import { LightningElement, wire } from "lwc";
import { APPLICATION_SCOPE, MessageContext, subscribe, unsubscribe } from "lightning/messageService";
import SAMPLEMC from "@salesforce/messageChannel/SampleMessageChannel__c";

export default class LmsComponentX extends LightningElement
{
    @wire(MessageContext)
    context;

    receivedMessage;
    subscription;
    today;
    isListening = false;

    months = new Map
    ([
        [0,  "January"   ],
        [1,  "February"  ],
        [2,  "March"     ],
        [3,  "April"     ],
        [4,  "May"       ],
        [5,  "June"      ],
        [6,  "July"      ],
        [7,  "August"    ],
        [8,  "September" ],
        [9,  "October"   ],
        [10, "November"  ],
        [11, "December"  ]
    ]);

    days = new Map
    ([
        [0, "Sunday"    ],
        [1, "Monday"    ],
        [2, "Tuesday"   ],
        [3, "Wednesday" ],
        [4, "Thursday"  ],
        [5, "Friday"    ],
        [6, "Saturday"  ]
    ]);

    connectedCallback() {
        this.subscribeMessage();
    }

    disconnectedCallback()
    {
        if (this.subscription) {
            unsubscribe(this.subscription);
        }
    }

    renderedCallback()
    {
        let today = new Date();
        let month = this.months.get(today.getMonth());
        let day = this.days.get(today.getDay());
        let date = today.getDate();
        let year = today.getFullYear();
        this.today = `Today is ${day}, ${month} ${date}, ${year}.`;
    }

    disconnectedCallback()
    {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    subscribeMessage()
    {
        this.subscripion = subscribe(this.context, SAMPLEMC, (message)=>{ this.handleMessage(message); }, { scope: APPLICATION_SCOPE });
        this.isListening = true;
    }

    handleMessage(message)
    {
        if (this.isListening) {
            this.receivedMessage = (message.lmsData.value ? message.lmsData.value : "No message published.");
        }
    }

    subscribeButtonHandler() {
        this.isListening = true;
    }

    unsubscribeButtonHandler() {
        this.isListening = false;
    }

    get isActive() {
        return (this.isListening);
    }

    get isNotActive() {
        return !(this.isListening);
    }
}