import { LightningElement } from 'lwc';
import { showToast        } from 'c/utils'

const HTTP_STATUS = {
  200: 'OK',
  201: 'Created',
  202: 'Accepted',
  203: 'Non-Authoritative Information',
  204: 'No Content',
  205: 'Reset Content',
  206: 'Partial Content',
  207: 'Multi-Status',
  208: 'Already Reported',
  218: 'This is fine (Apache Web Server)',
  226: 'IM Used',
  302: 'Found',
  303: 'See Other',
  304: 'Not Modified',
  307: 'Temporary Redirect',
  308: 'Resume Incomplete',
  400: 'Bad Request',
  401: 'Unauthorized',
  402: 'Payment Required',
  403: 'Forbidden',
  404: 'Not Found',
  405: 'Method Not Allowed',
  406: 'Not Acceptable',
  407: 'Proxy Authentication Required',
  408: 'Request Timeout',
  409: 'Conflict',
  410: 'Gone',
  411: 'Length Required',
  412: 'Precondition Failed',
  413: 'Payload Too Large',
  414: 'Request URI Too Long',
  415: 'Unsupported Media Type',
  416: 'Requested Range Not Satisfiable',
  417: 'Expectation Failed',
  418: 'I\'m a Teapot',
  419: 'Page Expired (Laravel Framework)',
  420: 'Method Failure (Spring Framework)',
  421: 'Misdirected Request',
  422: 'Unprocessable Entity',
  423: 'Locked',
  429: 'Too Many Requests',
  440: 'Login Timeout',
  450: 'Blocked by Windows Parental Controls',
  451: 'Unavailable For Legal Reasons',
  494: 'Request Header Too Large',
  495: 'SSL Certificate Error',
  496: 'SSL Certificate Required',
  497: 'HTTP Request Sent to HTTPS Port',
  498: 'Invalid Token',
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