import { LightningElement } from 'lwc';

export default class HelloQuerySelectorDemo extends LightningElement
{
    isDisplayed = false;
    users = ["Gene Simmons", "Paul Stanley", "Ace Frehley", "Peter Criss"];
 
    showDetailsHandler()
    {
        const h1 = this.template.querySelector("h1");
        h1.style.color = "maroon";
        h1.style.fontWeight = "bold";

      //lwc:dom="manual" example
        const headerElement = this.template.querySelector(".header");
        headerElement.innerHTML = '<p style="color:#ff2400; font-weight:bold;">KISS ROCKS!!!</p>';

        const userElements = this.template.querySelectorAll(".name");
        Array.from(userElements).forEach(element => {
            element.setAttribute("title", element.innerText);
        });

        this.isDisplayed = true;
    }

    hideDetailsHandler()
    {
        const h1 = this.template.querySelector("h1");
        h1.style.color = "black";
        h1.style.fontWeight = "normal";

        const headerElement = this.template.querySelector(".header");
        headerElement.innerHTML = "";
 
        this.isDisplayed = false;
    }
}