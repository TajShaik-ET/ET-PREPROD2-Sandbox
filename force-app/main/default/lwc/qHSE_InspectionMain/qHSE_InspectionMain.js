import { LightningElement, api, wire, track } from 'lwc';

import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import OBJECT from '@salesforce/schema/QHSE_Inspection__c';

import City from '@salesforce/schema/QHSE_Inspection__c.City__c';
import Designation from '@salesforce/schema/QHSE_Inspection__c.Designation__c';
import Inspection_Date from '@salesforce/schema/QHSE_Inspection__c.Inspection_Date__c';
import Inspector_Name from '@salesforce/schema/QHSE_Inspection__c.Inspector_Name__c';
import Location from '@salesforce/schema/QHSE_Inspection__c.Location__c';
import Result_Date from '@salesforce/schema/QHSE_Inspection__c.Result_Date__c';
import Station from '@salesforce/schema/QHSE_Inspection__c.StationName__c';
import Name from '@salesforce/schema/QHSE_Inspection__c.Name';



import fetchInspectionData from '@salesforce/apex/qHSE_InspectionController.fetchInspectionData';
import createInspectionRecord from '@salesforce/apex/qHSE_InspectionController.createInspectionRecord';
import fetchInspectionLines from '@salesforce/apex/qHSE_InspectionController.fetchInspectionLines';
import { deleteRecord } from "lightning/uiRecordApi";

const actions = [
    { label: 'Show details', name: 'show_details' },
];

const COLUMNS = [
    { type: 'action', label:'Actions', typeAttributes: { rowActions: actions, menuAlignment: 'left' }},
    { label: 'Station/المحطة', fieldName: 'StationFormula__c'},
    { label: 'Inspection Date/تاريخ التفتيش', fieldName: 'Inspection_Date__c', type: 'date', sortable: true,},
    // { label: 'Result Date/تاريخ التقرير', fieldName: 'Result_Date__c', type: 'date' },
    { label: 'Inspector Name/اسم المفتش', fieldName: 'Inspector_Name__c'},
    { label: 'Location/موقع التفتيش', fieldName: 'Location__c'},
    
];

export default class QHSE_InspectionMain extends LightningElement {
    @track inspectionLines = [];

    columns = COLUMNS;
    isloading = false;
    inspectionObject = OBJECT;
    inspectionFields = {
        City,
        Designation,
        Inspection_Date,
        Inspector_Name,
        Location,
        Result_Date,
        Station,
        Name
    };
    lineNo = 0;
    inspectionSaved = false;
    @track termsDetail = [];
    @track inspectionsData = [];

    showInspectionLine = false;
    inspectionsLinesData = [];

    //we are using this variable to keep track whether user clicked on save button or 
    // not, if not then we need to delete the draft inspection record
    isSavedButtonClicked = false;
    inspectionId;

    async fetchInspectionData(){
        await fetchInspectionData().then((response) => {
            console.log('--fetchQuoteData--');
            console.log(response);
            if(response != null){
                this.inspectionsData = response;
            }
        }).catch((error) => {
            console.log('error');
            console.error(error);
        });
        this.inspectionSaved = true;
    }

    handleCancel(event){
        this.deleteTemporaryInspectionRecord();
        this.termsDetail = [];
        this.lineNo = 0;
        this.handleFormReset();
        this.inspectionId = null;
        this.inspectionSaved = false;
        this.showInspectionLine = false;
    }
    handleFormReset(event) {
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
    }

    handleSuccess(){

    }

    handleSaveClick(event) {
        console.log('----handleSaveClick------');
        //check required fields in the childs
        var inspectionLinesRequiredFields = true;
        var childQhseLines = this.template.querySelectorAll('c-q-h-s-e-_-inspection-lines');
        childQhseLines.forEach(child => {
            console.log('----handleSaveClick------');
            var temp = child.checkInspectionLineRequiredField();
            //if false then don't let the lines save
            if(!temp){
                inspectionLinesRequiredFields = false;
                console.log('----inspectionLinesRequiredFields--false----');
            }
        });

        //check inspection fields
        var allFieldFilled = false;
        allFieldFilled = this.checkInspectionRequiredField();
        
        //submit parent and child form
        if(inspectionLinesRequiredFields && allFieldFilled){
            this.isSavedButtonClicked = true;
            var tempId = this.inspectionId;
            const form = this.template.querySelector('[data-id="inspection"]');
            form.submit();

            childQhseLines.forEach(child => {
                child.handleInspectionIdAndLineSaving(tempId);
            });
            this.inspectionSaved = true;
            this.fetchInspectionData();
        }else{
            console.log('----showToast------');
            this.showToast();
        }
        
    }

