import { LightningElement, api } from "lwc";
import { updateRecord          } from "lightning/uiRecordApi";
import { ShowToastEvent        } from "lightning/platformShowToastEvent";

import id_field         from "@salesforce/schema/Opportunity.Id";
import stage_name_field from "@salesforce/schema/Opportunity.StageName";

export default class ClosedAction extends LightningElement
{
    @api recordId;
    @api objectApiName;

    @api invoke()
    {
        let fields = {};
        fields[id_field.fieldApiName] = this.recordId;
        fields[stage_name_field.fieldApiName] = "Closed";

        let recordInput = { fields };
        updateRecord(recordInput).then
        (
            () => {
                this.showToast("Success!", `Opportunity ${this.recordId} was successfully closed.`, "success");
                console.log("Invoked closedAction for " + this.objectApiName + "[Id=\"" + this.recordId + "\"].");
            }
        )
        .catch
        (
            (error) => {
                this.showToast("Error!", error.message, "error");
            }
        );
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}