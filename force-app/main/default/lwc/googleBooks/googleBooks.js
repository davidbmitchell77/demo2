import { LightningElement } from "lwc";

const url = "https://www.googleapis.com/books/v1/volumes?q=";

export default class GoogleBooks extends LightningElement
{
    query = "William The Conqueror";
    books = [];
    timer;

    connectedCallback() {
        this.findBooks(url + this.query);
    }

    disconnectedCallback()
    {
        if (this.timer) {
            this.timer = null;
        }
    }

    findBooks(s)
    {
        fetch(s)
       .then(response => response.json()
       .then(data     => { this.books = data.items; }))
      .catch(error    => { this.log(error); });
    }

    changeHandler(event)
    {
        this.query = event.target.value;
        window.clearTimeout(this.timer);
        this.timer = setTimeout(
            () => { this.findBooks(url + this.query); },
            (0.75 * 1000)
        );
    }

    clickHandler(event)
    {
        let name = event.target.name;

        if (name.toLowerCase().includes("https://"))
        {
            this.popupCenter
            (
                name,
                "_blank",
                1300,
                850
            );
            return false;
        }
    }

    log(message)
    {
        let messageType = Object.prototype.toString.call(message);

        if (messageType === "[object String]") { console.log(message);   }
        if (messageType === "[object Array]" ) { console.info(message);  }
        if (messageType === "[object Object]") { console.info(message);  }
        if (messageType === "[object Error]" ) { console.error(message); }
    }

    popupCenter(url, title, w, h)
    {
      //Fixes dual-screen position                                most browsers       firefox
        const dualScreenLeft = window.screenLeft !==  undefined ? window.screenLeft : window.screenX;
        const dualScreenTop  = window.screenTop  !==  undefined ? window.screenTop  : window.screenY;

        const width  = window.innerWidth  ? window.innerWidth  : document.documentElement.clientWidth  ? document.documentElement.clientWidth  : screen.width;
        const height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

        const systemZoom = width / window.screen.availWidth;
        const left = (width - w) / 2 / systemZoom + dualScreenLeft;
        const top = (height - h) / 2 / systemZoom + dualScreenTop;
        const newWindow = window.open
        (
            url,
            title,
            `
            scrollbars=yes,
            width=${w / systemZoom},
            height=${h / systemZoom},
            top=${top},
            left=${left}
            `
        );

        if (window.focus) {
            newWindow.focus();
        }
    }
}