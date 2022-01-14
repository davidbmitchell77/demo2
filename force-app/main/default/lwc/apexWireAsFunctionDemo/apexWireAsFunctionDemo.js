import { LightningElement, wire } from "lwc";

import getAccountList from "@salesforce/apex/AccountController.getAccountList";

export default class ApexWireDemo extends LightningElement
{
    accounts;

    @wire(getAccountList, {})
    getAccounts({ data, error })
    {
        if (data)
        {
            this.accounts = data.map
            (
                account =>
                {
                    let newType = account.Type;
                    if (newType === "Customer - Channel") { newType = "Channel"; }
                    if (newType === "Customer - Direct" ) { newType = "Direct";  }
                    return { ...account, Type: newType };
                }
            );
        }

        if (error) {
            console.error(error);
        }
    }
}