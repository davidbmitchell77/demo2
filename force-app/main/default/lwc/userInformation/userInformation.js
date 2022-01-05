import { LightningElement } from 'lwc';
import user_id from '@salesforce/user/Id';
import is_guest from '@salesforce/user/isGuest';

export default class UserInformation extends LightningElement
{
    userId = user_id;
    isGuest = is_guest;

    get isGuestYN() {
        return ((this.isGuest) ? "Yes" : "No");
    }
}