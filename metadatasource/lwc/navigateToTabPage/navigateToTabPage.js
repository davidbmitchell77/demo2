import { LightningElement } from 'lwc';
import { NavigationMixin  } from 'lightning/navigation';

export default class NavigateToTabPage extends NavigationMixin(LightningElement)
{
    clickHandler(event)
    {
        let pageType = "";
        let apiName = "";
        let actionName = "";
        let filterName = "";

        let buttonLabel = event.target.label;

        if (buttonLabel === "Leads")
        {
            pageType = "standard__objectPage";
            apiName = "Lead";
            actionName = "list";
            filterName = "AllOpenLeads";
        }
        else if (buttonLabel === "Opportunities")
        {
            pageType = "standard__objectPage";
            apiName = "Opportunity";
            actionName = "list";
            filterName = "AllOpportunities";
        }
        else if (buttonLabel === "Accounts")
        {
            pageType = "standard__objectPage";
            apiName = "Account";
            actionName = "list";
            filterName = "AllAccounts";
        }
        else if (buttonLabel === "Components Communication")
        {
            pageType = "standard__navItemPage";
            apiName = "Components_Communication";
        }

        this.navigate(pageType, apiName, actionName, filterName);
    }

    navigate(pageType, apiName, actionName, filterName)
    {

        let attributes = {};
        attributes.objectApiName = apiName;
        attributes.apiName = apiName;
        attributes.actionName = actionName;

        let state = {};
        state.filterName = filterName;

        let pageRef = {};
        pageRef.type = pageType;
        pageRef.attributes = attributes;
        pageRef.state = state;

        this[NavigationMixin.Navigate](pageRef);
    }
}