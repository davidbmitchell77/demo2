import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent              } from 'lightning/platformShowToastEvent';

import getContactList from '@salesforce/apex/ContactController.getContactList';

const COLUMNS = [
    { type: "text",  label: "First Name", fieldName: "FirstName",   editable: false },
    { type: "text",  label: "Last Name",  fieldName: "FirstName",   editable: false },
    { type: "text",  label: "Account",    fieldName: "AccountName", editable: false },
    { type: "text",  label: "Title",      fieldName: "Title",       editable: false },
    { type: "phone", label: "Phone",      fieldName: "Phone",       editable: true  },
    { type: "email", label: "Email",      fieldName: "Email",       editable: true  }
];

export default class LightningDataTableParent extends LightningElement {

    @api recordId;

    cols  = COLUMNS;
    data  = [];

    @wire(getContactList, { accountId: "$recordId" })
    handle(response) {
        let { data, error } = response;
        if (data) {
            console.info(data);
            let temp = [];
            for (let i=0; i<data.length; i++) {
                temp.push({ ...data[i], AccountName: data[i].Account.Name });
            }
            this.data = [ ...temp ];
        }
        else {
            console.error(error);
            this.showToast('Error retrieving list of contacts!', 'Your browser encountered an error retrieving the requested records.  Please contact your system administator.', 'error', 'sticky');
        }
    }

    showToast(title, message, variant, mode) {
        this.dispatchEvent(new ShowToastEvent({ title: title, message: message, variant: variant, mode: mode }));
    }
}