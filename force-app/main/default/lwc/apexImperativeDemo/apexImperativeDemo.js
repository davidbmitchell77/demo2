import { LightningElement } from 'lwc';

import getAccountList from '@salesforce/apex/AccountController.getAccountList';

export default class ApexImperativeDemo extends LightningElement {
    accounts = [];

    clickHandler() {
        getAccountList().then ((result) => {
            this.accounts = [ ...result ];
            console.info(this.accounts);
        }).catch((error) => {
            console.error(error);
        });
    }
}