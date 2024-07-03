import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent              } from 'lightning/platformShowToastEvent';

import getContactList from '@salesforce/apex/ContactController.getContactList';

const COLUMNS = [
    { type: "text",  label: "First Name", fieldName: "FirstName",   editable: false, sortable: true },
    { type: "text",  label: "Last Name",  fieldName: "LastName",    editable: false, sortable: true },
    { type: "text",  label: "Account",    fieldName: "AccountName", editable: false, sortable: true },
    { type: "text",  label: "Title",      fieldName: "Title",       editable: true,  sortable: true },
    { type: "phone", label: "Phone",      fieldName: "Phone",       editable: true,  sortable: true },
    { type: "email", label: "Email",      fieldName: "Email",       editable: true,  sortable: true },
];

export default class LightningDataTableParent extends LightningElement {

    @api recordId;

    cols   = COLUMNS;
    data   = [];
    height = '20.5rem';
    mode   = 'fixed';

    @wire(getContactList, { accountId: "33" })
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
        else if (error) {
            this.nebulaLogger(error);
            this.showToast('Error retrieving list of contacts!', error.body.message, 'error', 'sticky');
        }
    }

    nebulaLogger(error) {
        const logger = this.template.querySelector('c-logger');
        if (logger) {
            logger.error(error).addTag('lightningDataTableParent.js');
            logger.saveLog();
        }
    }

    showToast(title, message, variant, mode) {
        this.dispatchEvent(new ShowToastEvent({ title: title, message: message, variant: variant, mode: mode }));
    }
}