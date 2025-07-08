import { LightningElement, track, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import ET_Rep_Solitation from '@salesforce/schema/Contract_Pdf_Header__c.ET_Rep_Solitation__c';
import ET_Representative from '@salesforce/schema/Contract_Pdf_Header__c.ET_Representative__c';
import ET_Rep_Designation from '@salesforce/schema/Contract_Pdf_Header__c.ET_Rep_Designation__c';
import Lessee_Solitation from '@salesforce/schema/Contract_Pdf_Header__c.Lessee_Solitation__c';
import Lessee_Rep from '@salesforce/schema/Contract_Pdf_Header__c.Lessee_Rep__c';
import Lessee_Rep_Designation from '@salesforce/schema/Contract_Pdf_Header__c.Lessee_Rep_Designation__c';
import CUSTOMER_QUOTE from '@salesforce/schema/Contract_Pdf_Header__c.Customer_Quote__c';
import Account from '@salesforce/schema/Contract_Pdf_Header__c.Account__c';
import SECTOR from '@salesforce/schema/Contract_Pdf_Header__c.Sector__c';
import PO_Box from '@salesforce/schema/Contract_Pdf_Header__c.P_O_Box__c';
import CUS_Business_Location from '@salesforce/schema/Contract_Pdf_Header__c.Customer_Business_Location__c';
import With_Driver from '@salesforce/schema/Contract_Pdf_Header__c.With_Driver__c';
import With_Fuel from '@salesforce/schema/Contract_Pdf_Header__c.With_Fuel__c';
import Sh1_Clause12_11Aa_Payment_Percentage from '@salesforce/schema/Contract_Pdf_Header__c.Sh1_Clause12_11Aa_Payment_Percentage__c';
import Sh1_Clause12_11Ac_Delayed_Days from '@salesforce/schema/Contract_Pdf_Header__c.Sh1_Clause12_11Ac_Delayed_Days__c';
import Sh1_Clause12_11Ad_Delayed_Days from '@salesforce/schema/Contract_Pdf_Header__c.Sh1_Clause12_11Ad_Delayed_Days__c';
import Sh1_Clause12_2_Calendar_Days from '@salesforce/schema/Contract_Pdf_Header__c.Sh1_Clause12_2_Calendar_Days__c';
import Sh1_Clause12_Ab_Return_Cheque_Amount from '@salesforce/schema/Contract_Pdf_Header__c.Sh1_Clause12_Ab_Return_Cheque_Amount__c';
import Sh1_Clause14_4_Insurance_Excess_Charge from '@salesforce/schema/Contract_Pdf_Header__c.Sh1_Clause14_4_Insurance_Excess_Charge__c';
import Sh1_Clause15_1_Rental_Months from '@salesforce/schema/Contract_Pdf_Header__c.Sh1_Clause15_1_Rental_Months__c';
import Sh1_Clause15_1b_Rental_Months from '@salesforce/schema/Contract_Pdf_Header__c.Sh1_Clause15_1b_Rental_Months__c';
import Sh1_Clause15_1b2_Rental_Months from '@salesforce/schema/Contract_Pdf_Header__c.Sh1_Clause15_1b2_Rental_Months__c';
import Sh1_Clause15_1c_Rental_Months from '@salesforce/schema/Contract_Pdf_Header__c.Sh1_Clause15_1c_Rental_Months__c';
import Sh1_Clause15_1c5_Rental_Months from '@salesforce/schema/Contract_Pdf_Header__c.Sh1_Clause15_1c5_Rental_Months__c';
import Sh1_Clause15_1c6_Rental_Months from '@salesforce/schema/Contract_Pdf_Header__c.Sh1_Clause15_1c6_Rental_Months__c';
import Sh1_Clause3_1_Agreement_YearMonth from '@salesforce/schema/Contract_Pdf_Header__c.Sh1_Clause3_1_Agreement_YearsMonths__c';
import Sh1_Clause3_1_Minimum_Period from '@salesforce/schema/Contract_Pdf_Header__c.Sh1_Clause3_1_Minimum_Period__c';
import Sh1_Clause5_1_Vehicle_Percentage from '@salesforce/schema/Contract_Pdf_Header__c.Sh1_Clause5_1_Vehicle_Percentage__c';
import Sh1_Clause7_1_KM_Reading from '@salesforce/schema/Contract_Pdf_Header__c.Sh1_Clause7_1_KM_Reading__c';
import Sh1_Clause7_2_Charge_Additional_KM from '@salesforce/schema/Contract_Pdf_Header__c.Sh1_Clause7_2_Charge_Additional_KM__c';
import Sh1_Clause9_1_Branding_Charge from '@salesforce/schema/Contract_Pdf_Header__c.Sh1_Clause9_1_Branding_Charge__c';
import Early_Termination_After_LPO from '@salesforce/schema/Contract_Pdf_Header__c.Early_termination_Fee_After_Issue_LPO__c';
import Sh1_Clause12_4_Salik_Darb from '@salesforce/schema/Contract_Pdf_Header__c.Sh1_Clause12_4_SALIK_DARB__c';
import Sh1_Clause12_3_TF_Admin_Fee from '@salesforce/schema/Contract_Pdf_Header__c.Sh1_Clause12_3_TF_Admin_Fee__c';
import Sh1_Clause16_1_TF_Client_Driver_Req from '@salesforce/schema/Contract_Pdf_Header__c.Sh1_Clause16_1_TF_Client_Driver_Required__c';
import Sh1_Clause18_1f_Traffic_Offence from '@salesforce/schema/Contract_Pdf_Header__c.Sh1_Clause18_1f_Traffic_Offence__c';
import Sh1_Clause17_3_Breach_of_Permitted_Use from '@salesforce/schema/Contract_Pdf_Header__c.Sh1_Clause17_3_Breach_of_Permitted_Use__c';
import Sh1_Clause4_4_Smoking_Charges from '@salesforce/schema/Contract_Pdf_Header__c.Sh1_Clause4_4_Smoking_Charges__c';
import Sh1_Clause16_4_Charges_for_Letters_Certs from '@salesforce/schema/Contract_Pdf_Header__c.Sh1_Clause16_4_Charges_of_Letters_Certs__c';
import Sh1_Clause16_2_Delay_In_Renewal from '@salesforce/schema/Contract_Pdf_Header__c.Sh1_Clause16_2_Delay_in_Renewal__c';
import Effective_Date from '@salesforce/schema/Contract_Pdf_Header__c.Effective_Date__c';
import Account_Emirate from '@salesforce/schema/Contract_Pdf_Header__c.Account_Emirate__c';
import Trade_License from '@salesforce/schema/Contract_Pdf_Header__c.Trade_License__c';
import Scope_of_work from '@salesforce/schema/Contract_Pdf_Header__c.Scope_of_work__c';
import Scope_of_Work_Header from '@salesforce/schema/Contract_Pdf_Header__c.Scope_of_Work_Header__c';
import Annexure_Agreement_Years from '@salesforce/schema/Contract_Pdf_Header__c.Annexure_Agreement_Years__c';
import Annexure_Allocated_Fuel_Price from '@salesforce/schema/Contract_Pdf_Header__c.Annexure_Allocated_Fuel_Price__c';
import Annexure_Allownce_Fuel_Price from '@salesforce/schema/Contract_Pdf_Header__c.Annexure_Allownce_Fuel_Price__c';
import Annexure_Payment_Days from '@salesforce/schema/Contract_Pdf_Header__c.Annexure_Payment_Days__c';
import Vehicle_Insurance from '@salesforce/schema/Contract_Pdf_Header__c.Vehicle_Insurance__c';
import Maintenance from '@salesforce/schema/Contract_Pdf_Header__c.Maintenance__c';
import Traffic_fines from '@salesforce/schema/Contract_Pdf_Header__c.Traffic_fines__c';
import Damage_Penalty from '@salesforce/schema/Contract_Pdf_Header__c.Damage_Penalty__c';
import Impound_Vehicle_Recovery_Charges from '@salesforce/schema/Contract_Pdf_Header__c.Impound_Vehicle_Recovery_Charges__c';
import Delay_in_renewal_process from '@salesforce/schema/Contract_Pdf_Header__c.Delay_in_renewal_process__c';
import Laws_or_Decisions from '@salesforce/schema/Contract_Pdf_Header__c.Laws_or_Decisions__c';
import Fuel_Price from '@salesforce/schema/Contract_Pdf_Header__c.Fuel_Price__c';
import Fuel_differences from '@salesforce/schema/Contract_Pdf_Header__c.Fuel_differences__c';
import Additional_Term from '@salesforce/schema/Contract_Pdf_Header__c.Additional_Term__c';
import Replacement from '@salesforce/schema/Contract_Pdf_Header__c.Replacement__c';
import Vehicle_Count from '@salesforce/schema/Contract_Pdf_Header__c.Vehicle_Count__c';
import Manpower_Count from '@salesforce/schema/Contract_Pdf_Header__c.Manpower_Count__c';
import Contract_Pdf_Header from '@salesforce/schema/Contract_Pdf_Header__c';

import getAllContractLines from '@salesforce/apex/PRI_customerQuoteController.getAllContractLines';
import buildAdditionalArticles from '@salesforce/apex/PRI_customerQuoteController.buildAdditionalArticles';
import getEditables from '@salesforce/apex/PRI_customerQuoteContractController.getEditables';
import { loadStyle } from 'lightning/platformResourceLoader';
import externalCustCode from '@salesforce/resourceUrl/externalCustCode';

export default class GenerateContract extends NavigationMixin(LightningElement) {
    SPNR = true;
    @api recordId;
    totalContractLines = 0;
    contractHeaderObject = Contract_Pdf_Header;
    contractHeader = {
        Effective_Date,
        ET_Rep_Solitation,
        ET_Representative,
        ET_Rep_Designation,
        Lessee_Solitation,
        Lessee_Rep,
        Lessee_Rep_Designation,
        CUSTOMER_QUOTE,
        Account,
        SECTOR,
        PO_Box,
        CUS_Business_Location,
        With_Driver,
        With_Fuel,
        Sh1_Clause12_11Aa_Payment_Percentage,
        Sh1_Clause12_11Ac_Delayed_Days,
        Sh1_Clause12_11Ad_Delayed_Days,
        Sh1_Clause12_2_Calendar_Days,
        Sh1_Clause12_Ab_Return_Cheque_Amount,
        Sh1_Clause14_4_Insurance_Excess_Charge,
        Sh1_Clause15_1_Rental_Months,
        Sh1_Clause3_1_Agreement_YearMonth,
        Sh1_Clause3_1_Minimum_Period,
        Sh1_Clause5_1_Vehicle_Percentage,
        Sh1_Clause15_1b_Rental_Months,
        Sh1_Clause15_1b2_Rental_Months,
        Sh1_Clause15_1c_Rental_Months,
        Sh1_Clause15_1c5_Rental_Months,
        Sh1_Clause15_1c6_Rental_Months,
        Sh1_Clause7_1_KM_Reading,
        Sh1_Clause7_2_Charge_Additional_KM,
        Sh1_Clause9_1_Branding_Charge,
        Sh1_Clause12_4_Salik_Darb,
        Sh1_Clause12_3_TF_Admin_Fee,
        Sh1_Clause16_1_TF_Client_Driver_Req,
        Sh1_Clause18_1f_Traffic_Offence,
        Sh1_Clause17_3_Breach_of_Permitted_Use,
        Sh1_Clause4_4_Smoking_Charges,
        Sh1_Clause16_4_Charges_for_Letters_Certs,
        Sh1_Clause16_2_Delay_In_Renewal,
        Account_Emirate,
        Trade_License,
        Early_Termination_After_LPO,
        Scope_of_work,
        Scope_of_Work_Header,
        Annexure_Agreement_Years,
        Annexure_Allocated_Fuel_Price,
        Annexure_Allownce_Fuel_Price,
        Annexure_Payment_Days,
        Vehicle_Insurance,
        Maintenance,
        Traffic_fines,
        Damage_Penalty,
        Impound_Vehicle_Recovery_Charges,
        Delay_in_renewal_process,
        Laws_or_Decisions,
        Fuel_Price,
        Fuel_differences,
        Additional_Term,
        Replacement,
        Manpower_Count,
        Vehicle_Count

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
    @track fourthYearTermination;
    @track fifthYearTermination;
    @track sixthYearTermination;
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
            this.ContractStart = this.customerQuoteData.ContractStart;
            this.ContractEnd = this.customerQuoteData.ContractEnd;
            this.AnnualKMCharge = this.customerQuoteData.AnnualKMCharge;
            this.InsuranceExcessCharge = this.customerQuoteData.InsuranceExcessCharge;
            this.CelanderDays = this.customerQuoteData.CelanderDays;
            this.DelayPaymentPer = this.customerQuoteData.DelayPaymentPer;
            this.firstYearTermination  = this.customerQuoteData.firstYearTermination;
            this.secondYearTermination= this.customerQuoteData.secondYearTermination;
            this.thirdYearTermination  = this.customerQuoteData.thirdYearTermination;
            this.fourthYearTermination= this.customerQuoteData.fourthYearTermination;
            this.fifthYearTermination  = this.customerQuoteData.fifthYearTermination;
            this.sixthYearTermination  = this.customerQuoteData.sixthYearTermination;
            this.contractType = this.customerQuoteData.ContractType;
            this.tradeLicense = this.customerQuoteData.TradeLicense;
            this.lpoTermination = this.customerQuoteData.LPOTermination;
            this.salikDarb = this.customerQuoteData.SalikDarb;
            this.trafficFineAdmin = this.customerQuoteData.trafficFineAdmin;
            this.trafficFineClientDriver = this.customerQuoteData.TFClientDirver;
            this.trafficOffense = this.customerQuoteData.trafficOffense;
            this.breachPermittedUse = this.customerQuoteData.breachPermittedUse;
            this.smokingCharges = this.customerQuoteData.smokingCharges;
            this.chargesLettersCert = this.customerQuoteData.chargesLettersCert;
            this.delayRenewal = this.customerQuoteData.delayRenewal;
            this.accId = this.customerQuoteData.Account;
            this.brandingCharge = this.customerQuoteData.brandingCharge;
            this.returnChecque = this.customerQuoteData.returnChecque;
            this.delayPaySuspension = this.customerQuoteData.delayPaySuspension;
            this.delayPaytermination = this.customerQuoteData.delayPaytermination;
            this.vehReplacePer = this.customerQuoteData.vehReplacePer;
            this.vehInsurance = this.customerQuoteData.Vehicle_Insurance ? this.customerQuoteData.Vehicle_Insurance : 'No';
            this.maintenance = this.customerQuoteData.Maintenance ? this.customerQuoteData.Maintenance : 'No';
            this.trafficFines = this.customerQuoteData.Traffic_fines ? this.customerQuoteData.Traffic_fines : 'No';
            this.demagePenalty = this.customerQuoteData.Damage_Penalty ? this.customerQuoteData.Damage_Penalty : 'No';
            this.impoundVehCharge = this.customerQuoteData.Impound_Vehicle_Recovery_Charges ? this.customerQuoteData.Impound_Vehicle_Recovery_Charges : 'No';
            this.lawDecisions = this.customerQuoteData.Laws_or_Decisions ? this.customerQuoteData.Laws_or_Decisions : 'No';
            this.fuelPrice = this.customerQuoteData.Fuel_Price ? this.customerQuoteData.Fuel_Price : 'No';
            this.fuelDifferences = this.customerQuoteData.Fuel_differences ? this.customerQuoteData.Fuel_differences : 'No';
            this.additionalTerm = this.customerQuoteData.Additional_Term ? this.customerQuoteData.Additional_Term : 'No';
            this.replacement = this.customerQuoteData.Replacement ? this.customerQuoteData.Replacement : 'No';
            /*this.vehInsurance = this.customerQuoteData.Vehicle_Insurance;
            this.maintenance = this.customerQuoteData.Maintenance;
            this.trafficFines = this.customerQuoteData.Traffic_fines;
            this.demagePenalty = this.customerQuoteData.Damage_Penalty;
            this.impoundVehCharge = this.customerQuoteData.Impound_Vehicle_Recovery_Charges;
            this.lawDecisions = this.customerQuoteData.Laws_or_Decisions;
            this.fuelPrice = this.customerQuoteData.Fuel_Price;
            this.fuelDifferences = this.customerQuoteData.Fuel_differences;
            this.additionalTerm = this.customerQuoteData.Additional_Term;
            this.replacement = this.customerQuoteData.Replacement;*/
            this.vehicleQuoteItemsCount = this.customerQuoteData.vehicleQuoteItemsCount;
            this.workforceQuoteItemsCount = this.customerQuoteData.workforceQuoteItemsCount;
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
        if(this.RecordsData.ETSALES_Sector__c == 'School'){
            this.addSector ='ST';
        }else if(this.RecordsData.Opportunity_Name__r.RecordType.Name == 'Transportation'){
            this.addSector= 'Transportation';
        }else{
            this.addSector= 'T&L';
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
        await getAllContractLines({recordId: this.recordId}).then((response) => {
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
        this.contractHeaderId = event.detail.id;
        var contractHeaderId = this.contractHeaderId;

        let contractSections = this.template.querySelectorAll('c-generate-contract-lines');
        totalItems = contractSections.length;
        contractSections.forEach(child => {
            child.handleContractHeaderId(contractHeaderId);
        });

        this.totalContractLines = totalItems;
        console.log('---Total Lines---'+this.totalContractLines);
        this.navigateToRecordPage(contractHeaderId, 'Contract_Pdf_Header__c');
    }

    handleError(event) {
        console.error('Error in form submission:', event.detail.message);
    }

    navigateToRecordPage(contractHeaderId, obj) {
        
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                ObjectApiName :obj,
                recordId: contractHeaderId,
                actionName: 'view'
            }
        });
    }
    @track agreementYear = 1; // Default value set to 1 year
    get isFirstYearVisible() {
        return this.agreementYear >= 1;
    }

    get isSecondYearVisible() {
        return this.agreementYear >= 2;
    }

    get isThirdYearVisible() {
        return this.agreementYear >= 3;
    }

    get isFourthYearVisible() {
        return this.agreementYear >= 4;
    }

    get isFifthYearVisible() {
        return this.agreementYear >= 5;
    }

    get isSixthYearVisible() {
        return this.agreementYear >= 6;
    }
    getAgreementYear(event){
        this.agreementYear = event.target.value;












        if (this.agreementYear.length > 1 ) {
            // event.preventDefault();
            //add message for length validation
        }
    }
        
}