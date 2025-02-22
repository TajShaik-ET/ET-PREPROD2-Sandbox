({
    getCaseData : function(component, event, helper,status) {
        var action = component.get('c.getCaseDetailsCustomer');//getCaseDetails
        action.setParams({
            "status" : status
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                component.set('v.caseList', a.getReturnValue());
                component.set('v.currentData', a.getReturnValue()); 
                console.log('Customer Care '+JSON.stringify(component.get('v.currentData'))); 
                
            }
        });
        $A.enqueueAction(action);
    },
    approveCaseHelper : function (component, event,helper,recId){
       
        var action = component.get('c.approveMOECase');
        action.setParams({
            recId : recId,
            caseComments : component.get("v.comments")
        });
        action.setCallback(this, function (a) {
            console.log(a.getReturnValue());
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                $A.get('e.force:showToast').setParams({
                    "title": "Success",
                    "message": "Case is approved succesfully!",
                    "type": "success",
                }).fire();
                /* var actionEvt = $A.get("e.c:ETST_sendDataEvent");
                actionEvt.setParams({
                    "actionname": 'refresh'
                });
                
                actionEvt.fire();*/
                location.reload();
            }
        });
        $A.enqueueAction(action);
    },
    rejectCaseHelper : function (component, event,helper,recId){     
       
        var action = component.get('c.rejectMOECase');
        action.setParams({
            recId : recId,
            caseComments : component.get("v.comments")
        });
        action.setCallback(this, function (a) {
            console.log(a.getReturnValue());
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                $A.get('e.force:showToast').setParams({
                    "title": "Success",
                    "message": "Case is rejected succesfully!",
                    "type": "success",
                }).fire();
                location.reload();
            }
        });
        $A.enqueueAction(action);
    },
    closeCaseHelper : function (component, event,helper,recId){   
      
       
        var action = component.get('c.closeMOECase');
        action.setParams({
            recId : recId,
            caseComments : component.get("v.comments")
        });
        action.setCallback(this, function (a) {
            console.log(a.getReturnValue());
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                
                $A.get('e.force:showToast').setParams({
                    "title": "Success",
                    "message": "Case is closed succesfully!",
                    "type": "success",
                }).fire();
                location.reload();
            }else{
                //alert('error');
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
    }
})