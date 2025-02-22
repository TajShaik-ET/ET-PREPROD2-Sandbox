({
    getETDIDetails : function(component, event, helper) {
        
        var etdiPostServices = [];
        etdiPostServices.push({key: '--None--', value: '--None--'});
        etdiPostServices.push({key: 'Course Change', value: 'Course Change'});
        etdiPostServices.push({key: 'Instructor Change', value: 'Instructor Change'}); 
        etdiPostServices.push({key: 'Class Booking', value: 'Class Booking'});
        etdiPostServices.push({key: 'Exam Booking', value: 'Exam Booking'});
        etdiPostServices.push({key: 'Change to Online Lecture', value: 'Change to Online Lecture'});
        etdiPostServices.push({key: 'Cancel Class', value: 'Cancel Class'});
        etdiPostServices.push({key: 'Cancel Exam', value: 'Cancel Exam'});
        component.set("v.etdiPostServices",etdiPostServices); 
        
        var newCourse = [];
        newCourse.push({key: '--None--', value: '--None--'});
        newCourse.push({key: 'LAV', value: 'LAV'});
        newCourse.push({key: 'LMV', value: 'LMV'});
        newCourse.push({key: 'HVB', value: 'HVB'});
        newCourse.push({key: 'MOT', value: 'MOT'});
        newCourse.push({key: 'HVT', value: 'HVT'});
        newCourse.push({key: 'HFL', value: 'HFL'});
        newCourse.push({key: 'LFL', value: 'LFL'});
        newCourse.push({key: 'SHO', value: 'SHO'});
        newCourse.push({key: 'BLD', value: 'BLD'});
        component.set("v.newCourse",newCourse); 
        
        /*  var instructorScheduleMap = [];
        instructorScheduleMap.push({key: '28 Apr 2021', value: ['09:30','10:30']});
        instructorScheduleMap.push({key: '29 Apr 2021', value: ['09:30','11:30']});
        instructorScheduleMap.push({key: '30 Apr 2021', value: ['09:30','12:30']});
        instructorScheduleMap.push({key: '31 Apr 2021', value: ['09:30','13:30']});
        component.set("v.instructorScheduleMap",instructorScheduleMap); */
    },
    
    getOldLicenseType: function(component,event,helper){
        let caseId = component.get('v.recordId');
        var action = component.get('c.getOldLicenseType');
        action.setParams({
            caseId:caseId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var license = response.getReturnValue();
            if (license!= "") {
                let oldLicenseType =  response.getReturnValue();
                component.set('v.oldLicenseType', oldLicenseType);
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type" : "error",
                "message": "Unable to fetch Current License from ETDI Details.Please get ETDI Details first."
            });
                toastEvent.fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
        });
        
        $A.enqueueAction(action);
    },
    
    handleETDIServiceDetails: function(component,event,helper){
        debugger;
        
        if($A.util.isEmpty(component.get("v.oldLicenseType"))){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type" : "error",
                "message": "Unable to fetch Current License from ETDI Details.Please get ETDI Details first."
            });
            toastEvent.fire(); 
            return;
        }
        if($A.util.isEmpty(component.get("v.selectedCourseValue"))||(component.get("v.selectedCourseValue")=='--None--')){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type" : "error",
                "message": "Please choose the new License Type from dropdown."
            });
            toastEvent.fire(); 
            return;
        }
        
        if(component.get("v.selectedCourseValue")==component.get("v.oldLicenseType")){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type" : "error",
                "message": "Please choose different License Type."
            });
            toastEvent.fire(); 
            return;
        }
        
        let caseId = component.get('v.recordId');
        let OldLicenceType = component.get('v.oldLicenseType');
        let NewLicenceType = component.get('v.selectedCourseValue');
        var action = component.get('c.changecourse');
        action.setParams({
            CaseId:caseId,
            OldLicenceType:OldLicenceType,
            NewLicenceType:NewLicenceType
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type": "Success",
                    "message": "The ETDI details has been updated successfully."
                });
                toastEvent.fire();
                // Close the action panel
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                         var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type" : "error",
                "message": errors[0].message
            });
            toastEvent.fire(); 
                         var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action);
        
    },
    
    handleETDIInstructorChange: function(component,event,helper){
        debugger;
        let caseId = component.get('v.recordId');
        let changeInstructorReason = component.get('v.changeInstructorReason');
        var action = component.get('c.changeInstructor');
        action.setParams({
            CaseId:caseId,
            InstructorChangeReason:changeInstructorReason,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type": "Success",
                    "message": "The course details has been updated successfully."
                });
                toastEvent.fire();
                // Close the action panel
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                         var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type" : "error",
                "message": errors[0].message
            });
            toastEvent.fire(); 
                         var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action);
        
    },
    handleClassBooking: function(component,event,helper){
        // debugger;
        let caseId = component.get('v.recordId');
        var action = component.get('c.getClassScheduleOfInstructor');
        //var action = component.get('c.getdatetime');
        action.setParams({
            CaseId:caseId,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var arrayMapKeys = [];
                arrayMapKeys.push({key: '--None--', value: '--None--'});
                for(var key in result){
                    arrayMapKeys.push({key: key, value: result[key]});
                }
                component.set("v.instructorScheduleMap", arrayMapKeys);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": errors[0].message
                });
                toastEvent.fire(); 
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
        });
        
        $A.enqueueAction(action);
    },
    
    getInstructorId: function(component,event,helper){
        debugger;
        let caseId = component.get('v.recordId');
        var action = component.get('c.getInstructorID');
        action.setParams({
            CaseId:caseId,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.instructorId", result);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": errors[0].message
                });
                toastEvent.fire(); 
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
        });
        
        $A.enqueueAction(action);
        
    },
    
    getExamType: function(component,event,helper){
        //debugger;
        let caseId = component.get('v.recordId');
        var action = component.get('c.getExamType');
        action.setParams({
            CaseId:caseId,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                let examValuesMap = [];
                if(result){
                    examValuesMap.push({key: '--None--', value: '--None--'});
                    for(let key in result){
                        examValuesMap.push({key:key, value:result[key]});
                    }
                }
                component.set("v.examValuesMap", examValuesMap);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": errors[0].message
                });
                toastEvent.fire(); 
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
        });
        
        $A.enqueueAction(action);
        
    },
    
    createClassBooking: function(component,event,helper){
        debugger;
        let caseId = component.get('v.recordId');
        let bookingDate = component.get('v.selectedInstructorDate');
        let bookingTime = component.get('v.selectedInstructorTime');
        let InstructorId = component.get('v.instructorId');
        var action = component.get('c.bookClass');
        action.setParams({
            CaseId:caseId,
            bookingDate:bookingDate,
            bookingTime:bookingTime,
            InstructorId:InstructorId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type" : "Success",
                    "message":result
                });
                toastEvent.fire(); 
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": errors[0].message
                });
                toastEvent.fire(); 
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
        });
        
        $A.enqueueAction(action);
        
    },
    createExamBooking: function(component,event,helper){
        debugger;
        let caseId = component.get('v.recordId');
        let examType = component.get('v.selectedExamID');
        let bookingDate = $A.localizationService.formatDate(component.get("v.examDate"), "DD-MM-YYYY");
        let examName = component.get('v.selectedExamName');
        let bkdate = bookingDate.toString();
        var action = component.get('c.bookExam');
        action.setParams({
            CaseId:caseId,
            examType:examType,
            bookingDate:bkdate,
            examName:examName
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type" : "Success",
                    "message":"Exam Request created succesfully"
                });
                toastEvent.fire(); 
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": errors[0].message
                });
                toastEvent.fire(); 
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
        });
        
        $A.enqueueAction(action);
        
    },
    
    createOnlineLectureChange: function(component,event,helper){
        debugger;
        let caseId = component.get('v.recordId');
        let Reason = component.get('v.changeOnlineReason');
        var action = component.get('c.changeToOnlineLecture');
        action.setParams({
            CaseId:caseId,
            Reason:Reason,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type" : "Success",
                    "message":"Change request created succesfully"
                });
                toastEvent.fire(); 
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": errors[0].message
                });
                toastEvent.fire(); 
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
        });
        
        $A.enqueueAction(action);
        
    },
    getPendingClasses: function(component,event,helper){
        debugger;
        let caseId = component.get('v.recordId');
        var action = component.get('c.getPendingClasses');
        action.setParams({
            CaseId:caseId,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var obj = JSON.parse(result);
                component.set('v.pendingClassObj', obj.pendingClasses);
                component.set('v.pendingClassesSerializeString', result);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": errors[0].message
                });
                toastEvent.fire(); 
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
        });
        
        $A.enqueueAction(action);
        
    },
    classCancellationHelper: function(component,event,helper,selectedRows){
        debugger;
        let caseId = component.get('v.recordId');
        let selectedClassSheduleId = component.get('v.selectedPendingClassIds');
        //let allPendingClass = JSON.stringify(component.get('v.pendingClassObj'));
        let allPendingClass = component.get('v.pendingClassesSerializeString');;
        let Reason = component.get('v.cancelClassReason');
        var action = component.get('c.getSelectedCancelClass');
        action.setParams({
            CaseId:caseId,
            selectedClassSheduleId:selectedClassSheduleId,
            allPendingClass:allPendingClass,
            Reason:Reason
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type" : "Success",
                    "message":"Cancel request created succesfully"
                });
                toastEvent.fire(); 
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": errors[0].message
                });
                toastEvent.fire(); 
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
        });
        
        $A.enqueueAction(action);
        
    },
    getPendingExams: function(component,event,helper){
        debugger;
        let caseId = component.get('v.recordId');
        var action = component.get('c.getPendingExams');
        action.setParams({
            CaseId:caseId,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var obj = JSON.parse(result);
                component.set('v.pendingExamsObj', obj.pendingExams);
                component.set('v.pendingExamsSerializeString', result);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": errors[0].message
                });
                toastEvent.fire(); 
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
        });
        
        $A.enqueueAction(action);
        
    },
    examCancellationHelper: function(component,event,helper,selectedRows){
        debugger;
        let caseId = component.get('v.recordId');
        let selectedServiceExamIDs = component.get('v.selectedPendingExamIds');
        let allPendingExam = component.get('v.pendingExamsSerializeString');;
        let Reason = component.get('v.cancelExamReason');
        var action = component.get('c.getSelectedCancelExam');
        action.setParams({
            CaseId:caseId,
            selectedServiceExamIDs:selectedServiceExamIDs,
            allPendingExam:allPendingExam,
            Reason:Reason
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type" : "Success",
                    "message":"Cancel request created succesfully"
                });
                toastEvent.fire(); 
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": errors[0].message
                });
                toastEvent.fire(); 
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
        });
        
        $A.enqueueAction(action);
        
    },
})