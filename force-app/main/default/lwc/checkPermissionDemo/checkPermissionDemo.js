import { LightningElement } from "lwc";
import HasViewAllData from "@salesforce/userPermission/ViewAllData";
import ModifyAllData from "@salesforce/userPermission/ModifyAllData";
import ManageEncyptionKeys from "@salesforce/userPermission/ManageEncyptionKeys";
import AssignPermissionSets from "@salesforce/userPermission/AssignPermissionSets";

export default class CheckPermissionDemo extends LightningElement
{
    hasViewAllData = HasViewAllData;
    modifyAllData = ModifyAllData;
    manageEncyptionKeys = ManageEncyptionKeys;
    assignPermissionSets = AssignPermissionSets;

    values = [ true ];

    get userPermissions()
    {
        let results = new Array();

        results.push({ label: "View All Data", value: this.hasViewAllData });
        results.push({ label: "Modify All Data", value: this.modifyAllData });
        results.push({ label: "Manage Encryption Keys", value: this.manageEncyptionKeys });
        results.push({ label: "Assign Permission Sets", value: this.assignPermissionSets });

        return results;
    }

    get checkedValues()
    {
        let results = new Array();

        results.push(true);

        return results;

    }
}