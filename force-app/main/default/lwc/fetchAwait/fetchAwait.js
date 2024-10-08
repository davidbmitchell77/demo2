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
            if (response.ok) {
                const data = await response.json();
                console.info(data);
                this.users = data;
            }
            else {
                console.error(response);
                showToast(this, `${response.status}: ${httpStatusText[response.status]}`, `(${response.url})`, 'error', 'pester');
            }
        }
        catch(error) {
            console.error(`${error.message}:`, this.url);
            showToast(this, `HTTP Error: ${error.message}`, `(${this.url})`, 'error', 'pester');
        }
    }
}