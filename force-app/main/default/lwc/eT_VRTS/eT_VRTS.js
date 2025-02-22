import {
    LightningElement,
    wire,
    track,
    api
} from 'lwc';
import {
    loadStyle
} from 'lightning/platformResourceLoader';
import {
    ShowToastEvent
} from "lightning/platformShowToastEvent";
import ExternalStyle from '@salesforce/resourceUrl/ExternalStyle';
import ETST_Logo from '@salesforce/resourceUrl/ETLogo'; // Import the static resource URL
import UAE_Logo from '@salesforce/resourceUrl/UAE_Logo'; // Import the static resource UAE_Logo 
import SCHOOL_BUS from '@salesforce/resourceUrl/VRTS_SCHOOL_BUS';
import getVehicleMasterData from '@salesforce/apex/ET_VRTS.getVehicleMaster_records';
import getAllVRTSData from '@salesforce/apex/ET_VRTS.getAllVRTSrecords';
import saveObservationsData from '@salesforce/apex/ET_VRTS.saveObservations';
import createSubResp from '@salesforce/apex/ET_VRTS.createSubResp';
import deleteSubResp from '@salesforce/apex/ET_VRTS.deleteSubResp';
import {
    deleteRecord
} from "lightning/uiRecordApi";

export default class ET_VRTS extends LightningElement {
    SPNR;
    VRTS_ET_Logo = ETST_Logo; // Assign the imported resource URL to a property
    VRTS_UAE_Logo = UAE_Logo;
    VRTS_SCHOOL_BUS = SCHOOL_BUS;
    @api recordId;
    @track selectedSecIndex;
    @track sections = {};
    @track sectionsName = {};
    @track sectionsAllData = [];
    @track vehicleData = {};
    @api inspectionDateValue;
    VRTS_StartPage = true;
    VRTS_FormPage = false;
    VRTS_InfoPage = false;
    VRTS_IterationPage = false;
    VRTS_SubmitPage = false;
    VRTS_ThankPage = false;
    @track finalResult = 'Pass';
    @track statusOfElectricalConnections = [];
    @track deviceName = [];
    isSubmitButtonClicked = false;

    connectedCallback() {
        Promise.all([
            loadStyle(this, ExternalStyle)
        ])
        this.statusOfElectricalConnections.push('The presence of sharp edges around electrical wires', 'The presence of loose electrical connections', 'The presence of exposed wires in a way that allows them to be tampered with');
        this.deviceName.push('Internal sirens', 'Motion sensor device inside the bus', 'Check the bus button after the trip ends', 'Emergency button', 'The main screen is in front of the driver');
        this.deviceName.push('External cameras (4)', 'Indoor cameras (3)', 'Primary storage device', 'Temperature-humidity measuring device', 'Bus engine self-extinguishing system');
        this.deviceName.push('Bus cruise control device', 'Stop lever', 'The electronic board for the route', 'Fire extinguishers (2)');
        //console.log('statusOfElectricalConnections', JSON.stringify(this.statusOfElectricalConnections));
        //console.log('deviceName',  this.deviceName);
    }

    VRTS_Start() {
        this.VRTS_StartPage = false;
        this.VRTS_InfoPage = false;
        this.VRTS_FormPage = true;
        //this.VRTS_FormPage_Next(); //remove
        //this.returnHome();
    }

    VRTS_FormPage_Back() {
        this.VRTS_StartPage = true;
        this.VRTS_InfoPage = false;
        this.VRTS_FormPage = false;
    }

    VRTS_FormPage_Next() {
        //console.log('VRTS_FormPage_Next');
        this.VRTS_StartPage = false;
        this.VRTS_InfoPage = true;
        this.VRTS_FormPage = false;
    }

    VRTS_InfoPage_Back() {
        this.VRTS_StartPage = false;
        this.VRTS_InfoPage = false;
        this.VRTS_FormPage = true;
        this.VRTS_IterationPage = false;
    }

    VRTS_InfoPage_Next() {
        this.VRTS_StartPage = false;
        this.VRTS_InfoPage = false;
        this.VRTS_FormPage = false;
        this.VRTS_IterationPage = true;
        this.getData();
    }

