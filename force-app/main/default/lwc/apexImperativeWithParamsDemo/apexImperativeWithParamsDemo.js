import { LightningElement } from "lwc";

import getAccountListBySearchKey from "@salesforce/apex/AccountController.getAccountListBySearchKey";

export default class ApexImperativeWithParamsDemo extends LightningElement
{
    searchKey = "";
    accounts = [];

    changeHandler(event)
    {
        this.searchKey = event.target.value;
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
}