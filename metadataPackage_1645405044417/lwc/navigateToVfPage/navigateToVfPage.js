import { LightningElement } from 'lwc';
import { NavigationMixin  } from 'lightning/navigation';

export default class NavigateToVfPage extends NavigationMixin(LightningElement)
{
    clickHandler(event)
    {
        let pageType = "";
        let path = "";
        let target = "";
 
        let buttonLabel = event.target.label;
 
        if (buttonLabel === "Visualforce Page")
        {
            pageType = "standard__webPage";
            path = "/apex/navigateVfPage";
            target = "_blank";
            try {
                this.navigate(pageType, path, target);
            }
            catch(e) {
                console.error(e);
                this.open(path, target);
            }
        }
    }

    navigate(pageType, url, target)
    {
        let attributes = {};
        attributes.url = url;

        let pageRef = {};
        pageRef.type = pageType;
        pageRef.attributes = attributes;

        console.clear();

        console.info(`this[NavigationMixin.Navigate](${JSON.stringify(pageRef)});`);
        this[NavigationMixin.Navigate](pageRef);
        /* Promise DOES NOT WORK!!!
        .then(generatedUrl=>{
            console.log(`window.open(${generatedUrl}, "${target}");`);
            window.open(generatedUrl, "_blank");
        });
        */
    }

    open(path, target)
    {
        let protocol = window.location.protocol + "//";
        let hostname = window.location.host;
        let port = ((window.location.port) ? (":" + window.location.port) : "");
        let s = protocol + hostname + path;

        console.info(`window.open(${s}, "${target}");`);
        window.open(s, target).focus();
    }
}