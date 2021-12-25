import { LightningElement, track } from 'lwc';

export default class HelloWorld extends LightningElement
{
    fullname = "Zero to Hero";
    title = "LWC";
    num1 = 0;
    num2 = 0;
 
    @track address =
    {
        city: "Chula Vista",
        state: "California",
        zip: "91913",
        country: "United States"
    }

    changeHandler(event) {
        this.title = event.target.value;
    }

    trackHandler(event) {
        this.address.city = event.target.value;
    }

    num1Handler(event) {
        this.num1 = ((event.target.value != null) ? event.target.value : 0);
    }
 
    num2Handler(event) {
        this.num2 = ((event.target.value != null) ? event.target.value : 0);
    }
 
    get result() {
        return (this.num1 ** this.num2);
    }
}