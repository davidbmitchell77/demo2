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
        postalCode: "91913",
        country: "United States"
    }

    changeHandler(event) {
        this.title = event.target.value;
    }

    trackHandler(event) {
        this.address.city = event.target.value;
    }

    get foobar() {
        return (this.num1 ** this.num2);
    }
}