    handleSubmit(event) {
        console.log('onsubmit event recordEditForm' + event.detail.fields);
        this.SPNR = true;
        if (this.VRTS_SubmitPage) {
            event.preventDefault();
            //this.saveData();  
            const fields = event.detail.fields;
            fields["Status__c"] = 'Submitted'; //this.finalResult = 'Fail';
            fields["Final_Result__c"] = this.finalResult;
            this.template.querySelector('lightning-record-edit-form').submit(fields);
        }
    }

    handleSuccess(event) {
        console.log('onsuccess event recordEditForm', event.detail.id);
        this.recordId = event.detail.id;
        this.SPNR = false;
        if (!this.VRTS_SubmitPage)
            this.VRTS_FormPage_Next();
        if (this.VRTS_SubmitPage) {
            this.VRTS_SubmitPage = false;
            this.VRTS_ThankPage = true;
            this.isSubmitButtonClicked = true;
        }
    }

    handleError(event) {
        this.SPNR = false;
        console.log("handleError event");
        console.log(JSON.stringify(event.detail));
    }

    getData() {
        console.log('getData');
        getAllVRTSData({
            ObsRecId: this.recordId,
            statusOfElectricalConnections: this.statusOfElectricalConnections,
            deviceName: this.deviceName
        }).then((response) => {
            console.log('response: ', response);
            if (response != null && response != '') {
                this.sectionsAllData = response;
                this.sections = response[0];
                this.sectionsName = response[0].name;
                this.selectedSecIndex = 0;
                //console.log('sectionsAllData: ', this.sectionsAllData);
            } else {}
        }).catch((error) => {
            console.log('error');
            console.error(error);
            this.showToastNotification('Error', error, 'error', 'sticky');
        })
    }

    get showComments() {
        let picklistAnswered = true;
        if (this.sections.name.En != 'Automatic Fire Suppression System' && this.sections.name.En != 'Cable Connections' && this.sections.name.En != 'Second Device')
            picklistAnswered = this.getPicklistAnswered();
        return !picklistAnswered;
    }

    getVehicleData(vehicleId) {
        console.log('getVehicleData: ' + vehicleId);
        getVehicleMasterData({
            recId: vehicleId
        }).then((response) => {
            console.log('response: ', JSON.stringify(response));
            if (response != null && response != '') {
                if (response.length > 0)
                    this.vehicleData = response[0];
                //console.log('vehicleData: ', JSON.stringify(this.vehicleData));
            } else {}
        }).catch((error) => {
            console.log('error');
            console.error(error);
            //this.showToastNotification('Error', error, 'error', 'sticky');
        })
    }

