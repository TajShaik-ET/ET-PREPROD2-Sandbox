import { LightningElement, api } from 'lwc';
import NAME from '@salesforce/schema/Contract_Line__c.Name';
import DESCRIPTION from '@salesforce/schema/Contract_Line__c.Description__c';
import CONTRACT_LINE from '@salesforce/schema/Contract_Line__c';
import EDITABLE from '@salesforce/schema/Contract_Line__c.Editable__c';
import DELETE from '@salesforce/schema/Contract_Line__c.Delete__c';
import CONTRACT_SUB_LINE_NO from '@salesforce/schema/Contract_Line__c.Line_No__c';
import CONTRACT_MASTER from '@salesforce/schema/Contract_Line__c.Contract_Master__c';
import REF_ARTICLE from '@salesforce/schema/Contract_Line__c.Referenced_Article__c';

export default class GenerateContractSubLines extends LightningElement {
    @api subCaluse;
    isDisabled = true;
    @api additionalArticle;
    contractSubLineFields = {
        NAME,
        DESCRIPTION,
        EDITABLE,
        DELETE,
        CONTRACT_SUB_LINE_NO,
        CONTRACT_MASTER,
        REF_ARTICLE
    }
    contractSubLineObject = CONTRACT_LINE;
    
    connectedCallBack(){
        console.log('In Subline>>>');
        console.log('----connectedCallBack-contractSubLine---', this.subCaluse);
    }
    handleSuccess(){
        console.log('----handleSuccess----');
    }

    @api handleContractMasterId(contractMasterId){
        console.log('----handleContractHeaderId----', contractMasterId);
        this.contractMasterId = contractMasterId;
        var contractMasterIdField = this.template.querySelector('[data-id="contractMasterId"]');
        contractMasterIdField.value = contractMasterId;
        this.template.querySelector('lightning-record-edit-form').submit();
    }

    makeContractDescEditable(){
        this.isDisabled = !(this.isDisabled);
        console.log('----makeContractDescEditable----');
    }

    handleContractSubLineDelete(){
        console.log('----handleContractSubLineDelete----');
        var subClauseId = this.subCaluse.Id;
        this.dispatchEvent(new CustomEvent('deletesubclause', {
            detail: subClauseId
        }));
    }

}