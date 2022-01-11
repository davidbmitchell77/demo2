import { LightningElement, wire } from 'lwc';
import { getObjectInfos         } from 'lightning/uiObjectInfoApi';

import Account     from '@salesforce/schema/Account';
import Opportunity from '@salesforce/schema/Opportunity';
import Contact     from '@salesforce/schema/Contact';

export default class WireGetObjectInfo extends LightningElement
{
    objectApiNames = [ Opportunity, Account, Contact ];

    @wire(getObjectInfos, { objectApiNames: '$objectApiNames' })
    objectInfos;

    get objectInfosStr() {
        return ((this.objectInfos) ? JSON.stringify(this.objectInfos.data, null, 2) : "");
    }

    get objInfo() {
        return ((this.objectInfos.data) ? this.objectInfos.data : {});
    }
}