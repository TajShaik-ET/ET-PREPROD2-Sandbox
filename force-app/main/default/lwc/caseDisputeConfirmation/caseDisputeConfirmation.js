import { LightningElement, api, track } from 'lwc';
import updateDisputeConfirmation from '@salesforce/apex/CaseDisputes.updateDisputeConfirmation';

export default class CaseDisputeConfirmation extends LightningElement {
    @api recordId;
    @track showSuccessMessage = false;
    @track showErrorMessage = false;
    @track successMessage = '';
    @track errorMessage = '';

    handleUpdateConfirmation() {
        updateDisputeConfirmation({ caseId: this.recordId })
            .then(result => {
                if (result === 'Already you have updated dispute fields.') {
                    this.showErrorMessage = true;
                    this.errorMessage = result;
                } else {
                    this.showSuccessMessage = true;
                    this.successMessage = result;

                    setTimeout(() => {
                        this.closePopup();
                    }, 2000);
                }
            })
            .catch(error => {
                this.showErrorMessage = true;
                this.errorMessage = 'Error checking dispute fields: ' + error.body.message;
            });
    }

    closePopup() {
        const closeEvent = new CustomEvent('close');
        this.dispatchEvent(closeEvent);
    }
}