    async clickNext() {
        let disableNext = false;
        //console.log('disableNext: ', disableNext);
        //console.log('selectedSecIndex: ', this.selectedSecIndex);
        //console.log('VRTS_SubmitPage: ', this.VRTS_SubmitPage);
        if (this.sections.name.En != 'Automatic Fire Suppression System' && this.sections.name.En != 'Cable Connections' && this.sections.name.En != 'Second Device') {
            let picklistAnswered = this.getPicklistAnswered();
            if (picklistAnswered == false) {
                for (var key1 in this.sections.secOptions) {
                    if (this.sections.secOptions[key1].isComment == true && (this.sections.secOptions[key1].response == '' || this.sections.secOptions[key1].response == null)) {
                        disableNext = true;
                        this.showToastNotification('Error', 'Please add comments', 'error', 'sticky');
                        break;
                    }
                }
            }
        } else if (this.sections.name.En == 'Automatic Fire Suppression System' || this.sections.name.En == 'Cable Connections') {
            for (var key1 in this.sections.secOptions) {
                if (this.sections.secOptions[key1].response == '' || this.sections.secOptions[key1].response == null) {
                    disableNext = true;
                    this.showToastNotification('Error', 'Please select options', 'error', 'sticky');
                    break;
                }
            }
        }
        if (disableNext == false) {
            for (var key2 in this.sectionsAllData) {
                if (this.sectionsAllData[key2].name.En == this.sections.name.En) {
                    this.sectionsAllData[key2] = this.sections;
                    //console.log('sections Final 1: ', JSON.stringify(this.sectionsAllData[key2]));
                    break;
                }
            }
            if (this.sections.name.En == 'Automatic Fire Suppression System') {
                this.isAFSS();
            }
            if (this.sections.name.En == 'Automatic Fire Suppression (Except SUNWIN)') {
                this.isExcSunwin();
            }
            if (this.sections.name.En == 'Cable Connections') {
                console.log('-----isCC called---');
                await this.isCC();
                console.log('-----isCC ended---');
            }
            if (this.sections.name.En != 'Automatic Fire Suppression System' && this.sections.name.En != 'Automatic Fire Suppression (Except SUNWIN)' && this.sections.name.En != 'Cable Connections') {
                if (this.selectedSecIndex < (this.sectionsAllData.length - 1))
                    this.selectedSecIndex = +this.selectedSecIndex + +1;
            }
            if (this.sections.name.En == 'Second Device') {
                this.isSD();
            }
            //this.saveData();
            //console.log('selectedSecIndex: ' + this.selectedSecIndex);
            if (this.VRTS_SubmitPage == false) {
                this.sections = this.sectionsAllData[this.selectedSecIndex];
                this.sectionsName = this.sections.name;
                //console.log('sections Final 2: ', JSON.stringify(this.sectionsAllData[this.selectedSecIndex]));
            }
            if (this.VRTS_SubmitPage == true) {
                //const sectionsAll = [];
                this.finalResult = 'Pass';
                for (var key2 in this.sectionsAllData) {
                    if (this.sectionsAllData[key2].isSkipped == false && this.sectionsAllData[key2].name.En != 'Automatic Fire Suppression System' && this.sectionsAllData[key2].name.En != 'Cable Connections' && this.sectionsAllData[key2].name.En != 'Second Device') {
                        for (var key3 in this.sectionsAllData[key2].secOptions) {
                            if (this.sectionsAllData[key2].secOptions[key3].isResult == true && (this.sectionsAllData[key2].secOptions[key3].response == 'Fail' || this.sectionsAllData[key2].secOptions[key3].response == '')) {
                                this.finalResult = 'Fail';
                                break;
                            }
                        }
                    }
                }
                for (var key4 in this.sectionsAllData) {
                    if (this.sectionsAllData[key4].name.En == 'Second Device') {
                        var strResp;
                        for (var key5 in this.sectionsAllData[key4].secOptions[1].subRespWrps) {
                            if (strResp != null)
                                strResp = strResp + ';' + this.sectionsAllData[key4].secOptions[1].subRespWrps[key5].answer;
                            else
                                strResp = this.sectionsAllData[key4].secOptions[1].subRespWrps[key5].answer;
                        }
                        //console.log('strResp:', strResp);
                        if (strResp != null) {
                            this.sectionsAllData[key4].secOptions[1].response = strResp;
                        }
                        break;
                    }
                }
                //console.log('sectionsAllData 1: ', JSON.stringify(this.sectionsAllData));
                console.log('finalResult:', this.finalResult);
            }
            console.log("------------------Save Data Called-----------.");
            this.saveData();
            console.log("------------------Save Data Ended-----------.");
        }
    }

    clickBack(event) {
        var buttonName = event.target.name;
        console.log('selectedSecIndex 1:' + this.selectedSecIndex);
        if (this.selectedSecIndex > 0) {
            for (var key1 in this.sectionsAllData) {
                if (key1 == this.selectedSecIndex && this.selectedSecIndex !== -1) {
                    this.sectionsAllData[key1] = this.sections;
                    //console.log('sections Final: ', JSON.stringify(this.sectionsAllData[key1]));
                    break;
                }
            }
            if (!this.VRTS_SubmitPage) {
                this.selectedSecIndex = this.selectedSecIndex - 1;
                if (this.sectionsAllData[this.selectedSecIndex].isSkipped == true) {
                    this.selectedSecIndex = this.selectedSecIndex - 1;
                }
            }
            //console.log('selectedSecIndex 2: ' + this.selectedSecIndex);
            this.sections = this.sectionsAllData[this.selectedSecIndex];
            this.sectionsName = this.sections.name;
            if (this.VRTS_SubmitPage) {
                this.VRTS_SubmitPage = false;
                this.VRTS_IterationPage = true;
            }
        }
    }

