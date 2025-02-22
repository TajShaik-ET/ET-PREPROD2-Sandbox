import { LightningElement, track, wire, api } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import { loadStyle } from 'lightning/platformResourceLoader';
import ET_inspectionExternalStyle from '@salesforce/resourceUrl/ET_inspectionExternalStyle'
import LOGO_LEFT from "@salesforce/resourceUrl/logoleft";
import LOGO_RIGHT from "@salesforce/resourceUrl/logoright";
import getReceiptDetails from '@salesforce/apex/ETI_InspectionReceiptCtrl.searchInspectionReceipt';
import saveReceiptDetails from '@salesforce/apex/ETI_InspectionReceiptCtrl.saveInspectionReceipt';
import integrateReceipt from '@salesforce/apex/ETI_InspectionReceiptCtrl.IntegrateWithAman';
import getPrintResult from '@salesforce/apex/ETI_InspectionReceiptCtrl.getPrintResult';
import getPicklistValues from '@salesforce/apex/ETI_InspectionReceiptCtrl.getPicklistValues';
import getRelatedFilesByRecordId from '@salesforce/apex/ETI_InspectionReceiptCtrl.getRelatedFilesByRecordId';
import uploadFile from '@salesforce/apex/ETI_InspectionReceiptCtrl.uploadFile';
import deleteFile from '@salesforce/apex/ETI_InspectionReceiptCtrl.deleteFile';
import getRoleAndProfile from '@salesforce/apex/ETI_InspectionReceiptCtrl.getRoleAndProfile';
import { refreshApex } from '@salesforce/apex';
import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import NAME_FIELD from '@salesforce/schema/User.Name';
import EMPLOYEENUMBER_FIELD from '@salesforce/schema/User.EmployeeNumber';
import { showToastNotification, isEmptyString } from "c/eT_Utils";

export default class ETI_InspectionReceipt extends NavigationMixin(LightningElement) {
   logoleft = LOGO_LEFT;
   logoright = LOGO_RIGHT;
   showSpinner = false;
   isBusinessCommunity = false;
   @track error;
   @track name;
   @track searchInput = '';
   @track laneNumber = '';
   @track receiptDetails;
   @track responseWrapper;
   @track showAfterApproval = false;
   @track showSubmit = true;
   @track showSave = false;
   @track showPrintBtn = false;
   todayDate;
   isCodesModalOpen;
   isSubmitModalOpen;
   activeSectionsBreak = [];
   activeSectionsVisual = [];
   inspCodesBreak = [];
   inspCodesVisual = [];
   allCodesBreak = [];
   allCodesVisual = [];
   @track oldCodes = [];
   defectsMapBreak = new Map();
   defectsMapVisual = new Map();
   defectsArrayBreak = [];
   defectsArrayVisual = [];
   @track inspectorDetail = [];
   testResult = '';
   tabName = '';
   @track filesList = [];
   fileData;
   selectedValue = ''; // Holds the selected value
   picklistOptions = []; // Stores the picklist options fetched from metadata
   userId = USER_ID; // Automatically gets the current userId
   @track userRole;
   @track userProfile = '';
   @track error = '';
   @track isApprovalSubmit = false;
   @track showApproval = false;
   @track showPicklist = true;
   @track fileAppend = '';
   @track inspObsrFields = 'Id,Aman_Receipt__c,AMAN_Receipt_No__c,Break_Major_Count__c,Visual_Major_Count__c,Vehicle_Make__c,Vehicle_Model__c,Vehicle_Color__c,Break_Inspection_Draft__c,Visual_Inspection_Draft__c,Is_Break_Inspection_Completed__c,Is_Visual_Inspection_Completed__c,Break_Inspection_Count__c,Visual_Inspection_Count__c,Remarks__c,Remarks_by_Supervisor__c,Steering_Type__c,Gear_Type__c,No_Of_Tires__c,No_Of_Seats__c,No_Of_Doors__c,Weight_Loaded__c,Weight_Unloaded__c,Horse_Power__c,No_Of_Cylinders__c,Fuel_Type__c,Engine_No__c,Chassis_No__c,Model_Year__c,Country__c,Vehicle_Type__c,Vehicle_Kind__c,No_Of_Axles__c,Break_Inspector_Name__c,Visual_Inspector_Name__c,Break_Inspector_Id__c,Visual_Inspector_Id__c,Lane_Number__c,Submit_for_Approval__c,Actual_Approver__c,Actual_Approver_Name__c,Rejected__c,Approved__c,Approver_Name_and_ID__c,Approver_Finance_ID__c,Email_Sent_to_Supervisor__c,Email_Sent_to_Inspectors__c,isSyncedToAman__c,Integration_Status__c';

