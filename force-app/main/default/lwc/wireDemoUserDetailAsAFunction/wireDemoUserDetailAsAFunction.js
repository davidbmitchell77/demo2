import { LightningElement, wire } from 'lwc';
import { getRecord              } from 'lightning/uiRecordApi';

import USER_ID from '@salesforce/user/Id';

export default class WireDemoUserDetail extends LightningElement {
    userId = USER_ID;
    userDetails;
    errMsg = '';

    @wire(getRecord, { recordId: "$userId", fields: [ 'User.Name', 'User.Title', 'User.Email', 'User.Phone' ] })
    userDetailHandler({ data, error }) {
        if (data) {
            this.userDetails = data.fields;
        }
        if (error) {
            this.errMsg = error.body.message;
            console.error(this.errMsg);
        }
    }
}