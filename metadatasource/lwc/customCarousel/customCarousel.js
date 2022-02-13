/***********
 * enable-auto-scroll for autoScroll to enable
 * slide-timer for controlling the slider speed default is 3000
 * slides-data is the data and data should be in this format {image:'',heading:'',description:''}
 * show-full is for 100% width other wise use customWidth
 * custom-width is use for controlling the width of the slider manually
 *
 */
import { LightningElement, api } from "lwc";

const card_visible_classes = "fade slds-show";
const card_hidden_classes  = "fade slds-hide";
const dot_visible_classes  = "dot active";
const dot_hidden_classes   = "dot";
const default_slider_timer = 3000;
const default_slider_width = 700;

export default class CustomCarousel extends LightningElement
{
    @api slideTimer       = default_slider_timer;
    @api customWidth      = default_slider_width;
    @api enableAutoScroll = false;
    @api showFull         = false;

    slides = [];
    slideIndex = 1;
    timer;

    @api
    get slidesData() {
        return this.slides;
    }

    get maxWidth() {
        return ((this.showFull) ? `width:100%` : `width:${Number(this.customWidth)}px`);
    }

    set slidesData(data)
    {
        this.slides = data.map
        (
            (item, index) => {
                return ((index === 0) ? { ...item, slideIndex: (index + 1), cardClasses: card_visible_classes, dotClases: dot_visible_classes } : { ...item, slideIndex: (index + 1), cardClasses: card_hidden_classes, dotClases: dot_hidden_classes });
            }
        );
    }

    connectedCallback()
    {
        if (this.enableAutoScroll) {
            this.timer = window.setInterval(()=>{ this.slideSelectionHandler(this.slideIndex + 1) }, Number(this.slideTimer));
        }
    }

    disconnectedCallback()
    {
        if (this.enableAutoScroll) {
            window.clearInterval(this.timer);
        }
    }

    currentSlide(event) {
        let slideIndex = Number(event.target.dataset.id);
        this.slideSelectionHandler(slideIndex);
    }

    backSlide() {
        let slideIndex = (this.slideIndex - 1);
        this.slideSelectionHandler(slideIndex);
    }

    forwardSlide() {
       let slideIndex = (this.slideIndex + 1);
       this.slideSelectionHandler(slideIndex);
    }

    slideSelectionHandler(id)
    {
        if (id > this.slides.length) {
            this.slideIndex = 1;
        }
        else if (id < 1) {
            this.slideIndex = this.slides.length;
        }
        else {
            this.slideIndex = id;
        }
        this.slides = this.slides.map
        (
            (item) => {
                return ((this.slideIndex === item.slideIndex) ? { ...item, cardClasses: card_visible_classes, dotClases: dot_visible_classes } : { ...item, cardClasses: card_hidden_classes, dotClases: dot_hidden_classes });
            }
        );
    }
}