import { LightningElement, wire } from 'lwc';

import getAccountListByType from '@salesforce/apex/AccountController.getAccountListByType';

export default class ApexWireWithParams extends LightningElement {
    selectedType = null;

    @wire(getAccountListByType, { type: '$selectedType' })
    filteredAccounts;

    typeHandler(event) {
        this.selectedType = event.target.value;
    }

    get accountTypeOptions() {
        let options = [];
        options.push({ label: '--None--'             , value: null                   });
        options.push({ label: 'Customer - Channel'   , value: 'Customer - Channel'   });
        options.push({ label: 'Customer - Direct'    , value: 'Customer - Direct'    });
        options.push({ label: 'Installation Partner' , value: 'Installation Partner' });
        options.push({ label: 'Prospect'             , value: 'Prospect'             });
        options.push({ label: 'Technology Partner'   , value: 'Technology Partner'   });
        return options;
    }
}