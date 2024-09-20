import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import debug  from '@salesforce/apex/AuraLogger.debug' ;
import info   from '@salesforce/apex/AuraLogger.info'  ;
import error  from '@salesforce/apex/AuraLogger.error' ;
import fine   from '@salesforce/apex/AuraLogger.fine'  ;
import finer  from '@salesforce/apex/AuraLogger.finer' ;
import finest from '@salesforce/apex/AuraLogger.finest';

const currentDate = () => {
    let today = new Date();
    let mm = months.get(today.getMonth());
    let day = days.get(today.getDay());
    let dd = today.getDate();
    let yyyy = today.getFullYear();
    return (`${day}, ${mm} ${dd}, ${yyyy}`);
}

const currentTime = () => {
    let today = new Date();
    let hr = right('0' + today.getHours(), 2);
    let mi = right('0' + today.getMinutes(), 2);
    let ss = right('0' + today.getSeconds(), 2);
    let ms = right('00' + today.getMilliseconds(), 3);
    let offset = right('0' + (today.getTimezoneOffset() / -60), 2);
    return (`${hr}:${mi}:${ss}.${ms} (UTC ${offset}:00)`);
}

const exportCSVFile = (headers, totalData, fileTitle) => {
    if (!totalData || !totalData.length) {
        return null;
    }

    const jsonObject = JSON.stringify(totalData);
    const result = convertToCSV(jsonObject, headers);

    if (!result) {
        return null;
    }

    const blob = new Blob([ result ]);
    const exportedFileName = (fileTitle ? (fileTitle + '.csv') : 'export.csv');

    if (navigator.msSaveBlob) {
        navigator.msSaveBlob(blob, exportedFileName);  // IE
    }
    else if (navigator.userAgent.match(/iPhone|iPad|iPod/i)) {
        const link = window.document.createElement('a');
        link.href = 'data:text/csv;charset=utf-8,' + encodeURI(result);
        link.target = '_blank';
        link.download = exportedFileName;
        link.click();
    }
    else {
        const link = window.document.createElement('a');
        if (link.download !== undefined) {
            const url = URL.createObjectURL(blob);
            link.setAttribute('href', url);
            link.setAttribute('download', exportedFileName);
            link.style.visibility = 'hidden';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }
    }
}

const convertToCSV = (objArray, headers) => {
    const columnDelimiter = ',';
    const lineDelimiter   = '\r\n';
    const actualHeaderKey = Object.keys(headers);
    const headerToShow    = Object.values(headers);
    let str = '';
    str += headerToShow.join(columnDelimiter);
    str += lineDelimiter;
    const data = ((typeof(objArray) !== 'object') ? JSON.parse(objArray) : objArray);
    data.forEach((obj) => {
        let line = '';
        actualHeaderKey.forEach((key) => {
            if (line != '') {
                line += columnDelimiter;
            }
            let strItem = (obj[key] ? (obj[key] + '') : '');
            line += ((strItem) ? strItem.replace(/,/g, '') : strItem);
        });
        str += (line + lineDelimiter);
    });
    return str;
}

const days = new Map([
    [ 0, 'Sunday'    ],
    [ 1, 'Monday'    ],
    [ 2, 'Tuesday'   ],
    [ 3, 'Wednesday' ],
    [ 4, 'Thursday'  ],
    [ 5, 'Friday'    ],
    [ 6, 'Saturday'  ]
]);

const deepCopy = (obj) => {
    return JSON.parse(JSON.stringify(obj));
}

const guid = () => {
    return crypto.randomUUID().toUpperCase();
}

const hash = (obj) => {
    return (
        JSON.stringify(obj).split('').reduce((hash, char) => {
            return (char.charCodeAt(0) + (hash << 6) + (hash << 16) - hash);
        }, 0)
    );
}

