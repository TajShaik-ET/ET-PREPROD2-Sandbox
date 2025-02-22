import { LightningElement, api, track } from 'lwc';
import imageResource from '@salesforce/resourceUrl/carIMG_LWC';
import saveHealthCheck from '@salesforce/apex/MOTO_VehInspectionCtrl.saveHealthCheck';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import LWCImages from "@salesforce/resourceUrl/LWCImages";
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';


let ArrayFields = [];
ArrayFields.push('All_Doors_Hinges_Locks__c');
ArrayFields.push('Front_Rear_Wiper_Blades__c');
ArrayFields.push('AII_Seat_Belts_Operation__c');
ArrayFields.push('Air_Conditioner_Filter__c');
ArrayFields.push('Air_filter__c');
ArrayFields.push('Airbag_SRS_System__c');
ArrayFields.push('All_Tyre_Condition_Pressure__c');
ArrayFields.push('ATM_Oil__c');
ArrayFields.push('Ball_Joints_Dust_Cover__c');
ArrayFields.push('Battery_Connections__c');
ArrayFields.push('Body_Check_Dents_Corrosion__c');
ArrayFields.push('Brake_Fluid__c');
ArrayFields.push('Brake_Pads_Discs_Shoes__c');
ArrayFields.push('Brake_Pipes_Hoses__c');
ArrayFields.push('coolant_LLC__c');
ArrayFields.push('Coolant_SLLC__c');
ArrayFields.push('Differential_Oil__c');
ArrayFields.push('Drive_Belts__c');
ArrayFields.push('Drive_Shah_Boots__c');
ArrayFields.push('Engine_Oil_Oil_Filter__c');
ArrayFields.push('Exhaust_Pipes_Gaskets__c');
ArrayFields.push('Fr_Rr_Susp_Bushes_Shock_Absorber__c');
ArrayFields.push('Fuel_Lines_Connections__c');
ArrayFields.push('Internal_Lights_Guages__c');
ArrayFields.push('Leaks_Oil_Fluids__c');
ArrayFields.push('Opern_Lights_Horn_Wipers_Washers__c');
ArrayFields.push('Parking_Brake__c');
ArrayFields.push('Power_Steering_Fluid__c');
ArrayFields.push('Power_Window__c');
ArrayFields.push('Propeller_Shaft__c');
ArrayFields.push('Spark_Plugs_Platinum_lridium__c');
ArrayFields.push('Steering_Knuckle_Grease_If_fitted__c');
ArrayFields.push('Steering_Wear_Leaks__c');
ArrayFields.push('Tranfer_Box_Oil__c');
ArrayFields.push('Drive_Belts__c');
ArrayFields.push('windshield_Fluid__c');

export default class MotoVehicleReceivingForm extends LightningElement {

    //spinner
	loaded;
	Tloaded = true;
	Floaded = false;

    @api oppRecord;

    @track All_Doors_Hinges_Locks__c=true;
    @track Front_Rear_Wiper_Blades__c;

    @track HealthCheckRec;
    @track selectedUrgent;
    @track selectedAdviosry;
    @track selectedOk;
    @track objTempRec;
    @track allDoorsValue = '';
    @track wiperBladesValue = '';
    @track comments = '';
    fieldValue;