    handleFieldChange(event) {
        var fieldName = event.target.name;
        var fieldValue = event.target.value;
        //console.log(fieldName + ' : ' + fieldValue);
        if (fieldName == 'commentId' && fieldValue != null) {
            for (var key1 in this.sections.secOptions) {
                if (this.sections.name.En != 'Automatic Fire Suppression System' && this.sections.name.En != 'Cable Connections' &&
                    this.sections.secOptions[key1].isComment == true) {
                    this.sections.secOptions[key1].response = fieldValue;
                    break;
                }
            }
        }
        if (fieldName == 'ET_Bus_Internal_No__c' && fieldValue != null)
            this.getVehicleData(fieldValue);
        if (fieldName == 'Inspection_Date__c' && fieldValue != null) {
            var selectedDate = new Date(fieldValue);
            var dtNow = new Date();
            if (selectedDate.setHours(0, 0, 0, 0) < dtNow.setHours(0, 0, 0, 0)) {
                this.inspectionDateValue = null;
                var dt = dtNow.toDateString().split(' ').slice(1).join(' ').split(' ');
                this.inspectionDateValue = dt[1] + ' ' + dt[0] + ' ' + dt[2];
            }
        }
    }

    handleonchangeSub(event) {
        let index = event.target.dataset.index;
        let subindex = event.target.dataset.subindex;
        console.log(index + ' - ' + this.sections.name.En + ' - ' + event.target.value);
        for (var key1 in this.sections.secOptions) {
            if (key1 == index && index !== -1 && subindex !== -1) {
                this.sections.secOptions[key1].subRespWrps[subindex].answer = event.target.value;
                //console.log('sections.secOptions 1: ', JSON.stringify(this.sections.secOptions[key1].subRespWrps[subindex]));
                break;
            }
        }
    }

    handleonchange(event) {
        let index = event.target.dataset.index;
        console.log(index + ' - ' + this.sections.name.En + ' - ' + event.target.value);
        for (var key1 in this.sections.secOptions) {
            if (key1 == index && index !== -1) {
                this.sections.secOptions[key1].response = event.target.value;
                //console.log('sections.secOptions 1: ', JSON.stringify(this.sections.secOptions));
                break;
            }
        }
        if (event.target.value != 'Yes') {
            for (var key1 in this.sections.secOptions) {
                if (this.sections.name.En != 'Automatic Fire Suppression System' && this.sections.name.En != 'Cable Connections' &&
                    this.sections.secOptions[key1].isComment == true) {
                    this.sections.secOptions[key1].response = '';
                    break;
                }
            }
        }
        //console.log('sequence: ' + this.sections.secOptions[index].sequence); //event.target.value 
        //Except SUNWIN
        if (this.sections.name.En == 'Automatic Fire Suppression System' && event.target.value == 'Yes' && this.sections.secOptions[index].sequence == '9.001') {
            this.sections.secOptions[(+index + +1)].response = 'No';
        } else if (this.sections.name.En == 'Automatic Fire Suppression System' && event.target.value == 'No' && this.sections.secOptions[index].sequence == '9.001') {
            this.sections.secOptions[(+index + +1)].response = 'Yes';
        }
        //SUNWIN
        if (this.sections.name.En == 'Automatic Fire Suppression System' && event.target.value == 'Yes' && this.sections.secOptions[index].sequence == '9.002') {
            this.sections.secOptions[index - 1].response = 'No';
        } else if (this.sections.name.En == 'Automatic Fire Suppression System' && event.target.value == 'No' && this.sections.secOptions[index].sequence == '9.002') {
            this.sections.secOptions[index - 1].response = 'Yes';
        }

        //Visible Cable Connections
        if (this.sections.name.En == 'Cable Connections' && event.target.value == 'Yes' && this.sections.secOptions[index].sequence == '19.001') {
            this.sections.secOptions[(+index + +1)].response = 'No';
        } else if (this.sections.name.En == 'Cable Connections' && event.target.value == 'No' && this.sections.secOptions[index].sequence == '19.001') {
            this.sections.secOptions[(+index + +1)].response = 'Yes';
        }
        //Invisible Cable Connections
        if (this.sections.name.En == 'Cable Connections' && event.target.value == 'Yes' && this.sections.secOptions[index].sequence == '19.002') {
            this.sections.secOptions[index - 1].response = 'No';
        } else if (this.sections.name.En == 'Cable Connections' && event.target.value == 'No' && this.sections.secOptions[index].sequence == '19.002') {
            this.sections.secOptions[index - 1].response = 'Yes';
        }
        //console.log('sections.secOptions 2: ', JSON.stringify(this.sections.secOptions));
        //console.log('selectedSecIndex: ', this.selectedSecIndex);
        if (this.sections.name.En != 'Automatic Fire Suppression System' && this.sections.name.En != 'Cable Connections' && this.sections.name.En != 'Second Device') {
            let picklistAnswered = this.getPicklistAnswered();
            this.getResult(picklistAnswered);
        }
    }

