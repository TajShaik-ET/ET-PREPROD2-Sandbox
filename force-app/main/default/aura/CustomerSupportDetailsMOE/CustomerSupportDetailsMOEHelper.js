({
    getCaseData : function(component, event, helper,status) {
        debugger;
        var action = component.get('c.getCaseDetailsCustomer');//getCaseDetails
        action.setParams({
            "status" : status
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            
            if (state == 'SUCCESS') {
                var respose=a.getReturnValue();
                component.set('v.caseList', respose);
                component.set('v.currentData', respose);             
                console.log('a.getReturnValue() '+JSON.stringify(component.get('v.currentData'))); 
            }
        });
        $A.enqueueAction(action);
    },
     getPrivateuserdata: function(component, event, helper,status){
      // debugger;
        var action = component.get('c.getprivateschoolUserData');
        action.setParams({
            
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            
            if (state == 'SUCCESS') {
                var respose=a.getReturnValue();
                console.log('respose11222 '+JSON.stringify(respose));
               component.set('v.userParentProfileWrap', respose.loggedinUserProfileName);  
                
            }else{
                alert('Error in getting User details');
            }
        });
        $A.enqueueAction(action);       
    },
    convertArrayOfObjectsToCSV : function(component,objRecords) {
        var csvStringResult,counter,keys,lineDivider,columnDivider;
        if(objRecords==null || !objRecords.length)
        {
            return null;         
        }
        columnDivider=',';
        lineDivider='\n';
        keys=['CaseNumber','RecordType','Status_Category__c','Sub_Status__c','Assigned_Resource__r','Assigned_Vehicle__r','ETST_Student__r'];
        csvStringResult='';
        csvStringResult+=keys.join(columnDivider);
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
                else if(typeof objRecords[i][skey]==='object' && (skey==='Assigned_Resource__r' || skey==='Assigned_Vehicle__r' || skey==='ETST_Student__r')){
                    csvStringResult+='"'+objRecords[i][skey].Name+'"';
                    counter ++;
                }
                // Querying same object field
                    else{
                        csvStringResult+='"'+objRecords[i][skey]+'"';
                        counter ++;
                    }
                
            }
            csvStringResult+=lineDivider;
            
        }
        
        return csvStringResult
    },
    approveHelper: function(component, event,helper,recId){
        debugger;
        var action = component.get('c.customerCaseApprovalProcess');
        action.setParams({
            recId :recId,
            caseComments: component.get("v.comments")
        });
        action.setCallback(this, function (a) {
            console.log(a.getReturnValue());
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                
                $A.get('e.force:showToast').setParams({
                    "title": "Success",
                    "message": "Case is Approved succesfully!",
                    "type": "success",
                }).fire();
                location.reload();
            }else{
                alert('error');
            }
        });
        $A.enqueueAction(action);
    },
        closedHelper: function(component, event,helper,recId){
         debugger;
        var action = component.get('c.closeMOECase');
          
        action.setParams({
            recId :recId
           
        });
        action.setCallback(this, function (a) {
            console.log(a.getReturnValue());
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                $A.get('e.force:showToast').setParams({
                    "title": "Success",
                    "message": "Case is Closed succesfully!",
                    "type": "success",
                }).fire();
              //  location.reload();
            }else{
                alert('error');
            }
        });
        $A.enqueueAction(action);
    },
    rejectHelper: function(component, event,helper,recId){
        var action = component.get('c.customerCaseRejectProcess');
        action.setParams({
            recId :recId,
            caseComments: component.get("v.comments")
        });
        action.setCallback(this, function (a) {
            console.log(a.getReturnValue());
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                
                $A.get('e.force:showToast').setParams({
                    "title": "Success",
                    "message": "Case is Rejected  succesfully!",
                    "type": "success",
                }).fire();
                location.reload();
            }else{
                alert('error');
            }
        });
        $A.enqueueAction(action);
    },
       updateCommnetsHelper : function (component, event,helper,recId){   
       debugger;
        var action = component.get('c.cutomerCaseUpdateCommnets');
        action.setParams({
            recId : recId,
            caseComments : component.get("v.comments"),
            finevalue:component.get("v.finevalue")
        });
        action.setCallback(this, function (a) {
            console.log(a.getReturnValue());
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                
                $A.get('e.force:showToast').setParams({
                    "title": "Success",
                    "message": "Case is updated  succesfully!",
                    "type": "success",
                }).fire();
                location.reload();
            }else{
                $A.get('e.force:showToast').setParams({
                    "title": "Error",
                    "message": "Something went wrong!",
                    "type": "error",
                    "duration":'2000',
                    "key" : 'info_alt',
                    "mode": 'pester'
                }).fire();
                
                setTimeout(function () {
                    component.set("v.showCommentsPage", false);
                }, 2000); 
              // component.set("v.showCommentsPage",false);
            }
        });
        $A.enqueueAction(action);
    },
    showError : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message:'This is an error message',
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
    },
    getRequestForInfomation : function(component, event, helper,status) {
        debugger;
        var action = component.get('c.getRequestInfo');//getCaseDetails
        action.setParams({
            "status" : status
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            
            if (state == 'SUCCESS') {
                var respose=a.getReturnValue();
                component.set('v.caseList', respose);
                component.set('v.currentData', respose);             
                console.log('a.getReturnValue() '+JSON.stringify(component.get('v.currentData'))); 
            }
        });
        $A.enqueueAction(action);
    },
})