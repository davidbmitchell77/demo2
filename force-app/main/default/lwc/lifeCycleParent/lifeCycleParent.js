import { LightningElement } from 'lwc';

export default class LifeCycleParent extends LightningElement
{
    name = "";

    constructor() {
        super();
        console.log("Parent constructor called.");
    }
 
    connectedCallback() {
        console.log("Parent connectedCallback called.");
    }
 
    renderedCallback() {
        console.log("Parent rederedCallback called.")
    }

    changeHandler(event) {
        this.name = event.target.value;
    }
}