    isAFSS() {
        if (this.sections.name.En == 'Automatic Fire Suppression System' && (this.sections.secOptions[0].response == null || this.sections.secOptions[0].response == '')) {
            this.showToastNotification('Error', ' Please select to proceed', 'error', 'pester');
        } else {
            //Except SUNWIN
            if (this.sections.name.En == 'Automatic Fire Suppression System' && this.sections.secOptions[0].response == 'Yes' && this.sections.secOptions[0].sequence == '9.001') {
                for (var key1 in this.sectionsAllData) {
                    if (this.sectionsAllData[key1].name.En == 'Automatic Fire Suppression (SUNWIN)') {
                        this.sectionsAllData[key1].isSkipped = true;
                        for (var key2 in this.sectionsAllData[key1].secOptions) {
                            this.sectionsAllData[key1].secOptions[key2].response = '';
                        }
                    }
                    if (this.sectionsAllData[key1].name.En == 'Automatic Fire Suppression (Except SUNWIN)') {
                        this.sectionsAllData[key1].isSkipped = false;
                        this.selectedSecIndex = key1;
                    }
                }
            } else if (this.sections.name.En == 'Automatic Fire Suppression System' && this.sections.secOptions[0].response == 'No' && this.sections.secOptions[0].sequence == '9.001') {
                for (var key1 in this.sectionsAllData) {
                    if (this.sectionsAllData[key1].name.En == 'Automatic Fire Suppression (SUNWIN)') {
                        this.sectionsAllData[key1].isSkipped = false;
                        this.selectedSecIndex = key1;
                    }
                    if (this.sectionsAllData[key1].name.En == 'Automatic Fire Suppression (Except SUNWIN)') {
                        this.sectionsAllData[key1].isSkipped = true;
                        for (var key2 in this.sectionsAllData[key1].secOptions) {
                            this.sectionsAllData[key1].secOptions[key2].response = '';
                        }
                    }
                }
            }
            //SUNWIN
            /*if (this.sections.name.En == 'Automatic Fire Suppression System' && this.sections.secOptions[1].response == 'Yes' && this.sections.secOptions[1].sequence == '9.002') {
                for (var key1 in this.sectionsAllData) {
                    if (this.sectionsAllData[key1].name.En == 'Automatic Fire Suppression (SUNWIN)') {
                        this.sectionsAllData[key1].isSkipped = false;
                        this.selectedSecIndex = key1;
                    }
                    if (this.sectionsAllData[key1].name.En == 'Automatic Fire Suppression (Except SUNWIN)') {
                        this.sectionsAllData[key1].isSkipped = true;
                        for (var key2 in this.sectionsAllData[key1].secOptions) {
                            this.sectionsAllData[key1].secOptions[key2].response = '';
                        }
                    }
                }
            } else if (this.sections.name.En == 'Automatic Fire Suppression System' && this.sections.secOptions[1].response == 'No' && this.sections.secOptions[1].sequence == '9.002') {
                for (var key1 in this.sectionsAllData) {
                    if (this.sectionsAllData[key1].name.En == 'Automatic Fire Suppression (SUNWIN)') {
                        this.sectionsAllData[key1].isSkipped = true;
                        for (var key2 in this.sectionsAllData[key1].secOptions) {
                            this.sectionsAllData[key1].secOptions[key2].response = '';
                        }
                    }
                    if (this.sectionsAllData[key1].name.En == 'Automatic Fire Suppression (Except SUNWIN)') {
                        this.sectionsAllData[key1].isSkipped = false;
                        this.selectedSecIndex = key1;
                    }
                }
            }*/
        }
        //console.log('sections.secOptions 2: ', JSON.stringify(this.sections.secOptions));
        //console.log('selectedSecIndex: ', this.selectedSecIndex);
    }

