import { LightningElement } from 'lwc';
import { NavigationMixin  } from 'lightning/navigation';

export default class NavigateToHome extends NavigationMixin(LightningElement)
{
    handleClick(event)
    {
        let buttonLabel = event.target.label;
        let pageName = "";

        if (buttonLabel === "Navigate to Home") {
            pageName = "home";
        }
        else if (buttonLabel === "Navigate to Chatter") {
            pageName = "chatter";
        }

        this.navigate(pageName);
    }

    navigate(pageName)
    {
        try
        {
            this[NavigationMixin.Navigate]
            ({
                type: "standard__namedPage",
                attributes: {
                    pageName: pageName
                }
            });
        }
        catch(e) {
            console.error(e);
        }
    }
}