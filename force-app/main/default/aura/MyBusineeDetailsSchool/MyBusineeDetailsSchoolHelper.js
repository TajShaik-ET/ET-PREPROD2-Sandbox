({
     saveOppHelper: function(component, event, helper)  {
         
         var action = component.get('c.saveOpportunity');
        action.setParams({
            type:  'Transportation',
            opp:  component.get('v.opp'),
            currentPO : component.get('v.currentPO') 
            
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                  var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Success!",
                    "message": "The Opportunity with us is created succesfully"
                });
                toastEvent.fire(); 
                 component.set('v.addMore',false);
                 }else{
                console.log('error ----'+JSON.stringify(a.getError()));
            }
        });
        $A.enqueueAction(action);
              
    },
    terminateRequestHelper: function(component, event, helper)  {
        var action = component.get('c.terminateRequest');
        action.setParams({
            caseRecord:  component.get('v.caseRecord'),           
            POName: component.get('v.currentPO')
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Success!",
                    "message": "The case is created succesfully"
                });
                toastEvent.fire(); 
                 component.set('v.terminateRequest',false); 
                 }else{
                console.log('error ----'+JSON.stringify(a.getError()));
            }
        });
        $A.enqueueAction(action);
              
    },
    showSalesAggsHelper : function(component, event, helper)  {
        component.set('v.salesAgreement',true);
        component.set('v.isSalesAggs',true);
        var item=event.getSource().get('v.value');
        component.set('v.currentPO',item);
        var action = component.get('c.getPODetails');
        action.setParams({
            POName: item
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
              
                var result = a.getReturnValue();
                
                component.set("v.cntList", result);
              // alert(JSON.stringify(result));
                /*var custs=[];
                var recs=[];
                for ( var key in result.VehicleCount ) {
                    custs.push({value:result.VehicleCount[key], key:key});
                } 
				for ( var key in result.resourceCount ) {
                    recs.push({value:result.resourceCount[key], key:key});
                }
                
                if(recs.length==0){
                    recs.push({value:0, key:9});
                    recs.push({value:0, key:10});
                    recs.push({value:0, key:11});
                }
                else if(recs.length==1){
                    recs.push({value:0, key:9});
                    recs.push({value:0, key:10});
                }
                else if(recs.length==2){
                    recs.push({value:0, key:9});
                }
                if(custs.length==0){
                    custs.push({value:0, key:9});
                    custs.push({value:0, key:10});
                    custs.push({value:0, key:11});
                }
                else if(custs.length==1){
                    custs.push({value:0, key:9});
                    custs.push({value:0, key:10});
                }
                else if(custs.length==2){
                    custs.push({value:0, key:9});
                }
                component.set("v.VehicleCount", custs);
                component.set("v.resourceCount", recs);
                
                 */
             
                 
            }else{
                alert('error ----'+JSON.stringify(a.getError()));
            }
        });
        $A.enqueueAction(action);
        
    },
    showVehiclesHelper: function (component, event, helper,monthNo) {
        var action = component.get('c.showVehiclesforMonth');
        action.setParams({
            POName:  component.get('v.currentPO'),
            monthNo: monthNo
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                var result = a.getReturnValue();
                component.set('v.vehileList', result);
                
            }
        });
        $A.enqueueAction(action);
    },
    getSiteDetailsHelper: function (component, event, helper) {
        var action = component.get('c.getSiteDetails');
        action.setParams({
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                var result = a.getReturnValue();
                component.set('v.currentsiteData', result);
                component.set('v.siteList', result);
                
            }
        });
        $A.enqueueAction(action);
    },
    getInvHelper: function (component, event, helper) {
        var action = component.get('c.getInvDetails');
        action.setParams({
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                var result = a.getReturnValue();
                component.set('v.currentInvoicesList', result);
                component.set('v.invoicesList', result);
                
            }
        });
        $A.enqueueAction(action);
    },

     showResourcesHelper: function (component, event, helper,monthNo) {
        var action = component.get('c.showResourcesforMonth');
        action.setParams({
            POName:  component.get('v.currentPO'),
            monthNo: monthNo
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                var result = a.getReturnValue();
                component.set('v.resourceList', result);
                
            }
        });
        $A.enqueueAction(action);
    },
    resetFlags : function(component)  {
        component.set('v.more', false); 
        component.set('v.addMore', false); 
         component.set('v.assignVehicles', false); 
        component.set('v.terminateRequest', false); 
        
    },
    convertArrayOfObjectsToCSV : function(component,objRecords,type) {
         
        var csvStringResult,counter,keys,lineDivider,columnDivider;
        if(objRecords==null || !objRecords.length)
        {
            return null;         
        }
        columnDivider=',';
        lineDivider='\n';
        if(type=='site'){
           keys=['FirstName','LastName','Phone'];
        }else{
             keys=['Name','Sales_Agreement__r','Assign_Start_Date__c','Assign_End_Date__c'];
        }
        
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
                else if(typeof objRecords[i][skey]==='object' && (skey==='Sales_Agreement__r')){
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
        
        return csvStringResult;
    },
    resetDashBoard: function(component) {
        component.set('v.sites',false);
        component.set('v.salesAgreementClick', false);
        component.set('v.salesAgreement', false);
        
        component.set('v.assignResources', false);
        component.set('v.assignResourcesClick', false);
        
        component.set('v.assignVehiclesClick', false);
        component.set('v.assignVehicles', false);
        
        component.set('v.invoicesClick', false);
        component.set('v.invoices', false);
        component.set('v.isSalesAggs',false); 
        component.set('v.studentsClick', false);
        component.set('v.students', false);
        component.set('v.isStudent', false); 
        component.set('v.salesAgreementDashboard', false);
    },
    getStudentListHelper  : function(component, event, helper)  {
        
       var action = component.get('c.getStudentList');
        action.setParams({
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                var result = a.getReturnValue();
                component.set('v.studentsList', result);
                component.set('v.currentStudentsList', result);
                           
            }
        });
        $A.enqueueAction(action);  
       
    },
})