import { LightningElement, wire } from 'lwc';
import { getObjectInfo          } from 'lightning/uiObjectInfoApi';

import Account from '@salesforce/schema/Account';

export default class GetObjectInfoDemo extends LightningElement
{
    objectApiName = Account;
    objectName = "";
    defaultRecordTypeId = "";

    apiName;
    defaultRecordTypeId;
    childRelationships;

    @wire(getObjectInfo, { objectApiName: "$objectApiName" })
    objectInfo({ data, error })
    {
        if (data)
        {
            this.apiName = data.apiName;
            this.defaultRecordTypeId = data.defaultRecordTypeId;
            this.childRelationships = data.childRelationships.length;
            this.template.querySelector("textarea").value = JSON.stringify(data, null, 2);
            console.info(data);
        }

        if (error)
        {
            this.template.querySelector("textarea").value = JSON.stringify(error, null, 2);
            console.error(error);
        }
    }
}