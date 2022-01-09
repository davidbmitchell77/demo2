import { LightningElement, api } from 'lwc';

import Contact   from '@salesforce/schema/Contact';
import Name      from '@salesforce/schema/Contact.Name';
import Title     from '@salesforce/schema/Contact.Title';
import Phone     from '@salesforce/schema/Contact.Phone';
import Email     from '@salesforce/schema/Contact.Email';
import AccountId from '@salesforce/schema/Contact.AccountId';

export default class RecordEditForm extends LightningElement
{
    @api objectApiName = Contact;
    @api recordId = null;

    fields =
    {
        name: Name,
        title: Title,
        phone: Phone,
        email: Email,
        AccountId: AccountId
    };

    reset(event)
    {
        const fields = this.template.querySelectorAll("lightning-input-field");

        if (fields)
        {
            Array.from(fields).forEach(field => { field.reset(); });
        }
    }
}