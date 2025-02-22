import { ShowToastEvent } from "lightning/platformShowToastEvent";

export function showToastNotification(title, message, variant, mode) {
    console.log(message);
    const evt = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant, //info (default), success, warning, and error
        mode: mode //dismissible (default), pester, sticky
    });
    return evt;
}

export function isEmptyString(value) {
    return (value == null || (typeof value === "string" && value.trim().length === 0));
}