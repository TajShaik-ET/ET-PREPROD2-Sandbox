import { LightningElement, api, wire, track } from 'lwc';
import generatePdfContent from '@salesforce/apex/ET_AddendumPDFPageController.generateQuoteDoc';

import { getRecord } from 'lightning/uiRecordApi';
import NAME from '@salesforce/schema/Addendum__c.Name';
import APPROVAL_STATUS from '@salesforce/schema/Addendum__c.Approval_Status__c';
import APPROVAL_STAGE from '@salesforce/schema/Addendum__c.Approval_Stage__c';
import ALL_APPROVAL from '@salesforce/schema/Addendum__c.All_Approval_Finished__c';
import PDFAddendumType from '@salesforce/schema/Addendum__c.Addendum_Type__c';
import CQRecordType from '@salesforce/schema/Addendum__c.Customer_Quote__r.RecordType__c';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';


export default class ET_AddendumPDFButton extends LightningElement {
    @api recordId;
    vfpageUrl;
    showPdfPage = false;
    objvar = {
        RecordId : '',
        PDFAddendumType : ''
    };

    @track oppType;

    get computedVfPageUrl(){
        console.log('this.vfpageUrl in get'+this.vfpageUrl);
        return this.vfpageUrl;
    }

    @wire(getRecord, { recordId: '$recordId', fields: [NAME, APPROVAL_STATUS, APPROVAL_STAGE, ALL_APPROVAL, PDFAddendumType, CQRecordType] })
    wiredContact({ error, data }) {
        if (data) {
            console.log('---data---',data);
            this.contract = data;
            this.checkApprovalStatus();
        }
    }
    
    checkApprovalStatus(){
        this.objvar.RecordId= this.recordId;
        this.objvar.PDFAddendumType= this.contract.fields.Addendum_Type__c.value;
        this.oppType = this.contract.fields.Customer_Quote__r.value.fields.RecordType__c.value;
        console.log('--PDFAddendumType--'+this.contract.fields.Addendum_Type__c.value);

        /* if(this.contract.fields.Approval_Status__c.value == 'Submitted'){
            this.showToastNotification('Warning', 'Warning', 'Contract has already been Submitted and waiting for approval from '+ this.contract.fields.Approval_Stage__c.value +'!');
        }else if(this.contract.fields.Approval_Status__c.value == 'Rejected'){
            this.showToastNotification('Warning', 'Error', 'Contract has already been rejected by '+ this.contract.fields.Approval_Stage__c.value +'!');
        }else if(this.contract.fields.Approval_Status__c.value == 'Approved' && this.contract.fields.All_Approval_Finished__c.value != true){
            this.showToastNotification('Success', 'Success', 'Wiating for Approval from '+ this.contract.fields.Approval_Stage__c.value +'!');
        }else if(this.contract.fields.Approval_Status__c.value == 'Approved' && this.contract.fields.All_Approval_Finished__c.value == true){  */         
            if (this.contract.fields.Addendum_Type__c.value =='Renewal') {
                this.vfpageUrl = '/apex/ET_AddendumPDFPage?Id=' + this.objvar.RecordId;
                this.showPdfPage = true;
            }else if (this.contract.fields.Addendum_Type__c.value =='Additional') {
                this.vfpageUrl = '/apex/ET_AddendumPDFPageAdditional?Id=' + this.objvar.RecordId;
                this.showPdfPage = true;
            }else if (this.contract.fields.Addendum_Type__c.value =='Extension') {
                this.vfpageUrl = '/apex/ET_AddendumPDFPageExtension?Id=' + this.objvar.RecordId;
                this.showPdfPage = true;
            }else{
                this.showToastNotification('Warning', 'Warning', 'PDFAddendumType is Null');
            }
       /*  }else{
            this.showToastNotification('Warning', 'Error', 'Contract can only be generated after getting Approvals');
        } */
    }

    handleSavePDF(){
        generatePdfContent({ RecId: this.objvar.RecordId, PDFAddendumType: this.objvar.PDFAddendumType})//, OppType: this.oppType
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