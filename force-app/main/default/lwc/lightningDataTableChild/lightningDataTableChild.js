import { LightningElement, api } from 'lwc';
import { updateRecord          } from 'lightning/uiRecordApi';
import { ShowToastEvent        } from 'lightning/platformShowToastEvent';
import { updateDataConnector } from 'lightning/analyticsWaveApi';

export default class LightningDataTableChild extends LightningElement {

    @api cols;
    @api records;

    draftValues   = [];
    sortBy        = undefined;
    sortDirection = undefined;

    doSave(event) {
        let data = event.detail.draftValues.map((draftValue) => {
            let fields = { ...draftValue };
            return { fields: fields };
        });
        let promises = data.map((record) => {
            let promise = updateRecord(record);
            return promise;
        });
        Promise.all(promises)
       .then(() => {
            this.draftValues = [];
        })
       .catch((error) => {
            console.error(error);
            this.showToast('Error updating or reloading data!', error.body.message, 'error', 'sticky');
        });
    }

    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.records));
        let keyValue = (a)=>{ return a[fieldname]; };
        let isReverse = ((direction === 'asc') ? 1 : -1);
        parseData.sort((a,b) => {
            a = (keyValue(a) ? keyValue(a) : '');
            b = (keyValue(b) ? keyValue(b) : '');
            return (isReverse * ((a > b) - (b > a)));
        });
        this.records = parseData;
    }

    showToast(title, message, variant, mode) {
        this.dispatchEvent(new ShowToastEvent({ title: title, message: message, variant: variant, mode: mode || 'pester' }));
    }
}