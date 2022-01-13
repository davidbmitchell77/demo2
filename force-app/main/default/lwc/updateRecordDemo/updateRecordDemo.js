import { LightningElement, wire } from "lwc";
import { getListUi              } from "lightning/uiListApi";
import { updateRecord           } from "lightning/uiRecordApi";

import Contact from "@salesforce/schema/Contact";

const cols =
[
    { type: "text",  label: "Account", fieldName: "Account", editable: false },
    { type: "text",  label: "Name",    fieldName: "Name",    editable: false },
    { type: "text",  label: "Title",   fieldName: "Title",   editable: false },
    { type: "tel",   label: "Phone",   fieldName: "Phone",   editable: true  },
    { type: "email", label: "Email",   fieldName: "Email",   editable: true  }
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
                record =>
                {
                    let contact =
                    {
                        "Id":      this.getValue(record, "Id"      ),
                        "Account": this.getValue(record, "Account" ),
                        "Name"   : this.getValue(record, "Name"    ),
                        "Title"  : this.getValue(record, "Title"   ),
                        "Phone"  : this.getValue(record, "Phone"   ),
                        "Email"  : this.getValue(record, "Email"   )
                    };
                    return contact;
                }
            );
        }

        if (error) {
            console.error(error);
        }
    }

    getValue(data, field)
    {
        let value = data.fields[field].value;
        let displayValue = data.fields[field].displayValue;

        return ((displayValue) ? displayValue : value);
    }

    handleSave(event)
    {
        let recordInputs = event.detail.draftValues.map
        (
            draftValue =>
            {
                let fields = { ...draftValue };
                return { fields: fields };
            }
        );

        let promises = recordInputs.map
        (
            recordInput =>
            {
                let promise = updateRecord(recordInput);
                return promise;
            }
        );

        Promise.all(promises).then
        (
            () => {
                this.draftValues = [];
                console.log("Contact record updated.");
            }
        ).catch
        (
            error => {
                console.error(error);
            }
        );
    }
}