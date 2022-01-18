import { LightningElement, api } from 'lwc';
import { ShowToastEvent   } from 'lightning/platformShowToastEvent';

import Account from '@salesforce/schema/Account';

//                                                                                 developer edition      scratch org
const AccountId = location.host.toLowerCase().startsWith("dbmlightning-dev-ed") ? "0016g000004Gt0oAAC" : "0010R00001NYNimQAH";

export default class RecordFormDemo extends LightningElement
{
    @api objectApiName = Account;
    @api recordId = AccountId;

    successHandler(event)
    {
        let successMsg = new ShowToastEvent
        ({
            title: "Account updated",
            message: "Record Id: " + event.detail.id,
            variant: "success"
        });

        this.dispatchEvent(successMsg);
    }
}