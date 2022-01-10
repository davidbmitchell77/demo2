import { LightningElement, wire } from 'lwc';
import { getRecord              } from 'lightning/uiRecordApi';

import Id from '@salesforce/user/Id';

export default class WireDemoUserDetail extends LightningElement
{
    userId = Id;
    userDetails;
    errMsg = "";

    @wire
    (
        getRecord,
        {
            recordId: Id,
            fields:
            [
                "User.Name",
                "User.Title",
                "User.Email",
                "User.Phone_sss"
            ]
        }
    )
    userDetailHandler(response)
    {
        if (response.data) {
            this.userDetails = response.data.fields;
        }
        if (response.error) {
            this.errMsg = response.error.body.message;
            console.error(this.errMsg);
        }
    };
}