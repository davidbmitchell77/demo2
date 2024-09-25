import { LightningElement } from 'lwc';

import USER_ID  from '@salesforce/user/Id';
import IS_GUEST from '@salesforce/user/isGuest';

export default class UserInformation extends LightningElement {
    userId  = USER_ID;
    isGuest = IS_GUEST;

    get isGuestYN() {
        return ((this.isGuest) ? 'Yes' : 'No');
    }
}