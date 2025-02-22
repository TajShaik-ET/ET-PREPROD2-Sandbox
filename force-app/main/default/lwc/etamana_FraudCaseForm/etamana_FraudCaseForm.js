import { LightningElement, track, wire } from 'lwc';
import createAmanaCase from '@salesforce/apex/ETAmana_FraudCaseFormController.createAmanaCase';
import submitAmanaCase from '@salesforce/apex/ETAmana_FraudCaseFormController.submitAmanaCase';
import getAmanaCaseStatus from '@salesforce/apex/ETAmana_FraudCaseFormController.getAmanaCaseStatus';
import deleteAmanaCase from '@salesforce/apex/ETAmana_FraudCaseFormController.deleteAmanaCase';
import getRelatedFilesByRecordId from '@salesforce/apex/ETAmana_FraudCaseFormController.getRelatedFilesByRecordId';
import uploadFile from '@salesforce/apex/ETAmana_FraudCaseFormController.uploadFile';
import deleteFile from '@salesforce/apex/ETAmana_FraudCaseFormController.deleteFile';
import ReportCSS from "@salesforce/resourceUrl/report";
import { loadStyle } from 'lightning/platformResourceLoader';
import LWCImages from "@salesforce/resourceUrl/LWCImages";
/*import { getObjectInfo, getPicklistValues } from "lightning/uiObjectInfoApi";
import CASE_OBJECT from "@salesforce/schema/Amana_Solution__c";
import BUSINESSFUNCTIONINCIDENT_FIELD from "@salesforce/schema/Amana_Solution__c.ETAmana_Business_function_incident__c";
import VIOLATIONTYPE_FIELD from "@salesforce/schema/Amana_Solution__c.ETAmana_Type_of_the_violation__c";
import RELATIONWITHET_FIELD from "@salesforce/schema/Amana_Solution__c.ETAmana_Relation_with_Emirates_Transport__c";
import INCIDENTLOCATION_FIELD from "@salesforce/schema/Amana_Solution__c.ETAmana_incident_location__c";*/
import getPicklistValuesApex from '@salesforce/apex/ETAmana_FraudCaseFormController.getPicklistValues';
export default class Etamana_FraudCaseForm extends LightningElement {
Logo = LWCImages + "/AmanaLogo.png";
ETLogo = LWCImages + "/ETLogo.png";

    @track uniqueNumber;
    @track caseRecord = {
        ETAmana_Relation_with_Emirates_Transport__c: '',
        ETAmana_incident_location__c: '',
        ETAmana_Business_function_incident__c: '',
        ETAmana_incident_location__c: '',
        ETAmana_When_did_the_incident_occur__c: null,
        ETAmana_Type_of_the_violation__c: '',
        ETAmana_Summary_title__c: '',
        ETAmana_Description__c: '',
        ETAmana_Full_Name__c: '',
        ETAmana_Email_Address__c: '',
        ETAmana_Mobile_Number__c: ''
    };
    @track caseId;
    @track ETAmana_Status__c = 'New';
    @track uploadedFiles = [];
    @track uploadedFilesData = [];
    @track showSpinner = false;
    caseRecordTypeId;
    /*businessFunctionOptions = [];
    violationTypeOptions = [];
    relationWithETOptions = [];
    incidentLocationOptions = [];*/
    debounceTimeout; //Prevent Repeated Actions multiple(click within seconds) case creation
    @track filesList = [];
    fileData;
    isSubmitButtonClicked = false;
    isModalOpen = false;
    modalMessage = '';
    @track searchKey = '';
    @track searchResult = null;
    @track activeTab = 'Report Fraud Case';
    @track businessFunctionOptions = [];
    @track violationTypeOptions = [];
    @track relationWithETOptions = [];
    @track incidentLocationOptions = [];

