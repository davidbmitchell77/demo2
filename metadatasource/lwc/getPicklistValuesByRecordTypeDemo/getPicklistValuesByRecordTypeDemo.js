import { LightningElement, wire        } from "lwc";
import { getPicklistValuesByRecordType } from "lightning/uiObjectInfoApi";
import { getObjectInfo                 } from "lightning/uiObjectInfoApi";

import Account from "@salesforce/schema/Account";

export default class GetPicklistValuesByRecordTypeDemo extends LightningElement
{
    dataStr = "";
    errorStr = "";
    data = undefined;
    error = undefined;
    accountSources = undefined;
    industries = undefined;
    isActive = undefined;
    serviceLevelAgreements = undefined;

    @wire(getObjectInfo, { objectApiName: Account })
    objectInfo;

    @wire(getPicklistValuesByRecordType, { objectApiName: Account, recordTypeId: "$objectInfo.data.defaultRecordTypeId" })
    picklistValues({ data, error })
    {
        if (data)
        {
            this.data = data;
            this.dataStr = JSON.stringify(this.data, null, 2);
            this.accountSources = data.picklistFieldValues.AccountSource.values;
            this.industries = data.picklistFieldValues.Industry.values;
            this.isActive = data.picklistFieldValues.Active__c.values;
            this.serviceLevelAgreements = data.picklistFieldValues.SLA__c.values;
            console.info(data);
        }

        if (error)
        {
            this.error = error;
            this.errorStr = JSON.stringify(error, null, 2);
            console.error(error);
        }
    };
}