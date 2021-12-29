import { LightningElement, track } from 'lwc';

export default class HelloQuerySelectorDemo extends LightningElement
{
    @track isDisplayed = false;
    users = ["Gene", "Paul", "Ace", "Peter"];
 
    showDetailsHandler()
    {
        const h1 = this.template.querySelector("h1");
        h1.style.border = "1px solid maroon";

      //lwc:dom="manual" example 1
        const headerElement = this.template.querySelector(".header");
        headerElement.innerHTML = "<p>Hey!&nbsp;&nbsp;I am a header.</p>";

        const userElements = this.template.querySelectorAll(".name");
        Array.from(userElements).forEach(element => {
            element.setAttribute("title", element.innerText);
        });

      //lwc:dom="manual" example 2
        const footerElement = this.template.querySelector(".footer");
        footerElement.innerHTML = "<p>Hey!&nbsp;&nbsp;I am a footer.</p>";

        this.isDisplayed = true;
    }

    hideDetailsHandler()
    {
        const h1 = this.template.querySelector("h1");
        h1.style.border = "none";

        const headerElement = this.template.querySelector(".header");
        headerElement.innerHTML = "";
  
        const footerElement = this.template.querySelector(".footer");
        footerElement.innerHTML = "";
 
        this.isDisplayed = false;
    }
}