    connectedCallback() {
        console.log('connectedCallback triggered');
        //this.uniqueNumber = this.generateUniqueNumber();
        // this.createAmanaCaseRecord();
        window.addEventListener('beforeunload', this.handleWindowClose.bind(this));
        loadStyle(this, ReportCSS)
            .then(() => {
                console.log("All CSS loaded. Initialization complete.");
            })
            .catch(error => {
                console.log("Failed to load the CSS:", error);
            });
        this.fetchPicklistValues();

    }
    fetchPicklistValues() {
        getPicklistValuesApex()
            .then((data) => {
                this.businessFunctionOptions = data.businessFunctionOptions.map(option => ({
                    label: option,
                    value: option
                }));
                this.violationTypeOptions = data.violationTypeOptions.map(option => ({
                    label: option,
                    value: option
                }));
                this.relationWithETOptions = data.relationWithETOptions.map(option => ({
                    label: option,
                    value: option
                }));
                this.incidentLocationOptions = data.incidentLocationOptions.map(option => ({
                    label: option,
                    value: option
                }));
            })
            .catch((error) => {
                console.error('Error fetching picklist values:', error);
            });
    }



    /*@wire(getPicklistValues, { recordTypeId: "$caseRecordTypeId", fieldApiName: BUSINESSFUNCTIONINCIDENT_FIELD })
    wiredBusinessFunctionValues({ error, data }) {
        if (data) {
            this.businessFunctionOptions = data.values;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.businessFunctionOptions = undefined;
        }
    }
        @wire(getPicklistValues, { fieldApiName: BUSINESSFUNCTIONINCIDENT_FIELD })
        wiredBusinessFunctionValues({ error, data }) {
            if (data) {
                this.businessFunctionOptions = data.values;
            } else if (error) {
                console.error('Error fetching business function picklist values:', error);
            }
        }
        

    @wire(getPicklistValues, { fieldApiName: VIOLATIONTYPE_FIELD })
    wiredViolationTypeFieldValues({ error, data }) {
        if (data) {
            this.violationTypeOptions = data.values;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.violationTypeOptions = undefined;
        }
    }

    @wire(getPicklistValues, {  fieldApiName: RELATIONWITHET_FIELD })
    wiredRelationWithETFieldValues({ error, data }) {
        if (data) {
            this.relationWithETOptions = data.values;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.relationWithETOptions = undefined;
        }
    }

    @wire(getPicklistValues, {  fieldApiName: INCIDENTLOCATION_FIELD })
    wiredIncidentLocationieldValues({ error, data }) {
        if (data) {
            this.incidentLocationOptions = data.values;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.incidentLocationOptions = undefined;
        }
    }*/

    generateUniqueNumber() {
        console.log('Generating unique number...');
        const prefix = 'UN-';
        const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        const randomAlphabets = Array.from({ length: 3 }, () =>
            alphabet.charAt(Math.floor(Math.random() * alphabet.length))
        ).join('');
        const timestamp = Date.now().toString().slice(-2);
        const randomPart = Math.floor(Math.random() * 100).toString().padStart(2, '0');
        const uniqueNumber = `${prefix}${randomAlphabets}${timestamp}${randomPart}`;
        console.log('Generated Unique Number:', uniqueNumber);
        return uniqueNumber;
    }
    //debounceTimeout; //Prevent Repeated Actions multiple(click within seconds) case cration
    handleTabChange(event) {
        const selectedTab = event.target.activeTabValue;
        console.log('Selected Tab: ' + selectedTab);
        console.log('caseId: ' + this.caseId);
        console.log('isSubmitButtonClicked: ' + this.isSubmitButtonClicked);

        /*if (selectedTab === this.activeTab) {
            console.log('Selected Tab:', selectedTab);
            this.createAmanaCaseRecord();
        }*/
        if (selectedTab === this.activeTab && !this.caseId) {
            console.log('Selected Tab:', selectedTab);
            if (this.debounceTimeout) {
                clearTimeout(this.debounceTimeout);
            }

            this.debounceTimeout = setTimeout(() => {
                this.createAmanaCaseRecord();
                console.log('Draft case created.');
            }, 500); // Adjust debounce time as needed
        }
        /*if (selectedTab === this.activeTab && this.caseId != null && this.caseId !='') {
            
            console.log('Selected Tab:', selectedTab);
            this.createAmanaCaseRecord();
        }*/
        if (selectedTab === 'Search Case Status' && this.caseId != null && this.isSubmitButtonClicked != true) {
            console.log('Selected Tab:', selectedTab);
            this.deleteAmanaCaseHandler();
        }
        // Update the active tab
        this.activeTab = selectedTab;
    }
    createAmanaCaseRecord() {
        this.uniqueNumber = this.generateUniqueNumber();
        console.log('Creating fraud case record with Unique Number:', this.uniqueNumber);
        this.showSpinner = true;
        createAmanaCase({ uniqueNumber: this.uniqueNumber })
            .then(result => {
                console.log('Fraud case created successfully:');
                this.caseId = result.Id;
                //this.ETAmana_Status__c = result.Status;
                this.ETAmana_Status__c = result.ETAmana_Status__c;
                this.caseRecord = result;
                this.showSpinner = false;
                // alert(this.caseId);
                console.table(this.caseRecord.Id);
            })
            .catch(error => {
                console.error('Error creating fraud case:', error);
                this.showSpinner = false;
            });
    }

