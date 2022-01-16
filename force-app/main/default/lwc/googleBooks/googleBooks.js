import { LightningElement } from "lwc";

const url = "https://www.googleapis.com/books/v1/volumes?q=";

export default class GoogleBooks extends LightningElement
{
    query = "William The Conqueror";
    books = [];
    timer;

    connectedCallback() {
        this.findBooks(url + this.query);
    }

    disconnectedCallback()
    {
        if (this.timer) {
            this.timer = null;
        }
    }

    findBooks(s)
    {
        fetch(s)
       .then(response => response.json()
       .then(data     => { this.books = data.items; }))
      .catch(error    => { this.log(error); });
    }

    changeHandler(event)
    {
        this.query = url + event.target.value;
        window.clearTimeout(this.timer);
        this.timer = setTimeout(
            () => { this.findBooks(this.query); },
            (0.75 * 1000)
        );
    }

    log(message)
    {
        let messageType = Object.prototype.toString.call(message);

        if (messageType === "[object String]") { console.log(message);   }
        if (messageType === "[object Array]" ) { console.info(message);  }
        if (messageType === "[object Object]") { console.info(message);  }
        if (messageType === "[object Error]" ) { console.error(message); }
    }
}