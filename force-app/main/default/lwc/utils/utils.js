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
    const lineDelimiter = '\r\n';
    const actualHeaderKey = Object.keys(headers);
    const headerToShow = Object.values(headers);
    let str = '';
    str += headerToShow.join(columnDelimiter);
    str += lineDelimiter;
    const data = ((typeof(objArray) !== 'object') ? JSON.parse(objArray) : objArray);
    data.forEach(
        (obj) => {
            let line = '';
            actualHeaderKey.forEach(
                (key) => {
                    if (line != '') {
                        line += columnDelimiter;
                    }
                    let strItem = (obj[key] ? (obj[key] + '') : '');
                    line += ((strItem) ? strItem.replace(/,/g, '') : strItem);
                }
            )
            str += (line + lineDelimiter);
        }
    )
    return str;
}

const guid = () => {
    return crypto.randomUUID().toUpperCase();
}

const uuid = () => {
    return crypto.randomUUID().toLowerCase();
}

const parse = (obj) => {
    return (JSON.parse(JSON.stringifiy(obj)));
}

const stringify = (obj) => {
    return JSON.stringify(obj);
}

const stringifyPretty = (obj) => {
    return JSON.stringify(obj, null, 4);
}

const showToast = (lwc, title, message, variant, mode) => {
    lwc.dispatchEvent(new ShowToastEvent({ title: title, message: message, variant: variant, mode: (mode || 'dismissible')}));
}

const logger = {
    debug: (message) => {  debug(message); },
     info: (message) => {   info(message); },
    error: (message) => {  error(message); },
     fine: (message) => {   fine(message); },
    finer: (message) => {  finer(message); },
   finest: (message) => { finest(message); }
}

export { exportCSVFile              };
export { logger                     };
export { guid, uuid                 };
export { parse                      };
export { stringify, stringifyPretty };
export { showToast                  };
