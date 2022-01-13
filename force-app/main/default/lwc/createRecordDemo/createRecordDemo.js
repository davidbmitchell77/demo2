import { LightningElement } from "lwc";
import { ShowToastEvent   } from "lightning/platformShowToastEvent";
import { createRecord     } from "lightning/uiRecordApi";

import Contact from "@salesforce/schema/Contact";

export default class CreateRecordDemo extends LightningElement
{
    formFields = {};

    changeHandler(event)
    {
        const { name, value } = event.target;
        this.formFields[name] = value;
    }

    createContact()
    {
        const recordInput = { apiName: Contact.objectApiName, fields: this.formFields };
        createRecord(recordInput).then
        (
            result =>
            {
                this.showMsg("Success", `Contact created with Id ${result.id}.`);
                this.template.querySelector("form.createForm").reset();
                this.formFields = {};
            }
        ).catch
        (
            error => {
                this.showToast("Error Creating record", error.body.message, "error");
            }
        );
    }

    showMsg(title, message, variant)
    {
        this.dispatchEvent
        (
            new ShowToastEvent
            (
                {
                    title,
                    message,
                    variant: (variant || "info")
                }
            )
        );
    }
}