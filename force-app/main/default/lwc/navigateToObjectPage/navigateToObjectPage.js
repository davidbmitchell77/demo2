import { LightningElement         } from 'lwc';
import { NavigationMixin          } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';

export default class NavigateToObjectPage extends NavigationMixin(LightningElement)
{
    handleClick(event)
    {
        let buttonLabel = event.target.label;
        let objectApiName = "";
        let actionName = "";
        let defaultFieldValues = {};

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
        else if (buttonLabel === "New Lead (with default data)")
        {
            objectApiName = "Lead";
            actionName = "new";
            defaultFieldValues.FirstName = "Angus";
            defaultFieldValues.LastName = "Young";
            defaultFieldValues.Email = "angus.young@acdc.com";
            defaultFieldValues.Title = "Lead Guitar (Gibson SG)";
            defaultFieldValues.LeadSource = "Phone Inquiry";
            defaultFieldValues.City = "Sydney";
            defaultFieldValues.State = "New South Wales";
            defaultFieldValues.Country = "Australia";

        }
        else if (buttonLabel === "New Contact (with default data)")
        {
            objectApiName = "Contact";
            actionName = "new";
            defaultFieldValues.FirstName = "Malcolm";
            defaultFieldValues.LastName = "Young";
            defaultFieldValues.Title = "Rhythm Guitar (Gretsch)";
            defaultFieldValues.Email = "malcolm.young@acdc.com";
            defaultFieldValues.Phone = "5555555555";
            defaultFieldValues.MailingCity = "Sydney";
            defaultFieldValues.MailingState = "New South Wales";
            defaultFieldValues.MailingCountry = "Australia";
        }

        this.navigate(objectApiName, actionName, defaultFieldValues);
    }

    navigate(objectApiName, actionName, defaultFieldValues)
    {
        try
        {
            this[NavigationMixin.Navigate]
            ({
                type: "standard__objectPage",
                attributes: {
                    objectApiName: objectApiName,
                    actionName: actionName
                },
                state: {
                    defaultFieldValues: encodeDefaultFieldValues(defaultFieldValues)
                }
            });
        }
        catch(e) {
            console.error(e);
        }
    }
}