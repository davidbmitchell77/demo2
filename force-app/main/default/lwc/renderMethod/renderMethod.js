import { LightningElement } from 'lwc';

import loginTemplate  from './loginTemplate.html';
import signupTemplate from './signupTemplate.html';
import renderTemplate from './renderMethod.html';

export default class RenderMethod extends LightningElement {
    selectedButton = '';

    render() {
        let result = renderTemplate;
        if (this.selectedButton.toLowerCase() === 'signup') {
            result = signupTemplate;
        }
        if (this.selectedButton.toLowerCase() === 'login') {
            result = loginTemplate;
        }
        return result;
    }

    handleClick(event) {
        this.selectedButton = event.target.label;
    }

    submitHandler(event) {
        console.log(`${event.target.label} successfully.`);
    }
}