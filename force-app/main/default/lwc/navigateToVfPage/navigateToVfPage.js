import { LightningElement } from 'lwc';
import { NavigationMixin  } from 'lightning/navigation';

export default class NavigateToVfPage extends NavigationMixin(LightningElement)
{
    clickHandler(event)
    {
        let pageType = "";
        let url = "";
 
        let buttonLabel = event.target.label;
 
        if (buttonLabel === "Visualforce Page")
        {
            pageType = "standard__webPage ";
            url = "/apex/navigateVfPage";
            this.navigate(pageType, url);
        }
    }

    navigate(pageType, url)
    {
        let attributes = {};
        attributes.url = url;

        let pageRef = {};
        pageRef.type = pageType;
        pageRef.attributes = attributes;

        this[NavigationMixin.Navigate](pageRef).then(generatedUrl=>{
            window.open(generatedUrl, "_blank");
        });
    }
}