({
    doInit: function (component, event, helper) {
        console.log('doinit called');
        component.set('v.isSchoolActivitiesDepartment', false);
        component.set('v.isSchoolServicesDepartment', false);
        component.set('v.isSpecialEducationDepartment', false);
        component.set('v.isPersonnelManagementDepartment', false);
        component.set('v.isMainSchoolContact', false);
        var action = component.get('c.getDashboardDataCustomerCare');//getDashboardData
        var searchFilterCall= false;
        action.setParams({
            
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                console.log('a.getReturnValue()***'+a.getReturnValue());
                var result = a.getReturnValue();
                /*component.set('v.caseList', a.getReturnValue());
                var newCasesCounter = 0;
                var escalatedCasesCounter = 0;
                var onHoldCasesCounter = 0;
                var invalidCasesCounter = 0;
                var newClosedCasesCounter = 0;
                
                for (var item in result) {
                    if (result[item].Status == 'New') {
                        newCasesCounter++;
                    }
                   else if (result[item].Status == 'Pending with Special Education' || result[item].Status == 'Pending with Department Of School Services'
                           || result[item].Status == 'Pending with Department Of School Activities') {
                        escalatedCasesCounter++;
                    }
                    
                    else if (result[item].Status == 'On Hold') {
                        onHoldCasesCounter++;
                    }else if (result[item].Status == 'Approved') {
                        invalidCasesCounter++;
                    }else if (result[item].Status == 'Closed') {
                        newClosedCasesCounter++;
                    }
                }*/
                
                component.set('v.newCases', result.newCount);
                 console.log("result.newCount***"+result.newCount);
                component.set('v.escalatedCases', result.inprogressCount);
                component.set('v.onHoldCases', result.rejectedCount);
                component.set('v.invalidCases', result.approvedCount);
                component.set('v.closedCases', result.closedCount);
                console.log("result.loggedinUserProfileName***"+result.loggedinUserProfileName);
              
                if(result.loggedinUserProfileName == 'P-MOE - Department Of School Activities'){
                    component.set('v.isSchoolActivitiesDepartment', true);
                }else if(result.loggedinUserProfileName == 'P-MOE - Department Of School Services'){
                    component.set('v.isSchoolServicesDepartment', true);
                }else if(result.loggedinUserProfileName == 'P-MOE - Special Education'){
                    component.set('v.isSpecialEducationDepartment', true);
                }else if(result.loggedinUserProfileName == 'P-MOE - Personnel Management'){
                    component.set('v.isPersonnelManagementDepartment', true);
                }else if(result.loggedinUserProfileName == 'P-Private School Partner User Login'){
                    component.set('v.isMainSchoolContact', true);
                }
                helper.setCommunityLanguage(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },
  createCasePopup : function(component, event, helper) {
        var modalBody;
        var modalFooter;
        $A.createComponents([
            ["c:CaseB2BPopup",{
                "recordId": '',
            }]
        ],
         function(components, status){
              if (status === "SUCCESS") {
                 modalBody = components[0];
                 console.log('&&&&&&&&&&&3');
                 component.find('overlayLib').showCustomModal({
                     header: "Create MOE Request",
                     body: modalBody,
                     footer: modalFooter,
                     showCloseButton: true,
                     cssClass: "my-modal,my-custom-class,my-other-class",
                     closeCallback: function() {
                         //alert('You closed the alert!');
                         $A.get('e.force:refreshView').fire();
                     }
                 });
             }
         });
    },
     closeactionevt : function(component,event){
       
        if(event.getParam("actionname") === 'refresh'){
            $A.get('e.force:refreshView').fire();
        }

     },
     createCasePopupMoE : function(component, event, helper) {
      /*  var modalBody;
        var modalFooter;
        $A.createComponents([
            ["c:CaseB2BPopupMOE",{
                "recordId": '',
            }]
        ],
         function(components, status){
              if (status === "SUCCESS") {
                 modalBody = components[0];
                 component.find('overlayLib').showCustomModal({
                     header: "Customer Care Request",
                     body: modalBody,
                     footer: modalFooter,
                     showCloseButton: true,
                     cssClass: "my-modal,my-custom-class,my-other-class",
                     closeCallback: function() {
                         //alert('You closed the alert!');
                         $A.get('e.force:refreshView').fire();
                     }
                 });
             }
         });*/
         component.set('v.newCase',true);
    },
    handleApplicationEvent : function(component, event) {
        var request = event.getParam("createRequest");
        var history = event.getParam("reqHistory");
        var escalation = event.getParam("escalation");
        var feedback = event.getParam("feedback");
        
        component.set("v.createRequest", request);
        component.set("v.reqHistory", history);
        component.set("v.escalation", escalation);
        component.set("v.feedback", feedback);
    },
    
    //method to show all cases table and hiding the case dashboards
    showAllCasesAction: function (component, event, helper) {
        var status = component.get("v.clAll");
        component.set("v.selectedStatus", status);
        component.set('v.showCaseTable',true);
        component.set('v.clickedDashboard','All'); 
        helper.getCaseData(component, event, helper,'All');
    },
    
    //methods to handle dashboard clicks
    handleNewCasesClick: function (component, event, helper) {
        component.set("v.selectedStatus", '');
        var status = component.get("v.clNew");
        
        component.set("v.selectedStatus", status);
        component.set('v.showCaseTable',true);
        helper.getCaseData(component, event, helper,'New');
    },
    handleApprovalCasesClick: function (component, event, helper) {
        component.set("v.selectedStatus", '');
        var status = component.get("v.clPendingApproval");
        component.set("v.selectedStatus", status);
        component.set('v.showCaseTable',true);
        helper.getCaseData(component, event, helper,'In Progress');
    },
    
    handleOnHoldCasesClick: function (component, event, helper) {
        component.set("v.selectedStatus", '');
        var status = component.get("v.clRejected");
        component.set("v.selectedStatus", status);
        component.set('v.showCaseTable',true);
        helper.getCaseData(component, event, helper,'Rejected');
    },
    handleInvalidCasesClick: function (component, event, helper) {
        component.set("v.selectedStatus", '');
        var status = component.get("v.clApproved");
        component.set("v.selectedStatus", status);
        component.set('v.showCaseTable',true);
        helper.getCaseData(component, event, helper,'Approved');
    },
    handleClosedCasesClick: function (component, event, helper) {
        component.set("v.selectedStatus", '');
        var status = component.get("v.clClosed");
        component.set("v.selectedStatus", status);
        component.set('v.showCaseTable',true);
         helper.getCaseData(component, event, helper,'Closed');
    },
    
    // methods to handle record clicks
    handleCaseClick: function (component, event, helper) {
        var recId = event.target.id;
        /*  var appEvent = $A.get("e.c:MyBusinessDetailPageEvent");
        appEvent.setParams({
            "showIFrame": true,
            "selectedRecordId": recId,
            "selectedRecordType":"case/"
        });
        appEvent.fire();*/
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "case/");
    },
    handleSalesAgreementClick: function (component, event, helper) {
        var recId = event.target.id;
        /*  var appEvent = $A.get("e.c:MyBusinessDetailPageEvent");
        appEvent.setParams({
            "showIFrame": true,
            "selectedRecordId": recId,
            "selectedRecordType":"et-sales-agreement/"
        });
        appEvent.fire*/
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "et-sales-agreement/");
    },
    handleAssignedResourcesClick: function (component, event, helper) {
        
        var recId = event.target.id;
        /*  var appEvent = $A.get("e.c:MyBusinessDetailPageEvent");
        appEvent.setParams({
            "showIFrame": true,
            "selectedRecordId": recId,
            "selectedRecordType":'saline-assigned-resource/'
        });
        appEvent.fire();*/
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "saline-assigned-resource/");
    },
    handleAssignedVehiclesClick: function (component, event, helper) {
        
        var recId = event.target.id;
        /*   var appEvent = $A.get("e.c:MyBusinessDetailPageEvent");
        appEvent.setParams({
            "showIFrame": true,
            "selectedRecordId": recId,
            "selectedRecordType":'saline-assigned-vehicle/'
        });
        appEvent.fire(); */
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "saline-assigned-vehicle/");
    },
    handleStudentClick: function (component, event, helper) {
        
        var recId = event.target.id;
        /*   var appEvent = $A.get("e.c:MyBusinessDetailPageEvent");
        appEvent.setParams({
            "showIFrame": true,
            "selectedRecordId": recId,
            "selectedRecordType":'invoice/'
        });
        appEvent.fire();*/
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "etst-student/");
    },
    
    handleSectionToggle: function (component, event) {
        var openSections = event.getParam('openSections');
    },
    handleSearch: function (component, event) {
        
        var caseWarapperList = component.get('v.customerCaseWrapper');
        
        var statusFilter = component.get('v.statusFilter');
        var caseNumber = component.get('v.caseNumber');
        var salesAgreementFilter=component.get("v.selectedLookUpSalesAgreementRecord.Id");
        var resourceFilter = component.get("v.selectedLookUpResourcesRecord.Id");
        var vehicleFilter = component.get("v.selectedLookUpVehiclesRecord.Id");
        var studentFilter = component.get("v.selectedLookUpStudentRecord.Id");
        
        console.log('statusFilter = ',statusFilter);
        console.log('caseNumber = ',caseNumber);
        console.log('salesAgreementFilter = ',salesAgreementFilter);
        console.log('resourceFilter = ',resourceFilter);
        console.log('vehicleFilter = ',vehicleFilter);
        console.log('studentFilter = ',studentFilter);
        
        var action = component.get('c.getCustomerCareDetailsGovt');
        action.setParams({
            caseNumber : caseNumber,
            Status : statusFilter,
            salesAgId : salesAgreementFilter,
            assignedResId : resourceFilter,
            assignedVehId : vehicleFilter,
            stdId : studentFilter
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                var result = a.getReturnValue();
                
                 //alert('resp = '+JSON.stringify(a.getReturnValue()));
                component.set('v.caseList',result);
            }
        });
        $A.enqueueAction(action);
      
  },
   sortData: function(component, event, helper) {
        var item=event.getSource().get('v.value');
        var currentData=component.get('v.currentData'); 
        //currentData.sort((a, b) => (a.item > b.item) ? 1 : -1)
        currentData.sort((a, b) => (parseInt(a.item) > parseInt(b.item)) ? 1 : -1)
        component.set('v.currentData',currentData); 
    }, 
    searchRequest: function(component, event, helper) {
        var searchKey=component.get('v.searchText');
        console.log('searchKey-->'+searchKey);
        if(searchKey.length>2){
            var deliveryData = component.get('v.caseList');
            var fileredData =  deliveryData.filter(function(item) {
                return (item.CaseNumber.indexOf(searchKey) !== -1);
               // ||(item.Status.toLowerCase().indexOf(searchKey) !== -1);
            });
            
            component.set('v.currentData',fileredData);
            //component.set('v.totalRecords',fileredData.size); 
        }else{
            //component.set('v.start',0);
            //var start=component.get('v.start'); 
            //var corousalSize=component.get('v.corousalSize'); 
            //var deliveryData=component.get('v.deliveryData'); 
            component.set('v.currentData',component.get('v.caseList')); 
            //component.set('v.totalRecords',component.get("v.RecordsCount"));
        }
    
    },
    openConfirmModal: function(component,event,helper){
      
        component.set("v.caseCommentsRequired", false);
        var recId=event.getSource().get('v.value');
        var status=event.getSource().get('v.label');
        component.set("v.status",status);  
        component.set("v.caseId",recId);
        var reject = component.get('v.clReject');
        var reply = component.get('v.clReply');
        console.log('status***'+status);
        if(status === reject || status === reply){
            component.set("v.caseCommentsRequired", true);
        }
         component.set("v.confirmFlag",true);
    },
    closeConfirmModal: function(component,event,helper){
         component.set("v.confirmFlag",false);
    },
    updateCase: function(component, event,helper){
       
        component.set("v.isDisabled", true);
        var recId = component.get("v.caseId");
        var status = component.get("v.status");
        
        var caseComments = component.get("v.comments");
        var approve = component.get('v.clApprove');
        var reject = component.get('v.clReject');
        var close = component.get('v.clComplete');
        console.log('status value'+status);
        console.log('close value'+close);
        console.log('approve value'+approve);
        console.log('reject value'+reject);
        var val = component.find("comment").get("v.value");
        if(status == approve){
             console.log('inside approve');
            helper.approveCaseHelper(component, event,helper,recId);
        }else if(status == reject){
                console.log('inside reject');
            if(val == null || val == '' || val== 'undefined'){
                component.find("comment").showHelpMessageIfInvalid();
                component.set("v.isDisabled", false);
            }else{
                helper.rejectCaseHelper(component, event,helper,recId);
            }
        }else if(status == close){
            console.log('inside close');
           helper.closeCaseHelper(component, event,helper,recId);
        }else{
            console.log('outside if');
        }
    },
    downloadCases :function(component, event, helper){
        var allCases=component.get("v.caseList");
        component.set("v.finalListToAdd",allCases);
        var finalListToDownload=component.get("v.finalListToAdd");
        var csv=helper.convertArrayOfObjectsToCSV(component,finalListToDownload); 
        if(csv==null)
        {
          return ;
        }                         
        var elementLink=document.createElement('a');
        elementLink.href='data:text/csv;charset=utf-8,'+encodeURI(csv);
        elementLink.target='_self';
        elementLink.download='CaseExportData.csv';
        document.body.appendChild(elementLink);
        elementLink.click();
        $A.get('e.force:refreshView').fire();   
    },
    /*
    approveCase: function (component, event,helper) {
        var recId=event.getSource().get('v.value');
        helper.approveCaseHelper(component, event,helper,recId);
    },
    rejectCase: function (component, event,helper) {
        var recId=event.getSource().get('v.value');
        helper.rejectCaseHelper(component, event,helper,recId);
    },
    replyCase: function (component, event,helper) {
        var recId=event.getSource().get('v.value');
       helper.replyCaseHelper(component, event,helper,recId);
    } */ 
    createESECase : function(component, event, helper) {
        
        component.set("v.showEseCase", true);
        component.set("v.buttonDisable", false); 
    },
    closeEseCase :function(component, event, helper) {
        
        component.set("v.showEseCase", false);
    },
    
     handleOnSuccess : function(component, event, helper) {
        component.set("v.showSpinner",false);
        $A.get('e.force:showToast').setParams({
            "title": "Success",
            "message": "Your request has been created successfully!",
            "type": "success",
        }).fire();
       component.set("v.showEseCase", false);
      
    },
    handleOnSubmit : function(component, event, helper) {
      
        component.set("v.buttonDisable", true); 
        component.set("v.showSpinner",true);
        event.preventDefault(); //Prevent default submit
        var eventFields = event.getParam("fields");
        eventFields["Status"] = 'New'; //Add Description field Value
        eventFields["Origin"] = 'CRM Portal'; 
        eventFields["RecordTypeId"]=$A.get("$Label.c.ESE_Issues_RecTypeId");
        
        component.find('caseForm').submit(eventFields);
        console.log(JSON.stringify('caseForm'));
    },
    handleOnError: function (cmp, event, helper) {
       
        component.set("v.buttonDisable", false); 
        var error = event.getParams();      
        var errorMessage = event.getParam("message");
       alert(errorMessage);
        $A.get('e.force:showToast').setParams({
            "title": "Error",
            "message": errorMessage,
            "type": "Error",
        }).fire();
    },
    
})