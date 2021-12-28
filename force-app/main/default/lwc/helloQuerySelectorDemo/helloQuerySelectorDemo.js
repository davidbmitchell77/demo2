import { LightningElement } from 'lwc';

export default class HelloQuerySelectorDemo extends LightningElement
{
    isDisplayed = false;
    users = ["Gene", "Paul", "Ace", "Peter"];
 
    fetchDetailHandler()
    {
        const h1 = this.template.querySelector("h1");
        h1.style.border = "1px solid maroon";

        const userElements = this.template.querySelectorAll(".name");
        Array.from(userElements).forEach(element => {
            element.setAttribute("title", element.innerText);
        });

      //lwc:dom="manual" example  
        const childElement = this.template.querySelector(".child");
        childElement.innerHTML = "<p>Hey!&nbsp;&nbsp;I am a child element.</p>";

        this.isDisplayed = true;
    }
}