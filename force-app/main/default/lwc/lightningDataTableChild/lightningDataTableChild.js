import { LightningElement, api } from 'lwc';

export default class LightningDataTableChild extends LightningElement {

    @api cols;
    @api records;
}