import { LightningElement } from 'lwc';

import AssignPermissionSets from '@salesforce/userPermission/AssignPermissionSets';
import ManageEncryptionKeys from '@salesforce/userPermission/ManageEncryptionKeys';
import ModifyAllData        from '@salesforce/userPermission/ModifyAllData';
import ViewAllData          from '@salesforce/userPermission/ViewAllData';
import DataExport           from '@salesforce/userPermission/DataExport';

export default class CheckPermissionDemo extends LightningElement {
    assignPermissionSets = AssignPermissionSets;
    manageEncryptionKeys = ManageEncryptionKeys;
    modifyAllData        = ModifyAllData;
    viewAllData          = ViewAllData;
    dataExport           = DataExport;

    get userPermissions() {
        let results = new Array();
        results.push({ label: 'Assign Permission Sets', value: this.assignPermissionSets });
        results.push({ label: 'View All Data'         , value: this.viewAllData          });
        results.push({ label: 'Modify All Data'       , value: this.modifyAllData        });
        results.push({ label: 'Manage Encryption Keys', value: this.manageEncryptionKeys });
        results.push({ label: 'Export Data'           , value: this.dataExport           });
        return results;
    }

    get checkedValues() {
        let results = new Array();
        results.push(true);
        return results;
    }
}