import { LightningElement } from 'lwc';
import { NavigationMixin  } from 'lightning/navigation';

export default class NavigateToLWC extends NavigationMixin(LightningElement)
{
    clickHandler(event)
    {
        let pageType = "";
        let lwcPath = "";
        let url = "";

        let buttonLabel = event.target.label;

        if (buttonLabel === "Lightning Web Component")
        {
            pageType = "standard__webPage";
            lwcPath = "c:navigationLwcTarget";
            url = "/one/one.app#";
        }
 
        this.navigate(pageType, lwcPath, url);
    }

    navigate(pageType, lwcPath, url)
    {
        let lwcDefinition = {};
        lwcDefinition.componentDef = lwcPath;

        let attributes = {};
        attributes.url = url + btoa(JSON.stringify(lwcDefinition));

        let pageRef = {};
        pageRef.type = pageType;
        pageRef.attributes = attributes;

        this[NavigationMixin.Navigate](pageRef);
    }
}