import { LightningElement, wire } from "lwc";
import { APPLICATION_SCOPE, MessageContext, subscribe } from "lightning/messageService";
import SAMPLEMC from "@salesforce/messageChannel/SampleMessageChannel__c";

export default class LmsComponentX extends LightningElement
{
    @wire(MessageContext)
    context;

    receivedMessage;
    today;

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

    renderedCallback()
    {
        let today = new Date();
        let month = this.months.get(today.getMonth());
        let day = this.days.get(today.getDay());
        let date = today.getDate();
        let year = today.getFullYear();
        this.today = `Today is ${day}, ${month} ${date}, ${year}.`;
    }

    subscribeMessage() {
        subscribe(this.context, SAMPLEMC, (message)=>{ this.handleMessage(message); }, { scope: APPLICATION_SCOPE });
    }

    handleMessage(message) {
        this.receivedMessage = (message.lmsData.value ? message.lmsData.value : "No message published.");
    }
}