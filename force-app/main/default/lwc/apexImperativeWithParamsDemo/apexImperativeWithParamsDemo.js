import { LightningElement } from "lwc";

import getAccountListBySearchKey from "@salesforce/apex/AccountController.getAccountListBySearchKey";

export default class ApexImperativeWithParamsDemo extends LightningElement
{
    searchKey = "";
    timer;
    accounts = [];

    changeHandler(event)
    {
        window.clearTimeout(this.timer);
        this.searchKey = event.target.value;
        this.timer = setTimeout
        (
            () => {
                this.callApex();
            },
            1000
        );
    }

    callApex()
    {
        getAccountListBySearchKey({ searchKey: this.searchKey }).then
        (
            results => {
                this.accounts = results;
            }
        ).
        catch
        (
            error => {
                console.error(error);
            }
        )
    }

    disconnectedCallback() {
        this.timer = null;
    }
}