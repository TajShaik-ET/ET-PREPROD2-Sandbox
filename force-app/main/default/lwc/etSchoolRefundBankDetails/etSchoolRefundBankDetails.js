import { LightningElement, api, wire, track } from "lwc";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import BENEFICIARY from "@salesforce/schema/ET_Refund__c.ET_Customer__r.ET_Beneficiary__c";
import BANK_NAME from "@salesforce/schema/ET_Refund__c.ET_Customer__r.ET_Bank_Name__c";
import ACCOUNT_NUMBER from "@salesforce/schema/ET_Refund__c.ET_Customer__r.ET_Account_No__c";
import IBAN_CODE from "@salesforce/schema/ET_Refund__c.ET_Customer__r.ET_IBAN_Code__c";
import BRANCH_NAME from "@salesforce/schema/ET_Refund__c.ET_Customer__r.ET_Branch_Name__c";
import BANK_ADDRESS from "@salesforce/schema/ET_Refund__c.ET_Customer__r.ET_Bank_Address__c";
import LABEL_BENEFICIARY from "@salesforce/label/c.ETST_Beneficiary"; 
import LABEL_BENEFICIARY_AR from "@salesforce/label/c.ETST_Beneficiary_AR"; 
import LABEL_BANK_NAME from "@salesforce/label/c.ETST_Bank_Name";
import LABEL_BANK_NAME_AR from "@salesforce/label/c.ETST_Bank_Name_AR";
import LABEL_ACCOUNT_NUMBER from "@salesforce/label/c.ETST_Account_No";
import LABEL_ACCOUNT_NUMBER_AR from "@salesforce/label/c.ETST_Account_No_AR";
import LABEL_IBAN_CODE from "@salesforce/label/c.ETST_IBAN_Code";
import LABEL_IBAN_CODE_AR from "@salesforce/label/c.ETST_IBAN_Code_AR";
import LABEL_BRANCH_NAME from "@salesforce/label/c.ETST_Branch_Name";
import LABEL_BRANCH_NAME_AR from "@salesforce/label/c.ETST_Branch_Name_AR";
import LABEL_BANK_ADDRESS from "@salesforce/label/c.ETST_Bank_Address";
import LABEL_BANK_ADDRESS_AR from "@salesforce/label/c.ETST_Bank_Address_AR";
import LABEL_BANK_DETAILS from "@salesforce/label/c.ETST_Bank_Details";
import LABEL_BANK_DETAILS_AR from "@salesforce/label/c.ETST_Bank_Details_AR";

export default class EtSchoolRefundBankDetails extends LightningElement {
  label={
    LABEL_BENEFICIARY,
    LABEL_BENEFICIARY_AR,
    LABEL_BANK_NAME,
    LABEL_BANK_NAME_AR,
    LABEL_ACCOUNT_NUMBER,
    LABEL_ACCOUNT_NUMBER_AR,
    LABEL_IBAN_CODE,
    LABEL_IBAN_CODE_AR,
    LABEL_BRANCH_NAME,
    LABEL_BRANCH_NAME_AR,
    LABEL_BANK_ADDRESS,
    LABEL_BANK_ADDRESS_AR,
    LABEL_BANK_DETAILS,
    LABEL_BANK_DETAILS_AR
  }
  @api recordId;
  @track BENEFICIARY_LABEL;
  @track BANK_NAME_LABEL;
  @track ACCOUNT_NUMBER_LABEL;
  @track IBAN_CODE_LABEL;
  @track BRANCH_NAME_LABEL;
  @track BANK_ADDRESS_LABEL;
  @track BANK_DETAILS_LABEL;
  @wire(getRecord, {
    recordId: "$recordId",
    fields: [
      BENEFICIARY,
      BANK_NAME,
      ACCOUNT_NUMBER,
      IBAN_CODE,
      BRANCH_NAME,
      BANK_ADDRESS
    ]
  })
  record;
  get beneficiary() {
    return this.record.data ? getFieldValue(this.record.data, BENEFICIARY) : "";
  }
  get bankName() {
    return this.record.data ? getFieldValue(this.record.data, BANK_NAME) : "";
  }
  get accountNumber() {
    return this.record.data
      ? getFieldValue(this.record.data, ACCOUNT_NUMBER)
      : "";
  }
  get ibanCode() {
    return this.record.data ? getFieldValue(this.record.data, IBAN_CODE) : "";
  }
  get branchName() {
    return this.record.data ? getFieldValue(this.record.data, BRANCH_NAME) : "";
  }
  get bankAddress() {
    return this.record.data
      ? getFieldValue(this.record.data, BANK_ADDRESS)
      : "";
  }
  connectedCallback(){
      var url_string = window.location.href;
      var url = new URL(url_string)
      console.log('url***'+url);
      var lang = url.searchParams.get("lang");
      if(lang =='ar'){
        this.BENEFICIARY_LABEL = this.label.LABEL_BENEFICIARY_AR;
        this.BANK_NAME_LABEL = this.label.LABEL_BANK_NAME_AR;
        this.ACCOUNT_NUMBER_LABEL = this.label.LABEL_ACCOUNT_NUMBER_AR;
        this.IBAN_CODE_LABEL = this.label.LABEL_IBAN_CODE_AR;
        this.BRANCH_NAME_LABEL = this.label.LABEL_BRANCH_NAME_AR;
        this.BANK_ADDRESS_LABEL = this.label.LABEL_BANK_ADDRESS_AR;
        this.BANK_DETAILS_LABEL = this.label.LABEL_BANK_DETAILS_AR;
        
      }else{ 
        this.BENEFICIARY_LABEL = this.label.LABEL_BENEFICIARY;
        this.BANK_NAME_LABEL = this.label.LABEL_BANK_NAME;
        this.ACCOUNT_NUMBER_LABEL = this.label.LABEL_ACCOUNT_NUMBER;
        this.IBAN_CODE_LABEL = this.label.LABEL_IBAN_CODE;
        this.BRANCH_NAME_LABEL = this.label.LABEL_BRANCH_NAME;
        this.BANK_ADDRESS_LABEL = this.label.LABEL_BANK_ADDRESS;
        this.BANK_DETAILS_LABEL = this.label.LABEL_BANK_DETAILS;
      }
  } 
}