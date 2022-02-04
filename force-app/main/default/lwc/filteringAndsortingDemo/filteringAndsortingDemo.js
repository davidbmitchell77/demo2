import { LightningElement, wire } from "lwc";

import getContactList from "@salesforce/apex/ContactController.getContactList";

export default class FilteringAndSortingDemo extends LightningElement
{
    headings = [ "Id", "Name", "Title", "Email" ];
    fullTableData = [];
    filteredData = [];
    filterBy = "Name";
    sortedBy = "Name";
    sortDirection = "asc";
    timer;

    @wire(getContactList)
    contactHandler({ data, error })
    {
        if (data)
        {
            this.fullTableData = data;
            this.filteredData = [ ...this.sortBy(data) ];
            console.info(data);
        }
        if (error) {
            console.log(error);
        }
    }

    get FilterByOptions()
    {
        return [
            { label: "All",   value: "All"   },
            { label: "Id",    value: "Id"    },
            { label: "Name",  value: "Name"  },
            { label: "Title", value: "Title" },
            { label: 'Email', value: "Email" }
        ];
    }

    get sortByOptions()
    {
        return [
            { label: "Id",    value: "Id"    },
            { label: "Name",  value: "Name"  },
            { label: "Title", value: "Title" },
            { label: "Email", value: "Email" }
        ];
    }

    filterbyHandler(event) {
        this.filterBy = event.target.value;
    }

    filterHandler(event)
    {
        let value = event.target.value.toLowerCase();

        window.clearTimeout(this.timer);

        if (value)
        {
            this.timer = window.setTimeout
            (
                () =>
                {
                    this.filteredData = this.fullTableData.filter
                    (
                        (eachObj) =>
                        {
                            if (this.filterBy === "All")
                            {
                                return Object.keys(eachObj).some
                                (
                                    (key) => {
                                        return eachObj[key].toLowerCase().includes(value);
                                    }
                                );
                            }
                            else {
                                let val = ((eachObj[ this.filterBy ]) ? eachObj[ this.filterBy ] : "");
                                return val.toLowerCase().includes(value);
                            }
                        }
                    )
                },
                (0.75 * 1000)
            )
        }
        else {
            this.filteredData = [ ...this.fullTableData ];
        }
    }

    sortHandler(event) {
        this.sortedBy = event.target.value;
        this.filteredData = [ ...this.sortBy(this.filteredData) ];
    }

    sortBy(data)
    {
        let cloneData = [ ...data ];

        cloneData.sort
        (
            (a,b) =>
            {
                if (a[ this.sortedBy ] === b[ this.sortedBy ]) {
                    return 0;
                }
                return ((this.sortDirection === "desc") ? (a[ this.sortedBy ] > b[ this.sortedBy ]) ? -1 : 1 : (a[ this.sortedBy ] < b[ this.sortedBy ]) ? -1 : 1);
            }
        )

        return cloneData;
    }
}