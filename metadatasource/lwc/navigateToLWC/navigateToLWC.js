import { LightningElement } from 'lwc';
import { NavigationMixin  } from 'lightning/navigation';

export default class NavigateToLWC extends NavigationMixin(LightningElement)
{
    clickHandler(event)
    {
        let pageType = "";
        let lwcPath = "";
        let url = "";
        let recordId = "";

        let buttonLabel = event.target.label;

        if (buttonLabel === "Lightning Web Component")
        {
            pageType = "standard__webPage";
            lwcPath = "c:navigationLwcTarget";
            url = "/one/one.app#";
            recordId = "ad588b2f-b7e2-4448-a961-df2ddf10d161";
        }
 
        this.navigate(pageType, lwcPath, url, recordId);
    }

    navigate(pageType, lwcPath, url, recordId)
    {
        let attributes = {};
        attributes.recordId = recordId;
    
        let lwcDefinition = {};
        lwcDefinition.componentDef = lwcPath;
        lwcDefinition.attributes = attributes;

        attributes = {};
        attributes.url = url + (window.btoa(JSON.stringify(lwcDefinition)));

        let pageRef = {};
        pageRef.type = pageType;
        pageRef.attributes = attributes;

        this[NavigationMixin.Navigate](pageRef);
    }
}