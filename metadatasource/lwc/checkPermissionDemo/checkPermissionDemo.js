import { LightningElement } from "lwc";

import AssignPermissionSets from "@salesforce/userPermission/AssignPermissionSets";
import ManageEncyptionKeys  from "@salesforce/userPermission/ManageEncyptionKeys";
import ModifyAllData        from "@salesforce/userPermission/ModifyAllData";
import ViewAllData          from "@salesforce/userPermission/ViewAllData";

export default class CheckPermissionDemo extends LightningElement
{
    assignPermissionSets = AssignPermissionSets;
    manageEncyptionKeys  = ManageEncyptionKeys;
    modifyAllData        = ModifyAllData;
    viewAllData          = ViewAllData;

    get userPermissions()
    {
        let results = new Array();

        results.push({ label: "Assign Permission Sets", value: this.assignPermissionSets });
        results.push({ label: "View All Data", value: this.viewAllData });
        results.push({ label: "Modify All Data", value: this.modifyAllData });
        results.push({ label: "Manage Encryption Keys", value: this.manageEncyptionKeys });

        return results;
    }

    get checkedValues()
    {
        let results = new Array();
        results.push(true);
        return results;
    }
}