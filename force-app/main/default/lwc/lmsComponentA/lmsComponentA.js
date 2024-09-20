import { LightningElement, wire  } from 'lwc';
import { MessageContext, publish } from 'lightning/messageService';
import { getRecord               } from 'lightning/uiRecordApi';
import { days, months, right     } from 'c/utils';

import MESSAGE_CHANNEL from '@salesforce/messageChannel/SampleMessageChannel__c';

import USER_ID         from '@salesforce/user/Id';
import USER_ALIAS      from '@salesforce/schema/User.Alias';
import USER_EMAIL      from '@salesforce/schema/User.Email';
import USER_USERNAME   from '@salesforce/schema/User.Username';

export default class LmsComponentA extends LightningElement {

    @wire(MessageContext)
    messageContext;

    @wire(getRecord, { recordId: USER_ID, fields: [ USER_EMAIL, USER_ALIAS, USER_USERNAME ]})
    user

    inputValue;
    noInput = true;
    status;

    connectedCallback() {
        this.status = `Today is ${this.currentDate()}.`;
    }

    inputHandler(event){
        this.inputValue = event.target.value.trim();
        this.noInput = (this.inputValue ? false : true);
        this.status = (`Today is ${this.currentDate()}.`);
    }

    message() {
        return {
                   lmsData: { value: this.inputValue                      },
                  senderId: { value: USER_ID                              },
               senderAlias: { value: this.user.data.fields.Alias.value    },
               senderEmail: { value: this.user.data.fields.Email.value    },
            senderUsername: { value: this.user.data.fields.Username.value }
        };
    }

    publishMessage() {
        publish(this.messageContext, MESSAGE_CHANNEL, this.message());
        this.template.querySelector('lightning-input').value = null;
        this.noInput = true;
        this.status = (`Message published on ${this.currentDate()} at ${this.currentTime()}.`);
    }

    currentDate() {
        let today = new Date();
        let mm = months.get(today.getMonth());
        let day = days.get(today.getDay());
        let dd = today.getDate();
        let yyyy = today.getFullYear();
        return (`${day}, ${mm} ${dd}, ${yyyy}`);
    }

    currentTime() {
        let today = new Date();
        let hr = right('0' + today.getHours(), 2);
        let mi = right('0' + today.getMinutes(), 2);
        let ss = right('0' + today.getSeconds(), 2);
        let ms = right('00' + today.getMilliseconds(), 3);
        let offset = right('0' + (today.getTimezoneOffset() / -60), 2);
        return (`${hr}:${mi}:${ss}.${ms} (UTC ${offset}:00)`);
    }
}