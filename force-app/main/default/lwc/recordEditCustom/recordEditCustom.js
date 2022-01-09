import { LightningElement } from 'lwc';
import { ShowToastEvent   } from 'lightning/platformShowToastEvent';

import Account from '@salesforce/schema/Account';
import { getDataConnectorSourceFields } from 'lightning/analyticsWaveApi';

export default class RecordEditCustom extends LightningElement
{
    objectApiName = Account;
    inputValue = null;

    keyupHandler(event)
    {
        this.inputValue = event.target.value;
    }

    submitHandler(event)
    {
        event.preventDefault();

        let lightningInput = this.template.querySelector("lightning-input");

        if (!lightningInput.value.toLowerCase().includes("llc")) {
            lightningInput.setCustomValidity(`Account name must include "llc."`);
        }
        else
        {
            lightningInput.setCustomValidity("");
            let fields = event.detail.fields;
            fields.Name = this.inputValue;
            this.template.querySelector("lightning-record-edit-form").submit(fields);
        }

        lightningInput.reportValidity();
    }

    errorHandler(event)
    {
        let errorMsg = new ShowToastEvent
        ({
            title: "Error!",
            message: `Error creating account:  ${((event.message) ? event.message : "No internet.")}`,
            variant: "error"
        })

        this.dispatchEvent(errorMsg);
    }

    successHandler(event)
    {
        let successMsg = new ShowToastEvent
        ({
            title: "Account created.",
            message: `Record Id: ${event.detail.id}`,
            variant: "success"
        })

        this.dispatchEvent(successMsg);
        this.reset(this.template.querySelectorAll("lightning-input"));
    }

    reset(fields) {
        Array.from(fields).forEach(field => { field.value = null; });
    }
}