const httpStatusText = {
    200: 'OK',
    201: 'Created',
    202: 'Accepted',
    203: 'Non-Authoritative Information',
    204: 'No Content',
    205: 'Reset Content',
    206: 'Partial Content',
    207: 'Multi-Status',
    208: 'Already Reported',
    218: 'This is fine (Apache Web Server)',
    226: 'IM Used',
    302: 'Found',
    303: 'See Other',
    304: 'Not Modified',
    307: 'Temporary Redirect',
    308: 'Resume Incomplete',
    400: 'Bad Request',
    401: 'Unauthorized',
    402: 'Payment Required',
    403: 'Forbidden',
    404: 'Not Found',
    405: 'Method Not Allowed',
    406: 'Not Acceptable',
    407: 'Proxy Authentication Required',
    408: 'Request Timeout',
    409: 'Conflict',
    410: 'Gone',
    411: 'Length Required',
    412: 'Precondition Failed',
    413: 'Payload Too Large',
    414: 'Request URI Too Long',
    415: 'Unsupported Media Type',
    416: 'Requested Range Not Satisfiable',
    417: 'Expectation Failed',
    418: 'I\'m a Teapot',
    419: 'Page Expired (Laravel Framework)',
    420: 'Method Failure (Spring Framework)',
    421: 'Misdirected Request',
    422: 'Unprocessable Entity',
    423: 'Locked',
    424: 'Failed Dependency',
    426: 'Upgrade Required',
    428: 'Precondition Required',
    429: 'Too Many Requests',
    431: 'Request Header Fields Too Large',
    440: 'Login Timeout',
    444: 'Connection Closed Without Response',
    449: 'Retry With',
    450: 'Blocked by Windows Parental Controls',
    451: 'Unavailable For Legal Reasons',
    494: 'Request Header Too Large',
    495: 'SSL Certificate Error',
    496: 'SSL Certificate Required',
    497: 'HTTP Request Sent to HTTPS Port',
    498: 'Invalid Token',
    499: 'Client Closed Request',
    500: 'Internal Server Error',
    501: 'Not Implemented',
    502: 'Bad Gateway',
    506: 'Variant Also Negotiates',
    503: 'Service Unavailable',
    504: 'Gateway Timeout',
    505: 'HTTP Version Not Supported',
    507: 'Insufficient Storage',
    508: 'Loop Detected',
    509: 'Bandwidth Limit Exceeded',
    510: 'Not Extended',
    511: 'Network Authentication Required',
    520: 'Unkown Error',
    521: 'Web Server Is Down',
    522: 'Connection Timed Out',
    523: 'Origin Is Unreachable',
    524: 'A Timeout Occurred',
    525: 'SSL Handshake Failed',
    526: 'Invalid SSL Certificate',
    527: 'Railgun Listener to Origin Error',
    530: 'Origin DNS Error',
    598: 'Network Read Timeout Error'
};

const log = {
    debug: (messages      ) => {  debug({ messages: messages }); },
     info: (messages      ) => {   info({ messages: messages }); },
    error: (messages, tags) => {  error({ messages: messages, tags: tags }); },
     fine: (messages      ) => {   fine({ messages: messages }); },
    finer: (messages      ) => {  finer({ messages: messages }); },
   finest: (messages      ) => { finest({ messages: messages }); }
}

const months = new Map([
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

const parse = (obj) => {
    return (JSON.parse(JSON.stringify(obj)));
}

const showToast = (lwc, title, message, variant, mode) => {
    lwc.dispatchEvent(new ShowToastEvent({ title: title, message: message, variant: variant, mode: (mode || 'dismissible')}));
}

const stringify = (obj) => {
    return JSON.stringify(obj);
}

const stringifyPretty = (obj) => {
    return JSON.stringify(obj, null, 4);
}

const uuid = () => {
    return crypto.randomUUID().toLowerCase();
}

const left = (s, chars) => {
    return s.substr(0, chars);
}

const mid = (s, start, chars) => {
    return s.substr(start, chars);
}

const right = (s, chars) => {
    return s.substr((s.length - chars), chars);
}

export {
    currentDate, currentTime,
    deepCopy,
    exportCSVFile,
    guid, uuid,
    hash, httpStatusText, parse,
    left, mid, right,
    days, months,
    log,
    showToast,
    stringify, stringifyPretty
};