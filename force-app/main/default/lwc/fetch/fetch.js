import { LightningElement } from 'lwc';
import { showToast        } from 'c/utils'

const HTTP_STATUS = {
  200: 'OK',
  302: 'Found',
  303: 'See Other',
  304: 'Not Modified',
  307: 'Temporary Redirect',
  308: 'Resume Incomplete',
  400: 'Bad Request',
  401: 'Unauthorized',
  403: 'Forbidden',
  404: 'Not Found',
  405: 'Method Not Allowed',
  408: 'Request Timeout',
  409: 'Conflict',
  410: 'Gone',
  411: 'Length Required',
  412: 'Precondition Failed',
  413: 'Payload Too Large',
  416: 'Requested Range Not Satisfiable',
  429: 'Too Many Requests',
  499: 'Client Closed Request',
  500: 'Internal Server Error',
  502: 'Bad Gateway',
  503: 'Service Unavailable',
  504: 'Gateway Timeout'
};

export default class Fetch extends LightningElement {
    users;

    url = 'https://jsonplaceholder.typicode.com/users';  // YOU MUST ADD THIS URL TO: Setup > Security > Trusted URLs

    connectedCallback() {
        fetch(this.url)
       .then((response) => {
            console.clear();
            console.info(response);
            if (!response.ok) {
              showToast(this, `${response.status}`, `${HTTP_STATUS[response.status]} (${response.url})`, 'error', 'pester');
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