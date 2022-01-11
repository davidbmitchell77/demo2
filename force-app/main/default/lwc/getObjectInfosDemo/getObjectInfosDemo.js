import { LightningElement, wire } from 'lwc';
import { getObjectInfos         } from 'lightning/uiObjectInfoApi';

import Account     from '@salesforce/schema/Account';
import Contact     from '@salesforce/schema/Contact';
import Opportunity from '@salesforce/schema/Opportunity';

export default class WireGetObjectInfo extends LightningElement
{
    objectApiNames = [ Account, Contact, Opportunity ];

    @wire(getObjectInfos, { objectApiNames: '$objectApiNames' })
    objectInfos;

    get objectInfosStr() {
        return ((this.objectInfos.data) ? JSON.stringify(this.objectInfos.data, null, 2) : "");
    }

    get objectData() {
        return ((this.objectInfos.data) ? this.objectInfos.data : {});
    }
}