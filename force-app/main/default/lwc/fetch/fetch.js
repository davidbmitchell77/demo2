import { LightningElement } from 'lwc';

export default class Fetch extends LightningElement {

    url = 'https://jsonplaceholder.typicode.com/users/';

    connectedCallback() {
        fetch(this.url)
          .then((response) => {
            return response.json();
          })
          .then((data) => {
            console.clear();
            console.info(data);

          })
          .catch((error) => {
            console.error(error);
          });
    }
}