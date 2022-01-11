import { LightningElement, wire } from 'lwc';
import { getObjectInfo          } from 'lightning/uiObjectInfoApi';

import Account from '@salesforce/schema/Account';

export default class GetObjectInfoDemo extends LightningElement
{
    objectApiName = "";

    @wire(getObjectInfo, { objectApiName: Account })
    objectInfo(response)
    {
        let data = response.data;
        let error = response.error;

        if (data)
        {
            this.objectApiName = `apiName: ${data.apiName}`;
            this.template.querySelector("textarea").value = JSON.stringify(data.fields);
            console.log(data);
        }

        if (error) {
            this.message = JSON.stringify(error);
            console.error(error);
        }
    }
}