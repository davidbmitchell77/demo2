import { LightningElement          } from 'lwc';
import { httpStatusText, showToast } from 'c/utils';

export default class FetchAwait extends LightningElement {
    users;
    url = 'https://jsonplaceholder.typicode.com/users';  // YOU MUST ADD THIS URL TO: Setup > Security > Trusted URLs

    async connectedCallback() {
        await this.fetchData();
    }

    async fetchData() {
        try {
            const response = await fetch(this.url);
            const data = await response.json();
            console.info(data);
            this.users = data;
        }
        catch(error) {
            console.error(error);
            showToast(this, 'Error!', `${error.message} (${this.url})`, 'error', 'pester');
        }
    }
}