    isExcSunwin() {
        console.log('isExcSunwin selectedSecIndex: ' + (+this.selectedSecIndex + +2));
        if (this.sections.name.En == 'Automatic Fire Suppression (Except SUNWIN)')
            this.selectedSecIndex = ((+this.selectedSecIndex + +2));
    }

    async isCC() {
        if (this.sections.name.En == 'Cable Connections' && (this.sections.secOptions[0].response == null || this.sections.secOptions[0].response == '')) {
            this.showToastNotification('Error', ' Please select to proceed', 'error', 'pester');
        } else {
            //Visible Cable Connections
            if (this.sections.name.En == 'Cable Connections' && this.sections.secOptions[0].response == 'Yes' && this.sections.secOptions[0].sequence == '19.001') {
                for (var key1 in this.sectionsAllData) {
                    if (this.sectionsAllData[key1].name.En == 'Second Device') {
                        this.sectionsAllData[key1].isSkipped = false;
                        this.selectedSecIndex = key1;
                        break;
                    }
                }
            } else if (this.sections.name.En == 'Cable Connections' && this.sections.secOptions[0].response == 'No' && this.sections.secOptions[0].sequence == '19.001') {
                for (var key1 in this.sectionsAllData) {
                    if (this.sectionsAllData[key1].name.En == 'Second Device') {
                        this.sectionsAllData[key1].isSkipped = true;
                        var respId;
                        var subRespWrps;
                        for (var key2 in this.sectionsAllData[key1].secOptions) {
                            this.sectionsAllData[key1].secOptions[key2].response = '';
                            if (this.sectionsAllData[key1].secOptions[key2].question.En == 'Device Name') {
                                respId = this.sectionsAllData[key1].secOptions[key2].recId;
                                subRespWrps = this.sectionsAllData[key1].secOptions[key2].subRespWrps;
                            }
                        }
                        //console.log('respId: ', respId);
                        //console.log('subRespWrps: ', subRespWrps)
                        if (subRespWrps != null) {
                            console.log("----remove multi called------");
                            await this.removeSubResponseMultiHelper(subRespWrps);
                            console.log("----remove multi ended------");
                            if (respId != null) {
                                console.log("----add called------");
                                await this.addSubResponseHelper(1, this.sectionsAllData[key1].secOptions[key2].recId);
                                console.log("----add ended------");
                            }
                        }
                        break;
                    }
                }
                this.VRTS_SubmitPage = true; //skipping
                this.VRTS_IterationPage = false;
            }
            //Invisible Cable Connections
            /*if (this.sections.name.En == 'Cable Connections' && this.sections.secOptions[1].response == 'Yes' && this.sections.secOptions[1].sequence == '19.002') {
               for (var key1 in this.sectionsAllData) {
                  if (this.sectionsAllData[key1].name.En == 'Second Device') {
                     this.sectionsAllData[key1].isSkipped = true;
                     var respId;
                     var subRespWrps;
                     for (var key2 in this.sectionsAllData[key1].secOptions) {
                           this.sectionsAllData[key1].secOptions[key2].response = '';
                        if(this.sectionsAllData[key1].secOptions[key2].question.En == 'Device Name'){
                           //console.log('recId ',this.sectionsAllData[key1].secOptions[key2].recId);
                           //console.log('subRespWrps ',this.sectionsAllData[key1].secOptions[key2].subRespWrps);
                           respId = this.sectionsAllData[key1].secOptions[key2].recId;
                           subRespWrps = this.sectionsAllData[key1].secOptions[key2].subRespWrps;
                        }
                     }
                     //console.log('respId: ',respId);
                     //console.log('subRespWrps: ',subRespWrps)
                     if(subRespWrps != null){
                       for (var key3 in subRespWrps) {
                          this.removeSubResponseHelper(0,0,subRespWrps[key3].recId);
                       }
                       if(respId != null)
                          this.addSubResponseHelper(0,this.sectionsAllData[key1].secOptions[key2].recId);
                     }
                     break; 
                  }
               }
               this.VRTS_SubmitPage = true; //skipping
               this.VRTS_IterationPage = false;
            } else if (this.sections.name.En == 'Cable Connections' && this.sections.secOptions[1].response == 'No' && this.sections.secOptions[1].sequence == '19.002') {
               for (var key1 in this.sectionsAllData) {
                  if (this.sectionsAllData[key1].name.En == 'Second Device') {
                     this.sectionsAllData[key1].isSkipped = false;
                     this.selectedSecIndex = key1;
                     break;
                  }
               }
            }*/
        }
        //console.log('sections.secOptions 2: ', JSON.stringify(this.sections.secOptions));
        //console.log('selectedSecIndex: ', this.selectedSecIndex);
    }

