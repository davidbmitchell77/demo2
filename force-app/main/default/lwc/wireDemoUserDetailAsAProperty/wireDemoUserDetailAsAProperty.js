import { LightningElement, wire } from 'lwc';
import { getRecord              } from 'lightning/uiRecordApi';

import Id    from '@salesforce/user/Id';
import Name  from '@salesforce/schema/User.Name';
import Title from '@salesforce/schema/User.Title';
import Email from '@salesforce/schema/User.Email';
import Phone from '@salesforce/schema/User.Phone';

const fields = [Id, Name, Title, Email, Phone];

export default class WireDemoUserDetail extends LightningElement
{
    userId = Id;

    @wire(getRecord, { recordId: Id, fields })
    userDetailsProperty;
}