    handleBack(event){
        this.inspectionSaved = false;
        this.isSavedButtonClicked = false;
        this.termsDetail = [];
        this.lineNo = 0;
        this.handleFormReset();
        this.inspectionId = null;
    }

    handleList(event){
        this.inspectionSaved = true;
        this.showInspectionLine = false;
        this.fetchInspectionData(); 
    }

    addInspectionLine(event){
        var allFieldFilled = false;
        allFieldFilled = this.checkInspectionRequiredField();
        if(allFieldFilled){
            if(this.inspectionId == null){
                this.createTempInpsectionRecord();
            }else{
                this.lineNo++;
                this.termsDetail.push({lineNo: this.lineNo});
            }
        }else{
            this.showToast();
        }
        
    }

    showToast(){
        const evt = new ShowToastEvent({
            title: 'Required Field Missing',
            message: 'Please fill the required fields',
            variant: 'warning',
            mode: 'sticky'
        });
        this.dispatchEvent(evt);
    }

    checkInspectionRequiredField(){
        var station = this.template.querySelector('[data-id="Station"]').value;
        var inspection_Date = this.template.querySelector('[data-id="Inspection_Date"]').value;
        var inspector_Name = this.template.querySelector('[data-id="Inspector_Name"]').value;
        var designation = this.template.querySelector('[data-id="Designation"]').value;
        var location = this.template.querySelector('[data-id="Location"]').value;
        if((station != '' && station != null) && (inspection_Date != '' && inspection_Date != null) &&
           (inspector_Name != '' && inspector_Name != null) && (designation != '' && designation != null) &&
           (location != '' && location != null)){
            return true;
        }
    }

    removeInspectionLine(event){
        console.log('--removeInspectionLine--');
        var lineNo = event.detail;
        var index = this.termsDetail.findIndex( x =>  x.lineNo === lineNo);
        this.termsDetail.splice(index, 1);
        this.lineNo--;
    }

    handleError(event) {
        // event.preventDefault();
        // event.stopImmediatePropagation();
        this.showToast("Error", event.detail.detail, "error");
    }

    handleRowAction(event){
        const row = event.detail.row;
        console.log('------handleRowAction--row----',JSON.stringify(row));
        var slectedRow = JSON.parse(JSON.stringify(row));
        console.log('------handleRowAction--row-Id---',slectedRow.Id);
        // et_vrts_fileupload
        this.fetchInspectionLinesData(slectedRow.Id);
    }

    fetchInspectionLinesData(inspectionId){
        fetchInspectionLines({inspectionId: inspectionId }).then((response) => {
            console.log('--fetchInspectionLinesData--');
            console.log(response);
            if(response != null){
                this.inspectionsLinesData = response;
                this.showInspectionLine = true;
            }
        }).catch((error) => {
            console.log('error');
            console.error(error);
        })
    }

    connectedCallback(){
        //this.createTempInpsectionRecord();
        console.log('---conncted callbcak parent----');
    }

    async createTempInpsectionRecord(){
        var station = this.template.querySelector('[data-id="Station"]').value;
        var inspection_Date = this.template.querySelector('[data-id="Inspection_Date"]').value;
        var inspector_Name = this.template.querySelector('[data-id="Inspector_Name"]').value;
        var designation = this.template.querySelector('[data-id="Designation"]').value;
        var location = this.template.querySelector('[data-id="Location"]').value;


        await createInspectionRecord(
            {station: station, inspection_Date:inspection_Date,
                inspector_Name:inspector_Name, designation:designation,
                location:location})
        .then(response => {
           this.inspectionId = response;
        })
        .catch(error => {
            // Handle error
            console.error('Error:', error);
        });
        console.log('---createInspectionRecord--this.inspectionId--'+ this.inspectionId);
        this.lineNo++;
        this.termsDetail.push({lineNo: this.lineNo});
    }

    
    disconnectedCallback(){
        //this.deleteTemporaryInspectionRecord();
        console.log('----disconncted callbcak parent-------');
    }
    
    deleteTemporaryInspectionRecord(){
        if(this.inspectionId != null && this.isSavedButtonClicked != true){
            deleteRecord(this.inspectionId)
            .then(() => {
                console.log('----this.inspectionId----before---'+this.inspectionId);
                
            })
            .catch((error) => {

            });
            
        }
    }

    // //if user navigate soemwhere, without saving inspection record, then delete the temporary record as well
    // handleInspectionDelete(){
    //     console.log('----handleInspectionDelete-------'+this.lineNo);
    //     if(this.lineNo == 0){
    //         this.deleteTemporaryInspectionRecord();
    //     }
    // }
}