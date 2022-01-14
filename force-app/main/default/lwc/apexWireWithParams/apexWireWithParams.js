import { LightningElement, wire } from "lwc";

import getAccountListByType from "@salesforce/apex/AccountController.getAccountListByType";

export default class ApexWireWithParams extends LightningElement
{
    selectedType = null;

    @wire(getAccountListByType, { type: "$selectedType" })
    filteredAccounts;

    typeHandler(event) {
        this.selectedType = event.target.value;
    }

    get typeOptions()
    {
        let results = [];

        results.push({ label: "--None--", value: null });
        results.push({ label: "Customer - Channel", value: "Customer - Channel" });
        results.push({ label: "Customer - Direct", value: "Customer - Direct" });

        return results;
    }
}