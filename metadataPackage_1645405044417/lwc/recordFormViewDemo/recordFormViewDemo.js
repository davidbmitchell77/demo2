import { LightningElement, api } from 'lwc';

//                                                                                 developer edition      scratch org
const AccountId = location.host.toLowerCase().startsWith("dbmlightning-dev-ed") ? "0016g000004Gt0oAAC" : "0010R00001NYNimQAH";

export default class RecordFormViewDemo extends LightningElement
{
    @api objectApiName = "Account";
    @api recordId = AccountId;
}