import { LightningElement, wire } from "lwc";

import getAccountList from "@salesforce/apex/AccountController.getAccountList";

export default class ApexWireAsFunctionDemo extends LightningElement
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
                    let accountType = account.Type;
                    if (accountType === "Customer - Channel") { accountType = "Channel"; }
                    if (accountType === "Customer - Direct" ) { accountType = "Direct";  }
                    return { ...account, Type: accountType };
                }
            );
        }

        if (error) {
            console.error(error);
        }
    }
}