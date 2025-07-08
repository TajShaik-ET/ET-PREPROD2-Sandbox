({
    doInit: function (component, event, helper) {
        console.log('test cmp');
        helper.getEseUserdepartmentdata(component, event);
        helper.getPrivateuserdata(component, event);
        helper.getEmiratesdata(component, event);
        helper.getEseUserEmail(component, event);
       //  helper.fetchCases(component, event,helper);
        //helper.getCaseData(component, event, helper,'All');
        component.set('v.isSchoolActivitiesDepartment', false);
        component.set('v.isSchoolServicesDepartment', false);
        component.set('v.isSpecialEducationDepartment', false);
        component.set('v.isPersonnelManagementDepartment', false);
        component.set('v.isMainSchoolContact', false);
        component.set('v.isGovDepartment', false);
        component.set('v.isMOEExtraCurricularActivities', false);
        component.set('v.isESEsupportCenter', false);
        helper.setCommunityLanguage(component, event, helper); 
      
        let lang = component.get("v.clLang");
        if(lang=='en'){
            console.log('test'+lang);
            component.set('v.FB_Button', 'Feedback');
            component.set('v.FB_Header', 'Customer Feedback');
            component.set('v.FB_SubmitButton', 'Submit Feedback');
            component.set('v.FB_Close', 'Close');

            
            helper.getPicklistValues(component,event,helper);
        }else{
            helper.getArabicValue(component,event,helper);
            component.set('v.FB_Button', 'تعليق');
            component.set('v.FB_Header', 'ملاحظات العملاء');
            component.set('v.FB_SubmitButton', 'إرسال الملاحظات');
            component.set('v.FB_Close', 'يغلق');
        }
        var action = component.get('c.getDashboardData');
        var searchFilterCall= false;
        
        action.setParams({
            
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                var result = a.getReturnValue(); 
                // component.set('v.newCases', result.newCount);
                // var allRequests=result.newCount;
                
                component.set('v.escalatedCases', result.inprogressCount);
                console.log('result.inprogressCount '+result.inprogressCount);
                //var allRequests=0;
                var allRequests=result.inprogressCount;
                console.log('allRequests '+allRequests);
                component.set('v.onHoldCases', result.rejectedCount);
                console.log('result.rejectedCount '+result.rejectedCount);
                allRequests+=result.rejectedCount;
                component.set('v.closedCases', result.closedCount);
                console.log('result.closedCount'+result.closedCount);
                console.log('result.NewCount'+result.newCount);
                console.log('result.ApprovedCount'+result.approvedCount);
                allRequests+=result.closedCount;
                allRequests+=result.approvedCount;
                allRequests+=result.newCount;
                allRequests+=result.cancelCount;
                
                component.set('v.allRequestsCount', allRequests);
                component.set('v.cancelCases', +result.cancelCount);
                console.log('result.cancelCount'+result.cancelCount);
                var userParentProfileWrap = component.get('v.userParentProfileWrap');
                console.log('userParentProfileWrap '+JSON.stringify(userParentProfileWrap));
                var privateProfileLabel =  $A.get("$Label.c.ET_Private_School_Profile_Name");
                if(userParentProfileWrap.loggedinUserProfileName == privateProfileLabel && userParentProfileWrap.isParent==false)
                {
                    console.log('inside test');
                    component.set('v.isMainSchoolContact', true);
                }
                else if(result.loggedinUserProfileName == 'P-MOE - Department Of School Activities'){
                    component.set('v.isSchoolActivitiesDepartment', true);
                }else if(result.loggedinUserProfileName == 'MOE - Department Of School Services'){
                    component.set('v.isSchoolServicesDepartment', true);
                }else if(result.loggedinUserProfileName == 'P-MOE - Special Education'){
                    component.set('v.isSpecialEducationDepartment', true);
                }else if(result.loggedinUserProfileName == 'MOE - Personnel Management'){
                    component.set('v.isPersonnelManagementDepartment', true);
                    console.log('value '+v.isPersonnelManagementDepartment);
                }
                //Newline added with moe-extra-curricular acttivitys
                    else if(result.loggedinUserProfileName == 'P-MOE - Extra-Curricular Activities'){
                        component.set('v.isMOEExtraCurricularActivities', true);
                    }
                        else if(result.loggedinUserProfileName == 'P-MOE - Inclusive Education Department in ESE'){
                            component.set('v.isInclusiveDepartment', true);
                        }
                            else if(result.loggedinUserProfileName == 'Govt School Partner User Login'){
                                component.set('v.isGovDepartment', true);
                            }
                
                                else if(result.loggedinUserProfileName == 'ESE – Support Center'){
                                    component.set('v.isESEsupportCenter', true);
                                }
                
                // helper.setCommunityLanguage(component, event, helper); 
                
                
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
        
        component.set('v.newCase',true);
    },
    
    createAcitvityCase: function(component,event,helper){
        
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
        component.set('v.status', status);
        component.set('v.showCaseTable',true);
        component.set('v.clickedDashboard','All');
          var user =component.get('v.userEmail');
      
        if (user === 'malha.albreiki@ese.gov.ae') {
           
           // helper.getCaseUser(component,event,helper);
            helper.getCaseDataAbudhabi(component, event, helper,'All');
        }else{
            helper.getCaseData(component, event, helper,'All');
        }
       
        helper.getCancelbtnlogic(component, event, helper);
    },
    
    //methods to handle dashboard clicks
    handleNewCasesClick: function (component, event, helper) {
        component.set("v.status", '');
        //var status = component.get("v.new");
        var status = component.get("v.clNew");
        component.set("v.status", status);
        component.set('v.showCaseTable',true);
        helper.getCaseData(component, event, helper,'New');
    },
    handleApprovalCasesClick: function (component, event, helper) {
        
        
        component.set("v.status", '');
        // var status = component.get("v.inProgress");
        var status = component.get("v.clPendingApproval");
        component.set("v.status", status);
        component.set('v.showCaseTable',true);
        helper.getCaseData(component, event, helper,'In Progress');
    },
    
    handleOnHoldCasesClick: function (component, event, helper) {
        component.set("v.status", '');
        //var status = component.get("v.rejected");
        var status = component.get("v.clRejected");
        component.set("v.status", status);
        component.set('v.showCaseTable',true);
        helper.getCaseData(component, event, helper,'Rejected');
    },
    handleInvalidCasesClick: function (component, event, helper) {
        component.set("v.status", '');
        //var status = component.get("v.approved");
        var status = component.get("v.clApproved");
        component.set("v.status", status);
        component.set('v.showCaseTable',true);
        helper.getCaseData(component, event, helper,'Approved');
    },
    handleClosedCasesClick: function (component, event, helper) {
        component.set("v.status", '');
        //var status = component.get("v.closed");
        var status = component.get("v.clClosed");
        component.set("v.status", status);
        component.set('v.showCaseTable',true);
        helper.getCaseData(component, event, helper,'Closed');
    },
    
    handleCancelCasesClick: function (component, event, helper) {
        component.set("v.status", '');
        //var status = component.get("v.closed");
        var status = component.get("v.clCancel");
        component.set("v.status", status);
        component.set('v.showCaseTable',true);
        helper.getCaseData(component, event, helper,'Cancel');
    },
    
    
    
    
    // methods to handle record clicks
    handleCaseClick: function (component, event, helper) {
        var recId = event.target.id;
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "case/");
    },
    
    handleCaseClickNew: function (component, event, helper) {
      
        let lang = component.get("v.clLang");
        var recId = event.target.id;
        var caseTypeValue = event.currentTarget.dataset.filename;
        console.log('test'+caseTypeValue);
        if(caseTypeValue == 'Requests to provide transportation for trips, activities and Events'){
            component.set("v.EseRequestLine", true); 
            component.set("v.recordsID",recId)
            helper.eseHandlelineCase(component, event,helper,recId);
            helper.getcaseCommentsbyUser(component, event,recId);
        }else{
            if(lang=='en'){                
                var recId = event.target.id;
                component.set("v.recordDetailId", recId);
                component.set("v.objectApiName", "Case");
                component.set("v.ObjectName", "Case");
                component.set("v.recordName", "CaseNumber");
                component.set("v.fieldApiName1", "Subject");
                component.set("v.fieldApiName4", "RecordTypeId");
                component.set("v.fieldApiName2", "Status");
                component.set("v.fieldApiName3", "Priority");
                component.set("v.field1Label", "Subject");
                component.set("v.field4Label", "Type");
                component.set("v.field2Label", "Status");
                component.set("v.field3Label", "Priority");
                component.set("v.showDetailCmp", true);
            }else {
                if(caseTypeValue == 'Global Event Request'){
                    component.set("v.EseRequestLine", true); 
                    helper.eseHandlelineCase(component, event,helper,recId);
                    
                }else{
                    var recId = event.target.id;   
                    component.set("v.recordsID",recId)
                    component.set("v.ArabicCaseDetailView", true);         
                    helper.getRecordType(component,event,helper);
                   helper.getcaseCommentsbyUser(component, event);
                }
              
            }
       
        }
        
    },
    closeRqeuetsLine: function (component, event, helper){
        component.set("v.EseRequestLine", false);
        
    },
    closeArabicCaseDetailsView: function (component, event, helper){
        component.set("v.ArabicCaseDetailView", false);
        
    },
    
    handleSalesAgreementClick: function (component, event, helper) {
        var recId = event.target.id;
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "et-sales-agreement/");
    },
    handleAssignedResourcesClick: function (component, event, helper) {
        
        var recId = event.target.id;
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "saline-assigned-resource/");
    },
    handleAssignedVehiclesClick: function (component, event, helper) {
        
        var recId = event.target.id;
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "saline-assigned-vehicle/");
    },
    handleStudentClick: function (component, event, helper) {
        
        var recId = event.target.id;
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
    handleSortSRCase: function(component,event,helper){
        
        var item=event.target.id;
        
        var currentData=component.get('v.currentData'); 
        var sortDirection = component.get("v.sortDirection");
        if(sortDirection == 'asc')
            component.set("v.sortDirection","desc");
        else
            component.set("v.sortDirection","asc");
        console.log('sortDirection--------'+sortDirection);
        if(item=='caseNumber')
        {
            if(sortDirection == 'asc')
                currentData.sort((a, b) => (a.CaseNumber > b.CaseNumber) ? 1 : -1);
            else
                currentData.sort((a, b) => (a.CaseNumber > b.CaseNumber) ? -1 : 1);
        }
        if(item=='caseType')
        {
            if(sortDirection == 'asc')
                currentData.sort((a, b) => (a.RecordType.Name > b.RecordType.Name) ? 1 : -1);
            else
                currentData.sort((a, b) => (a.RecordType.Name > b.RecordType.Name) ? -1 : 1);
        }
        if(item=='nextAct')
        {
            if(sortDirection == 'asc')
                currentData.sort((a, b) => (a.Status_Category_AR__c > b.Status_Category_AR__c) ? 1 : -1);
            else
                currentData.sort((a, b) => (a.Status_Category_AR__c > b.Status_Category_AR__c) ? -1 : 1);
        }
        if(item=='preAct')
        {
            if(sortDirection == 'asc')
                currentData.sort((a, b) => (a.Sub_Status_AR__c > b.Sub_Status_AR__c) ? 1 : -1);
            else
                currentData.sort((a, b) => (a.Sub_Status_AR__c > b.Sub_Status_AR__c) ? -1 : 1);
        }
        if(item=='caseRes')
        {
            if(sortDirection == 'asc')
                currentData.sort((a, b) => (a.Assigned_Resource__r.Name > b.Assigned_Resource__r.Name) ? 1 : -1);
            else
                currentData.sort((a, b) => (a.Assigned_Resource__r.Name > b.Assigned_Resource__r.Name) ? -1 : 1);
        }
        if(item=='caseVec')
        {
            if(sortDirection == 'asc')
                currentData.sort((a, b) => (a.Assigned_Vehicle__r.Name > b.Assigned_Vehicle__r.Name) ? 1 : -1);
            else
                currentData.sort((a, b) => (a.Assigned_Vehicle__r.Name > b.Assigned_Vehicle__r.Name) ? -1 : 1);
        }
        if(item=='caseStudent')
        {
            if(sortDirection == 'asc')
                currentData.sort((a, b) => (a.ETST_Student__r.Name > b.ETST_Student__r.Name) ? 1 : -1);
            else
                currentData.sort((a, b) => (a.ETST_Student__r.Name > b.ETST_Student__r.Name) ? -1 : 1);
        }
        component.set('v.currentData',currentData); 
    },
    /* sortData: function(component, event, helper) {
        var item=event.getSource().get('v.value');
        var currentData=component.get('v.currentData'); 
        currentData.sort((a, b) => (a.item > b.item) ? 1 : -1)
        component.set('v.currentData',currentData); 
    }, */
    searchRequest: function(component, event, helper) {
        debugger;
        var searchKey=component.get('v.searchText');
        var searchKeyword = component.get("v.searchText");
        var originalList = component.get("v.caseList");
        console.log('data ',originalList);
        console.log('searchKey-->'+searchKeyword);
       var filteredList = originalList.filter(function(caseRecord) {
            // Adjust the fields based on your data structure
           return (
               caseRecord.CaseNumber.indexOf(searchKeyword) !== -1 ||
               (caseRecord.Sub_Status__c && caseRecord.Sub_Status__c.indexOf(searchKeyword) !== -1)||
               (caseRecord.ETST_Student__r && caseRecord.ETST_Student__r.Name && caseRecord.ETST_Student__r.Name.indexOf(searchKeyword) !== -1) ||
               (caseRecord.Status_Category__c && caseRecord.Status_Category__c.indexOf(searchKeyword) !== -1)||
               (caseRecord.RecordType && caseRecord.RecordType.Name && caseRecord.RecordType.Name.indexOf(searchKeyword) !== -1) ||
               (caseRecord.Account && caseRecord.Account.Name && caseRecord.Account.Name.indexOf(searchKeyword) !== -1) ||
               (caseRecord.Account && caseRecord.Account.ETIN_Name_Arabic__c && caseRecord.Account.ETIN_Name_Arabic__c.indexOf(searchKeyword) !== -1)||
               (caseRecord.Status_Category_AR__c  && caseRecord.Status_Category_AR__c.indexOf(searchKeyword) !== -1)||
               (caseRecord.Sub_Status_AR__c  && caseRecord.Sub_Status_AR__c.indexOf(searchKeyword) !== -1) ||
                (caseRecord.Case_Type_AR__c  && caseRecord.Case_Type_AR__c.indexOf(searchKeyword) !== -1)
               
           );
        });

        component.set("v.currentData", filteredList);
       /* if(searchKey.length>2){
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
        */
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
    downloadCasesNew :function(component, event, helper){
        var allCases=component.get("v.currentData");
        console.log('userp '+JSON.stringify(allCases));
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
    openConfirmModal: function(component,event,helper){
        var recId=event.getSource().get('v.value');
        var status=event.getSource().get('v.label');
        console.log('status '+status);
        component.set("v.status",status);  
        component.set("v.caseId",recId);
        component.set("v.caseCommentsRequired", false);
        var reject = component.get('v.clReject');
        var reply = component.get('v.clReply');
        console.log('status***'+status);
        if(status === reject || status === reply){
            component.set("v.caseCommentsRequired", true);
        }
        var currentData=component.get('v.currentData'); 
        currentData.forEach(function (field) {
            if(field.Id==recId ){
                if(field.Sub_Request__c=='Transportation'){
                  component.set('v.subRequestValue',field.Sub_Request__c);
                    if(field.Request_Type_For_Data_Handling__c=='وسائل النقل'){
                      component.set('v.subRequestValueAR',field.Request_Type_For_Data_Handling__c);
                    }
                    
                }
                if(field.Sub_Request_AR__c=='وسائل النقل'){
                    component.set('v.subRequestValueAR',field.Sub_Request_AR__c);
                    if(field.Request_Type_For_Data_Handling_AR__c=='Transportation'){
                         component.set('v.subRequestValue',field.Request_Type_For_Data_Handling_AR__c); 
                    }
                 }
                
                if(field.Sub_Request__c=='Bus Supervisor'){
                    component.set('v.subRequestValue',field.Sub_Request__c);
                    if(field.Request_Type_For_Data_Handling__c=='مشرف حافلة'){
                        component.set('v.subRequestValueAR',field.Request_Type_For_Data_Handling__c);
                    }
                }
                
                   if(field.Sub_Request_AR__c=='مشرف حافلة'){
                    component.set('v.subRequestValueAR',field.Sub_Request_AR__c);
                    if(field.Request_Type_For_Data_Handling_AR__c=='Bus Supervisor'){
                         component.set('v.subRequestValue',field.Request_Type_For_Data_Handling_AR__c); 
                    }  
                    
                   }   
            }
            
        });        
        component.set("v.confirmFlag",true);   
        
    },
    openDeleteModal: function(component,event,helper){
        var recId=event.getSource().get('v.value');
        var status=event.getSource().get('v.label');
        component.set("v.status",status);  
        component.set("v.caseId",recId);
        component.set("v.deleteFlag",true);
    },

    openCancelRquestModal: function(component,event,helper){
        var recId=event.getSource().get('v.value');
        var status=event.getSource().get('v.label');
        component.set("v.status",status);  
        component.set("v.caseId",recId);
        
        component.set("v.cancelFlag",true);
    },
    openFileView : function(component, event, helper) {
        var ticket = event.getSource().get('v.value');
        console.log('fileid'+ticket);
        component.set('v.ticketId',ticket); 
        component.set('v.isViewFileModal',true);  
        
    },
    closeConfirmModal: function(component,event,helper){
        
        component.set("v.confirmFlag",false);
        component.set("v.deleteFlag",false);
        component.set("v.cancelFlag",false);
        component.set("v.handicapFlag",false);
    },
    updateCase: function(component, event,helper){
        component.set("v.isDisabled", true);
        var recId = component.get("v.caseId");
        var status = component.get("v.status");
        var caseComments = component.get("v.comments");
        var approve = component.get('v.clApprove');
        var reject = component.get('v.clReject');
        var close = component.get('v.clComplete');
        var delet = component.get('v.clDelete');
        var cancel = component.get('v.clYes');
        console.log('cancel value'+cancel);
        var val = component.find("comment").get("v.value");
        if(status == approve){
            helper.approveCaseHelper(component, event,helper,recId);
        }else if(status == reject){
            if(val == null || val == '' || val== 'undefined'){
                component.find("comment").showHelpMessageIfInvalid();
                component.set("v.isDisabled", false);
            }else{
                helper.rejectCaseHelper(component, event,helper,recId);
            }
        }else if(status == close){
            helper.closeCaseHelper(component, event,helper,recId);
        }else if(status == delet){
            helper.deleteCaseHelper(component, event,helper,recId);
        }else if(status == cancel){
            helper.cancelCaseHelper(component, event,helper,recId);
        }
        else{
                console.log('outside if');
            }
    },
    openCloseCaseModal : function(component, event, helper) {
        var ticketId = event.getSource().get('v.value');
        component.set('v.ticketId',ticketId);        
        component.set('v.isCancelModal',true);
    },
    openAddCommentsModal : function(component, event, helper) {
        var ticket = event.getSource().get('v.value');
        component.set('v.ticketId',ticket);        
        component.set('v.isAddCommentModal',true);
    },  
    openViewCommentsModal : function(component, event, helper) {
        var ticket = event.getSource().get('v.value');
        component.set('v.ticketId',ticket);        
        component.set('v.isViewCommentsModal',true);
    },
    requestTypeOnChange : function(component, event, helper) {
        var requestTypeselect  = component.get("v.case.Request_Type__c");
    },
    requestTypeOnChangearbic : function(component, event, helper) {
        
        var requestTypeselectarbic  = component.get("v.case.Request_Type_AR__c");
    }, 
    downloadReportpopup : function(component, event, helper) {
        component.set("v.downlodeSelectionPageView", true);
    },    
    closedDownlodeReport: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.downlodeSelectionPageView", false);
   },
    handleDepartmentChange : function(component, event, helper) {
        var selectedDepartMents = component.find("departmentSelect").get("v.value");
        var returnCaseType = helper.getDefaultDepartment(selectedDepartMents);
        component.set("v.caseType", returnCaseType);
        component.set("v.selectedDepartment",selectedDepartMents);
        component.set("v.selectedCaseType",returnCaseType);
    },
    /*
    downloadFinalCSVFilterRecords : function(component, event, helper) {
        debugger;
        var selectedDepartmentValue = component.get("v.selectedDepartment");
        var selectedCaseTypeValue = component.get("v.selectedCaseType");
        var originalList = component.get("v.caseList");
        console.log('Originally Data ',originalList);
        var filteredList = originalList.filter(function(caseRecord) {
            // Adjust the fields based on your data structure
            return (
                (caseRecord.Status_Category__c && caseRecord.Status_Category__c.indexOf(selectedDepartmentValue) !== -1)||
                (caseRecord.RecordType && caseRecord.RecordType.Name && caseRecord.RecordType.Name.indexOf(selectedCaseTypeValue) !== -1)
            );
        });
        component.set("v.currentData", filteredList);
        //console.log('Test Data ',filteredList);
        var getFilterRecByCaseType=component.get("v.currentData");
        var csv=helper.convertOfCaseListToCSV(component,getFilterRecByCaseType);
        if(csv==null)
        {
           
            return ;
        }   
          // Ensure proper UTF-8 encoding with BOM (Byte Order Mark) to handle Arabic characters
    var BOM = '\uFEFF';  // BOM (Byte Order Mark) for UTF-8
    var csvWithBOM = BOM + csv; // Add BOM to the CSV data

        var elementLink=document.createElement('a');
        elementLink.href='data:text/csv;charset=utf-8-sig,'+encodeURIComponent(csvWithBOM); // Use encodeURIComponent to handle special characters
        elementLink.target='_self';
        elementLink.download='ESE_DepartmentCaseExport.csv';
        document.body.appendChild(elementLink);
        elementLink.click();
        $A.get('e.force:refreshView').fire(); 
    },
     //<!-- added by SrihariKoyila on 15-12-23 -->
       closeModel: function(component, event, helper) {
       component.set("v.showFeedBackPopup",false);
   },
   */
        downloadFinalCSVFilterRecords: function (component, event, helper) {
        debugger;
        // Retrieve the selected department and case type
        const selectedDepartment = component.get("v.selectedDepartment");
         console.log('department'+selectedDepartment);
        const selectedCaseType = component.get("v.selectedCaseType");
         console.log('CaseType'+selectedCaseType);
        // Fetch the original list of cases
        const originalList = component.get("v.caseList");
        console.log('Original Data: ', originalList);
            // Validation: If Department is selected, Case Type must also be selected
            if (selectedDepartment && !selectedCaseType) {
                alert('Please select a Case Type when a Department is selected.');
                return;
            }
        // Filter the list based on selected criteria
            const filteredList = originalList.filter(caseRecord => {
                if (!selectedDepartment && selectedCaseType) {
                // When department is null or empty and case type is selected
                return (
                caseRecord.RecordType.Name && caseRecord.RecordType.Name.includes(selectedCaseType)
                );
            } else if (selectedDepartment && selectedCaseType) {
                // When both department and case type are selected
                return (
                    (caseRecord.Status_Category__c && caseRecord.Status_Category__c.includes(selectedDepartment)) ||
                    (caseRecord.RecordType.Name && caseRecord.RecordType.Name.includes(selectedCaseType))
                );
            } else {
                // When neither or only department is selected (not valid in this scenario)
                return false;
            }
        });
        console.log(JSON.stringify(filteredList));
        component.set("v.currentData", filteredList);

        if (!filteredList.length) {
            alert('No records found matching the criteria.');
            return;
        }

        // Convert filtered data to CSV
        const csv = helper.convertCaseListToCSV(component, filteredList);

        if (!csv) {
            alert('No data available for export.');
            return;
        }

        // Add BOM for UTF-8 encoding (to handle special characters)
        const BOM = '\uFEFF';
        const csvWithBOM = BOM + csv;

        // Create a downloadable link
        const downloadLink = document.createElement('a');
        downloadLink.href = 'data:text/csv;charset=utf-8-sig,' + encodeURIComponent(csvWithBOM);
        downloadLink.target = '_self';
        downloadLink.download = 'ESE_DepartmentCaseExport.csv';

        document.body.appendChild(downloadLink);
        downloadLink.click();
        document.body.removeChild(downloadLink);

        // Refresh the view
        $A.get('e.force:refreshView').fire();
    },
    closeModel: function (component, event, helper) {
        component.set("v.showFeedBackPopup", false);
    },
      onchangeFeedback: function(component, event, helper) {
         var selectedValue = event.getSource().get("v.value");
        component.set("v.selectedValue", selectedValue);
        console.log('Selected Value: ' + selectedValue);
         if(selectedValue == 'Yes on time.'){
             component.set('v.showDateField', false);
             component.set('v.FB_caseStatus', 'Closed');
             component.set('v.FB_caseSelectedValue', 'Yes on time.');
         }
         if(selectedValue == 'Yes but different time.'){
             component.set('v.showDateField', true);
             component.set('v.FB_caseStatus', 'In Progress');
             component.set('v.FB_caseSelectedValue', 'Yes but different time.');
         }
         if(selectedValue == 'No.'){
             component.set('v.showDateField', false);
             component.set('v.FB_caseStatus', 'Closed');
             component.set('v.FB_caseSelectedValue', 'No.');
         }
    },
   fb_handleSuccess: function(component, event, helper) {
         component.set('v.isLoading',false);
         component.set("v.showFeedBackPopup",false);
         var toastEvent = $A.get("e.force:showToast");
         toastEvent.setParams({
            title: 'Success!',
            message: 'Feedback Submitted successfully',
            type: 'success'
        });
        toastEvent.fire();
        
       var selectedValue = component.get("v.FB_caseSelectedValue");
       if(selectedValue == 'Yes but different time.'){
           var recId = component.get("v.caseId");
           helper.feedBackCaseHelper(component, event,helper,recId);
       }
   		   component.set('v.showDetailCmp',false);
    },
    
    fb_handleError: function(component, event, helper) {
        var error = event.getParam("error");
        toastEvent.setParams({
            title: 'error!',
            message: error,
            type: 'error'
        });
        toastEvent.fire();
        console.log('Error while saving record:', error);
    },
    
    fb_handleSubmit: function(component, event, helper) {
         component.set('v.isLoading',true);
      
 },
      openFeedBack: function(component,event,helper){
        var recId=event.getSource().get('v.value');
        var status=event.getSource().get('v.label');
        component.set("v.status",status);  
        component.set("v.caseId",recId);
        component.set("v.showFeedBackPopup",true);
    },
    recordLoaded: function(component, event, helper) {
         var recordUi = event.getParam("recordUi");
        //console.log("Record UI loaded: ", recordUi);
        var feedbackValue = recordUi.record.fields.FeedBack_EN__c.value;
        if(feedbackValue == 'Yes but different time.'){
             component.set('v.showDateField', true);
         }
    },
     handleFilterList: function (component, event) {
         component.set("v.isFilter", true);
    },
     closedPopup: function(component, event, helper) {
        component.set("v.isFilter", false);
    },
    clearFilters: function(component, event, helper) {
        let originalList = component.get("v.caseList");
        component.set("v.startDate", null);
        component.set("v.endDate", null);
        component.set("v.filteredCaseList", []);
        component.set("v.recordCount", 0);
        component.set("v.noDataFound", false);
        component.set("v.currentData", originalList);

        console.log('Filters cleared and data reset.');
    },
    applyFilters: function (component, event, helper) {
        // Get the user input dates
        let startDate = component.get("v.startDate"); 
        // Input format: YYYY-MM-DD
        let endDate = component.get("v.endDate");
        component.set("v.isFilter", false);
        // Validation: Ensure both dates are provided
        if (!startDate || !endDate) {
            alert("Both Start Date and End Date are required.");
            return;
        }

        // Validate that Start Date is not later than End Date
        if (new Date(startDate) > new Date(endDate)) {
            alert("Start Date cannot be later than End Date.");
            return;
        }

        // Get the original list of cases
        let originalList = component.get("v.caseList");

        // Filter the list based on the date range
        let filteredList = originalList.filter(caseItem => {
            // Convert CreatedDate to YYYY-MM-DD format
            let caseDate = new Date(caseItem.CreatedDate).toISOString().split('T')[0]; // Extract date part

            // Compare with startDate and endDate
            return caseDate >= startDate && caseDate <= endDate;
        });

        // Set the filtered case list
        component.set("v.filteredCaseList", filteredList);
        component.set("v.currentData", filteredList);

        // Update the count
        let count = filteredList.length;
        component.set("v.recordCount", count);

        // Handle no data found scenario
        if (count === 0) {
            component.set("v.noDataFound", true);
        } else {
            component.set("v.noDataFound", false);
        }
       
        console.log('Filtered Cases: ', filteredList);
    },
    
    //--//
})