import { LightningElement } from 'lwc';
import { ShowToastEvent   } from 'lightning/platformShowToastEvent';

export default class Notifications extends LightningElement
{
    clickHandler(event)
    {
      let title;
      let message;
      let messageData;
      let variant;
      let mode;

      let buttonLabel = event.target.label;

      if (buttonLabel === "Info")
      {
          title = "Info";
          message = "You clicked the Info button.";
          messageData = [];
          variant = "info";
          mode = "dismissible";
      }
      else if (buttonLabel === "Success")
      {
          title = "Success";
          message = "You clicked the Sucess button.";
          messageData = [];
          variant = "success";
          mode = "dismissible";
      }
      else if (buttonLabel === "Warning")
      {
          title = "Warning!";
          message = "You clicked the Warning button.";
          messageData = [];
          variant = "warning";
          mode = "pester";
      }
      else if (buttonLabel === "Error")
      {
          title = "Error!!!";
          message = "You clicked the Error button.";
          messageData = [];
          variant = "error";
          mode = "sticky";
      }

      this.popup(title, message, messageData, variant, mode);
    }

    popup(title, message, messageData, variant, mode)
    {
        const event = new ShowToastEvent
        ({
                  title: title,
                message: message,
            messageData: messageData,
                variant: variant,
                   mode: mode
        });

        this.dispatchEvent(event);
    }
}