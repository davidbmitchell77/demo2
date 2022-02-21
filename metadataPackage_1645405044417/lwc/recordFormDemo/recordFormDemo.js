import { LightningElement } from 'lwc';
import { ShowToastEvent   } from 'lightning/platformShowToastEvent';

import Account       from '@salesforce/schema/Account';
import Name          from '@salesforce/schema/Account.Name';
import Type          from '@salesforce/schema/Account.Type';
import Industry      from '@salesforce/schema/Account.Industry';
import AnnualRevenue from '@salesforce/schema/Account.AnnualRevenue';

//                                                                                 developer edition      scratch org
const AccountId = location.host.toLowerCase().startsWith("dbmlightning-dev-ed") ? "0016g000004Gt0oAAC" : "0010R00001NYNimQAH";

export default class RecordFormDemo extends LightningElement
{
    objectApiName = Account;
    recordId = AccountId;

    fieldNames =
    [
        Name,
        Type,
        Industry,
        AnnualRevenue
    ];

    successHandler(event)
    {
        let mode = event.target.mode;

        let successMsg = new ShowToastEvent
        ({
            title: `Account ${(mode==="view") ? "updated" : "created"}`,
            message: "Record Id: " + event.detail.id,
            variant: "success"
        });

        this.dispatchEvent(successMsg);
    }
}