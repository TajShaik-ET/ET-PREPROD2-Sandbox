import { LightningElement, track, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import ET_Rep_Salutation from '@salesforce/schema/Addendum__c.Salutation__c';
import Customer_Salutation from '@salesforce/schema/Addendum__c.Customer_Salutation__c';
import ET_Representative from '@salesforce/schema/Addendum__c.Emirates_Transport_Representative__c';
import Company_s_Representative from '@salesforce/schema/Addendum__c.Company_s_Representative__c';
import ET_Rep_Designation from '@salesforce/schema/Addendum__c.ET_Designation__c';
import Customer_Designation from '@salesforce/schema/Addendum__c.Customer_Designation__c';
import Minimum_Period from '@salesforce/schema/Addendum__c.Minimum_Period__c';
import CUSTOMER_QUOTE from '@salesforce/schema/Addendum__c.Customer_Quote__c';
import CONTRACT from '@salesforce/schema/Addendum__c.Contract__c';
import SECTOR from '@salesforce/schema/Addendum__c.Sector__c';
import Effective_Date from '@salesforce/schema/Addendum__c.Effective_Date__c';
import Account_Emirate from '@salesforce/schema/Addendum__c.Account_Emirate__c';
import Trade_License from '@salesforce/schema/Addendum__c.Trade_License__c';
import P_O_Box from '@salesforce/schema/Addendum__c.P_O_Box__c';
import Addendum_Type from '@salesforce/schema/Addendum__c.Addendum_Type__c';
import Number_of_Year_Month from '@salesforce/schema/Addendum__c.Number_of_Year_Month__c';
import Duration_Type from '@salesforce/schema/Addendum__c.Duration_Type__c';
import Number_of_Vehicles from '@salesforce/schema/Addendum__c.Number_of_Vehicles__c';
import Starting_Date from '@salesforce/schema/Addendum__c.Starting_Date__c';
import Mobilization_Date from '@salesforce/schema/Addendum__c.Mobilization_Date__c';
import Addendum from '@salesforce/schema/Addendum__c';

import getAddendumContractLines from '@salesforce/apex/PRI_customerQuoteController.getAddendumContractLines';
import buildAdditionalArticles from '@salesforce/apex/PRI_customerQuoteController.buildAdditionalArticles';
import getEditables from '@salesforce/apex/PRI_customerQuoteContractController.getEditables';
import { loadStyle } from 'lightning/platformResourceLoader';
import externalCustCode from '@salesforce/resourceUrl/externalCustCode';

export default class GenerateContract extends NavigationMixin(LightningElement) {
    SPNR = true;
    @api recordId;
    totalContractLines = 0;
    contractHeaderObject = Addendum;
    contractHeader = {
        ET_Rep_Salutation,
        Customer_Salutation,
        ET_Representative,
        Company_s_Representative,
        ET_Rep_Designation,
        Customer_Designation,
        CUSTOMER_QUOTE,
        CONTRACT,
        Minimum_Period,
        SECTOR,
        Effective_Date,
        Account_Emirate,
        Trade_License,
        P_O_Box,
        Addendum_Type,
        Number_of_Year_Month,
        Duration_Type,
        Number_of_Vehicles,
        Starting_Date,
        Mobilization_Date
        

    };
    @track isAddition = false;
    @track contractLines = [];
    @track customerQuoteData;
    @track showShcHead = false;
    @track emirate;
    @track tradeLicense;
    @track ContractStart;
    @track ContractEnd;
    @track AnnualKMCharge;
    @track InsuranceExcessCharge;
    @track CelanderDays;
    @track DelayPaymentPer;
    @track firstYearTermination;
    @track secondYearTermination;
    @track thirdYearTermination;
    @track lpoTermination;
    @track salikDarb;
    @track trafficFineAdmin;
    @track trafficFineClientDriver;
    @track trafficOffense;
    @track breachPermittedUse;
    @track smokingCharges;
    @track chargesLettersCert;
    @track delayRenewal;
    @track contractType;
    @track yearlyLabel=false;
    @track cqRecordtype;
    @track isTransportation = false;
    @track withDriver = false;
    @track withFuel = false;
    @track vehInsurance = 'No';
    @track maintenance = 'No';
    @track trafficFines = 'No';
    @track demagePenalty = 'No';
    @track impoundVehCharge = 'No';
    @track lawDecisions = 'No';
    @track fuelPrice = 'No';
    @track fuelDifferences = 'No';
    @track additionalTerm = 'No';
    @track replacement = 'No';
    @track accId;
    @track brandingCharge;
    @track vehReplacePer;
    @track returnChecque;
    @track delayPaySuspension;
    @track delayPaytermination;
    @track vehicleQuoteItemsCount;
    @track workforceQuoteItemsCount;
    @track addendumType;
    @track showRenewal = false;
    @track showAdditional = false;
    @track showExtension = false;
    @track showContract = false;
    @track contractId;
    @track filterCondition; //filtercondition to cutom lookup
    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        this.currentPageReference = currentPageReference;
        this.recordId = this.currentPageReference.state.c__recordId;
        console.log("----recordId----"+this.recordId);
       
    }

    connectedCallback(){
        console.log('-----connectedCallBack------');
        window.setTimeout(() => {

            this.showShcHead=true;
    
         },4000);
        this.fetchContractMasterData();
        this.getEtidableFields();
        
    }

    getEtidableFields()
    {
        getEditables({
				
            CQId: this.recordId    
        }).then(result => {
            console.log('result>>>>>>>>>>>', result);
            
            //this.customerQuoteData = result;
            console.log('Customer Parse>>>>>>>>>', JSON.parse(result));
            this.customerQuoteData = JSON.parse(result);
            this.effectiveDate = this.customerQuoteData.EffectiveDate;
            this.emirate = this.customerQuoteData.Emirates;
            this.tradeLicense = this.customerQuoteData.TradeLicense;
            this.accId = this.customerQuoteData.Account;
            this.ContractStart = this.customerQuoteData.ContractStart;
            this.ContractEnd = this.customerQuoteData.ContractEnd;
            this.AnnualKMCharge = this.customerQuoteData.AnnualKMCharge;
            this.InsuranceExcessCharge = this.customerQuoteData.InsuranceExcessCharge;
            this.CelanderDays = this.customerQuoteData.CelanderDays;
            this.DelayPaymentPer = this.customerQuoteData.DelayPaymentPer;
            this.firstYearTermination = this.customerQuoteData.firstYearTermination;
            console.log('this.tradeLicense>>>>>>>>', this.tradeLicense);
            if(this.contractType == "Yearly")
            {
                this.yearlyLabel = true;
            }
            this.cqRecordtype = this.customerQuoteData.CQrecordType;
            console.log('this.CQrecordType>>>>>>>>', this.cqRecordtype);
            if(this.cqRecordtype == 'Transportation')
            {
                this.isTransportation = true;
                this.withDriver = true;
                this.withFuel = true;
            }
        })
        .catch(error => {
            console.log('Error>>>>', error)
        })    
    }
    getContractDetail(event)
    {
        this.contractId = event.detail.Id;
    }

    checkAddendumType(event)
    {
        this.addendumType = event.detail.value;
        if(this.addendumType == 'Renewal')
        {
            this.showAdditional = false;
            this.showExtension = false;
            this.showRenewal = true;
            this.showContract = true;
             
        }
        else if(this.addendumType == 'Additional')
        {
            this.showRenewal = false;
            this.showExtension = false;
            this.showAdditional = true;
            this.showContract = true;
        }
        else{
            this.showRenewal = false;
            this.showAdditional = false;
            this.showExtension = true;
            this.showContract = true;
        }

        this.fetchContractMasterData();

    }
    SearchKeyHandler(event) {
        this.filterCondition = 'Account__c = \'' + this.accId + '\'';
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
    @track addSector;
    @track additionalArtiles = [];
    handleAddClause()
    {
        console.log(' In Additional Article Method>>>>>>>>');
        if(this.addendumType == 'Renewal')
        {
            this.addSector = 'ADM_RENEWAL';
        }
        else if(admType == 'Additional')
        {
            this.addSector = 'ADM_ADDITIONAL';
        }
        buildAdditionalArticles({sector: this.addSector}).then((response) => {
        console.log('----response Additional Article---',response);
        this.additionalArtiles = response;
        //this.RecordsData = response.customerQuote;
        //this.SPNR = false;
        }).catch((error) => {
            console.log('error');
            console.error(error);
        })
        // this.additionalArtiles = [
        //     {
        //        articleLineNo: '25',
        //        id: 'a8YUE000000CCzt2AG',
        //        Name: 'Additional',
        //        subClauses: []
        //     }
        // ];
        this.isAddition = true;

    }

    
    async fetchContractMasterData(){
        console.log('----fetchContractMasterData---');
        await getAddendumContractLines({recordId: this.recordId, admType: this.addendumType}).then((response) => {
            console.log('----response---',response);
            this.contractLines = response.articlesDetail;
            this.RecordsData = response.customerQuote;
            this.SPNR = false;
        }).catch((error) => {
            console.log('error');
            console.error(error);
        })
        console.log('---contractLines--',this.contractLines);
        
        // this.setDefaultData();
    }

    /*validationrule() {
        // let isvalid = true;
        // let listforms = this.template.querySelectorAll('.validate');
        // console.log('validationrule listforms>>>>', listforms);
        // listforms.forEach(singleform => {
        //     if (!singleform.checkValidity()) {
        //         singleform.reportValidity();
        //         singleform.scrollIntoView({ behavior: 'smooth', block: 'center' });
        //         isvalid = false;

        //     }
        // });
        const allValid = [
            ...this.template.querySelectorAll('.validate'),
        ].reduce((validSoFar, inputCmp) => {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        console.log('validationrule isvalid>>>>', isvalid);
        return allValid;
    }*/
    @track checkValid =false;
    validationrule(){
        const inputs = this.template.querySelectorAll('lightning-input-field');

        // Check if all fields are valid
        let isValid = true;
        inputs.forEach(input => {
            if (!input.checkValidity()) {
                input.reportValidity();
                isValid = false;
            }
        });
        this.checkValid = isValid;
    }
    
    /*handleSaveClick(evt){
        
        // console.log('handleSaveClick');
        // var isValid = this.validationrule();
        consonole.log('isValid before>>>>>>>>>>>>>', this.checkValid);
        this.validationrule();
        consonole.log('isValid After>>>>>>>>>>>>>', this.checkValid);
        if(this.checkValid == true)
         {
            console.log('---handleSaveClick--');
            var headerForm = this.template.querySelector('[data-id="contractHeaderSection"]');
            console.log('---handleSaveClick--headerForm--', headerForm);
            headerForm.submit();
        }
        else{
            console.log('In else handleSaveClick>>>>>>>>');
        }
        
    }*/
    handleSaveClick(){
         // Get all input fields
         const inputFields = this.template.querySelectorAll('lightning-input-field');
         let allValid = true;
 
         // Check validity of each input field
         inputFields.forEach(field => {
             if (!field.reportValidity()) {
                 allValid = false;
             }
         });
         console.log('allValid >>>>>>>>>>>>>', allValid);
         // If all fields are valid, proceed with form submission
         if (allValid) {
             
            try {
                console.log('---handleSaveClick--');
                const headerForm = this.template.querySelector('[data-id="contractHeaderSection"]');
                console.log('---handleSaveClick--headerForm--', headerForm);
    
                // Attempt to submit the form
                headerForm.submit();
                this.showToast('Success', 'Form submitted successfully', 'success');
            } catch (error) {
                console.error('Error during form submission:', error);
                this.showToast('Error', 'An error occurred during form submission. Please try again.', 'error');
            }
         } else {
             this.showToast('Error', 'Please fill out all required fields', 'error');
         }
     }
 
     showToast(title, message, variant) {
         const event = new ShowToastEvent({
             title: title,
             message: message,
             variant: variant,
         });
         this.dispatchEvent(event);
     }

    handleCancel(){
        console.log('---handleCancel--');
    }

    /**
     * @description to save contract related, Articles records
     */
    handleSuccess(event){
        console.log('In handleSuccess>>>>>>>>>');

        var totalItems = 0
        this.addendumId = event.detail.id;
        var addendumId = this.addendumId;

        let contractSections = this.template.querySelectorAll('c-generate-contract-lines');
        totalItems = contractSections.length;
        contractSections.forEach(child => {
            child.handleAddendumId(addendumId);
        });

        this.totalContractLines = totalItems;
        console.log('---Total Lines---'+this.totalContractLines);
        this.navigateToRecordPage(addendumId, 'Contract_Pdf_Header__c');
    }

    handleError(event) {
        console.error('Error in form submission:', event.detail.message);
    }

    navigateToRecordPage(addendumId, obj) {
        
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                ObjectApiName :obj,
                recordId: addendumId,
                actionName: 'view'
            }
        });
    }
        
}