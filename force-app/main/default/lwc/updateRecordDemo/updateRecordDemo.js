import { LightningElement, wire } from "lwc";
import { getListUi              } from "lightning/uiListApi";
import { updateRecord           } from "lightning/uiRecordApi";

import Contact from "@salesforce/schema/Contact";

const cols =
[
    { type: "text",  label: "Id",    fieldName: "Id",    editable: false },
    { type: "text",  label: "Name",  fieldName: "Name",  editable: false },
    { type: "text",  label: "Title", fieldName: "Title", editable: false },
    { type: "tel",   label: "Phone", fieldName: "Phone", editable: true  },
    { type: "email", label: "Email", fieldName: "Email", editable: true  }
];

export default class UpdateRecordDemo extends LightningElement
{
    columns = cols;
    contacts = [];
    draftValues = [];

    @wire
    (
        getListUi,
        {
            objectApiName: Contact,
            listViewApiName: "AllContacts"
        }
    )
    listViewHandler({ data, error })
    {
        if (data)
        {
            this.contacts = data.records.records.map
            (
                item =>
                {
                    return
                    ({
                        "Id":    this.getValue(item, "Id"),
                        "Name":  this.getValue(item, "Name"),
                        "Title": this.getValue(item, "Title"),
                        "Phone": this.getValue(item, "Phone"),
                        "Email": this.getValue(item, "Email")
                    })
                }
            );
            console.log(data);
        }

        if (error) {
            console.error(error);
        }
    }

    getValue(data, field) {
        return data.fields[field].value;
    }

    handleSave(event)
    {
        console.log(JSON.stringify(event.detail.draftValues, null, 2));

        const recordInputs = event.detail.draftValues.map
        (
            draft =>
            {
                const fields = { ...draft };
                return { fields: fields };
            }
        );

        const promises = recordInputs.map(recordInput => updateRecord(recordInput));

        Promise.all(promises).then
        (
            () =>
            {
                console.log("Contact updated successfully.");
                this.draftValues = [];
            }
        ).catch
        (
            error => {
                console.error("Error updating the record", error);
            }
        )
    }
}