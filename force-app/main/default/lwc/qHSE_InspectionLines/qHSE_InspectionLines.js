import { LightningElement, api, wire, track } from 'lwc';

import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import OBJECT from '@salesforce/schema/QHSE_Inspection_Line__c';

import Classification from '@salesforce/schema/QHSE_Inspection_Line__c.Classification__c';
import Corrective_Action from '@salesforce/schema/QHSE_Inspection_Line__c.Corrective_Action__c';
import Description from '@salesforce/schema/QHSE_Inspection_Line__c.Description__c';
import Proof from '@salesforce/schema/QHSE_Inspection_Line__c.Proof__c';
import QHSE_Inspection from '@salesforce/schema/QHSE_Inspection_Line__c.QHSE_Inspection__c';
import Requirement from '@salesforce/schema/QHSE_Inspection_Line__c.Requirement__c';
import Root_Cause from '@salesforce/schema/QHSE_Inspection_Line__c.Root_Cause__c';
import Severity from '@salesforce/schema/QHSE_Inspection_Line__c.Severity__c';
import Status from '@salesforce/schema/QHSE_Inspection_Line__c.Status__c';
import Target_Date from '@salesforce/schema/QHSE_Inspection_Line__c.Target_Date__c';
import ET_Vehicle_Master from '@salesforce/schema/QHSE_Inspection_Line__c.ET_Vehicle_Master__c';
import Additional_Notes from '@salesforce/schema/QHSE_Inspection_Line__c.Additional_Notes__c';

import Name from '@salesforce/schema/QHSE_Inspection_Line__c.Name';
import createInspectionLineRecord from '@salesforce/apex/qHSE_InspectionController.createInspectionLineRecord';
import { deleteRecord } from "lightning/uiRecordApi";

export default class QHSE_InspectionLines extends LightningElement {
    @api lineNo;
    @api inspectionId;
    inspectionLineId;

    get acceptedFormats() {
        return ['.jpg','.png'];
    }
    inspectionLineObject = 'QHSE_Inspection_Line__c';
    inspectionLineFields = {
        Classification,
        Corrective_Action,
        Description,
        Proof,
        QHSE_Inspection,
        Requirement,
        Root_Cause,
        Severity,
        Status,
        Target_Date,
        Name,
        ET_Vehicle_Master,
        Additional_Notes
    };

    @api handleInspectionIdAndLineSaving(id){
        var inspectionIdField = this.template.querySelector('[data-id="inspectionId"]');
        inspectionIdField.value = id;
        this.template.querySelector('lightning-record-edit-form').submit();
    }

    @api checkInspectionLineRequiredField(){
        var requirement = this.template.querySelector('[data-id="Requirement"]').value;
        var description = this.template.querySelector('[data-id="Description"]').value;
        var severity = this.template.querySelector('[data-id="Severity"]').value;
        var classification = this.template.querySelector('[data-id="Classification"]').value;
        var target_Date = this.template.querySelector('[data-id="Target_Date"]').value;
        var proof = this.template.querySelector('[data-id="Proof"]').value;
        if((requirement != '' && requirement != null) && (description != '' && description != null) &&
           (severity != '' && severity != null) && (classification != '' && classification != null) &&
           (target_Date != '' && target_Date != null) && (proof != '' && proof != null)){
            return true;
        }else{
            return false;
        }
    }

    handleTermsDelete(event){
        this.deleteTemporaryInspectionLineRecord();
        console.log('--handleTermsDelete--');
        var termLineNo = this.lineNo;
        this.dispatchEvent(new CustomEvent('removeline', {
            detail: termLineNo
        }));
    }

    // handleDivClick(evt){
    //     evt.stopPropagation();
    //     if(this.inspectionLineId == null){
    //         console.log('---handleDivClick--inside If-inspectionLineId-'+this.inspectionLineId);
    //         console.log('---handleDivClick--inside If-inspection Id-'+this.inspectionId);
    //         // this.createTempInspectionLine();
    //     }else{
    //         console.log('----record already exist---'+this.inspectionLineId);
    //     }
    //     console.log('---handleDivClick----'+this.inspectionLineId);
    // }

    connectedCallback(){
        this.createTempInspectionLine();
        console.log('---conncted callbcak child----');
    }

    disconnectedCallback(){
        console.log('----disconncted callbcak child-------');
        // this.dispatchEvent(new CustomEvent('deleteinspection'));
    }

    createTempInspectionLine(){
        createInspectionLineRecord({inspectionId: this.inspectionId}).then((response) => {
            console.log('--createInspectionLineRecord--'+response);
            if(response != null){
                this.inspectionLineId = response;
            }
        }).catch((error) => {
            console.log('error');
            console.error(error);
        })
    }

    deleteTemporaryInspectionLineRecord(){
        if(this.inspectionLineId != null){
            deleteRecord(this.inspectionLineId)
            .then(() => {
            })
            .catch((error) => {
            });
        }  
    }

}