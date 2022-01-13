import { LightningElement } from "lwc";
import { ShowToastEvent   } from "lightning/platformShowToastEvent";
import { deleteRecord     } from "lightning/uiRecordApi";

export default class DeleteRecordDemo extends LightningElement
{
    recordId;

    changeHandler(event) {
       this.recordId = event.target.value;
    }

    reset() {
        this.template.querySelector("form").reset();
    }

    deleteHandler()
    {
        deleteRecord(this.recordId).then
        (
            () => {
                this.reset();
                this.showToast("Success", "Record deleted.", "success");
            }
        ).catch
        (
            error => {
                this.showToast("Error!!!", "An error occurred.", "error");
                console.error(error);
            }
        )
    }

    showToast(title, message, variant)
    {
        this.dispatchEvent
        (
            new ShowToastEvent
            ({
                title: title,
                message: message,
                variant: (variant || "info")
            })
        );
    }
}
