import { LightningElement, api, wire } from 'lwc';
import processRefundApproval from '@salesforce/apex/ET_RefundApprovalCallout.processRefund';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
const FIELDS = [
    'ET_Refund__c.Approval_Status__c',
    'ET_Refund__c.ET_Integration_Message__c'
];

export default class RefundApprovalToast extends LightningElement {
    @api recordId; // The recordId is automatically passed when the LWC is placed on a record page
    @api Name;
    @api objectApiName;
    previousApprovalStatus;
    isApproved = false;
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    refund(result) {
        const { data, error } = result;
        if (error) {
            this.showToast('Error', error.body.message, 'error');
        } else if (data) {
            console.log(data.fields.Approval_Status__c.value);
            const currentApprovalStatus = data.fields.Approval_Status__c.value;
            if (currentApprovalStatus === 'Approved' && this.previousApprovalStatus !== 'Approved') {
                // Call the Apex method if the status changes to 'Approved'
                if (this.isApproved) {
                    this.processRefund();
                }
                this.isApproved = true;
            }
            this.previousApprovalStatus = currentApprovalStatus;
        }
    }

    processRefund() {
        processRefundApproval({ recordid: this.recordId })
            .then((result) => {
                console.log(JSON.stringify(result));
                this.showToast('Success', 'Refund Approval Processed Successfully', 'success');
            })
            .catch((error) => {
                this.showToast('Error', error.body.message, 'error');
            });
    }

    // Helper function to show toast messages
    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }
}