   @wire(getRecord, {
      recordId: USER_ID,
      fields: [NAME_FIELD, EMPLOYEENUMBER_FIELD]
   }) wireuser({
      error,
      data
   }) {
      if (error) {
         this.error = error;
      } else if (data) {
         //console.log('data: ' + JSON.stringify(data));
         this.inspectorDetail.push({
            name: data.fields.Name.value,
            empNum: data.fields.EmployeeNumber.value
         });
         console.log('inspectorDetail: ' + JSON.stringify(this.inspectorDetail));
      }
   }

   
    @wire(getPicklistValues)
    wiredPicklist({ error, data }) {
        if (data) {
            this.picklistOptions = data.map(option => ({
                label: option.label,
                value: option.value
            }));
        } else if (error) {
            console.error('Error fetching picklist options:', error);
        }
    }

    fetchRoleAndProfile() {
      getRoleAndProfile({ userId: this.userId })
          .then((data) => {
              this.userRole = data.Role;
              this.userProfile = data.Profile;
              console.log('User Role>>>>>>>>', this.userRole);
              console.log('User Profile>>>>>>>>', this.userProfile);

              if(this.userRole == 'Vehicle Supervisor Partner User')
               {
                  this.fileAppend = '_sup';
               }

               if(this.userRole == 'Vehicle Inspector Partner User')
                  {
                     this.fileAppend = '_insp';
                  }
          })
          .catch((error) => {
              console.error('Error fetching Role and Profile:', error);
              this.error = 'Failed to fetch Role and Profile.';
          });
  }

    @track selectedLabel; 
    handlePicklistChange(event) {
        this.selectedValue = event.target.value; // Get the selected value
        const selectedOption = this.picklistOptions.find(
         option => option.value === this.selectedValue
     );

     // Get the label of the selected value
     this.selectedLabel = selectedOption ? selectedOption.label : '';
     console.log('Selected Value:', this.selectedValue);
     console.log('Selected Label:', this.selectedLabel);
     this.responseWrapper.inspObsr.Approver_Name_and_ID__c = this.selectedLabel;
     this.responseWrapper.inspObsr.Approver_Finance_ID__c = this.selectedValue;    
        //this.selectedLabel = event.target.Name;

    }

   connectedCallback() {
      this.fetchRoleAndProfile();
      
      
      var today = new Date();
      this.todayDate = today;
      //console.log(today);
      const currentUrl = window.location.href;
      if (currentUrl.includes('/Business/')) {
         this.isBusinessCommunity = true;
      } else {
         this.isBusinessCommunity = false;
      }
      //console.log('isBusinessCommunity:', this.isBusinessCommunity);
   }

