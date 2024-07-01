import { LightningElement, api } from 'lwc';
import { updateRecord          } from 'lightning/uiRecordApi';
import { ShowToastEvent        } from 'lightning/platformShowToastEvent';


export default class LightningDataTableChild extends LightningElement {

    @api cols;
    @api records;

    draftValues   = [];
    sortBy        = undefined;
    sortDirection = undefined;

    async doSave(event) {
        this.draftValues = [ ...event.detail.draftValues ];
        let data = event.detail.draftValues.slice().map((arrayElement) => {
            let fields = Object.assign({}, arrayElement);
            return { fields };
        });
        this.draftValues = [];

        try {
            const recordUpdatePromises = data.map((record) => updateRecord(record));
            await Promise.all(recordUpdatePromises);
            this.dispatchEvent(new CustomEvent('refresh', { detail: { message: 'Save button clicked.'} }));
        }
        catch(error) {
          this.showToast('Error updating or reloading data!', error.body.message, 'error', 'sticky');
        }
    }

    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.records));
        let keyValue = (a) => {
            return a[fieldname];
        };
        let isReverse = ((direction === 'asc') ? 1 : -1);
        parseData.sort((a, b) => {
            a = (keyValue(a) ? keyValue(a) : '');
            b = (keyValue(b) ? keyValue(b) : '');
            return (isReverse * ((a > b) - (b > a)));
        });
        this.records = parseData;
    }

    showToast(title, message, variant, mode) {
        this.dispatchEvent(new ShowToastEvent({ title: title, message: message, variant: variant, mode: mode }));
    }
}