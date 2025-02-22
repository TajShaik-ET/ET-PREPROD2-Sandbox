import { LightningElement, api, track } from 'lwc';
import synInspResultsToAman from '@salesforce/apex/ETI_InspectionReceiptCtrl.synInspResultsToAman';
import { showToastNotification, isEmptyString } from "c/eT_Utils";
export default class ETI_SyncInspectionResultsToAman extends LightningElement {
    @track inspObsrFields = 'Id,Aman_Receipt__c,AMAN_Receipt_No__c,Break_Major_Count__c,Visual_Major_Count__c,Vehicle_Make__c,Vehicle_Model__c,Vehicle_Color__c,Is_Break_Inspection_Completed__c,Is_Visual_Inspection_Completed__c,Break_Inspection_Count__c,Visual_Inspection_Count__c,Remarks__c,Steering_Type__c,Gear_Type__c,No_Of_Tires__c,No_Of_Seats__c,No_Of_Doors__c,Weight_Loaded__c,Weight_Unloaded__c,Horse_Power__c,No_Of_Cylinders__c,Fuel_Type__c,Engine_No__c,Chassis_No__c,Model_Year__c,Country__c,Vehicle_Type__c,No_Of_Axles__c,Break_Inspector_Name__c,Visual_Inspector_Name__c,Break_Inspector_Id__c,Visual_Inspector_Id__c,Lane_Number__c,isSyncedToAman__c,Integration_Status__c';
    _recordId;

    connectedCallback() {
    }

    @api
    get recordId() {
        return this._recordId;
    }

    set recordId(recordId) {
        if (recordId !== this._recordId) {
            this._recordId = recordId;
        }
    }

    @api
    async invoke() {
        console.log("invoked");
        const record = await this.syncToAman();
    }

    syncToAman() {
        console.log('syncToAman ' + this._recordId);
        synInspResultsToAman({
            inspObsrFields: this.inspObsrFields,
            inspObsrId: this._recordId
        }).then((response) => {
            //console.log('syncToAman >>> ' + JSON.stringify(response));
            if (response != null && response != '') {
                if (response == true) {
                    this.dispatchEvent(
                        showToastNotification('Succuss', 'Test Results are synced to Aman.', 'success', 'dismissible')
                    );
                    this.timeoutId = setTimeout(() => {
                        window.location.reload();
                    }, 3000);
                } else {
                    this.dispatchEvent(
                        showToastNotification('Error', '', 'Failed to sync Test Results to Aman.', 'dismissible')
                    );
                }
            } else {
                this.dispatchEvent(
                    showToastNotification('Error', 'Contact Admin', 'error', 'sticky')
                );
            }
        }).catch((error) => {
            console.log('error');
            console.error(error);
            this.dispatchEvent(
                showToastNotification('Error', error.body.message, 'error', 'sticky')
            );
        })
    }

    disconnectedCallback() {
        clearTimeout(this.timeoutId);
    }
}