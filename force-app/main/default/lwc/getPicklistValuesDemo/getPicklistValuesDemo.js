import { LightningElement, wire           } from "lwc";
import { getObjectInfo, getPicklistValues } from "lightning/uiObjectInfoApi";

import Account  from "@salesforce/schema/Account";
import Industry from "@salesforce/schema/Account.Industry";
import Type     from "@salesforce/schema/Account.Type";

export default class GetPIcklistValuesDemo extends LightningElement
{
    selectedIndustry = "";
    selectedType = "";
    industryOptions = [];
    typeOptions = [];

    @wire(getObjectInfo, { objectApiName: Account })
    objectInfo;

    @wire(getPicklistValues, { recordTypeId: "$objectInfo.data.defaultRecordTypeId", fieldApiName: Industry })
    industryPicklist({ data, error })
    {
        if (data) {
            this.industryOptions = [ ...this.generatePicklist(data) ];
            console.log(data);
        }

        if (error) {
            console.error(error);
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: Type })
    typePicklist({ data, error })
    {
        if (data) {
            console.log(data);
            this.typeOptions = [ ...this.generatePicklist(data) ];
        }

        if (error) {
            console.error(error);
        }
    }

    generatePicklist(data) {
        return data.values.map(item=>({ label: item.label, value: item.value }));
    }

    changeHandler(event)
    {
        if (event.target.name === "Industry") {
            this.selectedIndustry = event.detail.value;
        }

        if (event.target.name === "Type") {
            this.selectedType = event.detail.value;
        }
    }
}
