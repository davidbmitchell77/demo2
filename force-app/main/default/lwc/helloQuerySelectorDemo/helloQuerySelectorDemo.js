import { LightningElement } from 'lwc';

export default class HelloQuerySelectorDemo extends LightningElement
{
    users = ["Gene", "Paul", "Ace", "Peter"];
 
    fetchDetailHandler()
    {
        const h1 = this.template.querySelector("h1");
        h1.style.border = "1px solid maroon";
      //console.log(h1.innerText);
        const userElements = this.template.querySelectorAll(".name");
        Array.from(userElements).forEach(element => {
            console.log(element.innerText);
        });
    }
}