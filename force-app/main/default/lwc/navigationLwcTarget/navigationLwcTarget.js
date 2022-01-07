import { LightningElement } from 'lwc';
import customer_service_rep_image from "@salesforce/resourceUrl/customer_service_rep_image";

export default class NavigationLwcTarget extends LightningElement
{
    customerServiceRepImage = customer_service_rep_image;
}