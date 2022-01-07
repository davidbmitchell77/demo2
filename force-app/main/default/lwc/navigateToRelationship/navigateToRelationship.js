import { LightningElement } from 'lwc';
import { NavigationMixin  } from 'lightning/navigation';

export default class NavigateToRelationship extends NavigationMixin(LightningElement)
{
    clickHandler(event)
    {
        let pageType = "";
        let objectApiName = "";
        let relationshipApiName = "";
        let recordId = "";
        let actionName = "";

        let buttonLabel = event.target.label;

        if (buttonLabel === "Account Contacts")
        {
            pageType = "standard__recordRelationshipPage";
            objectApiName = "Account";
            relationshipApiName = "Contacts";
            recordId = "0010R00001NYNimQAH";
            actionName = "view";
        }
        else if (buttonLabel === "Case Activities")
        {
            pageType = "standard__recordRelationshipPage";
            objectApiName = "Case";
            relationshipApiName = "OpenActivities";
            recordId = "5000R000008WgDzQAK";
            actionName = "view";
        }
        else if (buttonLabel === "Opportunity Sales Stages")
        {
            pageType = "standard__recordRelationshipPage";
            objectApiName = "Opportunity";
          //relationshipApiName = "OpportunityLineItems";
            relationshipApiName = "OpportunityHistories";
            recordId = "0060R00000HbU6gQAF";
            actionName = "view";
        }

        this.navigate(pageType, objectApiName, relationshipApiName, recordId, actionName);
    }

    navigate(pageType, objectApiName, relationshipApiName, recordId, actionName)
    {
        let attributes = {};
        attributes.objectApiName = objectApiName;
        attributes.relationshipApiName = relationshipApiName;
        attributes.recordId = recordId;
        attributes.actionName = actionName;

        let pageRef = {};
        pageRef.type = pageType;
        pageRef.attributes = attributes;

        this[NavigationMixin.Navigate](pageRef);
    }
}