    handleInputChange(event) {
        const field = event.target.dataset.field;
        //alert(field);
        this.caseRecord[field] = event.target.value;
        console.log(this.caseRecord);
    }

    handleSubmit(event) {
        event.preventDefault(); // Prevent default form submission
        this.showSpinner = true;
        // Validate the required combobox fields
        const comboboxFields = this.template.querySelectorAll('lightning-combobox');
        let allValid = true;

        comboboxFields.forEach(combobox => {
            if (!combobox.value) {
                combobox.setCustomValidity('This field is required.');
                combobox.reportValidity();
                allValid = false;
            } else {
                combobox.setCustomValidity('');
            }
        });

        if (!allValid) {
            this.showSpinner = false;
            return; // Stop submission if validation fails
        }
        // Validate the date field
        const incidentDateInput = this.template.querySelector('lightning-input[data-field="ETAmana_When_did_the_incident_occur__c"]');

        // Validate the required field
        if (!incidentDateInput.checkValidity()) {
            incidentDateInput.reportValidity();
            this.showSpinner = false;
            return;
        }
        // Validate the email field   
        const emailInput = this.template.querySelector('lightning-input[data-field="ETAmana_Email_Address__c"]');
        const emailValue = emailInput.value;

        // Custom email regex pattern
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;  // Simple email regex

        // Validate the email format if the field has a value
        if (emailValue && !emailRegex.test(emailValue)) {
            emailInput.setCustomValidity("Please enter a valid email address.");  // Custom error message
            emailInput.reportValidity();  // Show custom validation message
            this.showSpinner = false;  // Ensure spinner is not shown if validation fails
            return;  // Prevent form submission if the email is invalid
        } else {
            // Clear custom validity message if the email is valid or empty
            emailInput.setCustomValidity("");
        }
        this.showSpinner = true;


        // Update status to 'New' before submission
        this.caseRecord.ETAmana_Status__c = 'New';


        submitAmanaCase({ caseData: this.caseRecord })
            .then(result => {
                this.caseId = result.Id;
                this.showSpinner = false;
                console.table(result);
                this.isSubmitButtonClicked = true;
                this.isModalOpen = true;
                this.modalMessage = 'Case Submitted Successfully! ' + this.caseId;
            })
            .catch(error => {
                console.error('Error creating case:', error);
                this.showSpinner = false;
                this.isModalOpen = true;
                this.modalMessage = 'Something went wrong!';
                console.table(error);
            });
    }



    openfileUpload(event) {
        console.log('openfileUpload');
        const file = event.target.files[0];
        if (!file) {
            this.isModalOpen = true;
            this.modalMessage = 'Please select a file';
            return;
        }
        const MAX_FILE_SIZE = 2000000; // 2 MB
        // Check file size
        if (file.size > MAX_FILE_SIZE) {
            this.isModalOpen = true;
            this.modalMessage = 'File size exceeds the limit of 2 MB';
            return;
        }
        const reader = new FileReader();
        reader.onload = () => {
            try {
                const base64 = reader.result.split(',')[1];
                this.fileData = {
                    filename: file.name,
                    base64: base64,
                    recordId: this.caseId
                };

                console.log('fileData:', JSON.stringify(this.fileData));
                this.handleUpload();
            } catch (error) {
                console.error('Error reading file:', error);
                this.showSpinner = false;
                this.isModalOpen = true;
                this.modalMessage = 'Error reading the file. Please try again.';
            }
        };

        reader.onerror = (error) => {
            console.error('FileReader error:', error);
            this.showSpinner = false;
            this.isModalOpen = true;
            this.modalMessage = 'Error loading file. Please try again.';
        };

        reader.readAsDataURL(file);
    }

