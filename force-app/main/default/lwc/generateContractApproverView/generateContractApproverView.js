import { LightningElement, api, wire } from 'lwc';

import getContractDetail from '@salesforce/apex/PRI_customerQuoteController.getContractDetail';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import NAME from '@salesforce/schema/Contract_Pdf_Header__c.Name';
import APPROVAL_STATUS from '@salesforce/schema/Contract_Pdf_Header__c.Approval_Status__c';
import APPROVAL_STAGE from '@salesforce/schema/Contract_Pdf_Header__c.Approval_Stage__c';
import ALL_APPROVAL from '@salesforce/schema/Contract_Pdf_Header__c.All_Approval_Finished__c';

import { loadStyle } from 'lightning/platformResourceLoader';
import externalCustCode from '@salesforce/resourceUrl/externalCustCode';
import approveContract from '@salesforce/apex/PRI_customerQuoteController.approveContract';
import { getRecordNotifyChange, notifyRecordUpdateAvailable, getRecord, updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';

export default class GenerateContractApproverView extends LightningElement {
    @api recordId;
    openModel = false;
    contractDetail;
    isSubmitted = true;

    @wire(getRecord, { recordId: '$recordId', fields: [NAME, APPROVAL_STATUS, APPROVAL_STAGE, ALL_APPROVAL] })
    wiredContact({ error, data }) {
        if (data) {
            console.log('---data---',data);
            this.contract = data;
            this.checkApprovalStatus();
        }
    }
    
    checkApprovalStatus(){
        console.log('----checkApprovalStatus-----');
        if(this.contract.fields.Approval_Status__c.value == 'Submitted'){
            this.isSubmitted = false;
        }else{
            this.isSubmitted = true;
        }
    }

    handleRejectClick(){
        this.updateContractApprovalStatus('Rejected');
        this.openModel = false;
    }

    handleApproveClick(){
        // this.updateContractApprovalStatus('Approved');
        approveContract({recordId: this.recordId }).then((response) => {
            console.log('--approveContract--',response);
            this.showToastNotification('Success', 'Success', 'Contract has been Approved successfully!');
        }).catch((error) => {
            console.log('error');
            console.error(error);
        });
        this.openModel = false;
    }

    updateContractApprovalStatus(status){
        const fields = {};
        fields.Id = this.recordId;
        fields.Approval_Status__c = status;
        const recordInput = { fields };
        updateRecord(recordInput)
        .then(() => {
            this.showToastNotification('Success', 'Success', 'Contract has been ' + status + ' successfully!');
        });
    }

    handleMoreDetailClick(){
        this.getContractDetail();
    }

    closeModal() {
        this.openModel = false;
    }

    getContractDetail(){
        getContractDetail({recordId: this.recordId }).then((response) => {
            console.log('--getContractDetail--',response);
            this.contractDetail = response;
            this.openModel = true;
        }).catch((error) => {
            console.log('error');
            console.error(error);
        })

    }

    showToastNotification(title, variant, msg){
        this.dispatchEvent(new ShowToastEvent({
            title : title,
            message : msg,
            variant : variant
        }));
        
        notifyRecordUpdateAvailable([{recordId: this.recordId}]);
        // getRecordNotifyChange([{ recordId: this.recordId }]);
        // refreshApex(this.contract);
    }

    renderedCallback(){
        Promise.all([
            loadStyle(this, externalCustCode)
        ])
        .then(() => {
            // console.log("All scripts and CSS are loaded. perform any initialization function.")
        })
        .catch(error => {
            console.log("failed to load the scripts");
        });
        
    }
}