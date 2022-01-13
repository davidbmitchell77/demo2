import { LightningElement } from "lwc";
import { ShowToastEvent   } from "lightning/platformShowToastEvent";
import { deleteRecord     } from "lightning/uiRecordApi";

export default class DeleteRecordDemo extends LightningElement
{
    recordId;

    changeHandler(event) {
       this.recordId = event.target.value;
    }

    deleteHandler()
    {
        deleteRecord(this.recordId).then
        (
            () => {
                this.showToast("Sucess!!", "Deleted Successfully!!", "success");
            }
        ).catch
        (
            error => {
                this.showToast("Error!!", "Error Occurred!!", "error");
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
