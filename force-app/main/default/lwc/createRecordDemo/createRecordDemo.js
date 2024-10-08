import { LightningElement } from 'lwc';
import { ShowToastEvent   } from 'lightning/platformShowToastEvent';
import { createRecord     } from 'lightning/uiRecordApi';

import Contact from '@salesforce/schema/Contact';

export default class CreateRecordDemo extends LightningElement {
    formFields = {};

    changeHandler(event) {
        let { name, value } = event.target;
        this.formFields[name] = value;
    }

    reset() {
        let theForm = this.template.querySelector('form');
        theForm.reset();

        let inputs = this.template.querySelectorAll('lightning-input');
        inputs.forEach((input) => {
            input.value = null;
        });
    }

    createContact() {
        const recordInput = { apiName: Contact.objectApiName, fields: this.formFields };
        createRecord(recordInput)
       .then((result) => {
            this.showToast('Success', `Contact created with Id ${result.id}.`, 'success');
            this.template.querySelector('form.createForm').reset();
            this.formFields = {};
        })
       .catch((error) => {
            this.showToast('Error Creating record', error.body.message, 'error');
        });
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title: title , message: message, variant: (variant || 'info') }));
    }
}