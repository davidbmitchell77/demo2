import { LightningElement, wire } from "lwc";
import { exportCSVFile          } from "c/utils";

import getAccounts from "@salesforce/apex/CsvController.getAccounts";

export default class CsvDemo extends LightningElement
{
    accountData;

    accountHeaders =
    {
        Id:            "Record Id",
        Name:          "Name",
        AnnualRevenue: "Annual Revenue",
        Industry:      "Industry",
        Phone:         "Phone"
    };

    @wire(getAccounts)
    accountHandler({ data, error })
    {
        if (data) {
            this.accountData = data;
            console.log(data);
        }
        if (error) {
            console.error(error);
        }
    }

    csvGenerator() {
        exportCSVFile(this.accountHeaders, this.accountData, "account_records");
    }
}