   get optionsLane() {
      return [
         { label: '1', value: '1' },
         { label: '2', value: '2' },
         { label: '3', value: '3' },
         { label: '4', value: '4' },
         { label: '5', value: '5' },
         { label: '6', value: '6' },
         { label: '7', value: '7' },
         { label: 'OV', value: 'OV' },
         { label: 'OI', value: 'OI' }
      ];
   }
   @track disableCodeSelect = false;
   fetchReceiptData() {
      this.inspCodesBreak = [];
      this.inspCodesVisual = [];
      this.allCodesBreak = [];
      this.allCodesVisual = [];
      this.oldCodes = [];
      this.activeSectionsBreak = [];
      this.activeSectionsVisual = [];
      this.defectsMapBreak = new Map();
      this.defectsMapVisual = new Map();
      this.defectsArrayBreak = [];
      this.defectsArrayVisual = [];
      this.testResult = '';
      this.receiptDetails = null;
      const fieldElement = this.template.querySelector('[data-id="searchIpnutId"]');
      if (fieldElement) {
         this.searchInput = fieldElement.value.toUpperCase();
      }
      this.showSpinner = true;
      //console.log('search Input >> ' + this.searchInput);
      getReceiptDetails({
         searchStr: this.searchInput,
         inspObsrFields: this.inspObsrFields
      }).then((response) => {
         //console.groupCollapsed();
         //console.group();
         //console.log('response: ' + JSON.stringify(JSON.parse(response))); 
         //console.log('response:', response);
         //console.dir(response); 
         if (JSON.parse(response) != null && JSON.parse(response) != '') {
            this.responseWrapper = JSON.parse(response);
            console.log('response inspRecpt:', this.responseWrapper.inspRecpt);
            console.log('response inspObsr:', this.responseWrapper.inspObsr);
            if (this.responseWrapper.isSuccess) {
               this.fetchFiles(); //retrieve files
               if (!this.responseWrapper.inspObsr.Is_Break_Inspection_Completed__c || !this.responseWrapper.inspObsr.Is_Visual_Inspection_Completed__c)
                  this.initInspObsrRec(this.responseWrapper.inspObsr);
               if (this.inspectorDetail.length > 0 && this.responseWrapper.inspObsr.Is_Break_Inspection_Completed__c == false) {
                  this.responseWrapper.inspObsr.Break_Inspector_Name__c = this.inspectorDetail[0].name;
                  this.responseWrapper.inspObsr.Break_Inspector_Id__c = this.inspectorDetail[0].empNum;
               }
               if (this.inspectorDetail.length > 0 && this.responseWrapper.inspObsr.Is_Visual_Inspection_Completed__c == false) {
                  this.responseWrapper.inspObsr.Visual_Inspector_Name__c = this.inspectorDetail[0].name;
                  this.responseWrapper.inspObsr.Visual_Inspector_Id__c = this.inspectorDetail[0].empNum;
               }
               if (this.responseWrapper.inspObsr.Is_Break_Inspection_Completed__c == true || this.responseWrapper.inspObsr.Is_Visual_Inspection_Completed__c == true) {
                  
                  this.disableCodeSelect = true;
                  this.initInspObsrRec(this.responseWrapper.inspObsr);
                  if (this.responseWrapper.inspObsr.Break_Major_Count__c > 0 || this.responseWrapper.inspObsr.Visual_Major_Count__c > 0)
                     this.testResult = 'Fail';
                  else
                     this.testResult = 'Pass';
               }
               //New logic of approval to hide and show

               //if (this.responseWrapper.inspObsr.Is_Break_Inspection_Completed__c == false && this.responseWrapper.inspObsr.Is_Visual_Inspection_Completed__c == false) {
                //  if(this.showAfterApproval == false)
                //     this.disableCodeSelect = true;
               //}
               if (this.responseWrapper.inspObsr.Approver_Finance_ID__c == this.inspectorDetail[0].empNum) {
                  this.showApproval = true;
                  
               }



               //console.log('responseWrapper.receiptWrp: ' + JSON.stringify(this.responseWrapper.receiptWrp));
               if (this.responseWrapper.receiptWrp != null && this.responseWrapper.receiptWrp != '') {
                  this.receiptDetails = this.responseWrapper.receiptWrp.ReceiptDetails;
                  console.log('receiptDetails >>> ' + JSON.stringify(this.receiptDetails));
                  var mapCodes = this.responseWrapper.receiptWrp.inspCodeMap;
                  for (var key1 in mapCodes) {
                     this.inspCodesBreak.push({
                        inspCodeDetails: mapCodes[key1].inspCodeDetails,
                        defectCount: mapCodes[key1].defectCount,
                        label: key1 + ' (' + mapCodes[key1].defectCount + '/' + mapCodes[key1].inspCodeDetails.length + ')',
                        key: key1
                     });
                  }
                  this.inspCodesVisual = this.inspCodesBreak;
                  //console.log('inspCodesBreak >>> ', this.inspCodesBreak);
                  var codesNewBreak = this.responseWrapper.inspCodesNewBreak;
                  for (var key2 in codesNewBreak) {
                     this.allCodesBreak.push({
                        code: codesNewBreak[key2].code,
                        defect: codesNewBreak[key2].defect,
                        record: codesNewBreak[key2].recVDT,
                        remarks: codesNewBreak[key2].remarks,
                        inspType: codesNewBreak[key2].inspType
                     });
                  }
                  //console.log('allCodesBreak: ', this.allCodesBreak);
                  var codesNewVisual = this.responseWrapper.inspCodesNewVisual;
                  for (var key3 in codesNewVisual) {
                     this.allCodesVisual.push({
                        code: codesNewVisual[key3].code,
                        defect: codesNewVisual[key3].defect,
                        record: codesNewVisual[key3].recVDT,
                        remarks: codesNewVisual[key3].remarks,
                        inspType: codesNewVisual[key3].inspType
                     });
                  }
                  //console.log('allCodesVisual: ', this.allCodesVisual);
                  var codesOld = this.responseWrapper.receiptWrp.inspCodesOld;
                  for (var key4 in codesOld) {
                     this.oldCodes.push({
                        code: codesOld[key4].code,
                        defect: codesOld[key4].defect,
                        record: codesOld[key4].recVDT
                     });
                  }
                  //console.log('codesOld: ', this.oldCodes);
                  this.dispatchEvent(
                     showToastNotification('Success', this.responseWrapper.message, 'success', 'pester')
                  );
               } else {
                  this.dispatchEvent(
                     showToastNotification('Error', this.responseWrapper.message, 'error', 'pester')
                  );
               }
            } else {
               this.dispatchEvent(
                  showToastNotification('Error', this.responseWrapper.message, 'error', 'pester')
               );
            }
         } else {
            this.dispatchEvent(
               showToastNotification('Error', 'Error. Contact Admin', 'error', 'sticky')
            );
         }
         this.showSpinner = false;
         //console.groupEnd();
      }).catch((error) => {
         console.log('error');
         console.error(error);
         this.dispatchEvent(
            showToastNotification('Error', error.body.message, 'error', 'sticky')
         );
      })
   }

