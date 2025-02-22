import { LightningElement, api, wire, track } from 'lwc';

import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import CUSTOMER_QUOTE_OBJECT from '@salesforce/schema/Customer_Quote__c';
import QUOTE_NUMBER from '@salesforce/schema/Customer_Quote__c.Name__c';
import QUOTE_NAME from '@salesforce/schema/Customer_Quote__c.Name';
import GRAND_TOTAL from '@salesforce/schema/Customer_Quote__c.Grand_Total__c';
import TOTAL_AMOUNT from '@salesforce/schema/Customer_Quote__c.Total_Amount__c';
import ACCOUNT_NAME from '@salesforce/schema/Customer_Quote__c.Account_Name__c';
import SECTOR from '@salesforce/schema/Customer_Quote__c.ETSALES_Sector__c';
import OPPO_NUM from '@salesforce/schema/Customer_Quote__c.Opportunity_Number__c';
import CLIENT_TYPE from '@salesforce/schema/Customer_Quote__c.clientType__c';
import QUOTE_TOTAL_INVESTMENT from '@salesforce/schema/Customer_Quote__c.Quote_Total_Investment__c';
import OPPO_NAME from '@salesforce/schema/Customer_Quote__c.Opportunity_Name__c';
import QUOTE from '@salesforce/schema/Customer_Quote__c.Quote__c';
import ACC_NUM from '@salesforce/schema/Customer_Quote__c.AccountNumber__c';
import REC_TYPE from '@salesforce/schema/Customer_Quote__c.RecordType__c';
import FUEL from '@salesforce/schema/Customer_Quote__c.Fuel_Included_Current_Contract__c';
import COMMENT from '@salesforce/schema/Customer_Quote__c.Comments__c';
import CONTRACT_TYPE from '@salesforce/schema/Customer_Quote__c.Contract_Type__c';
import ADDITIONAL_CHARGES from '@salesforce/schema/Customer_Quote__c.Additional_Terms_Charges__c';
import CUSTOMER_NAME from '@salesforce/schema/Customer_Quote__c.CustomerName__c';
import CUSTOMER_TITLE from '@salesforce/schema/Customer_Quote__c.Contact_PersonTitle__c';
import CUSTOMER_QUOTE_DATE from '@salesforce/schema/Customer_Quote__c.Customer_Quote_Date__c';
import ADDITIONAL_NOTES from '@salesforce/schema/Customer_Quote__c.Additional_Notes__c';
import GROUP_BY from '@salesforce/schema/Customer_Quote__c.Group_By__c';
// import CUSTOMER_QUOTE_VEHICLE from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Customer_Quote__c';


import getQuoteData from '@salesforce/apex/PRI_customerQuoteControllerManual.getPSRData';
import fetchLineItems from '@salesforce/apex/PRI_customerQuoteControllerManual.fetchLineItems';
import fetchOppoRelatedPSRList from '@salesforce/apex/PRI_customerQuoteControllerManual.fetchOppoRelatedPSRList';
import getAllTerms from '@salesforce/apex/PRI_customerQuoteControllerManual.getAllTerms';
import updateTotalAmount from '@salesforce/apex/PRI_customerQuoteController.updateTotalAmount';

export default class CustomerQuote extends NavigationMixin(LightningElement) {
    @api recordId = null; //test
    @track sectorCheck;
    @track opportunityData = {}; // To hold the fetched Opportunity data
    @track error;
    @track manualVehLines = [];
    @track manualWorkforceLines = [];
    objectName = 'Quote'; // as we have same button in the two obecjcts Quote and opportunity
    isQuote = true;
    quote = null;
    vehicleIds = [];
    isloading = true;
    isContractTypeSelected = false;
    isQuoteSelected = false;
    contractType = 'Monthly';
    customerQuote = CUSTOMER_QUOTE_OBJECT;
    customerQuoteId;
    customerQuoteFields = {
        QUOTE_NAME,
        QUOTE_NUMBER,
        // TOTAL_INVESTMENT,
        GRAND_TOTAL,
        TOTAL_AMOUNT,
        ACCOUNT_NAME,
        SECTOR,
        OPPO_NUM,
        CLIENT_TYPE,
        QUOTE_TOTAL_INVESTMENT,
        OPPO_NAME,
        QUOTE,
        ACC_NUM,
        REC_TYPE,
        COMMENT,
        ADDITIONAL_CHARGES,
        FUEL,
        CONTRACT_TYPE,
        CUSTOMER_NAME,
        CUSTOMER_TITLE,
        CUSTOMER_QUOTE_DATE,
        ADDITIONAL_NOTES,
        GROUP_BY
    };
    workforceIds = {};

