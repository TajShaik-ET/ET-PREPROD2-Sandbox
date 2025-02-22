({
    doInit: function(component, event, helper) {
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        component.set("v.userId", userId);
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.today', today);
        helper.getSchoolVisitFormDetail(component, event, helper);
        $A.util.toggleClass(component.find('resultsDiv'), 'slds-is-open');
        console.log('current user>>>>>>', component.get("v.currentUser"));
        console.log('current user Account>>>>>>', component.get("v.currentUser.AccountId"));
    },
    
    openModel: function(component, event, helper) {
        console.log('openModel');
        component.set("v.uploadedFiles", []);
        helper.startTime = helper.returnDateTime(component, event, helper);
        component.set("v.openForm", true);
        console.log('openModel recordId: '+component.get("v.recordId"));
        if (component.get("v.recordId") == null || component.get("v.recordId") == ''){
            helper.createDriverChecklistRec(component, event, helper);
            helper.retrieveDriverChecklistsMdt(component, event, helper);
        }
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.openForm", false);
        console.log('closeModel recordId: '+component.get("v.recordId"));
        if(component.get("v.recordId") != null && component.get("v.recordId") != '')
            helper.deleteDriverChecklist(component, event, helper);
    },
    
    goToHome: function(component, event, helper) {
        window.location.reload()
    },
    
    handleLoad: function(component, event, helper) {
        console.log('handle handleLoad');
        component.set("v.showSpinner", false);
    },
    
    handleChange: function (component, event, helper) {
        var selectedDate = component.get("v.today");
        var currentDate = new Date().toISOString().slice(0, 10);
        if(selectedDate === null || selectedDate === ''){
            helper.showToast(component, event, helper, 'Error!', 'error', 'sticky', '5000', 'Please select date'); 
        }else if (selectedDate < currentDate) {
            helper.showToast(component, event, helper, 'Error!', 'error', 'sticky', '5000', 'Please select a future date');
            component.set("v.today", $A.localizationService.formatDate(new Date(), "YYYY-MM-DD"));
        }else{
            component.set("v.today", selectedDate);
        }
    },
    handleChangeInternalNum: function(component, event, helper) {
        var InternalNumRec = component.get("v.internalNumber");
        console.log('In CHnage Inter Number>>>', InternalNumRec);
        
        // Check if InternalNumRec is not null or undefined
        if (InternalNumRec !== null && InternalNumRec !== undefined && InternalNumRec.length > 0) {
             helper.validateInternalNumber(component, event, helper);
            var query = 'SELECT Id, Name,Location_Code__c FROM Vehicle_Master__c WHERE Id = \'' + InternalNumRec + '\'';
            var action = component.get("c.fetchRecords");
            action.setParams({
                "query": query
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var records = response.getReturnValue();
                    var LocCode;
                    if (records && records[0] && records[0].Location_Code__c !== undefined && records[0].Location_Code__c !== null) {
                        LocCode = records[0].Location_Code__c;
                        //-//
                        var query = 'SELECT Id,Name,GL_Region__c, Location_Code__c from ETSALES_Location__c WHERE Location_Code__c = \'' + LocCode + '\'';
                        var action = component.get("c.fetchRecords");
                        action.setParams({
                            "query": query
                        });
                        action.setCallback(this, function(response) {
                            var state = response.getState();
                            if (state === "SUCCESS") {
                                var records = response.getReturnValue();
                                component.set("v.GLLocation", response.getReturnValue());
                                console.log('GL Location Station Branch>>>', component.get("v.GLLocation"));
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
                        //-//
                    } else {
                        console.error('Location_Code__c is not available or has an invalid value');
                    }
                    console.log('LocCode Inter Number>>>', LocCode);
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
        } else {
            console.error('InternalNumRec is null or undefined');
            // Set GLLocation to an empty array or remove records from the list
            var emptyGLLocation = [];
            emptyGLLocation.push({ GL_Region__c: '', Name: '' });
            component.set("v.GLLocation", emptyGLLocation);
        }
        
    },
    handleSubmit: function(component, event, helper) {
        try{
            event.preventDefault();
            component.set("v.showSpinner",true);
            //event.stopPropagation();
            helper.endTime = helper.returnDateTime(component, event, helper);
            var driverChecklistWrpMdt = component.get('v.driverChecklistWrpMdt'); 
            //console.log('getParams',event.getParams());
            var selectedRecord = component.get("v.selectedRecord");
            const fields = event.getParam('fields');
            //console.log('fields: ' , fields);
            //console.log('selectedRecord',selectedRecord);
            if (selectedRecord.length > 0) {
                //console.log('selectedRecord 2');
                for (var key in selectedRecord) {
                    /*if (selectedRecord[key].objectName == 'Account' && selectedRecord[key].lookupFieldType == 'Driver' && selectedRecord[key].value != null) {
                        fields["Driver__c"] = selectedRecord[key].value.Id;
                    }*/
                    if(component.get("v.currentUser.AccountId") != null)
                        fields["Driver__c"] = component.get("v.currentUser.AccountId");
                    if (selectedRecord[key].objectName == 'Account' && selectedRecord[key].lookupFieldType == 'School' && selectedRecord[key].value != null) {
                        //fields["School__c"] = selectedRecord[key].value.Id;
                        fields["School_Name__c"] = selectedRecord[key].value.Name;
                        if (selectedRecord[key].value.ETST_SchoolRefID__c != '' && selectedRecord[key].value.ETST_SchoolRefID__c != null)
                            fields["School_Code__c"] = selectedRecord[key].value.ETST_SchoolRefID__c;
                        else
                            fields["School_Code__c"] = selectedRecord[key].value.School_Code__c;
                    }
                }
            }
            fields["Date__c"] = component.find("dateID").get("v.value");
            fields["End_Time__c"] = helper.endTime;
            fields["Start_time__c"] = helper.startTime;
            //console.log(helper.startTime+' - '+helper.endTime);
            fields["Status__c"] = 'Submitted';
            fields["Final_Result__c"] = component.get("v.finalResult");
            var hasEmptySelection = driverChecklistWrpMdt.some(function(item) {
                if (item.optionType == 'Radio' && (item.response == null || item.response === undefined || item.response == ''))
                    return true;
            });
            //console.log('hasEmptySelection: '+hasEmptySelection);
            var errorMessage = '';
            errorMessage = helper.returnErrorMessage(component, event, helper, fields, 'Internal_Number__c', 'Internal Number', errorMessage);
            errorMessage = helper.returnErrorMessage(component, event, helper, fields, 'KM_Reading__c', 'KM Reading ', errorMessage);
            // errorMessage = helper.returnErrorMessage(component, event, helper, fields, 'Branch__c', 'Branch', errorMessage);
            // errorMessage = helper.returnErrorMessage(component, event, helper, fields, 'Station__c', 'Station', errorMessage);
            // errorMessage = helper.returnErrorMessage(component, event, helper, fields, 'Driver__c', 'Driver', errorMessage);
            errorMessage = helper.returnErrorMessage(component, event, helper, fields, 'School_Name__c', 'School', errorMessage);
            errorMessage = helper.returnErrorMessage(component, event, helper, fields, 'Date__c', 'Date', errorMessage);
            if(errorMessage != ''){
                component.set("v.showSpinner",false);
                helper.showToast(component, event, helper, 'Please fill out the following required fields under the "Driver Details" tab:', 'error', 'sticky', '5000', errorMessage);
            }else if(hasEmptySelection){
                component.set("v.showSpinner",false);
                helper.showToast(component, event, helper, 'Error!', 'error', 'sticky', '5000', 'Please select all items under the Safety of Buses Checklist tab');
            }else{
                // console.log('checkListEditForm');
                component.find('checkListEditForm').submit(fields);
            }
        }
        catch(e){
            console.log('message: '+e.message);
        }
    },
    
    handleError: function(component, event, helper) {
        component.set("v.showSpinner",false);
        var error = event.getParams();
        console.log("Error : " + JSON.stringify(error));
        var errorMessage = event.getParam("message");
        console.log("Error Message : " + errorMessage);
        helper.showToast(component, event, helper, 'Error!', 'error', 'sticky', '5000', errorMessage);
    },
    
    handleSuccess: function(component, event, helper) {
        //calling SigasFileSave method to save signature
        component.find('lWCMethod').SigasFileSave(); 
        component.set("v.showSpinner",false);
        component.set("v.saved",true);
        console.log('handleSuccess');
        helper.createDriverChecklistLines(component, event, helper);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            'title': 'Success',
            'type': 'Success',
            'message': 'Request has been submitted successfully'
        });
        toastEvent.fire();
        //window.location.reload();
        console.log('record updated successfully');
    },
    
    handlenext: function(component, event, helper) {
        var date = component.find("dateID").get("v.value");
        var currentTab = component.get("v.selTabId");
        if (currentTab == 'tab1') {
            component.set("v.selTabId", 'tab2');
        } else if (currentTab == 'tab2') {
            component.set("v.selTabId", 'tab3');
        } 
    },
    
    handleback: function(component, event, helper) {
        var currentTab = component.get("v.selTabId");
        if (currentTab == 'tab2') {
            component.set("v.selTabId", 'tab1');
        } else if (currentTab == 'tab3') {
            component.set("v.selTabId", 'tab2');
        } 
    },
    
    handleRowAction: function(component, event, helper) {
        console.log('button');
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'view_details':
                helper.showRowDetails(component, row, action);
                break;
            case 'preview_button': // Add the 'preview_button' action
                helper.previewHandler(component, row,action); // Call a helper function to handle preview
                break;
        }
    },
    
    /*
    hanldeloadMoreData: function(component, event, helper) {
        var checklistData = component.get("v.DriverCheckList");
        var recordsToLoad = 20; 
        var startIndex = checklistData.length;
        var query = 'Select Id, Name,Date__c,Account__c, Account__r.Name, Internal_Number__c,Activity_Center__c,Assigned_Resources__c, Assigned_Resources__r.Name, School__c, School__r.Name, Branch__c, Station__c From Driver_Daily_Check_List__c Order by CreatedDate DESC LIMIT' + startIndex + ', ' + recordsToLoad;
        var action = component.get("c.loadMoreChecklistData");
        action.setParams({ "query": query });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               alert(state);
                var newRecords = response.getReturnValue();
                 console.log("newrcords: " + JSON.stringify(newRecords));
                if (newRecords.length > 0) {
                     checklistData = checklistData.concat(newRecords);
                     component.set("v.DriverCheckList", checklistData);
                }else{
                    alert("No more data to load");
                }
            }else{
                var errors = response.getError();
                if (errors) {
                    console.log("Errors: " + JSON.stringify(errors));
                }
            }
            
        });
        $A.enqueueAction(action);
    },
    */
    
    closeModalRow: function(component, event, helper) {
        component.set("v.openRow", false);
    },
    
    uploadeFileWithID: function(component, event, helper) {
        component.set("v.isModalOpen", true);
        helper.retriveuploadedFiles(component, event, helper);
    },
    
    closeModal: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    
    handleUploadFinished: function(component, event, helper) {
        var uploadedFiles = event.getParam("files");
        console.log("Files uploaded: " + uploadedFiles.length);
        // console.log("Uploaded Files: ", uploadedFiles);
        helper.showToast(component, event, helper, 'Success!', 'success', 'dismissable', '5000', uploadedFiles.length + ' files uploaded successfully');
        component.set("v.uploadedFiles", uploadedFiles);
    },
    
    handleDeleteFile: function(component, event, helper) {
        var fileIdToDelete = event.getSource().get("v.value");
        var action = component.get("c.deleteFileById");
        action.setParams({
            fileId: fileIdToDelete
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // File deleted successfully, remove it from the uploadedFiles list
                var uploadedFiles = component.get("v.uploadedFiles");
                var updatedFiles = uploadedFiles.filter(function(file) {
                    return file.Id !== fileIdToDelete;
                });
                component.set("v.uploadedFiles", updatedFiles);
                helper.showToast(component, event, helper, 'Success!', 'success', 'dismissable', '5000', 'File deleted successfully');
            } else {
                console.error("Error deleting file: " + JSON.stringify(response.getError()));
                helper.showToast(component, event, helper, 'Error!', 'error', 'sticky', '5000', 'Error deleting file');
            }
        });
        $A.enqueueAction(action);
    },
    
    OpenFile: function(component, event, helper) {
        var rec_id = event.currentTarget.id;
        $A.get('e.lightning:openFiles').fire({ //Lightning Openfiles event  
            recordIds: [rec_id] //file id  
        });
    },
    
    toggleState: function(component, event, helper) {
        //alert(event.getSource().get("v.value")+event.getSource().get("v.name")); 
        var buttonName = event.getSource().get("v.name");
        var seq = event.getSource().get("v.value");
        var srNo = Number(Math.trunc(seq)) + 1;
        //console.log('srNo: '+srNo);
        //console.log('seq: '+seq);
        var driverChecklistWrpMdt = component.get('v.driverChecklistWrpMdt');
        for (var key in driverChecklistWrpMdt) {
            if (driverChecklistWrpMdt[key].seq == seq) {
                driverChecklistWrpMdt[key].iconSelectedAction = event.getSource().get("v.title");
                if (buttonName == 'approevButton')
                    driverChecklistWrpMdt[key].response = 'Selected';
                if (buttonName == 'rejectButton')
                    driverChecklistWrpMdt[key].response = 'Not Selected';
                if (buttonName == 'notApplicableButton')
                    driverChecklistWrpMdt[key].response = 'Not Applicable';
            }
        }
        var isResult = 'Pass';
        var isCommentReq = false;
        
        for (var key in driverChecklistWrpMdt) {
            if (buttonName == 'approevButton' && driverChecklistWrpMdt[key].srNo == '14' && driverChecklistWrpMdt[key].optionType == 'Radio') {
                if(driverChecklistWrpMdt[key].response == 'Selected'){
                    driverChecklistWrpMdt[key].severity.ar = 'High';
                    isResult = 'Pass';
                }
                break;
            }else if (buttonName == 'rejectButton' && driverChecklistWrpMdt[key].srNo == '14' && driverChecklistWrpMdt[key].optionType == 'Radio') {
                if(driverChecklistWrpMdt[key].response == 'Not Selected'){
                    driverChecklistWrpMdt[key].severity.ar = 'High';
                    isResult = 'Fail';
                }
                break;
            }else if (buttonName == 'notApplicableButton' && driverChecklistWrpMdt[key].srNo == '14' && driverChecklistWrpMdt[key].optionType == 'Radio') {
                if(driverChecklistWrpMdt[key].response == 'Not Applicable'){
                    driverChecklistWrpMdt[key].severity.ar = 'Low';
                    isResult = 'Not Applicable';
                }
                break;
            }
        }
        for (var key in driverChecklistWrpMdt) {
            if (driverChecklistWrpMdt[key].srNo == srNo && driverChecklistWrpMdt[key].optionType == 'Radio' && 
                (driverChecklistWrpMdt[key].response == 'Not Selected' || driverChecklistWrpMdt[key].response == null)) {
                isResult = 'Fail';
                isCommentReq = true;
                break;
            }
        }
        for (var key in driverChecklistWrpMdt) {
            if (driverChecklistWrpMdt[key].srNo == srNo && driverChecklistWrpMdt[key].optionType == 'Result') {
                driverChecklistWrpMdt[key].response = isResult;
                if(driverChecklistWrpMdt[key].srNo == '14' && isResult == 'Not Applicable')
                    driverChecklistWrpMdt[key].severity.ar = 'Low';
                else if(driverChecklistWrpMdt[key].srNo == '14' && isResult != 'Not Applicable')
                    driverChecklistWrpMdt[key].severity.ar = 'High'; 
                break;
            }
        }
        for (var key in driverChecklistWrpMdt) {
            if (driverChecklistWrpMdt[key].srNo == srNo && driverChecklistWrpMdt[key].optionType == 'Comment') {
                driverChecklistWrpMdt[key].commentReq = isCommentReq;
                if(driverChecklistWrpMdt[key].srNo == '14' && isResult == 'Not Applicable')
                    driverChecklistWrpMdt[key].severity.ar = 'Low';
                else if(driverChecklistWrpMdt[key].srNo == '14' && isResult != 'Not Applicable')
                    driverChecklistWrpMdt[key].severity.ar = 'High';
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
    
    receiveData: function(component, event, helper) {
        const data = event.getParam("data");
        // console.log(data);
        // console.log('data: ' + JSON.stringify(data));
        var selectedRecord = component.get("v.selectedRecord");
        //  console.log('selectedRecord: ' + JSON.stringify(selectedRecord));
        var index;
        if (selectedRecord.length > 0) {
            if (data.objectName == 'Account' && data.lookupFieldType == 'Driver') {
                index = selectedRecord.findIndex(x => x.lookupFieldType === 'Driver')
            } else if (data.objectName == 'Account' && data.lookupFieldType == 'School') {
                index = selectedRecord.findIndex(x => x.lookupFieldType === 'School')
            } else {
                selectedRecord.push(data);
            }
            // console.log('index: ' + index);
            if (index != -1) {
                selectedRecord[index].value = data.value;
            } else {
                selectedRecord.push(data);
            }
        } else {
            selectedRecord.push(data);
        }
        if (data.objectName == 'Account' && data.lookupFieldType == 'School' && data.value != null) {
            //component.set('v.schoolCode', data.value.ETST_SchoolRefID__c);
            if (data.value.ETST_SchoolRefID__c != '' && data.value.ETST_SchoolRefID__c != null)
                component.set('v.schoolCode', data.value.ETST_SchoolRefID__c);
            else
                component.set('v.schoolCode', data.value.School_Code__c);
        }
        // console.log('selectedRecord Updated: ' + JSON.stringify(selectedRecord));
        component.set('v.selectedRecord', selectedRecord);
    },
    
    unrender: function () {
        // console.log('unrender');
        //this.superUnrender();
        // do custom unrendering here
    },
    
    delFilesAction:function(component,event,helper){
        var documentId = event.currentTarget.id;        
        helper.delUploadedfiles(component,documentId);  
    },
    
})