   initInspObsrRec(inspObsr) {
      if (!inspObsr.AMAN_Receipt_No__c) inspObsr.AMAN_Receipt_No__c = '';
      if (!inspObsr.Lane_Number__c) inspObsr.Lane_Number__c = '';
      if (!inspObsr.Vehicle_Make__c) inspObsr.Vehicle_Make__c = '';
      if (!inspObsr.Vehicle_Model__c) inspObsr.Vehicle_Model__c = '';
      if (!inspObsr.Break_Inspection_Draft__c) inspObsr.Break_Inspection_Draft__c = false;
      if (!inspObsr.Visual_Inspection_Draft__c) inspObsr.Visual_Inspection_Draft__c = false;
      if (!inspObsr.Is_Break_Inspection_Completed__c)
         { 
            inspObsr.Is_Break_Inspection_Completed__c = false;
             

         }
      if (!inspObsr.Is_Visual_Inspection_Completed__c) 
         {
            inspObsr.Is_Visual_Inspection_Completed__c = false;
            
         }
      if (!inspObsr.Remarks__c) inspObsr.Remarks__c = '';
      if (!inspObsr.Remarks__c) inspObsr.Remarks_by_Supervisor__c = '';
      if (!inspObsr.Steering_Type__c) inspObsr.Steering_Type__c = '';
      if (!inspObsr.Gear_Type__c) inspObsr.Gear_Type__c = '';
      if (!inspObsr.No_Of_Seats__c) inspObsr.No_Of_Seats__c = null;
      if (!inspObsr.No_Of_Doors__c) inspObsr.No_Of_Doors__c = null;
      if (!inspObsr.Weight_Loaded__c) inspObsr.Weight_Loaded__c = null;
      if (!inspObsr.Weight_Unloaded__c) inspObsr.Weight_Unloaded__c = null;
      if (!inspObsr.Horse_Power__c) inspObsr.Horse_Power__c = null;
      if (!inspObsr.No_Of_Cylinders__c) inspObsr.No_Of_Cylinders__c = null;
      if (!inspObsr.Fuel_Type__c) inspObsr.Fuel_Type__c = '';
      if (!inspObsr.Engine_No__c) inspObsr.Engine_No__c = '';
      if (!inspObsr.Chassis_No__c) inspObsr.Chassis_No__c = '';
      if (!inspObsr.Model_Year__c) inspObsr.Model_Year__c = '';
      if (!inspObsr.Country__c) inspObsr.Country__c = '';
      if (!inspObsr.Vehicle_Type__c) inspObsr.Vehicle_Type__c = '';
      if (!inspObsr.Vehicle_Kind__c) inspObsr.Vehicle_Kind__c = '';
      if (!inspObsr.Vehicle_Color__c) inspObsr.Vehicle_Color__c = '';
      if (!inspObsr.No_Of_Axles__c) inspObsr.No_Of_Axles__c = null;
      if (!inspObsr.Break_Inspector_Name__c) inspObsr.Break_Inspector_Name__c = '';
      if (!inspObsr.Visual_Inspector_Name__c) inspObsr.Visual_Inspector_Name__c = '';
      if (!inspObsr.Break_Inspector_Id__c) inspObsr.Break_Inspector_Id__c = '';
      if (!inspObsr.Viusal_Inspector_Id__c) inspObsr.Viusal_Inspector_Id__c = '';
      if (!inspObsr.Approved__c) inspObsr.Approved__c = false;
      if (!inspObsr.Rejected__c) inspObsr.Rejected__c = false;
      if (!inspObsr.Email_Sent_to_Supervisor__c) inspObsr.Email_Sent_to_Supervisor__c = false;
      if (!inspObsr.Email_Sent_to_Inspectors__c) inspObsr.Email_Sent_to_Inspectors__c = false;
      if (!inspObsr.Actual_Approver_Name__c) inspObsr.Actual_Approver_Name__c = '';
      if (!inspObsr.Actual_Approver__c)
      {
         inspObsr.Actual_Approver__c = '';
         this.showAfterApproval = false;
         this.showSubmit = true;
      }      
      else{
            this.showAfterApproval = true;
            this.showSubmit = false;
            
      }
      if (!inspObsr.Approver_Finance_ID__c) inspObsr.Approver_Finance_ID__c = '';
      if (!inspObsr.Approver_Name_and_ID__c)
      {
         inspObsr.Approver_Name_and_ID__c = '';
         this.showPicklist = true;

      }
      else
      {
         this.showPicklist = false;
      } 
      if (!inspObsr.Submit_for_Approval__c)
      {
         inspObsr.Submit_for_Approval__c = false;
      }
      if(inspObsr.Integration_Status__c == 'Success')
      {
         this.showPrintBtn = true;
      }
      this.responseWrapper.inspObsr = inspObsr;
      console.log('inspObsr: '+JSON.stringify(this.responseWrapper.inspObsr));
   }

