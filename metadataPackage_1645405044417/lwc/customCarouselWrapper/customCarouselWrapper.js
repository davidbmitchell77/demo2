import { LightningElement } from "lwc";

import carousel_images from "@salesforce/resourceUrl/carousel";

export default class CustomCarouselWrapper extends LightningElement
{
    slides =
    [
        {
            image: `${carousel_images}/carousel/photo1.jpg`,
            heading: "Caption 1",
            description: "You can add description of first slide here"
        },
        {
            image: `${carousel_images}/carousel/photo2.jpg`,
            heading: "Caption 2",
            description: "You can add description of second slide here"
        },
        {
            image: `${carousel_images}/carousel/photo3.jpg`,
            heading: "Caption 3",
            description: "You can add description of third slide here"
        }
    ];
}