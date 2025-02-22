import { LightningElement, api } from 'lwc';

import TERMS from '@salesforce/schema/TermsAndCondition__c';
import TERMS_DESC from '@salesforce/schema/TermsAndCondition__c.Terms_Description__c';
import TERMS_CODE from '@salesforce/schema/TermsAndCondition__c.Term_Code__c';
import CHARGE_TYPE from '@salesforce/schema/TermsAndCondition__c.Charge_Type__c';
import CHARGE_VALUE from '@salesforce/schema/TermsAndCondition__c.Charge_Value__c';
import CHARGE_VALUE_TYPE from '@salesforce/schema/TermsAndCondition__c.Charge_Type_Value__c';
import REMARKS from '@salesforce/schema/TermsAndCondition__c.Remarks__c';
import REMARKS_VALUE from '@salesforce/schema/TermsAndCondition__c.Remarks_Value__c';
import REMARKS_TYPE from '@salesforce/schema/TermsAndCondition__c.Remark_Type__c';
import CHARGEABLE from '@salesforce/schema/TermsAndCondition__c.Chargeable_to_Customer__c';
import SH_Order from '@salesforce/schema/TermsAndCondition__c.Line_Order__c';

import ADD_TERM from '@salesforce/schema/TermsAndCondition__c.Additional_Term_Text__c';
import CUSTOMER_QUOTE from '@salesforce/schema/TermsAndCondition__c.Customer_Quote__c';
import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';

import { loadStyle } from 'lightning/platformResourceLoader';
import externalCustCode from '@salesforce/resourceUrl/externalCustCode';

export default class PRI_termsAndCondition extends LightningElement {
    @api lineNo;
    @api termItem;
    @api isTermDisabled;
    @api customerQuoteId = '';
    @api allTerms;
    @api addtionalTerm;
    isAdditionalTerm = false;
    isManuallySelectedTerm = false;
    termsAndCondition = TERMS;
    terms = {
        TERMS_DESC,
        TERMS_CODE,
        CHARGE_TYPE,
        CHARGE_VALUE,
        CHARGE_VALUE_TYPE,
        REMARKS,
        REMARKS_VALUE,
        REMARKS_TYPE,
        CHARGEABLE,
        CUSTOMER_QUOTE,
        ADD_TERM,
        SH_Order
    };
    connectedCallback()
    {
        console.log('In connected Call back Terms and Condition>>>>>>>>');
        
        console.log('this.isTermDisabled>>>>>>>>>', this.isTermDisabled);
        if(this.isTermDisabled == false)
        {
            this.isAdditionalTerm = true;
        }
    }
    @api
    get isRemoveButtonDisabled(){
        return !(this.isManuallySelectedTerm) && this.termItem.isRequiredTerm;
    }

    @api handleCustomerQuoteIdAndSaving(id){
        this.customerQuoteId = id;
        var customerQuoteIdField = this.template.querySelector('[data-id="customerQuoteId"]');
        customerQuoteIdField.value = id;
        this.template.querySelector('lightning-record-edit-form').submit();
    }

    handleTermsDelete(event){
        // console.log('--handleTermsDelete--');
        var termLineNo = this.lineNo;
        this.dispatchEvent(new CustomEvent('removeterms', {
            detail: termLineNo
        }));
    }

    handleTermsChange(event){
        this.isManuallySelectedTerm = true;
        if(event.target.value == 'Additional Terms'){
            this.isAdditionalTerm = true;
        }else{
            this.isAdditionalTerm = false;
            this.findSelectedTermValues(event.target.value);
        }
    }

    findSelectedTermValues(selectedTerm){
        console.log('-----selectedTerm-----'+selectedTerm);
        var index = this.allTerms.findIndex( x =>  x.termsDescription == selectedTerm);
        
        this.termItem = this.allTerms[index];
        this.setTermItem();
    }

    //to reset term fields when user change the selection of term description
    setTermItem(){
        var fields = ['chargeTypeValue', 'chargeValue', 'chargeType', 'remarkType', 'remarksValue'];
        var tempItem = JSON.parse(JSON.stringify(this.termItem));
        for (let field of fields) {
            if(!this.termItem.hasOwnProperty(field)){
                // console.log('-----field-----'+field);
                tempItem[field] = '';
            }
        }
        this.termItem = tempItem;
    }

    handleSuccess(event){
        // console.log('---handleSuccess term-----');
        this.dispatchEvent(new CustomEvent("lineitemsave"));
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