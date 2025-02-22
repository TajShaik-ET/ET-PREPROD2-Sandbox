import { LightningElement, api, track} from 'lwc';

import CUSTOMER_QUOTE_WORKFORCE_OBJECT from '@salesforce/schema/Customer_Workforce_Quote_Item__c';

import NO_OF_MONTHS from '@salesforce/schema/Customer_Workforce_Quote_Item__c.No_of_Months__c';
import NAME from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Name';
import REMARKS from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Remarks__c';
import NUMBER_OF_VEHICLE from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Number_of_Workforce__c';
import VEHICLE_MONTHLY_PRICE from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Workforce_Monthly_Price__c';
import MONTHLY_RATE_ALL_UNITS_WITH_VAT from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Monthly_Rate_All_Unit_with_VAT__c';
import TOTAL_RATE_ALL_UNITS from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Total_Rate_All_Units__c';
import TYPE from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Type__c';
import DELIVERY_DAYS from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Delivery_Days__c';

import TOTAL_VEHICLE_COST from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Total_Cost__c';
import EXTRA_COST from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Extra__c';
import VEHICLE_MONTHLY_COST from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Workforce_Monthly_Cost__c';
import VAT_PER_UNIT from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Vat_Per_Unit__c';
import MONTHLY_RATE_WITH_VAT from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Monthly_Rate_with_VAT__c';
import NO_OF_YEARS from '@salesforce/schema/Customer_Workforce_Quote_Item__c.No_of_Years__c';
import CUSTOMER_QUOTE from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Quote__c';
import CONTRACT_PERIODE from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Contract_Period__c';
import LINE_NUM from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Workforce_Line_Number__c';
import SERVICE_TYPE from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Service_Type__c';
import VAT from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Vat_Rate__c';
import EXPECTED_MOB from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Expected_Mobilization__c';
//SK
import IS_NO_OF_MONTHS from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Is_No_of_Months__c';
import LABEL_NO_OF_MONTHS from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Label_No_of_Months__c';

import IS_REMARKS from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Is_Remarks__c';
import LABEL_REMARKS from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Label_Remarks__c';

import IS_NUMBER_OF_WORKFORCE from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Is_Number_of_Workforce__c';
import LABEL_NUMBER_OF_WORKFORCE from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Label_Number_of_Workforce__c';

import IS_WORKFORCE_MONTHLY_PRICE from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Is_Workforce_Monthly_Price__c';
import LABEL_WORKFORCE_MONTHLY_PRICE from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Label_Workforce_Monthly_Price__c';

import IS_MONTHLY_RATE_ALL_UNIT_WITH_VAT from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Is_Monthly_Rate_All_Unit_with_VAT__c';
import LABEL_MONTHLY_RATE_ALL_UNIT_WITH_VAT from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Label_Monthly_Rate_All_Unit_with_VAT__c';

import IS_TOTAL_RATE_ALL_UNITS from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Is_Total_Rate_All_Units__c';
import LABEL_TOTAL_RATE_ALL_UNITS from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Label_Total_Rate_All_Units__c';

import IS_TYPE from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Is_Type__c';
import LABEL_TYPE from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Label_Type__c';

import IS_DELIVERY_DAYS from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Is_Delivery_Days__c';
import LABEL_DELIVERY_DAYS from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Label_Delivery_Days__c';
import OPPORTUNITY from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Opportunity__c';
import QUOTE from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Quote1__c';


// Lable and CheckBox
import LABEL_ROW from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Is_Label_Row__c';
import CHECKBOX_ROW from '@salesforce/schema/Customer_Workforce_Quote_Item__c.Is_CheckBox_Row__c';

import { loadStyle } from 'lightning/platformResourceLoader';
import externalCustCode from '@salesforce/resourceUrl/externalCustCode';



export default class CustomerQuoteWorkforceLineItem extends LightningElement {
    @api recordId;
    @api lineitem;
    @api contractType;
    @api customerQuoteId = '';
    @api isLabelLine= false;
    @api isCheckboxLine = false;
    @api isActualValuedLine = false;
    hasRendered  = false;
    checkBoxFlag = true;
    isMonthlyContract;
    @track calculatedCost = {
        'numberOfMonths' : '1',
        'numberOfYears' : '1',
        'extraCost' : '0',
        'monthlyVehicleCost' : '0',
        // 'vatPerUnit' : '0',
        // 'monthRateWithVat' : '0',
        // 'monthRateAllUnitsWithVat': '0',
        'totalRateAllUnits' : '0',
        'monthRateAllUnits' : '0'
    };
    workforceQuoteItem = CUSTOMER_QUOTE_WORKFORCE_OBJECT;
    customerQuoteWorkforceFields = {
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
        TYPE,
        LINE_NUM,
        SERVICE_TYPE,
        CONTRACT_PERIODE,
        VAT,
        REMARKS,
        DELIVERY_DAYS,
        EXPECTED_MOB,

        IS_NO_OF_MONTHS,
        LABEL_NO_OF_MONTHS,
        IS_REMARKS,
        LABEL_REMARKS,
        IS_NUMBER_OF_WORKFORCE,
        LABEL_NUMBER_OF_WORKFORCE,
        IS_WORKFORCE_MONTHLY_PRICE,
        LABEL_WORKFORCE_MONTHLY_PRICE,
        IS_MONTHLY_RATE_ALL_UNIT_WITH_VAT,
        LABEL_MONTHLY_RATE_ALL_UNIT_WITH_VAT,
        IS_TOTAL_RATE_ALL_UNITS,
        LABEL_TOTAL_RATE_ALL_UNITS,
        IS_TYPE,
        LABEL_TYPE,
        IS_DELIVERY_DAYS,
        LABEL_DELIVERY_DAYS,
        OPPORTUNITY,
        QUOTE,

        LABEL_ROW,
        CHECKBOX_ROW,

    };