    isSD() {
        var isValidation = false;
        if (this.sections.secOptions.length > 1) {
            if (this.sections.secOptions[0].response == null || this.sections.secOptions[0].response == '') {
                this.showToastNotification('Error', ' Please select to proceed', 'error', 'pester');
                isValidation = true;
            } else {
                for (var key in this.sections.secOptions[1].subRespWrps) {
                    if (this.sections.secOptions[1].subRespWrps[key].answer == null || this.sections.secOptions[1].subRespWrps[key].answer == '') {
                        this.showToastNotification('Error', ' Please select to proceed', 'error', 'pester');
                        isValidation = true;
                        break;
                    }
                }
            }
        }
        if (isValidation == false) {
            this.VRTS_SubmitPage = true; //skipping
            this.VRTS_IterationPage = false;
        }
    }

    getPicklistAnswered() {
        let picklistAnswered = true;
        for (var key1 in this.sections.secOptions) {
            if (this.sections.secOptions[key1].isPicklist == true && this.sections.secOptions[key1].response != 'Yes') { //&&
                //this.sections.name.En != 'Automatic Fire Suppression System' && this.sections.name.En != 'Cable Connections') {
                picklistAnswered = false;
                break;
            }
        }
        console.log('picklistAnswered: ' + picklistAnswered);
        return picklistAnswered;
    }

    getResult(picklistAnswered) {
        for (var key2 in this.sections.secOptions) {
            if (this.sections.secOptions[key2].isResult == true) {
                if (picklistAnswered == true)
                    this.sections.secOptions[key2].response = 'Pass';
                else if (picklistAnswered == false)
                    this.sections.secOptions[key2].response = 'Fail';
                break;
            }
        }
    }

    saveData() {
        console.log('--------saveData inside--------');
        console.log('sectionsAllData:', this.sectionsAllData);
        saveObservationsData({
            ObsRecId: this.recordId,
            sectionWrapperListStr: JSON.stringify(this.sectionsAllData)
        }).then((response) => {
            console.log('--------save response: ---------------');
            if (response != null && response != '') {} else {}
        }).catch((error) => {
            console.log('error');
            console.error(error);
            this.showToastNotification('Error', error, 'error', 'sticky');
        })
    }

    get addSubRespDisabled() {
        //console.log(this.sections.name.En+' :addSubRespDisabled: '+this.sections.secOptions[1].subRespWrps.length);
        if (this.sections.secOptions[1].subRespWrps.length >= 3)
            return true;
        else
            return false;
    }

    get removeSubRespDisabled() {
        //console.log(this.sections.name.En+' :removeSubRespDisabled: '+this.sections.secOptions[1].subRespWrps.length);
        if (this.sections.secOptions[1].subRespWrps.length <= 1)
            return true;
        else
            return false;
    }

    addSubResponse(event) {
        var index = event.target.dataset.index;
        var respid = event.target.dataset.respid;
        this.addSubResponseHelper(index, respid);
    }

