import { LightningElement, api, wire } from 'lwc';
import { getRecord                   } from 'lightning/uiRecordApi';
import { getFieldValue               } from 'lightning/uiRecordApi';
import { getFieldDisplayValue        } from 'lightning/uiRecordApi';

import Name          from '@salesforce/schema/Lead.Name';
import City          from '@salesforce/schema/Lead.City';
import State         from '@salesforce/schema/Lead.State';
import PostalCode    from '@salesforce/schema/Lead.PostalCode';
import AnnualRevenue from '@salesforce/schema/Lead.AnnualRevenue';

export default class GetRecordDemo extends LightningElement
{
    @api recordId;
    @api objectApiName;

    data = "";
    name = "";
    city = "";
    state = "";
    postalCode = "";
    annualRevenue = "";

    @wire(getRecord, { recordId: "$recordId", fields: [ Name, City, State, PostalCode ], optionalFields: [ AnnualRevenue ] })
    record({ data, error })
    {
        if (data)
        {
            this.name = getFieldValue(data, Name);
            this.city = getFieldValue(data, City);
            this.state = getFieldValue(data, State);
            this.postalCode = getFieldValue(data, PostalCode);
            this.annualRevenue = getFieldDisplayValue(data, AnnualRevenue);
            this.data = JSON.stringify(data, null, 2);
            console.info(data);
        }

        if (error) {
            console.error(error);
        }
    };
}