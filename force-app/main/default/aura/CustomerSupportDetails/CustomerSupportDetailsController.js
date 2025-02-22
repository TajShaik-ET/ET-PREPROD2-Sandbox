({
    doInit: function (component, event, helper) {
       // debugger;
        helper.getProfileName(component, event);
        var action = component.get('c.getDashboardData');
        var searchFilterCall= false;
        action.setParams({
            
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                var result = a.getReturnValue();
                console.log('type list ='+JSON.stringify(result.caseType));
                console.log('accountName list ='+JSON.stringify(result.accountName));
                //setting the case type filter values
                var caseTypeLists = [];
                for (var i in result.caseType){
                    console.log(i);
                    caseTypeLists.push({
                        label: result.caseType[i],
                        value: i
                    });
                }
                component.set('v.caseType', caseTypeLists);
                
                var accountList = [];
                for (var i in result.accountName){
                    console.log(i);
                    accountList.push({
                        label: result.accountName[i],
                        value: i
                    });
                }
                component.set('v.AccountNameList', accountList);
                
                var caseStatusList = [];
                for (var i in result.caseStatus){
                    console.log(i);
                    caseStatusList.push({
                        label: result.caseStatus[i],
                        value: i
                    });
                }
                component.set('v.caseStatus', caseStatusList);
                component.set('v.accountType', result.accountType);
               //  component.set('v.userParentProfileWrap', result.accountType);
                component.set('v.newCases', result.newCount);
                component.set('v.escalatedCases', result.inprogressCount);
                component.set('v.onHoldCases', result.rejectedCount);
                component.set('v.invalidCases', result.approvedCount);
                component.set('v.closedCases', result.closedCount);
                 console.log('record type list '+JSON.stringify(result.caseType));  
                var opts = [];
                for (var i in result.accountName){
                    console.log(i);
                    opts.push({
                        label: result.accountName[i],
                        value: i
                    });
                }
                component.set('v.AccountNameList', opts);
                console.log('accountName'+JSON.stringify(component.get('v.AccountNameList')));
                helper.setCommunityLanguage(component, event, helper); 
            }
        });
        $A.enqueueAction(action);
        
      
    },
  createCasePopup : function(component, event, helper) {
        var modalBody;
        var modalFooter;
        $A.createComponents([
            ["c:BusinessCustomerCarePage",{
                "recordId": '',
            }]
        ],
         function(components, status){
              if (status === "SUCCESS") {
                 modalBody = components[0];
                 console.log('&&&&&&&&&&&3');
                 component.find('overlayLib').showCustomModal({
                     header: "Create Case",
                     body: modalBody,
                     footer: modalFooter,
                     showCloseButton: true,
                     cssClass: "my-modal,my-custom-class,my-other-class",
                     closeCallback: function() {
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
        component.set('v.showCaseTable',true);
        component.set('v.showFilter',true);
        component.set("v.status", 'All');
        component.set('v.clickedDashboard','All'); 
        helper.getCaseData(component, event, helper,'All');
    },
    handleTypeFilter : function (component, event, helper) {
        console.log('inside handle type filter');
        helper.getFilteredCaseData(component, event, helper,'All');
        
    },
    handleAccountNameFilter: function (component, event, helper) {
    },
    //methods to handle dashboard clicks
    handleNewCasesClick: function (component, event, helper) {
           var status = component.get("v.clNew");
        component.set("v.status", status);
        component.set("v.statusAR", 'جديد');
        
         component.set('v.showCaseTable',true);
        helper.getCaseData(component, event, helper,'New');
    },
    handleApprovalCasesClick: function (component, event, helper) {
        component.set("v.status", '');
        var status = component.get("v.clInProgress");
        component.set("v.status", status);
        component.set("v.statusAR", 'في تقدم');
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
        component.set("v.statusAR", 'مغلق');
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
    handleCaseClickNew: function (component, event, helper) {
        var recId = event.target.id;
        component.set("v.recordDetailId", recId);
        component.set("v.objectApiName", "Case");
        component.set("v.ObjectName", "Case");
        component.set("v.recordName", "CaseNumber");
        
        component.set("v.fieldApiName1", "Subject");
        component.set("v.fieldApiName4", "Type");
        component.set("v.fieldApiName2", "Status");
        component.set("v.fieldApiName3", "Priority");
        
        component.set("v.field1Label", "Subject");
        component.set("v.field4Label", "Type");
        component.set("v.field2Label", "Status");
        component.set("v.field3Label", "Priority");
        component.set("v.showDetailCmp", true);
        
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
    handleAssignedResourcesClickNew: function (component, event, helper) {
        var recId = event.target.id;
        component.set("v.recordDetailId", recId);
        component.set("v.objectApiName", "SALine_Assigned_Resource__c");
        component.set("v.ObjectName", "Assigned Resource");
        component.set("v.recordName", "Name");
        
        component.set("v.fieldApiName1", "Employee_ID__c");
        component.set("v.fieldApiName2", "Name"); 
        component.set("v.fieldApiName3", "Assign_Start_Date__c");
        component.set("v.fieldApiName4", "Assign_End_Date__c");
        
        component.set("v.field1Label", "Employee ID");
        component.set("v.field2Label", "Employee Name");
        component.set("v.field3Label", "Assign Start Date");
        component.set("v.field4Label", "Assign End Date");
        component.set("v.showDetailCmp", true);
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
    handleAssignedVehiclesClickNew: function (component, event, helper) {
        var recId = event.target.id;
        component.set("v.recordDetailId", recId);
        component.set("v.objectApiName", "SALine_Assigned_Vehicle__c");
        component.set("v.ObjectName", "Assigned Vehicle");
        component.set("v.recordName", "Name");
        
        component.set("v.fieldApiName1", "Name");
        component.set("v.fieldApiName2", "Vehicle_Number__c"); 
        component.set("v.fieldApiName3", "Assign_Start_Date__c");
        component.set("v.fieldApiName4", "Assign_End_Date__c");
        
        component.set("v.field1Label", "Associated Vehicle Name");
        component.set("v.field2Label", "Vehicle Number");
        component.set("v.field3Label", "Assign Start Date");
        component.set("v.field4Label", "Assign End Date");
        component.set("v.showDetailCmp", true);
    },
    handleAccountNameClick: function (component, event, helper){
        var recId = event.target.id;
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "etst-student/");
    },
    handleAccountNameClickNew: function (component, event, helper){
       var recId = event.target.id;
        component.set("v.recordDetailId", recId);
        component.set("v.objectApiName", "Account");
        component.set("v.ObjectName", "Account");
        component.set("v.recordName", "Name");
        
        component.set("v.fieldApiName1", "Name");
        component.set("v.fieldApiName2", "Website"); 
        component.set("v.fieldApiName3", "Phone");
        component.set("v.fieldApiName4", "ET_Emirates_Id__c");
        
        component.set("v.field1Label", "Name");
        component.set("v.field2Label", "Website");
        component.set("v.field3Label", "Phone");
        component.set("v.field4Label", "Emirates Id");
        component.set("v.showDetailCmp", true);
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
        var sortDirection = component.get("v.sortDirection");
        var selecteCol = event.target.id;
       // alert('selecteCol '+selecteCol);
        if(sortDirection == 'desc'){
            sortDirection='asc';
        }else{
            sortDirection='desc';
        }
        component.set('v.sortDirection',sortDirection);
        var rows = component.get('v.currentData');
       	var temp = rows[0];
        for(var a = 0; a < rows.length; a++)
        {
            for(var b = a + 1; b < rows.length; b++)
            {
                if(rows[a].selecteCol > rows[b].selecteCol)
                {
                    temp = rows[a];
                    rows[a] = rows[b];
                    rows[b] = temp;
                }
            }
        }
        
        console.log('rows'+JSON.stringify(rows));
        console.log('sortDirection'+sortDirection);
        if(sortDirection == 'desc'){
            rows.reverse();
        }
        component.set('v.currentData',rows);
        /*
        var item=event.getSource().get('v.value');
        console.log('item'+item);
        var currentData=component.get('v.currentData'); 
        
        var sortDirection = component.get("v.sortDirection");
        if(sortDirection == 'asc')
            component.set("v.sortDirection","desc");
        else
            component.set("v.sortDirection","asc");
        console.log('sortDirection--------'+sortDirection);
        
        if(sortDirection == 'asc')
            currentData.sort((a, b) => (a.Account.Name > b.Account.Name) ? 1 : -1)
            else
                currentData.sort((a, b) => (a.Account.Name > b.Account.Name) ? -1 : 1)
                component.set('v.currentData',currentData); 
                */
    }, 
    handleSort : function(component,event,helper){
        //alert('inside sort');
        var item=event.target.id;
        console.log('item'+item);
        var currentData=component.get('v.currentData'); 
       
   		 
		var sortDirection = component.get("v.sortDirection");
		if(sortDirection == 'asc')
			component.set("v.sortDirection","desc");
		else
			component.set("v.sortDirection","asc");
		console.log('sortDirection--------'+sortDirection);
         //var currentData=component.get('v.SOAlist');
         if(item=='CreatedDate')
         {
         if(sortDirection == 'asc')
             currentData.sort((a, b) => (a.CreatedDate > b.CreatedDate) ? 1 : -1)
         else
             currentData.sort((a, b) => (a.CreatedDate > b.CreatedDate) ? -1 : 1)
         }
         if(item=='Status')
         {
         if(sortDirection == 'asc')
             currentData.sort((a, b) => (a.Status > b.Status) ? 1 : -1)
         else
             currentData.sort((a, b) => (a.Status > b.Status) ? -1 : 1)
         }
         if(item=='RecordType.Name')
         {
         if(sortDirection == 'asc')
             currentData.sort((a, b) => (a.RecordType.Name > b.RecordType.Name) ? 1 : -1)
         else
             currentData.sort((a, b) => (a.RecordType.Name > b.RecordType.Name) ? -1 : 1)
         }
         if(item=='Assigned_Resource__r.Name')
         {
         if(sortDirection == 'asc')
             currentData.sort((a, b) => (a.Assigned_Resource__r.Name > b.Assigned_Resource__r.Name) ? 1 : -1)
         else
             currentData.sort((a, b) => (a.Assigned_Resource__r.Name > b.Assigned_Resource__r.Name) ? -1 : 1)
         }
         if(item=='Assigned_Vehicle__r.Name')
         {
         if(sortDirection == 'asc')
             currentData.sort((a, b) => (a.Assigned_Vehicle__r.Name > b.Assigned_Vehicle__r.Name) ? 1 : -1)
         else
             currentData.sort((a, b) => (a.Assigned_Vehicle__r.Name > b.Assigned_Vehicle__r.Name) ? -1 : 1)
         }
        if(item=='Account.Name')
         {
         if(sortDirection == 'asc')
             currentData.sort((a, b) => (a.Account.Name > b.Account.Name) ? 1 : -1)
         else
             currentData.sort((a, b) => (a.Account.Name > b.Account.Name) ? -1 : 1)
         }
        if(item=='CaseNumber')
         {
         if(sortDirection == 'asc')
             currentData.sort((a, b) => (a.CaseNumber > b.CaseNumber) ? 1 : -1)
         else
             currentData.sort((a, b) => (a.CaseNumber > b.CaseNumber) ? -1 : 1)
         }
        if(item=='Owner.Name')
        {
            if(sortDirection == 'asc')
                currentData.sort((a, b) => (a.Owner.Name > b.Owner.Name) ? 1 : -1)
                else
                    currentData.sort((a, b) => (a.Owner.Name > b.Owner.Name) ? -1 : 1)
       }
                 //currentData.sort(this.sortBy('Sales_Order__c'))
		component.set('v.currentData',currentData); 
    },
    searchRequest: function(component, event, helper) {
        var searchKey=component.get('v.searchText');
        console.log('searchKey-->'+searchKey);
        if(searchKey.length>2){
            var deliveryData = component.get('v.caseList');
            var fileredData =  deliveryData.filter(function(item) {
                return (item.CaseNumber.indexOf(searchKey) !== -1);
            });
            
            component.set('v.currentData',fileredData);
        }else{
            component.set('v.currentData',component.get('v.caseList')); 
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
    downloadCasesNew :function(component, event, helper){ 
        var type='downloadCases'; 
        var allResources=component.get("v.currentData");
        var csv=helper.convertArrayOfObjectsToCSV(component,allResources,type); 
        if(csv==null)
        {  return ;
        }                         
        var elementLink=document.createElement('a');
        elementLink.href='data:text/csv;charset=utf-8,'+encodeURI(csv);
        elementLink.target='_self';
        elementLink.download='caseExportData.csv';
        document.body.appendChild(elementLink);
        elementLink.click();
        $A.get('e.force:refreshView').fire();    
    }
})