import { LightningElement } from 'lwc';
import { NavigationMixin  } from 'lightning/navigation';

export default class NavigateToRecordPage extends NavigationMixin(LightningElement)
{
    clickHandler(event)
    {
        let pageType = "";
        let objectApiName = "";
        let recordId = "";
        let actionName = "";

        let buttonLabel = event.target.label;

        if (buttonLabel === "View Mode")
        {
            pageType = "standard__recordPage";
            objectApiName = "Contact";
            recordId = "0030R00001LkRfGQAV";
            actionName = "view";
        }
        else if (buttonLabel === "Edit Mode")
        {
            pageType = "standard__recordPage";
            objectApiName = "Contact";
            recordId = "0030R00001LkRfGQAV";
            actionName = "edit";
        }

        this.navigate(pageType, objectApiName, recordId, actionName);
    }

    navigate(pageType, objectApiName, recordId, actionName)
    {
        let attributes = {};
        attributes.objectApiName = objectApiName;
        attributes.recordId = recordId;
        attributes.actionName = actionName;

        let pageRef = {};
        pageRef.type = pageType;
        pageRef.attributes = attributes;

        this[NavigationMixin.Navigate](pageRef);
    }}