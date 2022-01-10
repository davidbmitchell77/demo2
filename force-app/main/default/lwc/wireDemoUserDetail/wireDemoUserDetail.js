import { LightningElement, wire } from 'lwc';
import { getRecord              } from 'lightning/uiRecordApi';

import Id from '@salesforce/user/Id';

export default class WireDemoUserDetail extends LightningElement
{
    userId = Id;

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
                "User.Phone"
            ]
        }
    )
    userDetailHandler(response)
    {
        if (response)
        {
            if(response.data) {
                console.info(response.data);
            }
            if  (response.error) {
                console.error(response.error.body.message);
            }
        }
    };
}