import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent              } from 'lightning/platformShowToastEvent';

import getContacts from '@salesforce/apex/ContactController.getContacts';

const COLUMNS = [
    { type: 'text',  label: 'First Name', fieldName: 'FirstName',   editable: false, sortable: true },
    { type: 'text',  label: 'Last Name',  fieldName: 'LastName',    editable: false, sortable: true },
    { type: 'url',   label: 'Title',      fieldName: 'ContactUrl',  editable: true,  sortable: true, typeAttributes: { label: { fieldName: 'Title' } }, target: '_blank' },
    { type: 'url',   label: 'Account',    fieldName: 'AccountUrl',  editable: false, sortable: true, typeAttributes: { label: { fieldName: 'AccountName'} }, target: '_blank' },
    { type: 'phone', label: 'Phone',      fieldName: 'Phone',       editable: true,  sortable: true },
    { type: 'email', label: 'Email',      fieldName: 'Email',       editable: true,  sortable: true },
];

export default class LightningDataTableParent extends LightningElement {

    @api recordId;
    @api accountName = '_';

    cols   = COLUMNS;
    data   = [];
    height = '20.5rem';
    mode   = 'fixed';

    @wire(getContacts, { accountName: "$accountName", lwcName: 'lightningDataTableParent' })
    handle(response) {
        let { data, error } = response;
        if (data) {
            console.info(data);
            let temp = data.map(
                (contact) => {
                    return {
                        ...contact,
                        ContactUrl:  (`${window.location.origin}/${contact.Id}`),
                        AccountName: (`${contact.Account.Name}`),
                        AccountUrl:  (`${window.location.origin}/${contact.Account.Id}`)
                    };
                }
            );
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