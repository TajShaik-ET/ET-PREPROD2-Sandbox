({
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
                console.log(errorToShow);
                utility.showToast("Single View", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "sticky");
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
                    
                    if(row.ETST_Student__c) row.studentPhone = row.ETST_Student__r.ETST_Phone__c;
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
                console.log(errorToShow);
                utility.showToast("Single View", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "sticky");
                component.set("v.serverActionFinished", true);  
            })
        )	
    },
    sortData : function(component,fieldName,sortDirection){
        if(fieldName=='navUrl') {fieldName='Name';}
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
    updateTransportRequestStatus : function(component, event, helper,status) {
        component.set('v.loaded',false);
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "updateBulkTransportRequestStatus";
        var params = {
            "serviceRecordIds" : component.get("v.serviceRecordIds"),
            "status" : component.get("v.status")
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                $A.get('e.force:refreshView').fire();
                console.log('Updated the status...');
                component.set('v.loaded',true);
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
                utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )	
    },
    convertArrayOfObjectsToCSV : function(component,objRecords,type) {
        
        var csvStringResult,counter,keys,lineDivider,columnDivider;
        if(objRecords==null || !objRecords.length)
        {
            return null;         
        }
        columnDivider=',';
        lineDivider='\n';
        keys=['Name','ETST_Student_Name__c','ETST_Student__r','ETST_Pick_Up_From__c',
              'ETST_Drop_Off_To__c','ETST_Pick_Up_Start_Date__c','ETST_Pick_Up_End_Date__c','ETST_Fare_Charges__c',
              'ETST_Status__c','ETST_Coordinator_Comments__c'];
        
        
        csvStringResult='';
        //csvStringResult+=keys.join(columnDivider);
        csvStringResult+=['Service No.','Student Name','School Name','Phone','Pickup Location',
                          'Drop Location','Start Date','Expiry Date','Status','Fare','Comments'];
        csvStringResult+=lineDivider;
        
        for(var i=0;i<objRecords.length;i++)
        {
            
            counter=0;
            for(var tempKey in keys)
            {
                var skey=keys[tempKey];
                
                if(counter>0)
                {
                    csvStringResult+=columnDivider;
                }
                // Querying standard related object field
                if(typeof objRecords[i][skey]==='object' && skey==='RecordType'){
                    csvStringResult+='"'+objRecords[i][skey].Name+'"';
                    counter ++;
                }
                // Querying custom related object field
                else if(typeof objRecords[i][skey]==='object' && (skey==='ETST_Student__r')){
                    csvStringResult+='"'+objRecords[i][skey].ETST_Student_School__c+'"';
                    csvStringResult+=columnDivider;
                    csvStringResult+='"'+objRecords[i][skey].ETST_Phone__c+'"'; 
                }
                // Querying same object field
                    else{
                        csvStringResult+='"'+objRecords[i][skey]+'"';
                        counter ++;
                    }
                
            }
            csvStringResult+=lineDivider;
            
        }
        
        return csvStringResult;
    },
})