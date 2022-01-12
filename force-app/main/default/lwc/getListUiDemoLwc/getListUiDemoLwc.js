import { LightningElement, wire } from "lwc";
import { getListUi              } from "lightning/uiListApi";

import Contact from "@salesforce/schema/Contact";
import Title   from "@salesforce/schema/Contact.Title";

export default class GetListUiDemoLwc extends LightningElement
{
    contacts = [];
    pageToken = null;
    nextPageToken = null;
    previousPageToken = null;

    @wire
    (
        getListUi,
        {
            objectApiName: Contact,
            listViewApiName: "AllContacts",
            pageSize: 10,
            sortBy: Title,
            pageToken: "$pageToken"
        }
    )
    listViewHandler({ data, error })
    {
        if (data)
        {
            this.contacts = data.records.records;
            this.nextPageToken = data.records.nextPageToken;
            this.previousPageToken = data.records.previousPageToken;
            console.log(data);
        }

        if (error) {
            console.error(error)
        }
    };

    handlePreviousPage() {
        this.pageToken = this.previousPageToken;
    }

    handleNextPage() {
        this.pageToken = this.nextPageToken;
    }
}