    handleUpload() {
        this.showSpinner = true;
        console.log('filename: ' + this.fileData.filename);
        const {
            base64,
            filename,
            recordId
        } = this.fileData;
        uploadFile({
            base64: base64,
            filename: filename,
            recordId: recordId
        }).then(result => {
            console.log('result: ' + result);
            if (result != null && result != '') {
                let title = this.fileData.filename + ' uploaded successfully!';
                this.isModalOpen = true;
                this.modalMessage = title;
                this.showSpinner = false;
                this.fileData = null;
                this.fetchFiles();
            } else {
                this.isModalOpen = true;
                this.modalMessage = 'File upload failed. Please try again.';
            }
        }).catch(error => {
            console.error('Error during file upload:', error);
            this.showSpinner = false;
            this.isModalOpen = true;
            this.modalMessage = 'File upload failed!';
        });
    }

    fetchFiles() {
        console.log('fetchFiles');
        getRelatedFilesByRecordId({
            recordId: this.caseId
        }).then((response) => {
            console.log('fetchFiles >>> ' + JSON.stringify(response));
            if (response != null && response != '') {
                this.filesList = Object.keys(response).map(item => ({
                    "label": response[item],
                    "value": item
                    //"url": `/sfc/servlet.shepherd/version/download/${item}`
                }))
                console.log(this.filesList)
            } else {
                this.filesList = [];
            }
        }).catch((error) => {
            console.log('error');
            console.error(error);
        })
    }


    get uploadDisabled() {
        var filesList = this.filesList;
        if (filesList.length >= 5) {
            return true;
        } else {
            return false;
        }
    }

    deleteHandler(event) {
        console.log(event.target.dataset.id);
        deleteFile({
            ContentDocId: event.target.dataset.id
        }).then((response) => {
            console.log('deleteFile response >>> ' + response);
            if (response != null && response != '') {
                if (response == true) {
                    this.isModalOpen = true;
                    this.modalMessage = 'File deleted Successfully!';
                }
                else {
                    this.isModalOpen = true;
                    this.modalMessage = 'File not deleted';
                }
                this.fetchFiles();
            }
        }).catch((error) => {
            console.log('error');
            console.error(error);
        })
    }

    /*downloadHandler(event) {
        console.log(event.target.dataset.id);
        window.open(event.target.dataset.id);
    }*/

    closeModal() {
        this.isModalOpen = false;
        this.modalMessage = '';
    }

    handleKeyChange(event) {
        this.searchKey = event.target.value;
    }

    handleSearch() {
        // Check if searchKey is empty
        if (!this.searchKey || this.searchKey.trim() === '') {
            // Clear the searchResult if searchKey is empty
            this.searchResult = null;
            return;
        }
        getAmanaCaseStatus({ uniqueNumber: this.searchKey })
            .then(result => {
                if (result) {
                    this.searchResult = result;
                } else {
                    this.searchResult = null;
                }
            })
            .catch(error => {
                this.searchResult = null;
                console.error('Error retrieving case:', error);
            });
    }
    disconnectedCallback() {
        window.removeEventListener('beforeunload', this.handleWindowClose.bind(this));
        this.deleteAmanaCaseHandler();
        console.log('---- disconncted callbcak -------');
    }
    handleWindowClose(event) {
        if (this.caseId != null && this.isSubmitButtonClicked != true) {
            this.deleteAmanaCaseHandler();
            console.log('Window or tab is being closed/reloaded. Case deleted.');
        }
    }
    deleteAmanaCaseHandler() {
        console.log(this.caseId + ' ---- disconncted callbcak ------- ' + this.isSubmitButtonClicked);
        if (this.caseId != null && this.isSubmitButtonClicked != true) {
            deleteAmanaCase({ caseId: this.caseId })
                .then(result => {
                    console.log('Case Deleted Successfully! ' + result);
                    if (result == true) {
                        this.caseId = '';
                    }
                })
                .catch(error => {
                    console.error('Error creating case:', error);
                    console.table(error);
                });
        }
    }

}