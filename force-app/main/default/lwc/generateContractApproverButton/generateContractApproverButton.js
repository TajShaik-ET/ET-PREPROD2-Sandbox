import { LightningElement,api, wire } from 'lwc';

import { getRecord, notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';
import NAME from '@salesforce/schema/Contract_Pdf_Header__c.Name';
import APPROVAL_STATUS from '@salesforce/schema/Contract_Pdf_Header__c.Approval_Status__c';
import APPROVAL_STAGE from '@salesforce/schema/Contract_Pdf_Header__c.Approval_Stage__c';
import ALL_APPROVAL from '@salesforce/schema/Contract_Pdf_Header__c.All_Approval_Finished__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import { getRecordNotifyChange } from 'lightning/uiRecordApi';

import submitContractforApproval from '@salesforce/apex/PRI_customerQuoteController.submitContractforApproval';

export default class GenerateContractApproverButton extends LightningElement {
    @api recordId;
    isSubmitted = false;
    
    @wire(getRecord, { recordId: '$recordId', fields: [NAME, APPROVAL_STATUS, APPROVAL_STAGE, ALL_APPROVAL] })
    wiredContact({ error, data }) {
        if (data) {
            console.log('---GenerateContractApproverButton---',data);
            this.contract = data;
            if(!this.isSubmitted){
                this.checkApprovalStatus();
            }
        }
    }

    checkApprovalStatus(){
        console.log('--status--'+this.contract.fields.Approval_Status__c.value);
        if(this.contract.fields.Approval_Status__c.value == 'Submitted'){
            this.showToastNotification('Warning', 'Warning', 'Contract has already been Submitted and waiting for approval from '+ this.contract.fields.Approval_Stage__c.value +'!');
        }else if(this.contract.fields.Approval_Status__c.value == 'Rejected'){
            this.showToastNotification('Warning', 'Error', 'Contract has already been rejected by '+ this.contract.fields.Approval_Stage__c.value +'!');
        }else if(this.contract.fields.Approval_Status__c.value == 'Approved' && this.contract.fields.All_Approval_Finished__c.value != true){
            this.showToastNotification('Success', 'Success', 'Wiating for Approval from '+ this.contract.fields.Approval_Stage__c.value +'!');
        }else if(this.contract.fields.Approval_Status__c.value == 'Approved' && this.contract.fields.All_Approval_Finished__c.value == true){
            this.showToastNotification('Success', 'Success', 'Contract has already been Approved!');
        }else{
            this.submitforApproval();
        }
    }

    submitforApproval(){
        submitContractforApproval({recordId: this.recordId }).then((response) => {
            console.log('--submitContractforApproval--',response);
            this.showToastNotification('Success', 'Success', 'Contract has been Submitted for Approval!');
            this.isSubmitted = true;
        }).catch((error) => {
            console.log('error');
            console.error(error);
        })

    }

    showToastNotification(title, variant, msg){
        this.dispatchEvent(new CloseActionScreenEvent());
        this.dispatchEvent(new ShowToastEvent({
            title : title,
            message : msg,
            variant : variant
        }));
        // getRecordNotifyChange([{ recordId: this.recordId }]);
        notifyRecordUpdateAvailable([{recordId: this.recordId}]);
    }
}