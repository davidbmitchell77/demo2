import { LightningElement } from "lwc";
import HasViewAllData from "@salesforce/userPermission/ViewAllData";
import ModifyAllData from "@salesforce/userPermission/ModifyAllData";
import ManageEncyptionKeys from "@salesforce/userPermission/ManageEncyptionKeys";
import AssignPermissionSets from "@salesforce/userPermission/AssignPermissionSets";

export default class CheckPermissionDemo extends LightningElement
{
    values = [ true ];

    get userPermissions()
    {
        let results = new Array();

        results.push({ label: "View All Data", value: HasViewAllData });
        results.push({ label: 'Modify All Data', value: ModifyAllData });
        results.push({ label: 'REST API Access', value: ManageEncyptionKeys });
        results.push({ label: 'Assign Permission Sets', value: AssignPermissionSets });

        return results;
    }
}