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
      //fetch(s).then(response=>response.json()).then(data=>{ this.books = data; console.info(data); }).catch(error=>console.error(error));
        fetch(s)
       .then(response => response.json()
       .then(data     => { this.books = data.items; console.info(data.items); }))
      .catch(error   =>  { console.error(error); });
    }

    changeHandler(event)
    {
        this.query = event.target.value;
        window.clearTimeout(this.timer);
        this.timer = setTimeout(() => { this.findBooks(url + this.query) }, 750);
    }
}