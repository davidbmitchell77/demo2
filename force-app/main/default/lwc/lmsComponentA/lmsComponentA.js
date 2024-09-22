import { LightningElement, wire   } from 'lwc';
import { MessageContext, publish  } from 'lightning/messageService';
import { getRecord                } from 'lightning/uiRecordApi';
import { currentDate, currentTime } from 'c/utils';

import MESSAGE_CHANNEL from '@salesforce/messageChannel/SampleMessageChannel__c';

import USER_ID         from '@salesforce/user/Id';
import USER_ALIAS      from '@salesforce/schema/User.Alias';
import USER_EMAIL      from '@salesforce/schema/User.Email';
import USER_USERNAME   from '@salesforce/schema/User.Username';

export default class LmsComponentA extends LightningElement {
    inputValue;
    noInput = true;
    status;

    @wire(MessageContext)
    messageContext;

    @wire(getRecord, { recordId: USER_ID, fields: [ USER_EMAIL, USER_ALIAS, USER_USERNAME ]})
    user

    connectedCallback() {
        this.status = `Today is ${currentDate()}.`;
    }

    inputHandler(event) {
        this.inputValue = event.target.value.trim();
        this.noInput = (this.inputValue ? false : true);
        this.status = (`Today is ${currentDate()}.`);
    }

    message() {
        return {
                   message: { value: this.inputValue                      },
                  senderId: { value: USER_ID                              },
               senderAlias: { value: this.user.data.fields.Alias.value    },
               senderEmail: { value: this.user.data.fields.Email.value    },
            senderUsername: { value: this.user.data.fields.Username.value },
                 timestamp: { value: new Date()                           }
        };
    }

    publishMessage() {
        this.status = (`Message published on ${currentDate()} at ${currentTime()}.`);
        publish(this.messageContext, MESSAGE_CHANNEL, this.message());
        this.template.querySelector('lightning-input').value = null;
        this.noInput = true;
    }
}