    connectedCallback() {
        let HealthCheckObj = { sobjectType: 'X36_Points_Health_Check__c' };
        HealthCheckObj.Opportunity__c = this.oppRecord.Id;
        this.HealthCheckRec = HealthCheckObj;

        let objTemp = { sobjectType: 'X36_Points_Health_Check__c' };
        objTemp.Opportunity__c = this.oppRecord.Id;        
        objTemp.All_Doors_Hinges_Locks__c="Ok";
        objTemp.Front_Rear_Wiper_Blades__c="OK";
        objTemp.Body_Check_Dents_Corrosion__c="OK";
        objTemp.Internal_Lights_Guages__c="OK";
        objTemp.Opern_Lights_Horn_Wipers_Washers__c="OK";
        objTemp.Power_Window__c="OK";
        objTemp.AII_Seat_Belts_Operation__c="OK";
        objTemp.Airbag_SRS_System__c="OK";
        objTemp.Spark_Plugs_Platinum_lridium__c="OK";
        objTemp.Air_filter__c="OK";
        objTemp.coolant_LLC__c="OK";
        objTemp.Coolant_SLLC__c="OK";
        objTemp.Battery_Connections__c="OK";
        objTemp.Air_Conditioner_Filter__c="OK";
        objTemp.Brake_Fluid__c="OK";
        objTemp.Power_Steering_Fluid__c="OK";
        objTemp.Drive_Belts__c="OK";
        objTemp.Leaks_Oil_Fluids__c="OK";
        objTemp.windshield_Fluid__c="OK";
        objTemp.Engine_Oil_Oil_Filter__c="OK";
        objTemp.ATM_Oil__c="OK";
        objTemp.Tranfer_Box_Oil__c="OK";
        objTemp.Differential_Oil__c="OK";
        objTemp.Brake_Pipes_Hoses__c="OK";
        objTemp.Fuel_Lines_Connections__c="OK";
        objTemp.Steering_Wear_Leaks__c="OK";
        objTemp.Steering_Knuckle_Grease_If_fitted__c="OK";
        objTemp.Propeller_Shaft__c="OK";
        objTemp.Drive_Shah_Boots__c="OK";
        objTemp.Ball_Joints_Dust_Cover__c="OK";
        objTemp.Fr_Rr_Susp_Bushes_Shock_Absorber__c="OK";
        objTemp.Leaks_Oil_and_Fluids__c="OK";
        objTemp.Exhaust_Pipes_Gaskets__c="OK";
        objTemp.Brake_Pads_Discs_Shoes__c="OK";
        objTemp.Parking_Brake__c="OK";
        objTemp.All_Tyre_Condition_Pressure__c="OK";
        
        this.objTempRec = objTemp;

        Promise.all([
            loadStyle(this, LWCImages + '/LWC-Images/css/ETExternalStyle.css')

        ])
            .then(() => {
                console.log("All scripts and CSS are loaded. perform any initialization function.")
            })
            .catch(error => {
                console.log("failed to load the scripts");
            });

    }
    handleUrgent(event) {
        let fieldName = event.target.name;
        let AllDoorsHingesLocks = this.template.querySelectorAll(`[data-id="${fieldName}"]`);
        AllDoorsHingesLocks.forEach(item => {
            item.selected = false;
        });
        let buttonIconStateful = event.target;
        buttonIconStateful.selected = true;
        this.objTempRec[fieldName] = "Urgent";

    }
    handleAdviosry(event) {
        let fieldName = event.target.name;
        let AllDoorsHingesLocks = this.template.querySelectorAll(`[data-id="${fieldName}"]`);
        AllDoorsHingesLocks.forEach(item => {
            item.selected = false;
        });
        let buttonIconStateful = event.target;
        buttonIconStateful.selected = true;
        this.objTempRec[fieldName] = "Adisory";

    }
    handleOk(event) {
        let fieldName = event.target.name;
        let AllDoorsHingesLocks = this.template.querySelectorAll(`[data-id="${fieldName}"]`);
        AllDoorsHingesLocks.forEach(item => {
            item.selected = false;
        });
        let buttonIconStateful = event.target;
        buttonIconStateful.selected = true;
        this.objTempRec[fieldName] = "OK";


    }
    handleRmarks(event) {
        let remark = event.target.name;
        let remarkVal = event.target.value;
        this.HealthCheckRec[remark] = remarkVal;

    }

    handleSubmit() {
        this.loaded=this.Tloaded;
        const fieldElement = this.template.querySelector('[data-id="Comments"]');
        if (fieldElement) {
            this.fieldValue = fieldElement.value;
        }
        this.objTempRec.Other_Remarks__c = this.fieldValue;
        for (let i = 0; i < ArrayFields.length; i++) {
            let fieldName = ArrayFields[i];
            if (this.objTempRec.hasOwnProperty(fieldName)) {
                let fieldValue = this.objTempRec[fieldName];
                console.log(this.HealthCheckRec[fieldName])
                if (typeof this.HealthCheckRec[fieldName] !== 'undefined') {
                    fieldValue = fieldValue + "__" + this.HealthCheckRec[fieldName];
                }
                this.objTempRec[fieldName] = fieldValue;

            }
        }
        console.log(this.HealthCheckRec);
        console.log(this.objTempRec);
        const healthCheckRecord = this.objTempRec;
        saveHealthCheck({ healthCheckRecord })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: '36 Points Health CheckForm is Created Successfully ',
                        variant: 'success',
                    }),
                );
                this.loaded=this.Floaded;
                this.backbButtonHanlder();
            })
            .catch(error => {
                alert(e.message)
            });
    }
    backbButtonHanlder(event) {
        const backButtonEvent = new CustomEvent("backbuttonclick", {
            detail: null
        });
        this.dispatchEvent(backButtonEvent);
    }






}