    connectedCallback(){
        console.log('---connectedCallback----workforce--'+this.contractType);
        if(this.contractType == "Monthly"){
            this.isMonthlyContract = true;
        }else{
            this.isMonthlyContract = false;
        }
        // this.calculateCost();
    }

    renderedCallback(){
        console.log('---renderedCallback---'+this.isLabelLine);
        if(!this.hasRendered && this.isActualValuedLine){
            this.calculateCost();
            this.hasRendered = true;
        }
        Promise.all([
			loadStyle(this, externalCustCode)
		])
		.then(() => {
        })
        .catch(error => {
            console.log("failed to load the scripts");
        });
        
    }

    get numberQuoteOpp() {
        return `${this.lineitem.quote.QuoteNumber} ${this.lineitem.quote.Opportunity.ETSALES_Opportunity_Number__c}`;
    }

    calculateCost(){
        var extra = parseFloat(this.template.querySelector('[data-id="extraCost"]').value);
        var monthlyVehiclePrice = this.template.querySelector('[data-id="monthlyVehiclePrice"]').value;
        var noOfVehicle = this.template.querySelector('[data-id="noOfVehicle"]').value;
        // var vateRate = this.template.querySelector('[data-id="vatRate"]').value;

        // vateRate =  vateRate == undefined ? 0.05 : vateRate;
        noOfVehicle =  noOfVehicle == undefined ? 0 : noOfVehicle;
        extra =  extra == undefined ? 0 : extra;
        monthlyVehiclePrice =  monthlyVehiclePrice == undefined ? 0 : monthlyVehiclePrice;

        var numberOfMonths;
        if(this.isMonthlyContract){
            numberOfMonths = this.template.querySelector('[data-id="numberOfMonths"]').value;
        }else{
            numberOfMonths = this.template.querySelector('[data-id="numberOfYears"]').value * 12;
        }

        // console.log('--extra--', typeof extra);
        // console.log('--monthlyVehiclePrice--', typeof monthlyVehiclePrice);
        // console.log('--noOfVehicle--', typeof noOfVehicle);
        // console.log('--numberOfMonths--', typeof numberOfMonths);

        //clauclation for vehicle line item
        var monthlyVehicleCost  = monthlyVehiclePrice + extra;
        // var vatPerUnit = monthlyVehicleCost * vateRate;
        // var monthRateWithVat = monthlyVehicleCost + vatPerUnit;
        // var monthRateAllUnitsWithVat = noOfVehicle * monthRateWithVat;
        var monthRateAllUnits = noOfVehicle * monthlyVehicleCost;
        var totalRateAllUnits = numberOfMonths * monthRateAllUnits;

        this.calculatedCost.monthlyVehicleCost = monthlyVehicleCost;
        // this.calculatedCost.vatPerUnit = vatPerUnit;
        // this.calculatedCost.monthRateWithVat = monthRateWithVat;
        this.calculatedCost.monthRateAllUnits = monthRateAllUnits;
        this.calculatedCost.totalRateAllUnits = totalRateAllUnits;
    }

    @api handleCustomerQuoteId(id){
        this.customerQuoteId = id;
        var customerQuoteIdField = this.template.querySelector('[data-id="customerQuoteId"]');
        customerQuoteIdField.value = id;
        this.template.querySelector('lightning-record-edit-form').submit();
    }
    
    handleWorkforceDelete(event){
        var workforceId = this.lineitem.workForceId;
        this.dispatchEvent(new CustomEvent('deleteworkforce', {
            detail: workforceId
        }));
    }

    handleSuccess(event){
        this.dispatchEvent(new CustomEvent("lineitemsave"));
    }

    handleOnSubmit(event){
        console.log('-----handleOnSubmit----');
    }

    handleReset(event){

    }

    checkPositiveValue(event){
        console.log('---checkPositiveValue---'+event.charCode);
        if(!((event.charCode >= 48 && event.charCode <= 57) || event.charCode == 46)){
            event.target.value = 0;
        }
    }

    handleError(event){
        console.log("----handleError workforce----");
        console.log(JSON.stringify(event.detail));
    }

    //using this method to refresh the label and checkbox lines
    @api
    changeContractType(type){
        console.log('----changeContractType-----'+type);
        if(type == "Monthly"){
            this.isMonthlyContract = true;
        }else{
            this.isMonthlyContract = false;
        }
    }

}