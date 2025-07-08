import { LightningElement, api, wire, track } from 'lwc';
import generatePdfContent from '@salesforce/apex/PRI_customerQuoteContractController.generateQuoteDoc';

import { getRecord } from 'lightning/uiRecordApi';
import NAME from '@salesforce/schema/Contract_Pdf_Header__c.Name';
import APPROVAL_STATUS from '@salesforce/schema/Contract_Pdf_Header__c.Approval_Status__c';
import APPROVAL_STAGE from '@salesforce/schema/Contract_Pdf_Header__c.Approval_Stage__c';
import ALL_APPROVAL from '@salesforce/schema/Contract_Pdf_Header__c.All_Approval_Finished__c';
import PDFSector from '@salesforce/schema/Contract_Pdf_Header__c.Sector__c';
import CQRecordType from '@salesforce/schema/Contract_Pdf_Header__c.Customer_Quote__r.RecordType__c';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';


export default class GenerateContractPdfButton extends LightningElement {
    @api recordId;
    vfpageUrl;
    showPdfPage = false;
    objvar = {
        RecordId : '',
        Sector : ''
    };

    @track oppType;

    get computedVfPageUrl(){
        console.log('this.vfpageUrl in get'+this.vfpageUrl);
        return this.vfpageUrl;
    }

    @wire(getRecord, { recordId: '$recordId', fields: [NAME, APPROVAL_STATUS, APPROVAL_STAGE, ALL_APPROVAL, PDFSector, CQRecordType] })
    wiredContact({ error, data }) {
        try {
            if (data) {
                console.log('---data---', data);
                this.contract = data;
                this.checkApprovalStatus();
            } else if (error) {
                // Handle the error
                console.error('---error---', error);
                this.handleError(error);
            }
        } catch (exception) {
            // Handle any unexpected exceptions
            console.error('---unexpected error---', exception);
            this.handleError(exception);
        }
    }
    handleError(error) {
        // Custom error handling logic
        // For example, show an error message to the user
        const errorMessage = error?.body?.message || 'An unexpected error occurred.';
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: errorMessage,
                variant: 'error',
            }),
        );
    }
    
    checkApprovalStatus(){
        this.objvar.RecordId= this.recordId;
        this.objvar.Sector= this.contract.fields.Sector__c.value;
        this.oppType = this.contract.fields.Customer_Quote__r.value.fields.RecordType__c.value;
        console.log('--Sector--'+this.contract.fields.Sector__c.value);

        if(this.contract.fields.Approval_Status__c.value == 'Submitted'){
            this.showToastNotification('Warning', 'Warning', 'Contract has already been Submitted and waiting for approval from '+ this.contract.fields.Approval_Stage__c.value +'!');
        }else if(this.contract.fields.Approval_Status__c.value == 'Rejected'){
            this.showToastNotification('Warning', 'Error', 'Contract has already been rejected by '+ this.contract.fields.Approval_Stage__c.value +'!');
        }else if(this.contract.fields.Approval_Status__c.value == 'Approved' && this.contract.fields.All_Approval_Finished__c.value != true){
            this.showToastNotification('Success', 'Success', 'Wiating for Approval from '+ this.contract.fields.Approval_Stage__c.value +'!');
        }else if(this.contract.fields.Approval_Status__c.value == 'Approved' && this.contract.fields.All_Approval_Finished__c.value == true){          
            if (this.contract.fields.Sector__c.value =='School') {
                this.vfpageUrl = '/apex/ET_generateContractPdf_School?Id=' + this.objvar.RecordId;
                this.showPdfPage = true;
            }else if (this.contract.fields.Customer_Quote__r.value.fields.RecordType__c.value =='Leasing/ Rental') {
                this.vfpageUrl = '/apex/ET_generateContractPdf_TL?Id=' + this.objvar.RecordId;
                this.showPdfPage = true;
            }else if (this.contract.fields.Customer_Quote__r.value.fields.RecordType__c.value =='Transportation') {
                this.vfpageUrl = '/apex/ET_generateContractPdf_Transport?Id=' + this.objvar.RecordId;
                this.showPdfPage = true;
            }else{
                this.showToastNotification('Warning', 'Warning', 'Sector is Null');
            }
        }else{
            this.showToastNotification('Warning', 'Error', 'Contract can only be generated after getting Approvals');
        }
    }

    handleSavePDF(){
        generatePdfContent({ quoteId: this.objvar.RecordId, Sector: this.objvar.Sector, OppType: this.oppType})
        .then(result => {
            this.showToast('Success', 'PDF Saved Successfully', 'success');
            this.showPdfPage = false;
        })
        .catch(error => {
            this.showToast('Error', 'Failed to generate PDF', 'error');
        });
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }

     showToastNotification(title, variant, msg){
         this.dispatchEvent(new CloseActionScreenEvent());
         this.dispatchEvent(new ShowToastEvent({
             title : title,
             message : msg,
             variant : variant
         }));
    }
}