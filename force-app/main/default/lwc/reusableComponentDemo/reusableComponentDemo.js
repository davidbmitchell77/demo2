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
 
    renderedCallback()
    {
        const today = new Date();
        this.weekday = this.weekdays.get(today.getDay());
        this.month = this.months.get(today.getMonth());
        this.day = today.getDate();
        this.year = today.getFullYear();
    }
}