   handleFieldChange(event) {
      var fieldAPI = event.target.name;
      var fieldValue = event.target.value;
      console.log('Field>>>>>>', fieldAPI , ' Value>>>>>>' , fieldValue);
      this.responseWrapper.inspObsr[fieldAPI] = fieldValue;
   }

   @track approvalCheck = false;
   handlecheckBox(event)
   {
      console.log(' CheckboxValue>>>>>>' , event.target.checked);
      console.log(' Checkbox name>>>>>>' , event.target.name);
      console.log(' User Id>>>>>>' , USER_ID);
      
      var fieldAPI = event.target.name;
      this.responseWrapper.inspObsr[fieldAPI] =  event.target.checked;
         if(event.target.name == 'Submit_for_Approval__c')
            this.approvalCheck = event.target.checked;      
         
         if(event.target.name == 'Approved__c')
         {
            this.responseWrapper.inspObsr.Actual_Approver__c = USER_ID;
            this.responseWrapper.inspObsr.Rejected__c = false;
         }
            

         if(event.target.name == 'Rejected__c' && event.target.checked == true)
         {
            this.responseWrapper.inspObsr.Approved__c = false;
            this.responseWrapper.inspObsr.Submit_for_Approval__c = false;
            this.responseWrapper.inspObsr.Email_Sent_to_Supervisor__c = false;
            this.responseWrapper.inspObsr.Approver_Name_and_ID__c = '';
            this.responseWrapper.inspObsr.Approver_Finance_ID__c = '';
         }
   }
   

   openCodesModal(event) {
      //console.log('Open Popup');
      this.isCodesModalOpen = true;
      this.tabName = event.target.value;
   }

   getSelectedCodes(event) {
      console.log('tabName: ', event.detail.tabName);
      if (event.detail.tabName == 'inspTabBreak') {
         this.inspCodesBreak = event.detail.inspCodes;
         this.allCodesBreak = event.detail.allCodes;
         this.adefectsMapBreak = event.detail.defectsMap;
         this.defectsArrayBreak = event.detail.defectsArray;
         this.activeSectionsBreak = event.detail.activeSections;
      }
      //console.log('allCodesBreak Array --> ', this.allCodesBreak);
      let sortedAllCodesBreak = [...this.allCodesBreak].sort((a,b) => parseInt(a.code, 10) - parseInt(b.code, 10));      
      this.allCodesBreak = sortedAllCodesBreak;      
      //console.log('allCodesBreak: ', JSON.parse(JSON.stringify(this.allCodesBreak)))
     if (event.detail.tabName == 'inspTabVisual') {
         this.inspCodesVisual = event.detail.inspCodes;
         this.allCodesVisual = event.detail.allCodes;
         this.defectsMapVisual = event.detail.defectsMap;
         this.defectsArrayVisual = event.detail.defectsArray;
         this.activeSectionsVisual = event.detail.activeSections;
      }
      console.log('allCodesVisual: ', this.allCodesVisual);
      let sortedAllCodesVisual = [...this.allCodesVisual].sort((a,b) => parseInt(a.code, 10) - parseInt(b.code, 10));      
      this.allCodesVisual = sortedAllCodesVisual;     

      var testResultBreak = true;
      var testResultVisual = true;
      this.testResult = 'Pass';
      if (this.allCodesBreak.length > 0) {
         for (var key2 in this.allCodesBreak) {
            if (this.allCodesBreak[key2].defect == 'Major') {
               testResultBreak = false;
               break;
            }
         }
      }
      if (this.allCodesVisual.length > 0) {
         for (var key3 in this.allCodesVisual) {
            if (this.allCodesVisual[key3].defect == 'Major') {
               testResultVisual = false;
               break;
            }
         }
      }
      if (!testResultBreak || !testResultVisual)
         this.testResult = 'Fail';
   }

