import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent              } from 'lightning/platformShowToastEvent';

import getContacts from '@salesforce/apex/ContactController.getContacts';

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
    @api accountName = 'Oil';

    cols   = COLUMNS;
    data   = [];
    height = '20.5rem';
    mode   = 'fixed';

    @wire(getContacts, { accountName: "$accountName", lwcName: 'lightningDataTableParent' })
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
             console.error(error);
             this.showToast('Error retrieving list of contacts!', error.body.message, 'error', 'sticky');
        }
    }

    handleClick(event) {
        let message = `You clicked the ${event.target.label} button!`;
        let variant = 'info';
        switch (event.target.label) {
            case 'Base':
                variant = 'info';
                break;
            case 'Neutral':
                variant = 'info';
                break;
            case 'Brand':
                variant = 'info';
                break;
            case 'Destructive':
                variant = 'error';
                break;
            case 'Destructive Text':
                variant = 'warning';
                break;
            case 'Success':
                variant = 'Success';
                break;
        }
        this.log(message);
        this.showToast('Button click detected!', message, variant);
    }

    handleInput(event) {
        this.accountName = event.target.value;
    }

    log(message) {
        const logger = this.template.querySelector('c-logger');
        if (logger) {
            logger.info(message);
            logger.saveLog();
        }
    }

    showToast(title, message, variant, mode) {
        this.dispatchEvent(new ShowToastEvent({ title: title, message: message, variant: variant, mode: (mode || 'dismissible')}));
    }
}