    quoteDetail = {};
    @track quoteWorkforce = [];
    @track quoteVehicleLines = [];
    @track quoteWorkforceLines = [];
    quoteVehicleLinesExist = false;
    quoteWorkforceLinesExist = false;
    vehicleUniqueKeys = [];//to calculate total investment
    get options() {
        return [
            // { label: 'Select Quote', value: '', selected: true },
            { label: 'Monthly', value: 'Monthly', selected: true },
            { label: 'Yearly', value: 'Yearly' },
        ];
    }

    @track quoteListOption = [];
    totalInvestment = 0;

    lineNo = 1;
    @track termsDetail = [];
    allTerms;
    totalLineItems = 0;

    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        this.currentPageReference = currentPageReference;
        this.recordId = this.currentPageReference.state.c__recordId;
        if (this.currentPageReference.state.c__objectName != undefined) {
            this.objectName = this.currentPageReference.state.c__objectName;
            this.isQuote = this.objectName == 'Quote' ? true : false;
        }
        console.log("----recordId----" + this.recordId);
    }

    connectedCallback() {

        console.log('IN Manual>>>>>>>>>>>');
        console.log('recordId>>>>>>>>>', this.recordId);
        // this.manualVehLines = [
        //     {
        //         id: 1  // Initialize with a unique id
        //     }
        // ];
        // console.log('In connect manual lines>>>>>', this.manualVehLines);

        // this.manualWorkforceLines = [
        //     {
        //         id: 1  // Initialize with a unique id
        //     }
        // ];
        // console.log('In connect manualWorkforceLines>>>>>', this.manualWorkforceLines);
        console.log('this.objectName>>>>>>>>>', this.objectName);
         if (this.objectName == 'Quote') {
             this.fetchQuoteData();
             this.fetchLines();
         } else {
             this.fetchOppoRelatedPSRList();
         }
        this.fetchAllTerms();
        // this.fetchQuoteVehicleLineData();
        // this.fetchWorkforceQuoteLineItemsData();
        
    }

    
    handleAddNewLine(event) {
        console.log('In handle parent method>>>>>');
        console.log('In handle parent manual lines>>>>>', this.manualVehLines);
        // Create a new line item with a unique id
        let newLineItem = {
            id: this.quoteVehicleLines.length + 1,  // Using array length to generate a unique id
            Name: '',  // Initialize other fields as needed
            vehquantity: ''
        };

        // Add the new line item to the manualVehLines array
        this.quoteVehicleLines = [...this.quoteVehicleLines, newLineItem];

        console.log('Updated quoteVehicleLines:', this.quoteVehicleLines);
    }

    handleDeleteLine(event) {
        console.log('In delete Parent>>>>>');
        const lineIdToDelete = +event.detail;
        console.log('lineIdToDelete Parent>>>>>', lineIdToDelete);
        if(lineIdToDelete)
        {
            // Filter the array to remove the item with the matching id
            this.quoteVehicleLines = this.quoteVehicleLines.filter(line => +line.id !== lineIdToDelete);
            this.quoteVehicleLines = [...this.quoteVehicleLines];
        }
        else{
            var vehicleId = event.detail;
            console.log('vehicleId Delete Parent>>>>>', vehicleId);
            var index = this.quoteVehicleLines.findIndex(x => x.vehicleLineId === vehicleId);
            this.quoteVehicleLines.splice(index, 1);
        }
        
       
        console.log('Updated manualVehLines after delete:', this.quoteVehicleLines);
    }
    

    handleAddNewWorkforceLine(event) {
        console.log('In handle parent method>>>>>');
        console.log('In handle parent manual lines>>>>>', this.manualWorkforceLines);
        // Create a new line item with a unique id
        let newLineItem = {
            id: this.quoteWorkforceLines.length + 1,  // Using array length to generate a unique id
            field1: '',  // Initialize other fields as needed
            field2: ''
        };

        // Add the new line item to the manualVehLines array
        this.quoteWorkforceLines = [...this.quoteWorkforceLines, newLineItem];

        console.log('Updated quoteWorkforceLines:', this.quoteWorkforceLines);
    }

    handleDeleteWorkforceLine(event) {
        console.log('In delete Parent>>>>>');
        //console.log('In line.id Parent>>>>>', line.id);
        const lineIdToDelete = +event.detail; // Get the id of the line to delete
        console.log('lineIdToDelete Parent>>>>>', lineIdToDelete);
        if(lineIdToDelete)
        {
              
            // Filter the array to remove the item with the matching id
            this.quoteWorkforceLines = this.quoteWorkforceLines.filter(line => +line.id !== lineIdToDelete);
        }
        else
        {
            const lineIdToDelete = event.detail;
            console.log('lineIdToDelete Parent In Esle>>>>>', lineIdToDelete);
            this.quoteWorkforceLines = this.quoteWorkforceLines.filter(line => line.workForceId !== lineIdToDelete);
        }
        //var index = this.manualWorkforceLines.findIndex(x => x.id === lineIdToDelete);
        //console.log('index for delete:',index);
        //this.manualWorkforceLines.splice(index, 1);
        this.quoteWorkforceLines = [...this.quoteWorkforceLines];
        console.log('Updated quoteWorkforceLines after delete:', this.quoteWorkforceLines);
    }
    handleQuoteSelection(event) {
        this.isQuoteSelected = true;
        console.log('---handleQuoteSelection---' + event.detail.value);
        this.recordId = event.detail.value;
        //alert(event.detail.value);
        this.fetchQuoteData();
        this.fetchLines();
    }

    handleContractTypeChange(event) {
        var contractTypeField = this.template.querySelector('[data-id="contractType"]');
        this.contractType = contractTypeField.value;
        this.quoteDetail.contractVal = this.contractType;
        // contractTypeField.disabled = true;
        this.isContractTypeSelected = true;

        //upon contract Type change fetch lines data again
        if (this.isQuoteSelected) {
            this.quoteVehicleLines = [];
        //     this.quoteWorkforceLines = [];
             this.fetchLines();
             this.passContractTypeToChild();
         }
    }

    fetchQuoteData() {
        console.log('--fetchQuoteData-- ' + this.recordId);
        getQuoteData({ recordIds: this.recordId }).then((response) => {
            console.log('--fetchQuoteData--');
            console.log(response);
            if (response != null) {
                this.mapQuoteToCustomerQuote(response);
            }
        }).catch((error) => {
            console.log('error>>>>>>>>', error);
            console.error(JSON.stringify(error));
        })
    }  

    fetchLines() {
        console.log('In Fetch Lines>>>>>>>');
        fetchLineItems({ quoteIds: this.recordId, contractType: this.contractType }).then((response) => {
            console.log('--fetchLineItems>>>>>>', response);
            console.log(response);
            if (response != null) {
                this.isLoading = false;
                this.quoteVehicleLines = response.vehicleLines;
                console.log('--quoteVehicleLines--length-' + this.quoteVehicleLines.length);
                this.quoteVehicleLinesExist = this.quoteVehicleLines.length > 0 ? true : false;
                this.quoteWorkforceLines = response.workforceLines;
                console.log('--quoteWorkforceLines--length-' + this.quoteWorkforceLines.length);
                this.quoteWorkforceLinesExist = this.quoteWorkforceLines.length > 0 ? true : false;
                //to calculate total investment, we need to keep track of unique vehicles list
                var uniqueKeys = [];
                this.quoteVehicleLines.forEach(vehicle => {
                    uniqueKeys.push(vehicle.Name);
                });
                this.vehicleUniqueKeys = uniqueKeys;
            }

        }).catch((error) => {
            console.log('error In Fetch Line>>>>>>>>>>', error);
            console.log('error In Fetch Line>>>', JSON.stringify(error));
        })
    }


    mapQuoteToCustomerQuote(response) {
        console.log('mapQuoteToCustomerQuote response: ' + JSON.stringify(response));
        var mapData = Object.keys(response).map(key => {
            return { key: key, value: response[key] };
        });
        var quoteDetail;
        //var totalInvestment = 0;
        var customerQuoteCount = 0;
        // Generate a random integer (e.g., between 1000 and 9999)
        let randomNumber = Math.floor(100 + Math.random() * 900);
        mapData.forEach(item => {
            console.log(`Key: ${item.key}, Value: ${JSON.stringify(item.value)}`);
            if (!quoteDetail)
                quoteDetail = item.value.quote;
            //totalInvestment += item.value.quote.Quote_Total_Investment__c;
            customerQuoteCount += item.value.customerQuoteCount;
        });
       // console.log('totalInvestment: ' + totalInvestment);
        console.log('customerQuoteCount: ' + customerQuoteCount);

        if (quoteDetail.Status != 'Approved') {
            //    this.showWarningToast();
        }
        // this.quoteDetail.zone = response.GL_Zone__c;
        console.log('quoteDetail.Opportunity.ETSALES_Sector__c>>>>>>>>>', quoteDetail.Opportunity__r.ETSALES_Sector__c);
        this.quoteDetail.sector = quoteDetail.Opportunity__r.ETSALES_Sector__c;
        //this.quoteDetail.QuoteNumber = quoteDetail.QuoteNumber;
        this.quoteDetail.AccountId = quoteDetail.Opportunity__r.AccountId;
        this.quoteDetail.opp_num = quoteDetail.Opportunity__r.ETSALES_Opportunity_Number__c;
        this.quoteDetail.opp_Type = quoteDetail.Opportunity__r.Type;
        this.quoteDetail.clientType = quoteDetail.Opportunity__r.Account.ETSALES_Profile_Class__c;
        //this.quoteDetail.totalInvestment = totalInvestment; //quoteDetail.Quote_Total_Investment__c;
        this.quoteDetail.customerQuoteName = 'Manual CQ ' + quoteDetail.Opportunity__r.ETSALES_Opportunity_Number__c +'_'+ randomNumber;
        this.quoteDetail.oppoId = quoteDetail.Opportunity__r.Id;
        //this.quoteDetail.quoteId = quoteDetail.Id;
        this.quoteDetail.acc_num = quoteDetail.Opportunity__r.Account.AccountNumber;
        if (quoteDetail.Opportunity__r.RecordType.Name === 'Leasing/ Rental' || quoteDetail.Opportunity__r.RecordType.Name === 'Logistics' || quoteDetail.Opportunity__r.RecordType.Name === 'Manpower')
            this.quoteDetail.recordType = 'Leasing/ Rental';
        else if (quoteDetail.Opportunity.RecordType.Name === 'Transportation')
            this.quoteDetail.recordType = quoteDetail.Opportunity__r.RecordType.Name;
        this.quoteDetail.fuel = quoteDetail.Opportunity__r.Fuel_Included_Current_Contract__c;
        //this.totalInvestment = totalInvestment; //quoteDetail.Quote_Total_Investment__c;
        this.sectorCheck = this.quoteDetail.sector;
        console.log('sectorCheck>>>>>>>>>', this.sectorCheck);
    }

    // function to save customer quote related records
    handleSuccess(event) {
        var totalItems = 0
        this.customerQuoteId = event.detail.id;
        var customerQuote = this.customerQuoteId;

        let terms = this.template.querySelectorAll('c-terms-and-condition');
        totalItems = totalItems + terms.length;
        terms.forEach(term => {
            term.handleCustomerQuoteIdAndSaving(customerQuote);
        });

        let childManualVehicles = this.template.querySelectorAll('c-customer-quote-manual-vehicle');
        totalItems = totalItems + childManualVehicles.length;
        childManualVehicles.forEach(child => {
            child.handleCustomerQuoteIdForVehicle(customerQuote);
        });

        let childManualWorkforce = this.template.querySelectorAll('c-customer-quote-manual-workforce');
        totalItems = totalItems + childManualWorkforce.length;
        childManualWorkforce.forEach(child => {
            child.handleCustomerQuoteId(customerQuote);
        });
        
        this.totalLineItems = totalItems;
        console.log('---Total Lines---' + this.totalLineItems);
        this.navigateToRecordPage(customerQuote, 'Customer_Quote__c');
    }


    lineItemSaveHandler(event) {
        // console.log('--lineItemSaveHandler---');
        const childInvestment = event.detail;

        // Update the parent's total investment
        this.newtotalInvestment += childInvestment;
        

        this.totalLineItems--;
        console.log('this.totalLineItems>>>>>>>>', this.totalLineItems);
        if (this.totalLineItems <= 1) {
            console.log('this.newtotalInvestment>>>>>>>>', this.newtotalInvestment);
            console.log('this.customerQuote>>>>>>>>>>>>>>', this.customerQuote);
            console.log('this.customerQuote Idm>>>>>>>>>>>>>>', this.customerQuoteId);
            updateTotalAmount({ customerQuoteId: this.customerQuoteId, totalAmount: this.newtotalInvestment}).then((response) => {
                console.log('In Sucess>>>>>>>>>>>>>>');
                this.navigateToRecordPage(this.customerQuote, 'Customer_Quote__c');
            }).catch((error) => {
                console.log('error', error);
                console.error(error);
            })
            
        }
    }



    @track newtotalInvestment = 0;


    // @track newtotalInvestment = 0;

    // lineItemSaveHandler(event) {
    //     console.log('--lineItemSaveHandler Manual>>>>>>>>');
    //     console.log('this.customerQuote Idm>>>>>>>>>>>>>>', this.customerQuoteId);
    //     const childInvestment = event.detail;

    //     // Update the parent's total investment
    //     this.newtotalInvestment += childInvestment;
    //     this.totalLineItems--;
    //     if (this.totalLineItems == 0) {
            
    //         console.log('this.newtotalInvestment>>>>>>>>', this.newtotalInvestment);
           
    //         updateTotalAmount({ customerQuoteId: this.customerQuoteId, totalAmount: this.newtotalInvestment}).then((response) => {
    //             console.log('In Sucess>>>>>>>>>>>>>>');
    //             this.navigateToRecordPage(this.customerQuote, 'Customer_Quote__c');
    //         }).catch((error) => {
    //             console.log('error', error);
    //             console.error(error);
    //         })
            
    //     }
    // }

    handleLineItemsSaving(temp) {

        var childFields = this.template.querySelectorAll('lightning-input-field[data-id="customerQuoteId"]');
        console.log('-----childFields---', childFields);
        var childForms = this.template.querySelectorAll('lightning-record-edit-form[data-id="vehicles"]');
        console.log('-----childForms---', childForms);
        this.template.querySelectorAll('lightning-input-field[data-id="customerQuoteId"]').forEach((field) => {
            field.value = temp;
        });

        this.template.querySelectorAll('lightning-record-edit-form[data-id="vehicles"]').forEach((form) => {
            form.submit();
        });

    }

    navigateToRecordPage(customerQuote, obj) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: customerQuote,
                objectApiName: obj,
                actionName: 'view'
            }
        });
    }

    handleOnSubmit(event) {
    }

    handleError(event) {
        console.log("handleError event");
        console.log(JSON.stringify(event.detail));
    }

    handleCancel(event) {
        this.navigateToRecordPage(this.recordId, "Quote");
    }

    handleSaveClick(event) {
        console.log('---handleSaveClick----', this.template.querySelector('lightning-record-edit-form'));
        var form1 = this.template.querySelector('[data-id="customerQuote"]');
        console.log('---handleSaveClick--form1--', form1);
        form1.submit();
    }

    deleteVehicleLine(event) {
        var vehicleId = event.detail;
        var index = this.quoteVehicleLines.findIndex(x => x.vehicleLineId === vehicleId);
        this.reCalculateTotalInvestment(index);
        this.quoteVehicleLines.splice(index, 1);
    }

    reCalculateTotalInvestment(index) {
        var itemToDelete = this.quoteVehicleLines[index];
        var vehicleUniqueKeyIndex = this.vehicleUniqueKeys.indexOf(itemToDelete.Name);
        if (vehicleUniqueKeyIndex != -1) {
            this.vehicleUniqueKeys.splice(vehicleUniqueKeyIndex, 1);
        }
        //As we have multiple enteries for each vehicle, we will only subtract 
        //it from total investment unless no entry of specific vehilce exist.
        if (!(this.vehicleUniqueKeys.includes(itemToDelete.Name))) {
            if (itemToDelete.NumberOfVehicles && itemToDelete.purchasePrice) {
                this.totalInvestment -= itemToDelete.NumberOfVehicles * itemToDelete.purchasePrice;
            }
        }
    }

    deleteWorkForceLine(event) {
        var workforceId = event.detail;
        var index = this.quoteWorkforceLines.findIndex(x => x.workForceId === workforceId);
        this.quoteWorkforceLines.splice(index, 1);
    }

    showWarningToast() {
        const evt = new ShowToastEvent({
            title: 'No Active PSR Found',
            message: 'Please create or activate a PSR before creating Manual Customer Quote',
            variant: 'warning',
            mode: 'sticky'
        });
        this.dispatchEvent(evt);
        this.navigateToRecordPage(this.recordId, "Quote");
    }

    fetchOppoRelatedPSRList() {
        fetchOppoRelatedPSRList({ oppId: this.recordId }).then((response) => {
            console.log('-Quotes--', Object.keys(response).length);
            if (response && Object.keys(response).length != 0) {
                var listOptions = [];
                for (let key in response) {
                    listOptions.push({ label: response[key], value: key });
                }
                this.quoteListOption = listOptions;
                console.log('this.quoteListOption>>>>>>>>', this.quoteListOption);
            } else {
                this.showWarningToast();
            }

        }).catch((error) => {
            console.log('error');
            console.error(error);
        })
    }

    fetchAllTerms() {
        console.log('--fetchAllTerms--');
        getAllTerms({ oppoId: this.recordId }).then((response) => {
            console.log('this.response>>>>>>>>>>>>>>', response);
            if (response != null) {
                this.allTerms = response.allTerms;
                console.log('this.allTerms>>>>>>>>>>>>>>', this.allTerms);
                this.buildAllTermsArray(response.defaultTerms);
            }
        }).catch((error) => {
            console.log('error');
            console.error(error);
        })
    }

    buildAllTermsArray(defaultTerms) {
        defaultTerms.forEach(defaultTerm => {
            this.lineNo++;
            this.termsDetail.push({ lineNo: this.lineNo, termItem: defaultTerm, allTerms: "", isTermDisabled: "true" });
        });
        console.log('----buildAllTermsArray--', this.termsDetail);
    }

    addTermsAndConsitionRow(event) {
        console.log('---addTermsAndConsitionRow---');
        this.lineNo++;

        this.termsDetail.push({ lineNo: this.lineNo, termItem: {}, allTerms: this.allTerms, isTermDisabled: false });
    }

    removeTermsAndConsitionRow(event) {
        console.log('--removeTermsAndConsitionRow--');
        var lineNo = event.detail;
        var index = this.termsDetail.findIndex(x => x.lineNo === lineNo);
        this.termsDetail.splice(index, 1);
        this.lineNo--;
    }

    passContractTypeToChild() {
        if (this.quoteWorkforceLinesExist) {
            console.log('--contract Type Change--' + this.contractType);
            var workforceLabelComponent = this.template.querySelector('[data-id="labelLine"]');
            if (workforceLabelComponent != undefined) {
                workforceLabelComponent.changeContractType(this.contractType);
            }
            var workforceCheckBoxComponent = this.template.querySelector('[data-id="checkboxLine"]');
            if (workforceCheckBoxComponent != undefined) {
                workforceCheckBoxComponent.changeContractType(this.contractType);
            }
        }
    }
}