import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CUSTOMER_VEHICLE_QUOTE_OBJECT from '@salesforce/schema/Customer_Vehicle_Quote_Item__c';
import NAME from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Name';
import NUMBER_OF_VEHICLE from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Number_of_Vehicles__c';
import TOTAL_VEHICLE_COST from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Total_Vehicles_Cost__c';
import EXTRA_COST from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Extra__c';
import VEHICLE_MONTHLY_PRICE from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Vehicle_Monthly_Price__c';
import VEHICLE_MONTHLY_COST from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Vehicle_Monthly_Cost__c';
import VAT_PER_UNIT from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Vat_Per_Unit__c';
import MONTHLY_RATE_WITH_VAT from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Monthly_Rate_with_VAT__c';
import MONTHLY_RATE_ALL_UNITS_WITH_VAT from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Monthly_Rate_All_Unit_with_VAT__c';
import TOTAL_RATE_ALL_UNITS from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Total_Rate_All_Units__c';
import NO_OF_MONTHS from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.No_of_Months__c';
import NO_OF_YEARS from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.No_of_Years__c';
import CUSTOMER_QUOTE from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Customer_Quote__c';
import SERVICE_TYPE from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Service_Type__c';
import LINE_NUM from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Line_Number__c';
import CONTRACT_PERIODE from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Contract_Period_In_Years__c';
import VEH_SOURCE from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Vehicle_Source__c';
import ANNUAL_MILEAGE from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.ET_Total_Annual_Mileage__c';
import EXTRA_MILES from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Extra_Miles__c';
import REMARKS from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Remarks__c';
import DELIVERY_DAYS from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Delivery_Days__c';
import VAT from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Vat_Rate__c';
import EXPECTED_MOBILIZATION from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Expected_Mobilization__c';

// Lable and CheckBox
import LABEL_ROW from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Is_Label_Row__c';
import CHECKBOX_ROW from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Is_CheckBox_Row__c';

import CONTRACT_PERIOD from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Is_No_of_Months__c';
import LABEL_CONTRACT_PERIOD from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Label_No_of_Months__c';
import LABEL_VEHICLE_NAME from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Label_Name__c';
import IS_NUMBER_OF_VEHICLE from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Is_Number_of_Vehicles__c';
import LABEL_NUMBER_OF_VEHICLE from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Label_No_of_Vehicles__c';
import IS_VEHICLE_MONTHLY_PRICE from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Is_Vehicle_Monthly_Price__c';
import LABEL_VEHICLE_MONTHLY_PRICE from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Label_Vehicle_Monthly_Price__c';
import IS_MONTHLY_RATE_ALL_UNITS_WITH_VAT from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Is_Monthly_Rate_All_Unit_with_VAT__c';
import LABEL_MONTHLY_RATE_ALL_UNITS_WITH_VAT from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Label_Monthly_Rate_All_Unit_with_VAT__c';
import IS_TOTAL_RATE_ALL_UNITS from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Is_Total_Rate_All_Units__c';
import LABEL_TOTAL_RATE_ALL_UNITS from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Label_Total_Rate_All_Units__c';
import IS_ANNUAL_MILEAGE from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Is_ET_Total_Annual_Mileage__c';
import LABEL_ANNUAL_MILEAGE from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Label_ET_Total_Annual_Mileage__c';
import IS_VEH_SOURCE from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Is_Vehicle_Source__c';
import LABEL_VEH_SOURCE from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Label_Vehicle_Source__c';
import IS_EXTRA_MILES from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Is_Extra_Miles__c';
import LABEL_EXTRA_MILES from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Label_Extra_Miles__c';
import IS_DELIVERY_DAYS from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Is_Delivery_Days__c';
import LABEL_DELIVERY_DAYS from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Label_Delivery_Days__c';
import OPPORTUNITY from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Opportunity__c';
import QUOTE from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Quote__c';
import QUOTE_OPP_NUM from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Quote_Opp_Number__c';
import VEV_PURCHASE_PRICE from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Vehicle_Current_Purchase_Price__c';
import VEV_TOTAL_INVESTMENT from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Vehicle_Total_Investment__c';

// import CUSTOMER_QUOTE_CSS from '@salesforce/resourceUrl/ET_inspectionExternalStyle'
import { loadStyle } from 'lightning/platformResourceLoader';
import externalCustCode from '@salesforce/resourceUrl/externalCustCode';

