import { LightningElement } from 'lwc';
import { NavigationMixin  } from 'lightning/navigation';

export default class NavigateToObjectPage extends NavigationMixin(LightningElement)
{
    handleClick(event)
    {
        let buttonLabel = event.target.label;
        let objectApiName = "";
        let actionName = ""

        if (buttonLabel === "New Lead")
        {
            objectApiName = "Lead";
            actionName = "new";
        }
        else if (buttonLabel === "New Contact")
        {
            objectApiName = "Contact";
            actionName = "new";
        }

        this.navigate(objectApiName, actionName);
    }

    navigate(objectApiName, actionName)
    {
        try
        {
            this[NavigationMixin.Navigate]
            ({
                type: "standard__objectPage",
                attributes: {
                    objectApiName: objectApiName,
                    actionName: actionName
                }
            });
        }
        catch(e) {
            console.error(e);
        }
    }
}