import { LightningElement } from 'lwc';

export default class LifeCycleParent extends LightningElement
{
    isChildVisible = false;

    constructor() {
        super();
        console.log("Parent constructor called.");
    }
 
    connectedCallback() {
        console.log("Parent connectedCallback called.");
    }
 
    renderedCallback() {
        console.log("Parent renderedCallback called.")
    }

    errorCallback(error, stack) {
        console.log("Parent errorCallback called.")
        console.log(error.message);
        console.log(stack)
    }

    handleClick() {
        this.isChildVisible = !(this.isChildVisible);
    }
}