   getCloseModal(event) {
      //console.log('event', event.detail.isCodesModalOpen);
      this.isCodesModalOpen = event.detail.isCodesModalOpen;
   }

   getToggleSection(event) {
      //console.log('event', event.detail.activeSections);
      if (event.detail.tabName == 'inspTabBreak') {
         this.activeSectionsBreak = event.detail.activeSections;
      }
      if (event.detail.tabName == 'inspTabVisual') {
         this.activeSectionsVisual = event.detail.activeSections;
      }
   }

   get isBreakInsp() {
      //console.log('disableSave');
      if (this.tabName == 'inspTabBreak')
         return true;
      else
         return false;
   }

   get isInspectionCompleted() {
      //console.log('disableCancel');
      var inspObsr = this.responseWrapper.inspObsr;
      if (inspObsr.Is_Break_Inspection_Completed__c == true && inspObsr.Is_Visual_Inspection_Completed__c == true)
         {
            return true;
         }
      else if (this.responseWrapper.inspObsr.Approver_Finance_ID__c == this.inspectorDetail[0].empNum) {
            return true; 
      }
      else
      {
         return false;
      }
   }

   showPrintMsg()
   {
      console.log('recpNo>>>>>>>' + this.responseWrapper.inspObsr.AMAN_Receipt_No__c + 'inspNo>>>' + this.inspectorDetail[0].empNum);
      getPrintResult({
         recpNo: this.responseWrapper.inspObsr.AMAN_Receipt_No__c,
         inspNo: this.inspectorDetail[0].empNum,//this.inspObsrFields,
         recordId: this.responseWrapper.inspObsr.Id
         
      }).then((response) => {
         console.log('response without Parse Print>>>>>>>> ', response);
         console.log('response Print>>>>>>>> ' + JSON.stringify(JSON.parse(response)));
         this.showSpinner = false;
         if (JSON.parse(response) != null && JSON.parse(response) != '') {
            this.responseWrapper.inspObsr = JSON.parse(response);
            refreshApex(this.responseWrapper.inspObsr);
            this.dispatchEvent(
               showToastNotification('Success', 'Receipt Send to Aman for Print', 'success', 'pester')
            );
         } else {
            this.dispatchEvent(
               showToastNotification('Success', 'Receipt Send to Aman for Print', 'success', 'pester')
            );
         }
      }).catch((error) => {
         //console.log('error: '+JSON.stringify(error));
         console.error('Fetch error: ', error);
         this.dispatchEvent(
            showToastNotification('Error', error.body.message, 'error', 'sticky')
         );
      })

      this.dispatchEvent(
         showToastNotification('Success', 'Print Success', 'success', 'pester')
      );
   }

   openfileUpload(event) {
      const file = event.target.files[0];
      if (!file) {
         this.dispatchEvent(
            showToastNotification('warning', 'Please select a file', '', 'pester')
         );
         return;
      }
      var reader = new FileReader();
      reader.onload = () => {
         var base64 = reader.result.split(',')[1];
         this.fileData = {
            'filename': file.name + this.fileAppend,
            'base64': base64,
            'recordId': this.responseWrapper.inspObsr.Id
         }
         //console.log('fileData: '+JSON.stringify(this.fileData));
         this.handleUpload();
      }
      reader.readAsDataURL(file);
   }

