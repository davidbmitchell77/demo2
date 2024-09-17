import { LightningElement, wire } from 'lwc';

import getAccountList from '@salesforce/apex/AccountController.getAccountList';

export default class ApexWireAsPropertyDemo extends LightningElement {
    @wire(getAccountList, {})
    accounts;
}