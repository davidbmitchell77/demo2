import { LightningElement, api, wire         } from 'lwc';
import { getRecord                           } from 'lightning/uiRecordApi';
import { getFieldValue, getFieldDisplayValue } from 'lightning/uiRecordApi';
import { deepCopy, showToast                 } from 'c/utils';

import getContacts    from '@salesforce/apex/AccountController.getContacts';

import ID             from '@salesforce/schema/Account.Id';
import NAME           from '@salesforce/schema/Account.Name';
import STREET         from '@salesforce/schema/Account.BillingStreet';
import CITY           from '@salesforce/schema/Account.BillingCity';
import STATE          from '@salesforce/schema/Account.BillingState';
import COUNTRY        from '@salesforce/schema/Account.BillingCountry';
import POSTAL_CODE    from '@salesforce/schema/Account.BillingPostalCode';
import PHONE          from '@salesforce/schema/Account.Phone';
import WEBSITE        from '@salesforce/schema/Account.Website';
import ANNUAL_REVENUE from '@salesforce/schema/Account.AnnualRevenue';
import DUNS_NUMBER    from '@salesforce/schema/Account.DunsNumber';

const FIELDS = [
    ID,
    NAME,
    STREET,
    CITY,
    STATE,
    COUNTRY,
    POSTAL_CODE,
    PHONE,
    WEBSITE
];

const OPTIONAL_FIELDS = [
    ANNUAL_REVENUE,
    DUNS_NUMBER
];

const COLUMNS = [
    { type: 'text',  label: 'Name',  fieldName: 'Name',  editable: false, sortable: true },
    { type: 'phone', label: 'Phone', fieldName: 'Phone', editable: true,  sortable: true },
    { type: 'email', label: 'Email', fieldName: 'Email', editable: true,  sortable: true },
];

export default class MyLwc extends LightningElement {
    @api recordId;
    @api objectApiName;

    account  = {};
    contacts = [];
    cols     = [ ...COLUMNS ];

    @wire(getRecord, { recordId: "$recordId", fields: FIELDS, optionalFields: OPTIONAL_FIELDS })
    handle({ data, error }) {
        if (data) {
            console.clear();
            console.info(data);
            this.account = deepCopy(data);
            this.relatedContacts(data.id).then((response) => {
                this.contacts = [ ...response ];
            });
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
            showToast(this, 'Error!', error.body.message, 'error', 'sticky');
        }
    }

    get name()          { return getFieldDisplayValue(this.account, NAME           ) ?? getFieldValue(this.account, NAME           ); }
    get street()        { return getFieldDisplayValue(this.account, STREET         ) ?? getFieldValue(this.account, STREET         ); }
    get city()          { return getFieldDisplayValue(this.account, CITY           ) ?? getFieldValue(this.account, CITY           ); }
    get state()         { return getFieldDisplayValue(this.account, STATE          ) ?? getFieldValue(this.account, STATE          ); }
    get postalCode()    { return getFieldDisplayValue(this.account, POSTAL_CODE    ) ?? getFieldValue(this.account, POSTAL_CODE    ); }
    get phone()         { return getFieldDisplayValue(this.account, PHONE          ) ?? getFieldValue(this.account, PHONE          ); }
    get website()       { return getFieldDisplayValue(this.account, WEBSITE        ) ?? getFieldValue(this.account, WEBSITE        ); }
    get annualRevenue() { return getFieldDisplayValue(this.account, ANNUAL_REVENUE ) ?? getFieldValue(this.account, ANNUAL_REVENUE ); }
    get dunsNumber()    { return getFieldDisplayValue(this.account, DUNS_NUMBER    ) ?? getFieldValue(this.account, DUNS_NUMBER    ); }
}