export default class CutsomerQuoteLineItem extends LightningElement {
    @api isLabelLine = false;
    @api isCheckboxLine = false;
    @api isActualValuedLine = false;
    @api recordId;
    @api lineitem;
    @api contractType;
    @api customerQuoteId = '';
    @api sector;
    hasRendered  = false;
    isShowModal = false;
    checkBoxFlag = true;
    isMonthlyContract;
    @track calculatedCost = {
        'numberOfMonths' : '1',
        'numberOfYears' : '1',
        'extraCost' : '0',
        'monthlyVehicleCost' : '0',
        //'monthlyVehicleUnitPrice' : '0',
        // 'vatPerUnit' : '0',
        // 'monthRateWithVat' : '0',
        // 'monthRateAllUnitsWithVat': '0',
        'totalRateAllUnits' : '0',
        'monthRateAllUnits' : '0',
        'totalMileage' : '0'
    };
    vehicleQuoteItem = CUSTOMER_VEHICLE_QUOTE_OBJECT;
    customerQuoteFields = {
        NO_OF_MONTHS,
        NO_OF_YEARS,
        NAME,
        NUMBER_OF_VEHICLE,
        TOTAL_VEHICLE_COST,
        EXTRA_COST,
        VEHICLE_MONTHLY_PRICE,
        VEHICLE_MONTHLY_COST,
        VAT_PER_UNIT,
        MONTHLY_RATE_WITH_VAT,
        MONTHLY_RATE_ALL_UNITS_WITH_VAT,
        TOTAL_RATE_ALL_UNITS,
        CUSTOMER_QUOTE,
        SERVICE_TYPE,
        LINE_NUM,
        CONTRACT_PERIODE,
        VEH_SOURCE,
        ANNUAL_MILEAGE,
        EXTRA_MILES,
        REMARKS,
        DELIVERY_DAYS,
        VAT,
        EXPECTED_MOBILIZATION,

        LABEL_ROW,
        CHECKBOX_ROW,
        CONTRACT_PERIOD,
        LABEL_CONTRACT_PERIOD,
        LABEL_VEHICLE_NAME,
        IS_NUMBER_OF_VEHICLE,
        LABEL_NUMBER_OF_VEHICLE,
        IS_VEHICLE_MONTHLY_PRICE,
        LABEL_VEHICLE_MONTHLY_PRICE,
        IS_MONTHLY_RATE_ALL_UNITS_WITH_VAT,
        LABEL_MONTHLY_RATE_ALL_UNITS_WITH_VAT,
        IS_TOTAL_RATE_ALL_UNITS,
        LABEL_TOTAL_RATE_ALL_UNITS,
        IS_ANNUAL_MILEAGE,
        LABEL_ANNUAL_MILEAGE,
        IS_VEH_SOURCE,
        LABEL_VEH_SOURCE,
        IS_EXTRA_MILES,
        LABEL_EXTRA_MILES,
        IS_DELIVERY_DAYS,
        LABEL_DELIVERY_DAYS,
        OPPORTUNITY,
        QUOTE,
        QUOTE_OPP_NUM,
        VEV_PURCHASE_PRICE,
        VEV_TOTAL_INVESTMENT
    };
    //wholeMonthlyVehiclePrice;
    //@track wholeMonthlyVehicleCost;
    //@track wholemonthRateAllUnits;
    //@track wholemonthRateAllUnits;
    @api handleCustomerQuoteIdForVehicle(id){
        this.customerQuoteId = id;
        var customerQuoteIdField = this.template.querySelector('[data-id="customerQuoteId"]');
        customerQuoteIdField.value = id;
        this.template.querySelector('lightning-record-edit-form').submit();
    }

    handleError(event){
        console.log("----handleError event----");
        console.log(JSON.stringify(event.detail));
    }
    connectedCallback(){
        console.log('---connectedCallback----vehicle--'+this.contractType);
        console.log('---connectedCallback----Sector--'+this.sector);
        if(this.contractType == "Monthly"){
            this.isMonthlyContract = true;
        }else{
            this.isMonthlyContract = false;
        }
        console.log('lineitem>>>>>>>>', this.lineitem);
    }

    renderedCallback(){
        if(!this.hasRendered && this.isActualValuedLine){
            console.log('--renderedCallback--');
            this.calculateCost();
            this.hasRendered = true;
        }

        Promise.all([
			loadStyle(this, externalCustCode)
		])
		.then(() => {
            console.log("All scripts and CSS are loaded. perform any initialization function.")
            this.calculateCost();
        })
        .catch(error => {
            console.log("failed to load the scripts");
        });
        console.log('Child component updated with new line items:', this.lineitem);
    }
    
    get numberQuoteOpp() {
        return `${this.lineitem.quote.QuoteNumber} ${this.lineitem.quote.Opportunity.ETSALES_Opportunity_Number__c}`;
    }

    @track totalInvestment;
    
