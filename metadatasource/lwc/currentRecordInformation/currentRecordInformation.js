import { LightningElement, api } from 'lwc';

export default class CurrentRecordInformation extends LightningElement
{
    @api recordId;
    @api objectApiName;
}