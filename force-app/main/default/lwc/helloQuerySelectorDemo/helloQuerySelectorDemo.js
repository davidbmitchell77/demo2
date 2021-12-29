import { LightningElement } from 'lwc';

export default class HelloQuerySelectorDemo extends LightningElement
{
    isDisplayed = false;
    users = ["Gene", "Paul", "Ace", "Peter"];
 
    showDetailsHandler()
    {
        const h1 = this.template.querySelector("h1");
        h1.style.border = "2px solid maroon";

      //lwc:dom="manual" example
        const headerElement = this.template.querySelector(".header");
        headerElement.innerHTML = "<p>Hey!&nbsp;&nbsp;I am a header.</p>";

        const userElements = this.template.querySelectorAll(".name");
        Array.from(userElements).forEach(element => {
            element.setAttribute("title", element.innerText);
        });

        this.isDisplayed = true;
    }

    hideDetailsHandler()
    {
        const h1 = this.template.querySelector("h1");
        h1.style.border = "none";

        const headerElement = this.template.querySelector(".header");
        headerElement.innerHTML = "";
 
        this.isDisplayed = false;
    }
}