    calculateCost(){
        var extra = parseFloat(this.template.querySelector('[data-id="extraCost"]').value);
        var monthlyVehiclePrice = this.template.querySelector('[data-id="monthlyVehiclePrice"]').value;
        var noOfVehicle = this.template.querySelector('[data-id="noOfVehicle"]').value;
        var vehCost = this.template.querySelector('[data-id="VEV_PURCHASE_PRICE"]').value;
        noOfVehicle =  noOfVehicle == undefined ? 0 : noOfVehicle;
        extra =  extra == undefined ? 0 : extra;
        vehCost =  vehCost == undefined ? 0 : vehCost;
        this.totalInvestment = +noOfVehicle * +vehCost;
        
        monthlyVehiclePrice =  monthlyVehiclePrice == undefined ? 0 : monthlyVehiclePrice;
        //monthlyVehiclePrice = Math.floor(monthlyVehiclePrice);
        //var monthlyVehicleUnitPrice = monthlyVehiclePrice;
        //this.calculatedCost.monthlyVehicleUnitPrice = monthlyVehicleUnitPrice;
        //console.log('this.calculatedCost.monthlyVehicleUnitPrice>>>>>>>>>', this.calculatedCost.monthlyVehicleUnitPrice);
        //this.wholeMonthlyVehiclePrice = Math.floor(monthlyVehiclePrice);
        //console.log('this.wholeNumber>>>>>>>>>', this.wholeNumber);
        
        // console.log('--vateRate--'+vateRate);
        var numberOfMonths;
        if(this.isMonthlyContract){
            numberOfMonths = this.template.querySelector('[data-id="numberOfMonths"]').value;
        }else{
            if(this.sector == 'School'){
                numberOfMonths = this.template.querySelector('[data-id="numberOfYears"]').value * 10;
            }
            else{
                numberOfMonths = this.template.querySelector('[data-id="numberOfYears"]').value * 12;
            }
                
        }

        // console.log('--extra--', typeof extra);
        // console.log('--monthlyVehiclePrice--', typeof monthlyVehiclePrice);
        // console.log('--noOfVehicle--', typeof noOfVehicle);
        // console.log('--numberOfMonths--', typeof numberOfMonths);

        //clauclation for vehicle line item
        var monthlyVehicleCost  = monthlyVehiclePrice + extra;
        //this.wholeMonthlyVehicleCost = monthlyVehicleCost;
        // var vatPerUnit = monthlyVehicleCost * vateRate;
        // var monthRateWithVat = monthlyVehicleCost + vatPerUnit;
        // var monthRateAllUnitsWithVat = noOfVehicle * monthRateWithVat;
        var monthRateAllUnits = noOfVehicle * monthlyVehicleCost;
        var totalRateAllUnits = numberOfMonths * monthRateAllUnits;

        this.calculatedCost.monthlyVehicleCost = monthlyVehicleCost;
        // this.calculatedCost.vatPerUnit = vatPerUnit;
        // this.calculatedCost.monthRateWithVat = monthRateWithVat;
        // this.calculatedCost.monthRateAllUnitsWithVat = monthRateAllUnitsWithVat;
        this.calculatedCost.monthRateAllUnits = monthRateAllUnits;
        //console.log('Math.round(monthRateAllUnits)>>>>>>>', Math.round(monthRateAllUnits));
        //console.log('this.calculatedCost.monthRateAllUnits>>>>>>', this.calculatedCost.monthRateAllUnits);
        
        this.calculatedCost.totalRateAllUnits = totalRateAllUnits;
        
        //anual mileage
        // var monthlyMileage = this.lineitem.annualMileage/12;
        // this.calculatedCost.totalMileage = monthlyMileage * numberOfMonths;
        this.calculatedCost.totalMileage = this.lineitem.annualMileage;
    }

    handleOnSubmit(event){
        console.log('-----handleOnSubmit child----');
        // event.preventDefault();
        // const inputFields = this.template.querySelectorAll('lightning-input-field');
        
        // if (inputFields) {
        //     inputFields.forEach(field => {
        //         console.log("input name---",field.name);
        //         if(field.name === "Customer_Quote__c") {
        //             // Do something here with the field
        //             console.log("input name---",field);
        //         }
        //     });
        // }
    }

    handleVehicleDelete(event){
        var vehicleId = this.lineitem.vehicleLineId;
        console.log('vehicleId>>>>>>>>>>', vehicleId);
        this.dispatchEvent(new CustomEvent('deletevehicle', {
            detail: vehicleId
        }));
            }

    handleSuccess(event){
        var investment = this.totalInvestment;
        this.dispatchEvent(new CustomEvent("lineitemsave", {
            detail: investment
        }));
    }

    handleReset(event){

    }

    checkPositiveValue(event){
        console.log('---checkPositiveValue---'+event.charCode);
        if(event.charCode == 45)
            {   
                this.calculatedCost.extraCost = 0;
                this.showWarningToast();
                event.preventDefault();
            }
    }
    showWarningToast() {
        const evt = new ShowToastEvent({
            title: 'Warning',
            message: 'Negative values are not allowed in the Extra Cost field.',
            variant: 'warning',
        });
        this.dispatchEvent(evt);
    }    
    handleVehicleDetailClick(event){
        this.isShowModal = true;
    }

    hideModalBox() {  
        this.isShowModal = false;
    }
}