({
    doInit : function(component, event, helper) {
        helper.getETDIDetails(component, event, helper);
     
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.todayDate', today);
        component.set('v.pendingClassColumns', [
            {label: 'Sequence', fieldName: 'SEQ_NUM', type: 'text'},
            {label: 'ScheduleID', fieldName: 'CUST_CLASS_SCH_ID', type: 'text'},
            {label: 'Date', fieldName: 'DATE', type: 'text'},
            {label: 'Time', fieldName: 'TIME', type: 'text'},
            {label: 'Instructor', fieldName: 'INSTRUCTOR_NAME', type: 'text'},
            {label: 'Status', fieldName: 'STATUS', type: 'text'}
        ]);
        component.set('v.pendingExamColumns', [
            {label: 'Exam ID', fieldName: 'CUSTOMER_SERVICE_EXAM_ID', type: 'text'},
            {label: 'Exam', fieldName: 'EXAM_CODE', type: 'text'},
            {label: 'Date', fieldName: 'EXAM_DATE', type: 'text'},
            {label: 'Centre', fieldName: 'EXAM_CENTRE', type: 'text'},
            {label: 'Vehicle Type', fieldName: 'VEHICLE_TYPE', type: 'text'}
        ]);
    },
    onChange: function (component, event, helper) {
        let etdiService = component.find('selectETDI').get('v.value');
        component.set('v.selectedService', etdiService);
        if(etdiService == 'Course Change'){
           helper.getOldLicenseType(component, event, helper);
        
        }
        if(etdiService == 'Class Booking'){
            helper.handleClassBooking(component, event, helper);
            helper.getInstructorId(component, event, helper);
        } 
        if(etdiService == 'Exam Booking'){
            helper.getExamType(component, event, helper);
        }
        if(etdiService == 'Cancel Class'){
            helper.getPendingClasses(component, event, helper);
        }
        if(etdiService == 'Cancel Exam'){
            helper.getPendingExams(component, event, helper);
        }
    },
    handleSubmit: function (component, event, helper) {
        helper.handleETDIServiceDetails(component, event, helper);
    },
    handleSubmitInstructor: function (component, event, helper) {
        helper.handleETDIInstructorChange(component, event, helper);
    },
    handleClassBookingSlots: function (component, event, helper) {
        var instructorScheduleTimeSlots = [];
        let selectedDate = component.get("v.selectedInstructorDate");
        let mapValues = component.get("v.instructorScheduleMap");
        const obj = Object.fromEntries(mapValues.map(item => [item.key, item.value]));
        console.log('values-'+obj[selectedDate]);
        if(obj[selectedDate] == '--None--') {
            instructorScheduleTimeSlots.push('');
        } else{
            for(var i = 0; i <= obj[selectedDate].length; i++ ){
                instructorScheduleTimeSlots.push(obj[selectedDate][i])
            }  
        }
        component.set("v.instructorScheduleTimeSlots", instructorScheduleTimeSlots);
    },
    handleSubmitClassBooking: function (component, event, helper) {
        helper.createClassBooking(component, event, helper);
    },
    handleExamBooking: function (component, event, helper) {
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        let examDate = component.get("v.examDate");
        if( !examDate || component.get("v.examDate") < today){
            $A.util.removeClass(component.find("examDateErr"), "slds-hide");
            component.set("v.dateErrorMessage", "Date should be greater than or equal today");
        } else{
            component.set("v.dateErrorMessage", "");
            $A.util.addClass(component.find("examDateErr"), "slds-hide");
            helper.createExamBooking(component, event, helper);
        }
        
    },
    handleOnlineLecture: function (component, event, helper) {
        helper.createOnlineLectureChange(component, event, helper);
    },
    handleSelect : function(component, event, helper) {
        var selectedRows = event.getParam('selectedRows'); 
        var setRows = [];
        var ids = [];
        for ( var i = 0; i < selectedRows.length; i++ ) {
            setRows.push(selectedRows[i]); 
            ids.push(selectedRows[i].CUST_CLASS_SCH_ID)
        }
        component.set("v.selectedPendingClassIds", ids);
        component.set("v.selectedPendingClasses", setRows);
    },
    handleSelectExam : function(component, event, helper) {
        debugger;
        var selectedRows = event.getParam('selectedRows'); 
        var setRows = [];
        var ids = [];
        for ( var i = 0; i < selectedRows.length; i++ ) {
            setRows.push(selectedRows[i]); 
            ids.push(selectedRows[i].CUSTOMER_SERVICE_EXAM_ID)
        }
        component.set("v.selectedPendingExamIds", ids);
        component.set("v.selectedPendingExams", setRows);
    },
    handleClassCancellation: function(component, event, helper) {
        var selectedRows = component.get("v.selectedPendingClasses");
        let reason = component.get("v.cancelClassReason");
        if(!reason) alert('Please enter reason');
        if(selectedRows.length != 0)helper.classCancellationHelper(component, event, helper, selectedRows);
        else alert('Please select the classes');
    },
    handleExamCancellation: function(component, event, helper) {
        var selectedRows = component.get("v.selectedPendingExams");
        let reason = component.get("v.cancelExamReason");
        if(!reason) alert('Please enter reason');
        else if(selectedRows.length != 0)helper.examCancellationHelper(component, event, helper, selectedRows);
        else alert('Please select the exam');
    },
    
})