({
    getToday : function(component)
    {
        const months = new Map
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

        const days = new Map
        ([
            [0, "Sunday"    ],
            [1, "Monday"    ],
            [2, "Tuesday"   ],
            [3, "Wednesday" ],
            [4, "Thursday"  ],
            [5, "Friday"    ],
            [6, "Saturday"  ]
        ]);

        let today = new Date();
        let mm = months.get(today.getMonth());
        let day = days.get(today.getDay());
        let dd = today.getDate();
        let yyyy = today.getFullYear();

        component.set("v.status", `Today is ${day}, ${mm} ${dd}, ${yyyy}.`);
    }
})
