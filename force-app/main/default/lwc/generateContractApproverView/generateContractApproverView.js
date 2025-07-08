import { LightningElement, api, wire,track } from 'lwc';

import getContractDetail from '@salesforce/apex/PRI_customerQuoteController.getContractDetail';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import NAME from '@salesforce/schema/Contract_Pdf_Header__c.Name';
import APPROVAL_STATUS from '@salesforce/schema/Contract_Pdf_Header__c.Approval_Status__c';
import APPROVAL_STAGE from '@salesforce/schema/Contract_Pdf_Header__c.Approval_Stage__c';
import ALL_APPROVAL from '@salesforce/schema/Contract_Pdf_Header__c.All_Approval_Finished__c';

import { loadStyle } from 'lightning/platformResourceLoader';
import externalCustCode from '@salesforce/resourceUrl/externalCustCode';
import approveContract from '@salesforce/apex/PRI_customerQuoteController.approveContract';
import getApprovalData from '@salesforce/apex/PRI_customerQuoteController.getApprovalData';

import { getRecordNotifyChange, notifyRecordUpdateAvailable, getRecord, updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';

export default class GenerateContractApproverView extends LightningElement {
    @api recordId;
    openModel = false;
    contractDetail;
    isSubmitted = true;
    @track showForm = false;
    @track isVisible = false;
    @track showDetail = true;

    @wire(getApprovalData, { recordId: '$recordId' })
    wiredApprovalData({ error, data }) {
        if (data) {
            const { approvalStatus, approvalStage, allApprovalFinished, legalApproval, userPermissionSets } = data;

            // Extract conditions
            const condition1 = approvalStatus === 'Submitted';
            const condition8 = allApprovalFinished === false;

            const condition2 = userPermissionSets.includes('Legal_Approval');
            const condition3 = approvalStage === 'Legal';

            const condition4 = userPermissionSets.includes('Finance_FAI_Approval');
            const condition5 = approvalStage === 'Finance Fixed Assets and Inventory';

            /* New */
            const condition6 = userPermissionSets.includes('Operation_Approval');//1
            const condition7 = approvalStage === 'Operation';

            const condition10 = userPermissionSets.includes('Insurance_Approval');//2
            const condition9 = approvalStage === 'Insurance';

            const condition11 = userPermissionSets.includes('Business_Approval'); //3
            const condition12 = approvalStage === 'Business';

            const condition13 = userPermissionSets.includes('Collections_Approval');//4
            const condition14 = approvalStage === 'Collections';

            const condition15 = userPermissionSets.includes('Purchase_Approval');//5
            const condition16 = approvalStage === 'Purchase';

            const condition17 = userPermissionSets.includes('CFO_Approval');//6
            const condition18 = approvalStage === 'CFO';

            const condition19 = userPermissionSets.includes('Finance_IR_Approval'); //8
            const condition20 = approvalStage === 'Finance Invoicing and Revenue Control';

            const condition21 = userPermissionSets.includes('Finance_TC_Approval');//9
            const condition22 = approvalStage === 'Finance Treasury & Corporate';

            


            console.log(condition1 + 'AND' + condition8  + 'AND' + '((' + condition2  + 'AND' + condition3 + ')' + 'OR' + '(' + condition4  + 'AND' + condition5 + ')' + 'OR' + '(' + condition6  + 'AND' + condition7 +')' + 'OR' + '(' + condition9  + 'AND' + condition10 + ')' + ')')

            // Final Condition: 1 AND condition8 AND ((2 AND 3) OR (4 AND 5) OR (6 AND 7) OR (9 AND 10))
            this.isVisible =
                condition1 &&
                condition8 &&
                ((condition2 && condition3) ||
                    (condition4 && condition5) ||
                    (condition6 && condition7) ||
                    (condition9 && condition10)||

                    (condition11 && condition12)||
                    (condition13 && condition14)||
                    (condition15 && condition16)||
                    (condition17 && condition18)||
                    (condition19 && condition20)||
                    (condition21 && condition22)
                );

            console.log('legalApproval>>', legalApproval, 'allApprovalFinished>>', allApprovalFinished); //, 'condition2>>', condition2, 'condition3>>', condition3
            if(legalApproval == 'Submitted for Approval' && allApprovalFinished == true && condition2 == true && condition3 == true)
            {
                console.log('In Condition>>>>>>>>');
                this.isVisible = true;
                this.showDetail = false;
                this.isSubmitted = false;
                console.log('this.isVisible>>>', this.isVisible);
            }
        } else if (error) {
            console.error('Error fetching approval data:', error);
        }
    }

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
        this.showForm = true;
      
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
        this.showForm = false;
        
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

    handleSuccess() {
        this.updateContractApprovalStatus('Rejected');
        this.showForm = false; // Hide form after successful update
    }
}