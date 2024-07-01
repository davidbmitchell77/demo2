import { LightningElement, api } from 'lwc';
import { updateRecord          } from 'lightning/uiRecordApi';
import { ShowToastEvent        } from 'lightning/platformShowToastEvent';

export default class LightningDataTableChild extends LightningElement {

    @api cols;
    @api records;

    draftValues   = [];
    sortBy        = undefined;
    sortDirection = undefined;

    async doSave(event) {
        this.draftValues = [ ...event.detail.draftValues];
        let data = event.detail.draftValues.slice().map((arrayElement) => {
            let fields = Object.assign({}, arrayElement);
            return { fields };
        });
        this.draftValues = [];

        try {
            const recordUpdatePromises = data.map((record) => updateRecord(record));
            await Promise.all(recordUpdatePromises);
        }
        catch(error) {
          this.showToast('Error updating or reloading data!', error.body.message, 'error', 'sticky');
        }
    }

    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.records));
        let keyValue = (a) => {
            return a[fieldname];
        };
        let isReverse = ((direction === 'asc') ? 1 : -1);
        parseData.sort((a, b) => {
            a = (keyValue(a) ? keyValue(a) : '');
            b = (keyValue(b) ? keyValue(b) : '')
            return (isReverse * ((a > b) - (b > a)));
        });
        this.records = parseData;
    }

    showToast(title, message, variant, mode) {
        this.dispatchEvent(new ShowToastEvent({ title: title, message: message, variant: variant, mode: mode }));
    }
}

/*
// apexContactsForAccount.js

import { LightningElement, wire, api } from "lwc";
import getContacts from "@salesforce/apex/ContactController.getContactList";
import { refreshApex } from "@salesforce/apex";
import { updateRecord } from "lightning/uiRecordApi";

import { ShowToastEvent } from "lightning/platformShowToastEvent";
import FIRSTNAME_FIELD from "@salesforce/schema/Contact.FirstName";
import LASTNAME_FIELD from "@salesforce/schema/Contact.LastName";
import TITLE_FIELD from "@salesforce/schema/Contact.Title";
import PHONE_FIELD from "@salesforce/schema/Contact.Phone";
import EMAIL_FIELD from "@salesforce/schema/Contact.Email";
import ID_FIELD from "@salesforce/schema/Contact.Id";

const COLS = [
  {
    label: "First Name",
    fieldName: FIRSTNAME_FIELD.fieldApiName,
    editable: true,
  },
  {
    label: "Last Name",
    fieldName: LASTNAME_FIELD.fieldApiName,
    editable: true,
  },
  { label: "Title", fieldName: TITLE_FIELD.fieldApiName, editable: true },
  {
    label: "Phone",
    fieldName: PHONE_FIELD.fieldApiName,
    type: "phone",
    editable: true,
  },
  {
    label: "Email",
    fieldName: EMAIL_FIELD.fieldApiName,
    type: "email",
    editable: true,
  },
];
export default class DatatableInlineEditWithUiApi extends LightningElement {
  @api recordId;
  columns = COLS;
  draftValues = [];

  @wire(getContacts, { accId: "$recordId" })
  contacts;

  async handleSave(event) {
    // Convert datatable draft values into record objects
    const records = event.detail.draftValues.slice().map((draftValue) => {
      const fields = Object.assign({}, draftValue);
      return { fields };
    });

    // Clear all datatable draft values
    this.draftValues = [];

    try {
      // Update all records in parallel thanks to the UI API
      const recordUpdatePromises = records.map((record) => updateRecord(record));
      await Promise.all(recordUpdatePromises);

      // Display fresh data in the datatable
      await refreshApex(this.contacts);
    } catch (error) {
      this.dispatchEvent(
        new ShowToastEvent({
          title: "Error updating or reloading contacts",
          message: error.body.message,
          variant: "error",
        }),
      );
    }
  }
}
*/