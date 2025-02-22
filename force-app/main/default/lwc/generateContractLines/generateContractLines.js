import { LightningElement, api, track } from 'lwc';

import NAME from '@salesforce/schema/Contract_Master__c.Name';
import DESCRIPTION from '@salesforce/schema/Contract_Master__c.Description__c';
import CONTRACT_HEAD from '@salesforce/schema/Contract_Master__c.Contract_Pdf_Header__c';
import ADDENDUM_HEAD from '@salesforce/schema/Contract_Master__c.Addendum__c';
import MASTER_LINE_NO from '@salesforce/schema/Contract_Master__c.Line_No__c';
import CONTRACT from '@salesforce/schema/Contract_Master__c';

export default class GenerateContractLines extends LightningElement {
    isLoading = true;
    contractLineFields = {
        NAME,
        DESCRIPTION,
        MASTER_LINE_NO,
        CONTRACT_HEAD,
        ADDENDUM_HEAD
    };
    contractLineObject = CONTRACT;
    @track lineLabel;
    @track newSubClause = [];
    @api article;
    @track isAdditionalArticle = false; // To track if article name is "Additional"
    @track addSubArticle = false;
    @track isModalOpen = false; // Tracks modal visibility
    @track newSubclauseName = ''; // Tracks input for new subclause name
    @track newSubclauseDescription = ''; // Tracks input for new subclause description

    connectedCallback(){
        console.log('-----GenerateContractLines--connectedCallback----', this.article.subCaluses);
        console.log('-----this.article.length>>>>>>>>>>>', this.article.length)
        this.lineLabel = this.article.articleLineNo +'. '+ this.article.Name;
        // Check if the article's name is 'Additional'
        if (this.article.Name === 'ADDITIONAL') {
            this.isAdditionalArticle = true;
            this.newSubClause = [];
        }
        this.isLoading = false;
    }

    handleInputChange(event) {
        // Replace anything that is not a digit (0-9) with an empty string
        event.target.value = event.target.value.replace(/[^0-9]/g, '');
        this.newSubclauseName = event.target.value;
    }

    @track index=2;
    // Handle Add Subclause button click (open modal)
    handleAddSubclause() {
        
        console.log('In Add Clause>>>>>>>>>>>');
        // this.newSubClause = [
        //         {
        //                 Id: 'a8YUE000000CCzt2AG',
        //                 Name: '25.' + this.index,
        //                 Description: 'Test desp',
        //                 refArticleId: 'a8YUE000000CCzt2AG'
        //         }
        //     ];

        this.newSubClause.push({
                //Id: 'a8YUE000000CCzt2AG',
                Name: this.article.articleLineNo + '.' + this.index,
                Description: 'Please Click Edit Checkbox to add description',
                ContractMaster: this.article.Id,
                //refArticleId: 'a8YUE000000CCzt2AG'
        });

        this.isModalOpen = true;
        console.log('Open this.isModalOpen>>>>>>>>>>>', this.isModalOpen);
        console.log('index>>>>>>>>>>>', this.index);
        this.addSubArticle =  true;
        this.index = this.index + 1;
    }

    // Handle modal close
    closeModal() {
        this.isModalOpen = false;
        this.newSubclauseName = '';  // Clear the input fields
        this.newSubclauseDescription = ''; 
        console.log('Close this.isModalOpen>>>>>>>>>>>', this.isModalOpen);
    }

    // Capture name input
    handleNameChange(event) {
        this.newSubclauseName = event.target.value;
    }

    // Capture description input
    handleDescriptionChange(event) {
        this.newSubclauseDescription = event.target.value;
    }

    AddSubclause() {
        this.isLoading = true;
    }

    /**
     * @description to save Article related, Sub-Articles records
     */
    handleSuccess(event){
        console.log('-----handleSuccess contract Master----');
        var totalItems = 0
        this.contractMasterId = event.detail.id;
        var contractMasterId = this.contractMasterId;

        let contractSections = this.template.querySelectorAll('c-generate-contract-sub-lines');
        totalItems = contractSections.length;
        contractSections.forEach(child => {
            child.handleContractMasterId(contractMasterId);
        });

        this.totalContractSubLines = totalItems;
        console.log('---Total Lines---'+this.totalContractSubLines);
        // this.navigateToRecordPage(contractHeaderId, 'Contract_Pdf_Header__c');
    }

    handleTermsDelete(){
        console.log('----handleTermsDelete----');
    }

    @api handleContractHeaderId(contractHeaderId){
        console.log('----handleContractHeaderId----');
        this.contractHeaderId = contractHeaderId;
        var contractHeaderIdField = this.template.querySelector('[data-id="contractHeaderId"]');
        contractHeaderIdField.value = contractHeaderId;
        this.template.querySelector('lightning-record-edit-form').submit();
    }
    @api handleAddendumId(addendumId){
        console.log('----handleAddendumId----');
        this.addendumId = addendumId;
        var addendumIdField = this.template.querySelector('[data-id="addendumId"]');
        addendumIdField.value = addendumId;
        this.template.querySelector('lightning-record-edit-form').submit();
    }

    handleDeleteSubClause(event){
        var subClauseId = event.detail;
        console.log('----handleDeleteSubClause----',this.article.subCaluses);
        var index = this.article.subCaluses.findIndex( x =>  x.Id === subClauseId);
        console.log('------handleDeleteSubClause---index----'+index);
        // this.article.subCaluses.splice(index, 1);
    }
}