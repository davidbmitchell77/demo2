import { LightningElement } from 'lwc';

export default class ReusableComponentDemo extends LightningElement
{
    weekday;
    month;
    day;
    year;
    
    weekdays = new Map
    ([
        [0, 'Sunday'    ],
        [1, 'Monday'    ],
        [2, 'Tuesday'   ],
        [3, 'Wednesday' ],
        [4, 'Thursday'  ],
        [5, 'Friday'    ],
        [6, 'Saturday'  ]
    ]);

    months = new Map
    ([
        [0, 'January'   ],
        [1, 'February'  ],
        [2, 'March'     ],
        [3, 'April'     ],
        [4, 'May'       ],
        [5, 'June'      ],
        [6, 'July'      ],
        [7, 'August'    ],
        [8, 'September' ],
        [9, 'October'   ],
        [10, 'November' ],
        [11, 'December' ]
    ]);
 
    connectedCallback()
    {
        this.weekdays.set(0, 'Sunday');
        this.weekdays.set(1, 'Monday');
        this.weekdays.set(2, 'Tuesday');
        this.weekdays.set(3, 'Wednesday');
        this.weekdays.set(4, 'Thursday');
        this.weekdays.set(5, 'Friday');
        this.weekdays.set(6, 'Saturday');

        this.months.set(0, 'January');
        this.months.set(1, 'February');
        this.months.set(2, 'March');
        this.months.set(3, 'April');
        this.months.set(4, 'May');
        this.months.set(5, 'June');
        this.months.set(6, 'July');
        this.months.set(7, 'August');
        this.months.set(8, 'September');
        this.months.set(9, 'October');
        this.months.set(10, 'November');
        this.months.set(11, 'December');
    }
 
    renderedCallback()
    {
        const today = new Date();
        this.year = today.getFullYear();
        this.month = this.months.get(today.getMonth());
        this.day = today.getDate();
        this.weekday = this.weekdays.get(today.getDay());
    }
}