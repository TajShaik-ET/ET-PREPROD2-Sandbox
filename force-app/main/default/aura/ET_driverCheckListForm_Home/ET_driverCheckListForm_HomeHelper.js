({
    startTime: null,
    endTime: null,
    
    getSchoolVisitFormDetail: function(component, event, helper) {
        helper.setTableColumns(component, event, helper);
        //console.log('userid',component.get("v.userId"));
        var status = 'Draft';
        var query = 'SELECT Id, Name, Driver__c, Driver__r.Name, Status__c, Station__c, Branch__c, Date__c, School_Code__c, School_Name__c, Internal_Number__r.Name, Activity_Center__c, KM_Reading__c FROM Driver_Daily_Check_List__c WHERE Status__c != ' + '\'' + status + '\'' + ' AND OwnerId = ' + '\'' + component.get("v.userId") + '\'' +' ORDER BY CreatedDate DESC LIMIT 5000';
        var action = component.get("c.fetchRecords");
        action.setParams({
            "query": query
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log('getSchoolVisitFormDetail respons: '+JSON.stringify(response.getReturnValue()));
                var records = response.getReturnValue();
                records.forEach(function(record) {
                    record.linkName = record.Name;
                    record.Name = record.Name;
                    if(record.Driver__c){
                        record.driverlookupData=record.Driver__r.Name;
                        record.linkName1=record.Driver__r.Name;
                    }else{
                        record.driverlookupData='';
                        record.linkName1='';
                    }
                    if(record.Internal_Number__c){
                        record.internalNumber=record.Internal_Number__r.Name;
                        record.internalpassData=record.Internal_Number__r.Name;
                    }else{
                        record.internalNumber='';
                        record.internalpassData='';
                    }
                    
                });
                component.set("v.DriverCheckList", response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    showRowDetails: function(component, row, action) {
        //console.log('aaa');
        component.set("v.driverRecord", row.Id);
        component.set("v.openRow", true);
    },
    
    retrieveDriverChecklistsMdt: function(component, event, helper) {
        var queryDriver = 'SELECT Type__c,Category_Ar__c,Category_En__c,Category_Ur__c,Question_Ar__c,Question_En__c,Question_Ur__c,Severity_Ar__c,Number__c,Version__c,Sequence__c,Show_Number__c,Show_Category__c FROM DriverChecklistMaster__mdt ORDER BY Sequence__c ASC NULLS LAST'; //WHERE Number__c = 1 
        var action = component.get("c.getDriverChecklistsMdt");
        action.setParams({
            "queryDriver": queryDriver
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            //console.log('action state--> ' + state);
            if (component.isValid() && state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.driverChecklistWrpMdt", result);
                console.log('result>>> ' + JSON.stringify(result));
            } else if (component.isValid() && state === "ERROR") {
                console.log("Exception caught successfully");
                //console.log("Error object", response);
                console.log("Error Message", response.getError()[0]);
                console.log("Error Message", response.getError()[0].message);
                console.log("Error Message", response.getState());
                console.log("Error object", JSON.stringify(response));
            }
        });
        $A.enqueueAction(action);
    },
    
    createDriverChecklistRec: function(component, event, helper) {
        var action = component.get("c.getDriverCheckListRecord");
        action.setParams({
            "status": 'Draft'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            //console.log('action state--> ' + state);
            if (component.isValid() && state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.recordId", result);
                //this.showToast(component, event, helper, 'Success!', 'success', 'dismissable', '5000', 'Record Id Created successfully');
                component.set("v.DriverCheckListrecordId", result);
                //console.log('result>>> ' + JSON.stringify(result));
            } else if (component.isValid() && state === "ERROR") {
                console.log("Exception caught successfully");
                //console.log("Error object", response);
                console.log("Error Message", response.getError()[0]);
                console.log("Error Message", response.getError()[0].message);
                console.log("Error Message", response.getState());
                console.log("Error object", JSON.stringify(response));
            }
        });
        $A.enqueueAction(action);
    },
    
    createDriverChecklistLines: function(component, event, helper) {
        // console.log('createDriverChecklistLines');
        // console.log(component.get("v.driverChecklistWrpMdt"));
        var action = component.get("c.saveDriverCheckListLines");
        action.setParams({
            "checklistRecId": component.get("v.recordId"),
            "driverChecklistWrpListStr": JSON.stringify(component.get("v.driverChecklistWrpMdt"))
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('action state--> ' + state);
            if (component.isValid() && state === "SUCCESS") {
                
                var result = response.getReturnValue();
                console.log('result>>> ' + result);
            } else if (component.isValid() && state === "ERROR") {
                console.log("Exception caught successfully");
                //console.log("Error object", response);
                console.log("Error Message", response.getError()[0]);
                console.log("Error Message", response.getError()[0].message);
                console.log("Error Message", response.getState());
                console.log("Error object", JSON.stringify(response));
            }
        });
        $A.enqueueAction(action);
    },
    
    deleteDriverChecklist: function(component, event, helper) {
        console.log('deleteDriverChecklist');
        var action = component.get("c.deleteChecklist");
        action.setParams({
            "checklistRecId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('action state--> ' + state);
            if (component.isValid() && state === "SUCCESS") {
                var result = response.getReturnValue();
                if(result == true)
                    component.set("v.recordId", '');
                //console.log('result>>> ' + result);
            } else if (component.isValid() && state === "ERROR") {
                console.log("Exception caught successfully");
                //console.log("Error object", response);
                console.log("Error Message", response.getError()[0]);
                console.log("Error Message", response.getError()[0].message);
                console.log("Error Message", response.getState());
                console.log("Error object", JSON.stringify(response));
            }
        });
        $A.enqueueAction(action);
    },
    
    returnDateTime: function(component, event, helper) {
        console.log('Time Zone Preference in Salesforce ORG :'+$A.get("$Locale.timezone"));
        var tzoffset = (new Date()).getTimezoneOffset() * 60000; //offset in milliseconds
        var localISOCurrentTime = (new Date(Date.now() - tzoffset)).toISOString().slice(0, -1);
        //The slice(0, -1) gets rid of the trailing Z which represents Zulu timezone and can be replaced by your own.
        console.log('localISOCurrentTime: '+localISOCurrentTime);
        console.log('currentTime: '+localISOCurrentTime.split('T')[1]);
        if(component.get("v.startTime") == null || component.get("v.startTime") == ''){
            var formattedTimeAm_PM = (new Date()).toLocaleTimeString(); // Format the time as a string
            console.log('formattedTimeAm_PM: '+formattedTimeAm_PM);
            component.set("v.startTime", formattedTimeAm_PM);
        }
        return localISOCurrentTime.split('T')[1];
    },
    
    returnErrorMessage: function(component, event, helper, fields, field, message, errorMessage) {
        console.log(field,message,errorMessage);
        if(!fields[field]){
            if(errorMessage == '')
                errorMessage = message;
            else
                errorMessage = errorMessage+','+message; 
        }
        console.log(errorMessage);
        return errorMessage;
    },
    
    retriveuploadedFiles: function(component, event, helper) {
        var action = component.get("c.getUploadedDriverFiles"); // Call the server-side Apex method
        var documentId = component.get("v.recordId"); // Get the record ID from the component
        // Set parameters for the server call
        action.setParams({  
            driverID: component.get("v.recordId") // Pass the record ID to the server method
        });   
        // Callback function to handle server response
        action.setCallback(this, function(response) {  
            var state = response.getState(); // Get the state of the response
            if (state === 'SUCCESS') { // If server call is successful
                var result = response.getReturnValue(); // Get the return value from the server
                // Format the CreatedDate field of each file in the result array
                result.forEach(function(f) {
                    var createdDate = new Date(f.CreatedDate); // Convert CreatedDate to a JavaScript Date object
                    // Format the date and time
                    var formattedTime = createdDate.toLocaleString('en-US', { year: 'numeric', month: 'numeric', day: 'numeric', hour: 'numeric', minute: 'numeric', second: 'numeric', hour12: true });
                    f.formattedTime = formattedTime; // Add formattedTime property to each file object
                });
                // Alert the user that all files were retrieved successfully
                console.log(result); // Log the result to the console
                component.set('v.uplodedFilesData', result); // Set the uplodedFilesData attribute of the component with the result array
            } else {
                // If server call fails, alert the user that something went wrong
                alert('Something went Wrong');
            } 
        });  
        
        $A.enqueueAction(action); // Enqueue the server call action
    },
    
    delUploadedfiles : function(component,documentId) {  
        var action = component.get("c.deleteFiles");           
        action.setParams({
            "sdocumentId":documentId            
        });  
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){
                this.retriveuploadedFiles(component, event, helper);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'This is File deleted successfully',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
            }else{
                alert('Something Went Wrong');
            }
        });  
        $A.enqueueAction(action);  
    }, 
    
    previewHandler: function(component, row, action) {
        const urlString = window.location.href;
        const communityBaseURL = urlString.split('/Employee')[0] + '/Employee';
        component.set("v.driverRecord", row.Id);
        const recordId = component.get("v.driverRecord");
        // const communityBaseURL = 'https://icrm--preprod2.sandbox.my.site.com/Employee/s/';
        const vfPageName = 'apex/DriverChecklistPDF';
        const vfUrl = `${communityBaseURL}/${vfPageName}?Id=${recordId}`;
        //window.open(vfUrl, '_blank');
        const popupWindow = window.open(vfUrl, 'PDF Preview', 'width=700,height=500,scrollbars=yes,resizable=yes');
        if (popupWindow) {
            popupWindow.focus();
        } else {
            alert('Popup blocked! Please allow popups for this site.');
        }
        /*
        
         component.set("v.vfUrl", vfUrl);
         
         // Open the modal with the VF page inside an iframe
         $A.createComponent(
             "c:DriverChecklistModal",
             {
                 "vfUrl": vfUrl
             },
             function(content, status) {
                 if (status === "SUCCESS") {
                     let overlay = component.find("overlayLib");
                     overlay.showCustomModal({
                         header: "Driver Checklist PDF",
                         body: content,
                         showCloseButton: true,
                         closeCallback: function() {}
                     });
                 }
             }
         );
          */
    },
    
    validateInternalNumber: function(component, event, helper) {
        var InternalNumRec = component.get("v.internalNumber");
        var query = "SELECT Id, Name, Internal_Number__c,LastModifiedDate  FROM Driver_Daily_Check_List__c  WHERE LastModifiedDate = TODAY";
        var action = component.get("c.fetchRecords"); // Apex method
        action.setParams({
            query: query
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log(JSON.stringify(result));
                // Check if InternalNumRec matches any existing internal number in the result
                var isDuplicate = result.some(record => record.Internal_Number__c == InternalNumRec);
                if (isDuplicate) {
                    component.set("v.hasError", isDuplicate);
                } else {
                    component.set("v.hasError", false);
                    console.log("Validation passed. No duplicate internal number found.");
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error("Error in Apex call:", errors);
            }
        });
        
        $A.enqueueAction(action); // Enqueue the action
    },
    
    handleSpecialNeeds: function (component, event, helper, isSpecialNeeds) {
        console.log('isSpecialNeeds: ',isSpecialNeeds);
        var driverChecklistWrpMdt = component.get('v.driverChecklistWrpMdt');
        for (var key in driverChecklistWrpMdt) {
            if (driverChecklistWrpMdt[key].seq == '13.001') {
                if (isSpecialNeeds == true) {
                    driverChecklistWrpMdt[key].iconSelectedAction = '';
                    driverChecklistWrpMdt[key].response = '';
                    driverChecklistWrpMdt[key].isDisabled = false;
                } else {
                    driverChecklistWrpMdt[key].iconSelectedAction = 'notApplicableButton';
                    driverChecklistWrpMdt[key].response = 'Not Applicable';
                    driverChecklistWrpMdt[key].isDisabled = true;
                }
            }
        }
        var isResult = 'Pass';
        var isCommentReq = false;
        for (var key in driverChecklistWrpMdt) {
            if (driverChecklistWrpMdt[key].iconSelectedAction == '' && driverChecklistWrpMdt[key].srNo == '14' && driverChecklistWrpMdt[key].optionType == 'Radio') {
                if (driverChecklistWrpMdt[key].response == '') {
                    driverChecklistWrpMdt[key].severity.ar = 'High';
                    isResult = 'Fail';
                }
                break;
            } else if (driverChecklistWrpMdt[key].iconSelectedAction == 'notApplicableButton' && driverChecklistWrpMdt[key].srNo == '14' && driverChecklistWrpMdt[key].optionType == 'Radio') {
                if (driverChecklistWrpMdt[key].response == 'Not Applicable') {
                    driverChecklistWrpMdt[key].severity.ar = 'Low';
                    isResult = 'Not Applicable';
                }
                break;
            }
        }
        for (var key in driverChecklistWrpMdt) {
            if (driverChecklistWrpMdt[key].srNo == '14' && driverChecklistWrpMdt[key].optionType == 'Radio' &&
                (driverChecklistWrpMdt[key].response == '' || driverChecklistWrpMdt[key].response == null)) {
                isResult = 'Fail';
                isCommentReq = true;
                break;
            }
        }
        for (var key in driverChecklistWrpMdt) {
            if (driverChecklistWrpMdt[key].srNo == '14' && driverChecklistWrpMdt[key].optionType == 'Result') {
                driverChecklistWrpMdt[key].response = isResult;
                if (driverChecklistWrpMdt[key].srNo == '14' && isResult == 'Not Applicable'){
                    driverChecklistWrpMdt[key].severity.ar = 'Low';
                }else if (driverChecklistWrpMdt[key].srNo == '14' && isResult != 'Not Applicable'){
                    driverChecklistWrpMdt[key].severity.ar = 'High';
                }
                break;
            }
        }
        for (var key in driverChecklistWrpMdt) {
            if (driverChecklistWrpMdt[key].srNo == '14' && driverChecklistWrpMdt[key].optionType == 'Comment') {
                driverChecklistWrpMdt[key].commentReq = isCommentReq;
                if (driverChecklistWrpMdt[key].srNo == '14' && isResult == 'Not Applicable'){
                    driverChecklistWrpMdt[key].severity.ar = 'Low';
                    driverChecklistWrpMdt[key].isDisabled = true;
                }else if (driverChecklistWrpMdt[key].srNo == '14' && isResult != 'Not Applicable'){
                    driverChecklistWrpMdt[key].severity.ar = 'High';
                    driverChecklistWrpMdt[key].isDisabled = false;
                }
                break;
            }
        }
        var finResult = 'Pass';
        for (var key in driverChecklistWrpMdt) {
            //console.log(key+' - '+driverChecklistWrpMdt[key].response);
            if (driverChecklistWrpMdt[key].severity.ar == 'High' && driverChecklistWrpMdt[key].optionType == 'Result' &&
                (driverChecklistWrpMdt[key].response == 'Fail' || driverChecklistWrpMdt[key].response == null || driverChecklistWrpMdt[key].response == 'undefined')) {
                finResult = 'Fail';
                // console.log(key+' - '+driverChecklistWrpMdt[key].response);
                break;
            }
        }
        component.set('v.finalResult', finResult);
        component.set('v.driverChecklistWrpMdt', driverChecklistWrpMdt);
        //console.log('driverChecklistWrpMdt: ' + JSON.stringify(driverChecklistWrpMdt));
    },
    
    showToast: function(component, event, helper, title, type, mode, duration, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "mode": mode,
            "duration": duration,
            "message": message
        });
        toastEvent.fire();
    },
    
    setTableColumns: function(component, event, helper) {
        component.set('v.mycolumns', [{
            label: 'Visit Reference No.',
            fieldName: 'li nkName',
            type: 'button',
            typeAttributes: {
                label: {
                    fieldName: 'Name'
                },
                name: 'view_details',
                title: 'Click to View Details'
            }
        },
                                      {
                                          label: 'Date',
                                          fieldName: 'Date__c',
                                          type: 'date'
                                      },
                                      {
                                          label: 'Driver Name',
                                          fieldName: 'linkName1',
                                          type: 'text',
                                          typeAttributes: {
                                              label: {
                                                  fieldName: 'driverlookupData'
                                              },
                                              target: '_blank'
                                          }
                                      },
                                      {
                                          label: 'Internal Number ',
                                          fieldName: 'internalpassData', 
                                          type: 'text',
                                          typeAttributes: {
                                              label: { fieldName: 'internalNumber' },
                                              target: '_blank'
                                          }
                                      } ,  
                                      {
                                          label: 'School Name',
                                          fieldName: 'School_Name__c',
                                          type: 'text'
                                      },
                                      {
                                          label: 'School Code',
                                          fieldName: 'School_Code__c',
                                          type: 'text'
                                      },
                                      {
                                          label: 'Branch',
                                          fieldName: 'Branch__c',
                                          type: 'text'
                                      },
                                      {
                                          label: 'Station',
                                          fieldName: 'Station__c',
                                          type: 'text'
                                      },
                                      {
                                          label: 'Activity Center',
                                          fieldName: 'Activity_Center__c',
                                          type: 'text'
                                      },
                                      {
                                          label: 'Preview',
                                          type: 'button-icon',
                                          fieldName: 'preview',
                                          typeAttributes: {
                                              iconName: 'utility:preview', // Icon for preview
                                              name: 'preview_button',
                                              title: 'Click to Preview',
                                              variant: 'bare',
                                              alternativeText: 'Preview'
                                              
                                          }
                                      },
                                     ]);
    },
                                      
 })