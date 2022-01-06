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
            header: "MSNBC",
            description: "24/7 News for the Next Generation.",
            href: "https://www.msnbc.com"
        },
        {
            src: "https://www.lightningdesignsystem.com/assets/images/carousel/carousel-02.jpg",
            header: "FOX News",
            description: "America's News.  And Much More™",
            href: "https://www.foxnews.com"
        },
        {
            src: "https://www.lightningdesignsystem.com/assets/images/carousel/carousel-03.jpg",
            header: "CNN",
            description: "Breakng News, Latest News, and Videos.",
            href: "https://www.cnn.com"
        },
        {
            src: "https://www.lightningdesignsystem.com/assets/images/carousel/carousel-02.jpg",
            header: "Al-Jazeera",
            description: ".كل الأخبار المناسبة للطباعة",
            href: "https://www.aljazeera.com/"
        }
    ];

    changeHandler(event) {
        this.percentage = event.target.value;
    }
    
    clickHandler() {
        this.template.querySelector("c-p2c-slider-component").resetSlider();
    }
}