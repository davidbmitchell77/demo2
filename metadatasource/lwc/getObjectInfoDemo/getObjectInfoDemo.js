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
        let data = response.data;
        let error = response.error;

        if (data)
        {
            this.objectName = data.apiName;
            this.defaultRecordTypeId = data.defaultRecordTypeId;
            this.template.querySelector("textarea").value = JSON.stringify(data.fields, null, 2);
            console.log(data);
        }

        if (error) {
            this.message = JSON.stringify(error);
            console.error(error);
        }
    }
}