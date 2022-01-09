import { LightningElement, api } from 'lwc';
import { ShowToastEvent        } from 'lightning/platformShowToastEvent'

import Account from '@salesforce/schema/Account';

export default class RecordEditCustom extends LightningElement
{
    @api objectApiName = Account;
    inputValue = null;

    keyupHandler(event)
    {
        this.inputValue = event.target.value;
    }

    submitHandler(event)
    {
        event.prevetDefault();

        let lightningInput = this.template.querySelector("lightning-input");
        if (lightningInput)
        {
            if (!lightningInput.value.toLowerCase().contains("LLC")) {
                lightningInput.setCustomValidity(`Account name must include "LLC."`);
            }
        }
        else
        {
            lightningInput.setCustomValidity(`Account name must include "LLC."`);
            let fields = event.detail.fields;
            fields.Name = this.inputValue;
            this.template.querySelector("lightning-record-edit-form").submit(fields);
        }
        lightningInput.reportValidity();
    }

    successHandler(event)
    {
        successMsg = new ShowToastEvent
        ({
            title: "Account created.",
            message: `Record Id: ${event.target.id}`,
            variant: "success"
        })
        this.dispatchEvent(successMsg);
    }
}