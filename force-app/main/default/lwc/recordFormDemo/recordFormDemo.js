import { LightningElement } from 'lwc';
import { ShowToastEvent   } from 'lightning/platformShowToastEvent';

import Account       from '@salesforce/schema/Account';
import Name          from '@salesforce/schema/Account.Name';
import Type          from '@salesforce/schema/Account.Type';
import Industry      from '@salesforce/schema/Account.Industry';
import AnnualRevenue from '@salesforce/schema/Account.AnnualRevenue';

export default class RecordFormDemo extends LightningElement
{
    objectName = Account;

    fieldNames =
    [
        Name,
        Type,
        Industry,
        AnnualRevenue
    ];

    successHandler(event)
    {
        let successMsg = new ShowToastEvent
        ({
            title: "Account created",
            message: "Record Id: " + event.detail.id,
            variant: "success"
        });

        this.dispatchEvent(successMsg);
    }
}