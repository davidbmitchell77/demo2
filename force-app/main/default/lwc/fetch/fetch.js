import { LightningElement } from 'lwc';
import { showToast        } from 'c/utils'
import { httpStatusText   } from 'c/utils';

export default class Fetch extends LightningElement {
    users;

    url = 'https://jsonplaceholder.typicode.com/users';  // YOU MUST ADD THIS URL TO: Setup > Security > Trusted URLs

    connectedCallback() {
        fetch(this.url)
       .then((response) => {
            console.clear();
            console.info(response);
            if (!response.ok) {
              showToast(this, `${response.status}`, `${httpStatusText[response.status]} (${response.url})`, 'error', 'pester');
            }
            return response.json();
        })
       .then((data) => {
            console.info(data);
            this.users = data;
        })
       .catch((error) => {
            showToast(this, 'Error!', `${error.message} (${this.url})`, 'error', 'pester');
        });
    }
}