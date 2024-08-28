import { LightningElement, api, wire } from 'lwc';
import { getRecord                   } from 'lightning/uiRecordApi';
import { ShowToastEvent              } from 'lightning/platformShowToastEvent';

import getContacts    from '@salesforce/apex/AccountController.getContacts';

import ID             from '@salesforce/schema/Account.Id';
import NAME           from '@salesforce/schema/Account.Name';
import CITY           from '@salesforce/schema/Account.BillingCity';
import STATE          from '@salesforce/schema/Account.BillingState';
import COUNTRY        from '@salesforce/schema/Account.BillingCountry';
import PHONE          from '@salesforce/schema/Account.Phone';
import WEBSITE        from '@salesforce/schema/Account.Website';
import ANNUAL_REVENUE from '@salesforce/schema/Account.AnnualRevenue';
import DUNS_NUMBER    from '@salesforce/schema/Account.DunsNumber';

const FIELDS = [
    ID,
    NAME,
    CITY,
    STATE,
    COUNTRY,
    PHONE,
    WEBSITE
];

const OPTIONAL_FIELDS = [
    ANNUAL_REVENUE,
    DUNS_NUMBER
];

export default class MyLwc extends LightningElement {
    @api recordId;
    @api objectApiName;

    account;
    contacts;

    @wire(getRecord, { recordId: "$recordId", fields: FIELDS, optionalFields: OPTIONAL_FIELDS })
    handle({ data, error }) {
        if (data) {
            console.clear();
            console.info(data.fields);
            this.account = data.fields;
            this.contacts = this.relatedContacts(this.recordId);
        }
        if (error) {
            console.error(error);
            this.account = {};
            this.showToast('Error!', error.body.message, 'error', 'sticky');
        }
    }

    async relatedContacts(accountId) {
        try {
            const response = await getContacts({ accountId: accountId });
            console.info(response);
            return response;
        }
        catch(error) {
            console.error;
            this.contacts = [];
            this.showToast('Error!', error.body.message, 'error', 'sticky');
        }
    }

    showToast(title, message, variant, mode) {
        this.dispatchEvent(new ShowToastEvent({ title: title, message: message, variant: variant, mode: (mode || 'dismissible') }));
    }
}