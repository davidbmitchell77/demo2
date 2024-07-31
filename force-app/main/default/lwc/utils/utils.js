import { ShowToastEvent } from 'lightning/platformShowToastEvent'  ;

import debug              from '@salesforce/apex/AuraLogger.debug' ;
import info               from '@salesforce/apex/AuraLogger.info'  ;
import error              from '@salesforce/apex/AuraLogger.error' ;
import fine               from '@salesforce/apex/AuraLogger.fine'  ;
import finer              from '@salesforce/apex/AuraLogger.finer' ;
import finest             from '@salesforce/apex/AuraLogger.finest';

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

const logger = {
    debug: (messages      ) => {  debug({ messages: messages }); },
     info: (messages      ) => {   info({ messages: messages }); },
    error: (messages, tags) => {  error({ messages: messages, tags: tags }); },
     fine: (messages      ) => {   fine({ messages: messages }); },
    finer: (messages      ) => {  finer({ messages: messages }); },
   finest: (messages      ) => { finest({ messages: messages }); }
}

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

export { exportCSVFile              };
export { logger                     };
export { guid, uuid                 };
export { hash, parse                };
export { stringify, stringifyPretty };
export { showToast                  };
