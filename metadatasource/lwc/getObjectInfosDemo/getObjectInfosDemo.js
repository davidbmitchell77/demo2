import { LightningElement, wire } from "lwc";
import { getObjectInfos         } from "lightning/uiObjectInfoApi";

import Account     from "@salesforce/schema/Account";
import Contact     from "@salesforce/schema/Contact";
import Opportunity from "@salesforce/schema/Opportunity";

export default class WireGetObjectInfo extends LightningElement
{
    objectApiNames = [ Account, Contact, Opportunity ];

    @wire(getObjectInfos, { objectApiNames: "$objectApiNames" })
    objectInfos;

    get objectsStr()
    {
        let result;

        if (this.objectInfos.data) {
            result = JSON.stringify(this.objectInfos.data, null, 2);
        }

        if (this.objectInfos.error) {
            result = JSON.stringify(this.objectInfos.error, null, 2);
        }

        return result;
    }

    get objects() {
        return ((this.objectInfos.data) ? this.objectInfos.data : {});
    }
}
