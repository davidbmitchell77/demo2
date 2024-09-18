import { LightningElement } from 'lwc';

export default class Fetch extends LightningElement {
    users;
    
    url = 'https://jsonplaceholder.typicode.com/users/';  // YOU MUST ADD THIS URL TO: Setup > Security > Trusted URLs

    connectedCallback() {
        fetch(this.url)
          .then((response) => {
            return response.json();
          })
          .then((data) => {
            console.clear();
            console.info(data);
            this.users = [ ...data ];
          })
          .catch((error) => {
            console.error(error);
          });
    }
}