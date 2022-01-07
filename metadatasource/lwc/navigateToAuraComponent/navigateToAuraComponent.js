import { LightningElement } from 'lwc';
import { NavigationMixin  } from 'lightning/navigation';

export default class NavigateToAuraComponent extends NavigationMixin(LightningElement)
{
    clickHandler(event)
    {
        let pageType = "";
        let componentName = "";
        let id = "";
     
        let buttonLabel = event.target.label;

        if (buttonLabel === "Aura Component")
        {
            pageType = "standard__component";
            componentName = "c__AuraNavigation";
            id = "8af7d5c9-76e7-4d48-afed-6032b0e64cb3";
 
            this.navigation(pageType, componentName, id);
        }
    }

    navigation(pageType, componentName, id)
    {
        let attributes = {};
        attributes.componentName = componentName;
        let pageRef = {};

        let state = {};
        state.c__id = id;

        pageRef.type = pageType;
        pageRef.attributes = attributes;
        pageRef.state = state;
        
        this[NavigationMixin.Navigate](pageRef);
    }
}