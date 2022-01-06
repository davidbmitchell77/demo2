import { LightningElement, api } from 'lwc';

export default class SetterDemoChild extends LightningElement
{
    userDetails;
 
    @api
    get details() {
        return this.userDetails;
    }

    set details(data)
    {
        let newAge = Math.round(data.age * 1.7);
        this.userDetails = {...data, age:newAge, location:"Sydney, Australia"};
    }
}