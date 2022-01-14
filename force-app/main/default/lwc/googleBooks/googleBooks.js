import { LightningElement } from "lwc";

const url = "https://www.googleapis.com/books/v1/volumes?q=";

export default class GoogleBooks extends LightningElement
{
    query = "robespierre";
    books = [];

    connectedCallback() {
        this.fetchBookData(url + this.query);
    }

    fetchBookData(s)
    {
      //fetch(s).then(response=>response.json()).then(data=>{ this.books = data; console.info(data); }).catch(error=>console.error(error));
        fetch(s)
       .then(response => response.json())
       .then(data     => { this.books = data.items; console.info(data.items); })
       .catch(error   => { console.error(error); });
    }

    changeHandler(event) {
        this.searchKey = event.target.value;
    }
}