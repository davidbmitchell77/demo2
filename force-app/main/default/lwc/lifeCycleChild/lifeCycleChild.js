import { LightningElement } from 'lwc';

export default class LifeCycleChild extends LightningElement
{
    interval;

    constructor() {
        super();
        console.log("Child constructor called.");
    }
 
    connectedCallback() {
        console.log("Child connectedCallback called.");
        this.interval = window.setInterval(() => { console.log("Child 10 second interval.") }, (10 * 1000));
    }
 
    renderedCallback() {
        console.log("Child renderedCallback called.");
    }

    disconnectedCallback() {
        console.log("Child disconnectedCallback called!");
        window.clearInterval(this.interval);
    }
}