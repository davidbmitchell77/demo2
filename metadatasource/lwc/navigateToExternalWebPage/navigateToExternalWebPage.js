import { LightningElement } from 'lwc';
import { NavigationMixin  } from 'lightning/navigation';

export default class NavigateToExternalWebPage extends NavigationMixin(LightningElement)
{
    clickHandler(event)
    {
        let pageType = "";
        let url = "";

        let buttonLabel = event.target.label;

        if (buttonLabel === "Al-Jazeera")
        {
            pageType = "standard__webPage";
            url = "https://www.aljazeera.com";
        }
        else if (buttonLabel === "CNN ws")
        {
            pageType = "standard__webPage";
            url = "https://www.cnn.com";
        }
        else if (buttonLabel === "FOX News")
        {
            pageType = "standard__webPage";
            url = "https://www.foxnews.com";
        }
        else if (buttonLabel === "MSNBC")
        {
            pageType = "standard__webPage";
            url = "https://www.msnbc.com";
        }
 
        this.navigate(pageType, url);
    }

    navigate(pageType, url)
    {
        let attributes = {};
        attributes.url = url;

        let pageRef = {};
        pageRef.type = pageType;
        pageRef.attributes = attributes;

        this[NavigationMixin.Navigate](pageRef);
    }
}