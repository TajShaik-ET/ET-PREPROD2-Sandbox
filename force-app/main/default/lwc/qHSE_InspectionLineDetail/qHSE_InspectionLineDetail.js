import { LightningElement, api } from 'lwc';
//inspection lines fields
import InpectionLine from '@salesforce/schema/QHSE_Inspection_Line__c';
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
import ID_FIELD from "@salesforce/schema/QHSE_Inspection_Line__c.Id"
import Additional_Notes from '@salesforce/schema/QHSE_Inspection_Line__c.Additional_Notes__c';

//inspection lines fields end
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from "lightning/platformShowToastEvent";


export default class QHSE_InspectionLineDetail extends LightningElement {
    @api inpsectionlineid;
    markedClosed = false;
    //inpsection lines variables
    inspectionLineObject = InpectionLine;
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
        ET_Vehicle_Master,
        Additional_Notes
    };
    
    handleMarkComplete(event){
        console.log('-------handleMarkComplete----');
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.inpsectionlineid;
        fields[Status.fieldApiName] = 'Closed'
        const recordInput = { fields };
        this.markedClosed = true;
        updateRecord(recordInput)
        .then(() => {
          this.dispatchEvent(
            new ShowToastEvent({
              title: "Success",
              message: "Successfully Marked Closed",
              variant: "success",
            }),
          );
          // Display fresh data in the form
        //   return refreshApex(this.contact);
        })
        .catch((error) => {
          this.dispatchEvent(
            new ShowToastEvent({
              title: "Error While Updating Status",
              message: error.body.message,
              variant: "error",
            }),
          );
        });
    }
}