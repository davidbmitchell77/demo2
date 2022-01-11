import { LightningElement, wire } from 'lwc';
import { getObjectInfo          } from 'lightning/uiObjectInfoApi';

import Account from '@salesforce/schema/Account';

export default class GetObjectInfoDemo extends LightningElement
{
    objectApiName = Account;
    objectName = "";
    defaultRecordTypeId = "";

    @wire(getObjectInfo, { objectApiName: "$objectApiName" })
    objectInfo(response)
    {
        if (response.data)
        {
            this.data = response.data;
            this.template.querySelector("textarea").value = JSON.stringify(data.fields, null, 2);
            console.log(data);
        }

        if (response.error) {
            this.error = response.error;
            this.template.querySelector("textarea").value = JSON.stringify(error.fields, null, 2);
            console.error(error);
        }
    }
}