   handleUpload() {
      this.showSpinner = true;
      //console.log('filename: ' + this.fileData.filename);
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
         //console.log('result: ' + result);
         if (result != null && result != '') {
            let title = this.fileData.filename + ' uploaded successfully!';
            this.dispatchEvent(
               showToastNotification('Success', title, 'success', 'pester')
            );
            this.showSpinner = false;
            this.fileData = null;
            this.fetchFiles();
         }
      })
   }

   fetchFiles() {
      //console.log('fetchFiles');
      getRelatedFilesByRecordId({
         recordId: this.responseWrapper.inspObsr.Id
      }).then((response) => {
         //console.log('fetchFiles >>> ' + JSON.stringify(response));
         if (response != null && response != '') {
            this.filesList = Object.keys(response).map(item => ({
               "label": response[item],
               "value": item,
               "url": `/sfc/servlet.shepherd/document/download/${item}`
            }))
            //console.log(this.filesList)
         } else {
            this.filesList = [];
         }
      }).catch((error) => {
         console.log('error');
         console.error(error);
         this.dispatchEvent(
            showToastNotification('Error', error.body.message, 'error', 'sticky')
         );
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

   previewHandler(event) {
      //console.log(event.target.dataset.id);
      this[NavigationMixin.Navigate]({
         type: 'standard__namedPage',
         attributes: {
            pageName: 'filePreview'
         },
         state: {
            selectedRecordId: event.target.dataset.id
         }
      })
   }

   deleteHandler(event) {
      //console.log(event.target.dataset.id);
      deleteFile({
         ContentDocId: event.target.dataset.id
      }).then((response) => {
         //console.log('deleteFile response >>> ' + response);
         if (response != null && response != '') {
            if (response == true) {
               this.dispatchEvent(
                  showToastNotification('Success', 'File deleted Successfully!', 'success', 'pester')
               );
            } else {
               this.dispatchEvent(
                  showToastNotification('Error', 'File not deleted', 'error', 'sticky')
               );
            }
            this.fetchFiles();
         }
      }).catch((error) => {
         console.log('error');
         console.error(error);
         this.dispatchEvent(
            showToastNotification('Error', error.body.message, 'error', 'sticky')
         );
      })
   }

   downloadHandler(event) {
      //console.log(event.target.dataset.id);
      window.open(event.target.dataset.id);
   }

   saveReceiptData() {
      //debugger;      
      var inspObsr = this.responseWrapper.inspObsr;
      if (isEmptyString(inspObsr.Remarks_by_Supervisor__c) && this.userRole == 'Vehicle Supervisor Partner User') {
         this.dispatchEvent(
            showToastNotification('Warning!', 'Please add remarks before saving', 'warning', 'sticky')
         );
      }

      if (isEmptyString(inspObsr.Lane_Number__c)) {
         this.dispatchEvent(
            showToastNotification('Information!', 'Please select Lane Number in Vehicle Information Tab', 'info', 'sticky')
         ); 
      } else if(this.filesList.length === 0 && this.userRole != 'Vehicle Supervisor Partner User'){
          this.dispatchEvent(
             showToastNotification('Error!', 'Please upload file before saving the record', 'error', 'sticky')
          );
      }else {
         this.showSpinner = true;
         //console.groupCollapsed();
         //console.group();
         //console.log('inspObsr: ', this.responseWrapper.inspObsr);
         if (this.responseWrapper.inspRecpt.Id)
            inspObsr.Aman_Receipt__c = this.responseWrapper.inspRecpt.Id;
         delete inspObsr.attributes;
         delete inspObsr.Inspection_Codes__r; //save issue with child
         var allCodesBreak = this.allCodesBreak;
         var allCodesVisual = this.allCodesVisual;
         //console.log('allCodesBreak:', allCodesBreak);
         //console.log('allCodesVisual:', allCodesVisual);
         //console.groupEnd();
         if (!inspObsr.Break_Inspection_Draft__c && allCodesBreak.length > 0)
            inspObsr.Break_Inspection_Draft__c = true;
         if (!inspObsr.Visual_Inspection_Draft__c && allCodesVisual.length > 0)
            inspObsr.Visual_Inspection_Draft__c = true;
         saveReceiptDetails({
            inspObsr: inspObsr,
            inspObsrFields: this.inspObsrFields,
            allCodesBreakStr: JSON.stringify(allCodesBreak),
            allCodesVisualStr: JSON.stringify(allCodesVisual)
         }).then((response) => {
            //console.log('response final: ' + JSON.stringify(JSON.parse(response)));
            this.showSpinner = false;
            if (JSON.parse(response) != null && JSON.parse(response) != '') {
               this.responseWrapper.inspObsr = JSON.parse(response);
               refreshApex(this.responseWrapper.inspObsr);
               this.isSaveCompleted = false;
               if(this.responseWrapper.inspObsr.Submit_for_Approval__c == true && this.responseWrapper.inspObsr.Approved__c == false && this.responseWrapper.inspObsr.Rejected__c == false)
               {
                  this.isApprovalSubmit = true;
               }
               console.log('Approve>>> ', this.responseWrapper.inspObsr.Approved__c , 'Reject>>>>>>>', this.responseWrapper.inspObsr.Rejected__c); 
               if(this.responseWrapper.inspObsr.Approved__c == true || this.responseWrapper.inspObsr.Rejected__c == true)
               {
                 
                  this.showAfterApproval = true;
                     //this.showApproval = false;
                     console.log('In if showAfterApproval>>>', this.showAfterApproval);   
               }
               this.dispatchEvent(
                  showToastNotification('Success', 'Saved succussfully', 'success', 'pester')
               );
               
            } else {
               this.dispatchEvent(
                  showToastNotification('Error', 'Issue while saving. Pleae contact admin', 'error', 'sticky')
               );
            }
         }).catch((error) => {
            //console.log('error: '+JSON.stringify(error));
            console.error('Fetch error: ', error);
            this.dispatchEvent(
               showToastNotification('Error', error.body.message, 'error', 'sticky')
            );
         })
      }
   }
   // To open modal on click of Submit button
   openSubmitModal(){
      this.isSubmitModalOpen = true;
   }
   // To close the Modal on click of No option in the modal & after calling Aman system
   closeSubmitModal(){
      this.isSubmitModalOpen = false;
   }
   // This function will be called on Click of Submit button
   handleConfirmSubmit(){
      this.integrateAman();
      this.closeSubmitModal();
   }
   integrateAman() {
      //debugger;
      var inspObsr = this.responseWrapper.inspObsr;
      if (inspObsr.Visual_Inspection_Draft__c == false) {
         this.dispatchEvent(
            showToastNotification('Information!', 'Please save the visual inspection code before submitting to AMAN', 'info', 'sticky')
         );
      } else {
         this.showSpinner = true;
         //console.groupCollapsed();
         //console.group();
         //console.log('inspObsr: ', this.responseWrapper.inspObsr);
         if (this.responseWrapper.inspRecpt.Id)
            inspObsr.Aman_Receipt__c = this.responseWrapper.inspRecpt.Id;
         delete inspObsr.attributes;
         delete inspObsr.Inspection_Codes__r; //save issue with child
         var allCodesBreak = this.allCodesBreak;
         var allCodesVisual = this.allCodesVisual;
         //console.log('allCodesBreak:', allCodesBreak);
         //console.log('allCodesVisual:', allCodesVisual);
         //console.groupEnd();
         if(inspObsr.Break_Inspection_Draft__c == true)
            inspObsr.Is_Break_Inspection_Completed__c = true;
         if(inspObsr.Visual_Inspection_Draft__c == true)
         {
            inspObsr.Is_Visual_Inspection_Completed__c = true;
         }
         else
         {
            this.dispatchEvent(
               showToastNotification('Error', 'Visual Inspection is not completed', 'error', 'sticky')
            );
         }
            
         console.log('VIsual>>>>>>>', inspObsr.Is_Visual_Inspection_Completed__c);
         console.log('Break>>>>>>>', inspObsr.Is_Break_Inspection_Completed__c);
         integrateReceipt({
            inspObsr: inspObsr,
            inspObsrFields: this.inspObsrFields,
            
         }).then((response) => {
            console.log('response final>>>>>>>> ' + JSON.stringify(JSON.parse(response)));
            this.showSpinner = false;
            if (JSON.parse(response) != null && JSON.parse(response) != '') {
               this.responseWrapper.inspObsr = JSON.parse(response);
               refreshApex(this.responseWrapper.inspObsr);
               this.dispatchEvent(
                  showToastNotification('Success', 'Submitted in Aman Successfully', 'success', 'pester')
               );
            } else {
               this.dispatchEvent(
                  showToastNotification('Error', 'Issue while submitting in Aman. Pleae contact admin', 'error', 'sticky')
               );
            }
         }).catch((error) => {
            //console.log('error: '+JSON.stringify(error));
            console.error('Fetch error: ', error);
            this.dispatchEvent(
               showToastNotification('Error', error.body.message, 'error', 'sticky')
            );
         })
      }
   }

   renderedCallback() {
      Promise.all([
         loadStyle(this, ET_inspectionExternalStyle)
      ])
         .then(() => {
            //console.log("All scripts and CSS are loaded. perform any initialization function.")
         })
         .catch(error => {
            //console.log("failed to load the scripts");
         });
   }

}