import { LightningElement, api } from 'lwc';

export default class P2cCarouselComponent extends LightningElement
{
    @api carouselData;

    handleClick(event)
    {
        event.preventDefault();
        window.open(event.target.href, event.target.dataset.target);
    }
}