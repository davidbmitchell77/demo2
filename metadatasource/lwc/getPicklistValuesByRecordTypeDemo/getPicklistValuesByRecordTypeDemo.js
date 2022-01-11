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

    @wire(getObjectInfo, { objectApiName: Account })
    objectInfo;

    @wire(getPicklistValuesByRecordType, { objectApiName: Account, recordTypeId: "$objectInfo.data.defaultRecordTypeId" })
    picklistValues({ data, error })
    {
        if (data)
        {
            this.data = data;
            this.dataStr = JSON.stringify(this.data, null, 2);
            console.info(data);
        }

        if (error)
        {
            this.error = error;
            this.errorStr = JSON.stringify(error, null, 2);
            console.error(error);
        }
    };

    get values()
    {
        let results = undefined;

        if (this.data)
        {
            if (this.data.picklistFieldValues)
            {
                if (this.data.picklistFieldValues.AccountSource)
                {
                    if (this.data.picklistFieldValues.AccountSource.values)
                    {
                        results = this.data.picklistFieldValues.AccountSource.values;
                    }
                }
            }
        }

        return results;
    }
}