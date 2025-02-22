({
    getCaseData : function(component, event, helper,status) {
        var action = component.get('c.getCaseDetails');
        action.setParams({
            "status" : 'In Progress'
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            
            if (state == 'SUCCESS') {
                var respose=a.getReturnValue();
                console.log(JSON.stringify(respose)+'respose');
                if(respose!=undefined && respose!=null && respose!=''){
                    component.set('v.currentApprover',respose[0].Status_Category__c); 
                    component.set('v.currentrecType',respose[0].RecordType.DeveloperName); 
                    
                    for(var i = 0; i < respose.length; i++){
                        var row = respose[i];
                        row.navUrl='/'+row.Id;
                        //if(row.ETST_Student__c) row.studentName = row.ETST_Student__r.Name;
                        //if(row.ETST_Student__c) row.studentId = row.ETST_Student__r.ETST_Student_Id__c;
                        //if(row.ETST_Student__c) row.studentPhone = row.ETST_Student__r.ETST_Phone__c;
                        //if(row.ETST_Student__c) row.schoolName = row.ETST_Student__r.ETST_School_Name__r.Name;           
                        //row.studentUrl = '/'+row.ETST_Student__c;
                    }
                    component.set('v.caseList', respose);
                    component.set('v.currentData', respose); 
                    
                    //console.log('a.getReturnValue() '+JSON.stringify(component.get('v.currentData'))); 
                }
            }
            component.set('v.loaded',true);
        });
        $A.enqueueAction(action);
    },
    doInit : function(component, event, helper) {
        component.set('v.loaded',false);
        var utility = component.find("ETST_UtilityMethods");
        var pageNo = component.get("v.pageNo");
        
        var backendMethod = "getTransportRequests";
        var params = {
            "pageNo": pageNo    
        };
        
        var promise = utility.executeServerCall(component, backendMethod, params);
        promise.then (
            $A.getCallback(function(response) {
                var requests = response.requests;
                console.log('requests***'+requests);
                for(var i = 0; i < requests.length; i++){
                    var row = requests[i];
                    row.navUrl='/'+row.Id;
                    if(row.ETST_Student__c) row.studentName = row.ETST_Student__r.Name;
                    if(row.ETST_Student__c) row.studentId = row.ETST_Student__r.ETST_Student_Id__c;
                    if(row.ETST_Student__c) row.studentPhone = row.ETST_Student__r.ETST_Phone__c;
                    if(row.ETST_Student__c) row.schoolName = row.ETST_Student__r.ETST_School_Name__r.Name;           
                    row.studentUrl = '/'+row.ETST_Student__c;
                }
                component.set("v.data", requests); 
                component.set("v.currentData",component.get("v.data"));
                component.set("v.schoolsList", response.schoolsList);
                component.set("v.payeeList", response.payeeList);
                component.set("v.statusList", response.statusList);
                if($A.get("$Label.c.ETST_Coordinator_ProfileId") == response.loggedinUserProfileId){
                    component.set("v.isCoordinatorLoggedIn", true);
                }
                
                if(requests.length==response.totalRecords){
                    component.set('v.loadMoreStatus', 'No more data to load');
                    component.set("v.enableInfiniteLoading",false);
                }else{
                    component.set('v.loadMoreStatus', 'Scroll to load more data....');
                    component.set("v.enableInfiniteLoading",true);
                }
                component.set('v.loaded',true);
            }),
            
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                utility.showToast("Single View", errorToShow, "error", "sticky");
                // component.set("v.serverActionFinished", true);  
            })
        )	
    },
    getData : function(component, event, helper) {
        component.set('v.loaded',false);
        var utility = component.find("ETST_UtilityMethods");
        var pageNo = component.get("v.pageNo");
        
        var backendMethod = "getSelectedTransportRequests";
        var params = {
            "pageNo": pageNo,            
            "school":component.get("v.selectedSchool"), 
            "payee":component.get("v.selectedPayee"),
            "status":component.get("v.selectedStatus")
        };
        
        var promise = utility.executeServerCall(component, backendMethod, params);
        promise.then (
            $A.getCallback(function(response) {
                var requests = response;
                //alert(JSON.stringify(opps[0]));
                for (var i = 0; i < requests.length; i++) {
                    var row = requests[i];
                    row.navUrl='/'+row.Id;
                    if(row.ETST_Student__c) row.studentName = row.ETST_Student__r.Name;
                    if(row.ETST_Student__c) row.studentId = row.ETST_Student__r.ETST_Student_Id__c;
                    
                    if(row.ETST_Student__c) row.studentName = row.ETST_Student__r.Name;
                    if(row.ETST_Student__c) row.schoolName = row.ETST_Student__r.ETST_School_Name__r.Name;           
                    row.studentUrl = '/'+row.ETST_Student__c;
                }
                component.set("v.data", requests); 
                component.set("v.currentData",component.get("v.data"));
                component.set('v.loaded',true);
            }),
            
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                utility.showToast("Single View", errorToShow, "error", "sticky");
                component.set("v.serverActionFinished", true);  
            })
        )	
    },
    sortData : function(component,fieldName,sortDirection){
        if(fieldName=='navUrl') {fieldName='CaseNumber';}
        var data1 = component.get("v.currentData");
        var key = function(a) { return a[fieldName]; }
        var reverse = sortDirection == 'asc' ? 1: -1;
        data1.sort(function(a,b){ 
            var a = key(a) ? key(a).toLowerCase() : '';//To handle null values , uppercase records during sorting
            var b = key(b) ? key(b).toLowerCase() : '';
            return reverse * ((a>b) - (b>a));
        });    
        
        component.set("v.currentData",data1);
    },
    updateCaseStatus : function(component, event, helper) {
        component.set("v.confirmFlag",false);
        component.set('v.loaded',false);
        var action = component.get('c.updateMOECaseStatus');
        action.setParams({
            "caseIds" : component.get("v.caseIds"),
            "status":component.get("v.status"),
            "ccmRemarks":component.get("v.ccmRemarks"),
            "Solution":component.get("v.Solution"),
            "Comments":component.get("v.comments")
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            
            if (state == 'SUCCESS') {
                //component.set('v.caseList', respose);
                //component.set('v.currentData', respose); 
                component.set('v.loaded',true);
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
        
    }
})