import { LightningElement, api } from 'lwc';
import { updateRecord          } from 'lightning/uiRecordApi';
import { ShowToastEvent        } from 'lightning/platformShowToastEvent';

export default class LightningDataTableChild extends LightningElement {

    @api cols;
    @api height;
    @api mode;
    @api records;

    draftValues   = [];
    sortBy        = undefined;
    sortDirection = undefined;

    renderedCallback() {
        if (this.height) {
            this.template.querySelector('.datatable').style.setProperty('height', this.height);
        }
    }

    doSave(event) {
        let updates = event.detail.draftValues.slice().map((draftValue) => {
            let fields = { ...draftValue };
            return { fields: fields };
        });
        let promises = updates.map((record) => {
            let promise = updateRecord(record);
            return promise;
        });
        Promise.all(promises)
       .then(() => {
            this.records = this.syncDataTable(JSON.parse(JSON.stringify(this.records)), updates);
            this.draftValues = [];
            this.showToast('Success!', 'Record(s) successfully updated!', 'success');
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
        let sortfield = '';
        switch (fieldname) {
            case 'ContactUrl':
                sortfield = 'Title'
                break;
            case 'AccountUrl':
                sortfield = 'AccountName'
                break;
            default:
                sortfield = fieldname;
        }
        let parseData = [ ...this.records ];
        let keyValue  = ((a)=>{ return a[sortfield]; });
        let isReverse = ((direction === 'asc') ? 1 : -1);
        parseData.sort((a,b) => {
            a = (keyValue(a) ? keyValue(a) : '');
            b = (keyValue(b) ? keyValue(b) : '');
            return (isReverse * ((a > b) - (b > a)));
        });
        this.records = [ ...parseData ];
    }

    syncDataTable(records, updates) {
        let results = [];
        let theMap  = new Map();
        for (let i=0; i<updates.length; i++) {
            theMap.set(updates[i].fields.Id, updates[i].fields);
        }
        for (let j=0; j<records.length; j++) {
            let rec = { ...records[j] };
            if (theMap.has(rec.Id)) {
                let changes = theMap.get(rec.Id);
                rec = { ...rec, ...changes };
            }
            results.push(rec);
        }
        return results;
    }

    showToast(title, message, variant, mode) {
        this.dispatchEvent(new ShowToastEvent({ title: title, message: message, variant: variant, mode: (mode || 'dismissible') }));
    }
}