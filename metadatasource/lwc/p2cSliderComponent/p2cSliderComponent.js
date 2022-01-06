import { LightningElement, api } from 'lwc';

export default class P2cSliderComponent extends LightningElement
{
    value = 20;
 
    changeHandler(event) {
        this.value = event.target.value;
    }
 
    @api resetSlider() {
        this.value = 0;
    }
}