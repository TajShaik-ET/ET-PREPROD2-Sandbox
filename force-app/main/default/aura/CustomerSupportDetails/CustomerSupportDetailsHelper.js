({
    getCaseData : function(component, event, helper,status) {
        var action = component.get('c.getCaseDetails');
        action.setParams({
            "status" : status
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            
            if (state == 'SUCCESS') {
                var respose=a.getReturnValue();
                component.set('v.caseList', respose);
                component.set('v.currentData', respose);             
                //console.log('a.getReturnValue() '+JSON.stringify(component.get('v.currentData'))); 
            }
        });
        $A.enqueueAction(action);
    },
    getFilteredCaseData : function(component, event, helper) {
        var selectedType = component.get('v.selectedType');
        var selectedAccountId = component.get('v.selectedAccountName');
        var selectedStatus = component.get('v.selectedStatus');
        var accountType = component.get('v.accountType');
        var action = component.get('c.getCaseDetailsBasedOnFilter');
        action.setParams({
            "selectedType" : selectedType,
            "selectedAccountId" : selectedAccountId,
            "selectedStatus" : selectedStatus,
            "accountType":accountType,
            "selectedStartDate":component.get('v.selectedStartDate'),
            "selectedEndDate":component.get('v.selectedEndDate')
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            
            if (state == 'SUCCESS') {
                var respose=a.getReturnValue();
                component.set('v.caseList', respose);
                component.set('v.currentData', respose);             
            }
        });
        $A.enqueueAction(action);
    },
    convertArrayOfObjectsToCSVNew : function(component,objRecords) {
        var csvStringResult,counter,keys,lineDivider,columnDivider;
        if(objRecords==null || !objRecords.length)
        {
            return null;         
        }
        columnDivider=',';
        lineDivider='\n';
        keys=['Case Number','Type','Status','Assigned Vehicle','Assigned Resource','Account','Created By'];
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
                if(skey==='Case Number'){
                    csvStringResult+='"'+objRecords[i]['CaseNumber']+'"';
                    counter ++;
                }else if(skey==='Type'){
                    csvStringResult+='"'+objRecords[i]['RecordType'].Name+'"';
                    counter ++;
                }else if(skey==='Status'){
                    csvStringResult+='"'+objRecords[i]['Status']+'"';
                    counter ++;
                }else if(skey==='Assigned Vehicle'){
                    csvStringResult+='"'+objRecords[i]['Assigned_Vehicle__r'].Name+'"';
                    counter ++;
                }else if(skey==='Assigned Resource'){
                    csvStringResult+='"'+objRecords[i]['Assigned_Resource__r'].Name+'"';
                    counter ++;
                }else if(skey==='Account'){
                    csvStringResult+='"'+objRecords[i]['Account'].Name+'"';
                    counter ++;
                }else if(skey==='Created By'){
                    csvStringResult+='"'+objRecords[i]['CreatedBy'].Name+'"';
                    counter ++;
                }else{
                    csvStringResult+='"'+objRecords[i][skey]+'"';
                    counter ++;
                }
            }
            csvStringResult+=lineDivider;
            
        }
        
        return csvStringResult;
    }, 
    getProfileName : function(component, event, helper,status) {
        var action = component.get('c.getProfileName');
        action.setParams({
           
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            
            if (state == 'SUCCESS') {
                var respose=a.getReturnValue();
                component.set('v.profileName', respose);          
            }
        });
        $A.enqueueAction(action);        
    },
    
    convertArrayOfObjectsToCSV : function(component,objRecords) {
        console.log('inside convertArrayOfObjectsToCSV');
        var csvStringResult,counter,keys,lineDivider,columnDivider;
        if(objRecords==null || !objRecords.length)
        {
            return null;         
        }
        columnDivider=',';
        lineDivider='\n';
        keys=['CaseNumber','RecordType','status','Assigned_Resource__r','Assigned_Vehicle__r','Account','CreatedBy','createdDate'];
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
                }else if(typeof objRecords[i][skey]==='object' && (skey==='Assigned_Resource__r' || skey==='Assigned_Vehicle__r' || skey==='Account' || skey==='CreatedBy')){
                    csvStringResult+='"'+objRecords[i][skey].Name+'"';
                    counter ++;
                }else{
                    csvStringResult+='"'+objRecords[i][skey]+'"';
                    counter ++;
                }
                
            }
            csvStringResult+=lineDivider;
            
        }
        
        return csvStringResult
    },
})