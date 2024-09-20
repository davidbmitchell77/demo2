import { LightningElement          } from 'lwc';
import { httpStatusText, showToast } from 'c/utils';

export default class Fetch extends LightningElement {
    users;
    url = 'https://jsonplaceholder.typicode.com/users';  // YOU MUST ADD THIS URL TO: Setup > Security > Trusted URLs

    connectedCallback() {
        this.fetchData();
    }

    fetchData() {
        fetch(this.url).then((response) => {
            if (response.ok) {
                return response.json();
            }
            else {
                console.error(response);
                showToast(this, `${response.status}: ${httpStatusText[response.status]}`, `(${response.url})`, 'error', 'pester');
            }
        })
       .then((data) => {
            if (data) {
                console.info(data);
                this.users = data;
            }
        })
       .catch((error) => {
            console.error(error);
            showToast(this, `HTTP Error: ${error.message}`, `(${this.url})`, 'error', 'pester');
        });
    }
}