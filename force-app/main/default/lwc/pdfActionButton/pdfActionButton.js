import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class PdfActionButton extends LightningElement {
    @api recordId; // Receives the record ID from the action button

    get pdfUrl() {
        return `/apex/DriverChecklistPDF?Id=${this.recordId}`;
    }

    handleOpenPdf() {
        if (this.recordId) {
            window.open(this.pdfUrl, '_blank');
        } else {
            this.showToast('Error', 'Record ID is missing.', 'error');
        }
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        }));
    }
}