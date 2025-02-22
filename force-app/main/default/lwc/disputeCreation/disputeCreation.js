import { LightningElement, wire, track, api } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import CASE_OBJECT from '@salesforce/schema/Case';
import INVOICE_AMOUNT from '@salesforce/schema/Case.InvoiceAmount__c';
import INVOICE_TYPE from '@salesforce/schema/Case.InvoiceType__c';
import INVOICE_NUMBER from '@salesforce/schema/Case.Invoice_Number__c';
import COLLECTION_REMARSK from '@salesforce/schema/Case.CollectionRemarks__c';
import SECTOR from '@salesforce/schema/Case.Sector__c';
import DISPUTE_AMOUNT from '@salesforce/schema/Case.DisputeAmount__c';
import DISPUTE_DATE from '@salesforce/schema/Case.Dispute_Date__c';
import DISPUTE_REASON from '@salesforce/schema/Case.DisputeReason__c';
import ACCOUNT_ID from '@salesforce/schema/Case.AccountId';
import CUSTOMER_NAME from '@salesforce/schema/Case.CustomerName__c';
import COLLECTOR_LOG from '@salesforce/schema/Case.Collector_Log__c';
import SUBJECT from '@salesforce/schema/Case.Subject';
import ORG_ID from '@salesforce/schema/Case.OrgId__c';
import OPERTAING_UNIT from '@salesforce/schema/Case.OperatingUnit__c';

import RECORD_TYPE_ID from '@salesforce/schema/Case.RecordTypeId';
import getInvoiceDetails from '@salesforce/apex/DisputeCreationController.getInvoiceDetails';
import executeEsclationRule from '@salesforce/apex/DisputeCreationController.executeEsclationRule';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class DisputeCreation extends NavigationMixin(LightningElement) {
    isInvoiceNumberEmpty = true;
    invoiceNumber = '';
    showSpinner = true;
    invoices;
    IsInvoiceFetched = true;
    errors;
    recId;
    collectorLogId;
    today = new Date().toISOString();
    caseObject = CASE_OBJECT;
    @track invoiceDetail = {
        'transactionType': '',
        'amountDueOriginal': '',
        'amountDueRemaining':'',
        'accountName': '',
        'totalAmount': '',
        'sector' : '',
        'operatingUnit': '',
        'orgId': ''
    };
    caseFields = {
        INVOICE_AMOUNT,
        INVOICE_TYPE,
        INVOICE_NUMBER,
        COLLECTION_REMARSK,
        SECTOR,
        DISPUTE_AMOUNT,
        DISPUTE_DATE,
        CUSTOMER_NAME,
        DISPUTE_REASON,
        ACCOUNT_ID,
        COLLECTOR_LOG,
        SUBJECT,
        RECORD_TYPE_ID,
        OPERTAING_UNIT,
        ORG_ID
    };

    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        this.currentPageReference = currentPageReference;
        this.recId = this.currentPageReference.attributes.attributes.recId;
        this.collectorLogId = this.currentPageReference.attributes.attributes.collectorLogId;
    }
    
    connectedCallback(){
        console.log("----recordId => "+this.recId);
        this.fetchInvoicesData();
    }

    fetchInvoicesData(){
        getInvoiceDetails({accId: this.recId }).then((response) => {
            console.log('---fetchInvoicesData--invoicse--');
            console.log(response);
            this.invoices = response;
            this.showSpinner = false;
        }).catch((error) => {
            console.log('error');
            console.error(error);
        })
    }

    handleReset(){
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
        this.isInvoiceNumberEmpty = false;
        this.resetInvoiceDetail();
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.collectorLogId,
                objectApiName: 'Collector_Logs__c',
                actionName: 'view'
            }
        });
    }

    handleListChange(){

    }

    fetchInvoiceDetail(event){
        this.IsInvoiceFetched = false;
        this.resetInvoiceDetail();
        console.log('-----fetchInvoiceDetail----'+this.invoiceNumber);
        console.log(this.invoices);
        if(this.invoices != null){
            var transactions  = this.invoices.transactions;
            if(transactions !=  null){
                let invoice = transactions.find((obj) => obj.transactionNumber == this.invoiceNumber);
                console.log(invoice);
                if(invoice != null){
                    this.invoiceDetail.transactionType = invoice.transactionType;
                    this.invoiceDetail.amountDueOriginal = invoice.amountDueOriginal;
                    this.invoiceDetail.accountName = this.invoices.accountName;
                    this.invoiceDetail.sector = invoice.sector;
                    this.invoiceDetail.orgId = invoice.orgId;
                    this.invoiceDetail.operatingUnit = invoice.operatingUnit;

                }else{
                    this.showErrorNotification();
                }
            }else{
                this.showErrorNotification();
            }
        }else{
            this.showErrorNotification();
        }
        // 201854069   201854071
        this.IsInvoiceFetched = true;
    }

    invoiceNumberChange(event){
        this.invoiceNumber = event.target.value;
        if(this.invoiceNumber != null && this.invoiceNumber != ''){
            this.isInvoiceNumberEmpty = false;
        }else{
            this.isInvoiceNumberEmpty = true;
        }
    }

    showErrorNotification(){
        const evt = new ShowToastEvent({
            title: 'No Invoce',
            message: 'No invoice found',
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

    resetInvoiceDetail(){
        this.invoiceDetail = {
            'transactionType': '',
            'amountDueOriginal': '',
            'amountDueRemaining':'',
            'accountName': '',
            'totalAmount': '',
            'orgId': '',
            'sector': '',
            'operatingUnit': ''
        };
    }

    handleSuccess(event){
        var disputeCaseId = event.detail.id;
        
        this.handleNavigation(disputeCaseId);

        /* 
        *   As we were executing esclation manually which is no more required

            console.log('--dispute case id created----', disputeCaseId);
            executeEsclationRule({caseId: disputeCaseId }).then((response) => {
                //navigate to recently created case
                
            }).catch((error) => {
                console.log('---error----');
                console.error(error);
            });
        */
    }
    @track isConfirmed = false; 

    handleOnSubmit(event){
            event.preventDefault();
            if (!this.isConfirmed) {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Warning',
                        message: 'Please confirm that the entered details are correct.',
                        variant: 'warning'
                    })
                );
                this.isConfirmed = true;
            } else {
                // Get the form fields data
                this.IsInvoiceFetched = false;
                const fields = event.detail.fields;
                console.log('fields :'+JSON.stringify(fields));
                this.template.querySelector('lightning-record-edit-form').submit(fields);
            }
    }

    handleNavigation(disputeCaseId){
        
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: disputeCaseId,
                objectApiName: 'Case',
                actionName: 'view'
            }
        });
        this.IsInvoiceFetched = true;
    }
}