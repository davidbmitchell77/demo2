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
    ) userDetailsProperty;
}