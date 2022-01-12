import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

import AnnualRevenue from '@salesforce/schema/Lead.AnnualRevenue';

export default class GetRecordByLayoutTypeDemo extends LightningElement
{
    @api recordId;
    @api objectApiName;

    data = "";
    name = "";
    city = "";
    state = "";
    postalCode = "";
    annualRevenue = "";

    @wire(getRecord, { recordId: "$recordId", layoutTypes: [ "Full" ], modes: ["View"], optionalFields: [ AnnualRevenue ] })
    record({ data, error })
    {
        if (data)
        {
            this.data = JSON.stringify(data, null, 2);
            this.name = (data.fields.CreatedBy.value.fields.Name.displayValue ? data.fields.CreatedBy.value.fields.Name.displayValue : data.fields.CreatedBy.value.fields.Name.value);
            this.city = (data.fields.City.displayValue ? data.fields.City.displayValue : data.fields.City.value);
            this.state = (data.fields.State.displayValue ? data.fields.State.displayValue : data.fields.State.value);
            this.postalCode = (data.fields.PostalCode.displayValue ? data.fields.PostalCode.displayValue : data.fields.PostalCode.value);
            this.annualRevenue = (data.fields.AnnualRevenue.displayValue ? data.fields.AnnualRevenue.displayValue : data.fields.AnnualRevenue.value);
            console.info(data);
        }

        if (error) {
            console.error(error);
        }
    };
}