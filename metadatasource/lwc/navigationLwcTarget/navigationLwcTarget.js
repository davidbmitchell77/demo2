import { LightningElement, api } from 'lwc';
import customer_service_rep_image from "@salesforce/resourceUrl/customer_service_rep_image";

export default class NavigationLwcTarget extends LightningElement
{
    @api recordId;
    customerServiceRepImage = customer_service_rep_image;

    renderedCallback() {
        console.log(`Record Id: ${this.recordId}`);
    }
}