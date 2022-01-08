import { LightningElement } from 'lwc';
import { ShowToastEvent   } from 'lightning/platformShowToastEvent';

import Account from '@salesforce/schema/Account';

export default class RecordFormDemo extends LightningElement
{
    objectName = Account;
    recordId = "0010R00001NYNimQAH";

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