    addSubResponseHelper(index, respid) {
        console.log('----------------addSubResponseHelper inside -----------------');
        //console.log(this.sections.name.En + ' addSubResponseHelper ' + index + ' respid ' + respid);
        return createSubResp({
            respId: respid, //'a8R8E00000041NOUAY'
            deviceName: this.deviceName
        }).then((response) => {
            console.log('----------------addSubResponseHelper response: -----------------');
            if (response != null && response != '') {
                for (var key1 in this.sectionsAllData) {
                    if (this.sectionsAllData[key1].name.En == 'Second Device') {
                        this.sectionsAllData[key1].secOptions[index].subRespWrps.push(response);
                        // console.log('addSubResponseHelper sections:', JSON.stringify(this.sectionsAllData[key1]));
                        break;
                    }
                }
            }
        }).catch((error) => {
            console.log('error');
            console.error(error);
            this.showToastNotification('Error', error, 'error', 'sticky');
        })
    }

    removeSubResponse(event) {
        var index = event.target.dataset.index;
        var subindex = event.target.dataset.subindex;
        var subid = event.target.dataset.subid;
        this.removeSubResponseHelper(index, subindex, subid);
    }

    removeSubResponseHelper(index, subindex, subId) {
        console.log('-----------removeSubResponseHelper inside: ----------');
        //console.log(this.sections.name.En + ' removeSubResponseHelper ' + index + ' :index - subindex:' + subindex + ' subId ' + subId);
        return deleteSubResp({
            SubIdStr: subId //'a8R8E00000041NOUAY'
        }).then((response) => {
            console.log('-----------removeSubResponseHelper response: ----------');
            if (response == true) {
                for (var key1 in this.sectionsAllData) {
                    if (this.sectionsAllData[key1].name.En == 'Second Device') {
                        if (subindex > -1)
                            this.sectionsAllData[key1].secOptions[index].subRespWrps.splice(subindex, 1);
                        //console.log('removeSubResponseHelper sections: ', this.sectionsAllData[key1]);
                        break;
                    }
                }
            }
        }).catch((error) => {
            console.log('error');
            console.error(error);
            this.showToastNotification('Error', error, 'error', 'sticky');
        })
    }

    removeSubResponseMultiHelper(subRespWrps) {
        console.log('-----------removeSubResponseMultiHelper inside: ----------');
        //console.log(this.sections.name.En + ' removeSubResponseMultiHelper ' + index + ' :index - subindex:' + subindex + ' subId ' + subId);
        var index = 1;
        var subIds;
        for (var key1 in subRespWrps) {
            if (subRespWrps[key1].recId != null)
                subIds = subIds + ';' + subRespWrps[key1].recId;
            else
                subIds = subRespWrps[key1].recId;
        }
        return deleteSubResp({
            SubIdStr: subIds //'a8R8E00000041NOUAY'
        }).then((response) => {
            console.log('-----------removeSubResponseMultiHelper response: ----------');
            if (response == true) {
                for (var key1 in this.sectionsAllData) {
                    if (this.sectionsAllData[key1].name.En == 'Second Device') {
                        this.sectionsAllData[key1].secOptions[index].subRespWrps = [];
                        //console.log('removeSubResponseMultiHelper sections: ', this.sectionsAllData[key1]);
                        break;
                    }
                }
            }
        }).catch((error) => {
            console.log('error');
            console.error(error);
            this.showToastNotification('Error', error, 'error', 'sticky');
        })
    }

    deleteDraftRecord() {
        console.log(this.recordId + ' ---- disconncted callbcak ------- ' + this.isSubmitButtonClicked);
        if (this.recordId != null && this.isSubmitButtonClicked != true) {
            deleteRecord(this.recordId)
                .then(() => {
                    console.log('----this.recordId----before---' + this.recordId);
                })
                .catch((error) => {
                    console.log('error');
                    console.error(error);
                });
        }
    }

    returnHome(event) {
        window.top.location.reload();
    }

    showToastNotification(title, message, variant, mode) {
        //console.log(message);
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant, //info (default), success, warning, and error
            mode: mode //dismissible (default), pester, sticky
        });
        this.dispatchEvent(evt);
    }

    disconnectedCallback() {
        this.deleteDraftRecord();
        //console.log('---- disconncted callbcak -------');
    }
}