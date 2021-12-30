import { LightningElement } from 'lwc';

export default class P2cParentComponent extends LightningElement
{
    cardHeading = "Parent to Child primitive data communication";
    message = "Hurray!  I got the data.";
    n = 20;
    percentage = 10;
 
    carouselData =
    [
        {
            src: "https://www.lightningdesignsystem.com/assets/images/carousel/carousel-01.jpg",
            header: "First description.",
            description: "Go to MSNBC website.",
            href: "https://www.msnbc.com"
        },
        {
            src: "https://www.lightningdesignsystem.com/assets/images/carousel/carousel-02.jpg",
            header: "Second description.",
            description: "Go to Fox News website.",
            href: "https://www.foxnews.com"
        },
        {
            src: "https://www.lightningdesignsystem.com/assets/images/carousel/carousel-03.jpg",
            header: "Third description.",
            description: "Go to CNN website.",
            href: "https://www.cnn.com"
        }
    ];

    changeHandler(event) {
        this.percentage = event.target.value;
    }
}