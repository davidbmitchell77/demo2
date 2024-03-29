import { LightningElement         } from 'lwc';
import { NavigationMixin          } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';

export default class NavigateToObjectPage extends NavigationMixin(LightningElement)
{
    clickHandler(event)
    {
        let pageType = "";
        let objectApiName = "";
        let actionName = "";
        let state = "";
        let values = {};

        let buttonLabel = event.target.label;

        if (buttonLabel === "New Lead")
        {
            pageType = "standard__objectPage";
            objectApiName = "Lead";
            actionName = "new";
            state = "defaultFieldValues";
        }
        else if (buttonLabel === "New Contact")
        {
            pageType = "standard__objectPage";
            objectApiName = "Contact";
            actionName = "new";
            state = "defaultFieldValues";
        }
        else if (buttonLabel === "New Lead (with default data)")
        {
            pageType = "standard__objectPage";
            objectApiName = "Lead";
            actionName = "new";
            state = "defaultFieldValues";
            values.Salutation = "Prof.";
            values.FirstName = "Angus";
            values.LastName = "Young";
            values.Email = "angus.young@acdc.com";
            values.Phone = "5555555555";
            values.Title = "Lead Guitar (Gibson SG)";
            values.LeadSource = "Phone Inquiry";
            values.Street = "1 Kings Cross";
            values.Company = "AC/DC, Inc.";
            values.City = "Sydney";
            values.State = "New South Wales";
            values.PostalCode = "1340";
            values.Country = "Australia";

        }
        else if (buttonLabel === "New Contact (with default data)")
        {
            pageType = "standard__objectPage";
            objectApiName = "Contact";
            actionName = "new";
            state = "defaultFieldValues";
            values.Salutation = "Mr.";
            values.FirstName = "Malcolm";
            values.LastName = "Young";
            values.Title = "Rhythm Guitar (Gretsch)";
            values.LeadSource = "Web";
            values.Email = "malcolm.young@acdc.com";
            values.Phone = "5555555555";
            values.Company = "AC/DC, Inc.";
            values.MailingStreet = "1 Kings Cross";
            values.MailingCity = "Sydney";
            values.MailingState = "New South Wales";
            values.MailingPostalCode = "1340";
            values.MailingCountry = "Australia";
        }
        else if (buttonLabel === "Account List View")
        {
            pageType = "standard__objectPage";
            objectApiName = "Account";
            actionName = "list";
            state = "filterName";
            values.filterName = "AllAccounts";
        }
        else if (buttonLabel === "Contact List View")
        {
            pageType = "standard__objectPage";
            objectApiName = "Contact";
            actionName = "list";
            state = "filterName";
            values.filterName = "AllContacts";
        }
        else if (buttonLabel === "Opportunity List View")
        {
            pageType = "standard__objectPage";
            objectApiName = "Opportunity";
            actionName = "list";
            state = "filterName";
            values.filterName = "AllOpportunities";
        }
        else if (buttonLabel === "Files")
        {
            pageType = "standard__objectPage";
            objectApiName = "ContentDocument";
            actionName = "home";
        }

        this.navigate(pageType, objectApiName, actionName, state, values);
    }

    navigate(pageType, objectApiName, actionName, st, values)
    {
        let attributes = {};
        attributes.objectApiName = objectApiName;
        attributes.actionName = actionName;

        let state = {};
        if (st === "defaultFieldValues") {
            state.defaultFieldValues = encodeDefaultFieldValues(values);
        }
        else if (st === "filterName") {
            state.filterName = values.filterName;
        }

        let pageRef = {};
        pageRef.type = pageType;
        pageRef.attributes = attributes;
        pageRef.state = state;

        this[NavigationMixin.Navigate](pageRef);
    }
}