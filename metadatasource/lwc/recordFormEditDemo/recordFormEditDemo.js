import { LightningElement, api } from 'lwc';
import { ShowToastEvent   } from 'lightning/platformShowToastEvent';

import Account from '@salesforce/schema/Account';

export default class RecordFormDemo extends LightningElement
{
    @api objectName = Account;
    @api recordId = "0010R00001NYNimQAH";

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