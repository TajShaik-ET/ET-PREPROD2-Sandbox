({
	   getCurrentInsuranceRecords : function (component,event, helper){
         
           var actions = [
               {label: 'Update Dependent Details', name: 'dependent'},
               {label: 'Update Employee Details', name: 'emp'}
               
           ];
           
           var actions2 = helper.getRowActions.bind(this, component);
          component.set('v.columns', [
                        //{label: 'Ref Number', fieldName: 'link2', type: 'url',typeAttributes: { label:  { fieldName: 'Name' }, target:'_blank'},sortable:true},
                        //{label: 'Ref Number', fieldName: 'Name', type: 'text', sortable:true},
                        {label: 'Employee ID', fieldName: 'Employee_ID__c', type: 'text',"cellAttributes": {"class": {"fieldName": "showClass"}}, sortable:true},
                       {label: 'Member Name', fieldName: 'Member_Name__c', type: 'text',"cellAttributes": {"class": {"fieldName": "showClass"}}, sortable:true},
                        {label: 'Plan', fieldName: 'Plan__c', type: 'text',"cellAttributes": {"class": {"fieldName": "showClass"}}, sortable:true},
                        {label: 'Relation', fieldName: 'Relation__c', type: 'text',"cellAttributes": {"class": {"fieldName": "showClass"}}, sortable:true},
                       {label: 'Emirates ID', fieldName: 'Emirates_ID__c', type: 'text',"cellAttributes": {"class": {"fieldName": "showClass"}}, sortable:true},
                        {label: 'Martial Status', fieldName: 'Marital_Status__c', type: 'text',"cellAttributes": {"class": {"fieldName": "showClass"}}, sortable:true},
                        {label: 'Renewal Notes', fieldName: 'Comments__c', type: 'text', "cellAttributes": {"class": {"fieldName": "showClass"}},editable: true},
                        {label: 'Employee Status', fieldName: 'Employee_Status__c', type: 'text',"cellAttributes": {"class": {"fieldName": "showClass"}}, sortable:true},
                        {label: 'Comments', fieldName: 'comment', type: 'text',"cellAttributes": {"class": {"fieldName": "showClass"}}, sortable:true},
                        //{label: 'Ready to Renew', cellAttributes:{ iconName: { fieldName: 'StatusIcon' }, iconPosition: 'right',sortable:true }},
                       // {type:'button',typeAttributes: {iconName: 'utility:edit',label: 'Edit',name: 'editRecord', title: 'editTitle', disabled: false, value: 'test'}},
                        {type: 'action', typeAttributes: { rowActions: actions2 } } 
                    ]);
      
       var action = component.get('c.getCurrentInsRecords');
      
        action.setParams({
            "recordLimit": component.get("v.initialRows"),
            "recordOffset": component.get("v.rowNumberOffset"),
            "visalocation": component.get("v.visaLocation")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
                       
            if (state === "SUCCESS") {  
                var resultData = response.getReturnValue();
                 var records =resultData;
                records.forEach(function(record){
                  
                    record.link2 = '/'+record.Id; 
                     record.FulName = record.EmployeeAcc__r.Name;
                      var msg ='';
                   if(record.Employee_Family__c){
                        
                        if(record.Employee_Family__r.Age__c >= 18 && record.Relation__c=='Child'){
                            record.StatusIcon ="action:close";
                            record.showClass = "redcolor";
                            msg = 'Child age more or equal to 18,';
                              
                        }else{
                             record.StatusIcon ="action:approval"; 
                             record.showClass = "blackcolor";
                        }
                        
                   }
                    
                    if((record.Employee_Status__c == 'Active'  || (record.Employee_Status__c == 'Inactive'&& record.Comments__c != null))&& record.EID__c != null ){
                        
                        record.StatusIcon ="action:approval";
                         record.showClass = "blackcolor";
                    }else{
                        record.StatusIcon ="action:close"; 
                        record.showClass = "redcolor";
                        if(record.EID__c == null){
                            msg+= ' Emirates ID Missing';
                        }
                        
                        }
                      record.comment = msg;
                    
                });
                
                
                
                component.set("v.data", resultData);
                component.set("v.currentCount", component.get("v.initialRows"));
            }
            else if (state === "ERROR") {
               var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
          }); 
        
        $A.enqueueAction(action);  
        
    },
    getRowActions: function(component, row, cb) {
        
        var actions = [];
       
        if(row.Relation__c =='Principal'){
            
             actions.push({label: 'Update', name: 'emp'});
           
        }else{
             actions.push({label: 'Update', name: 'dependent'});
        }
        cb(actions);
    },
    getTotalNumberOfRecords: function(component) {
        var action = component.get("c.getTotalRecords");
         action.setParams({
            "visalocation": component.get("v.visaLocation")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                var resultData = response.getReturnValue();
                component.set("v.totalNumberOfRows", resultData);
            }
        });
        $A.enqueueAction(action);
    },
    
    getMoreRecords: function(component , rows){
        
               
        return new Promise($A.getCallback(function(resolve, reject) {
            var action = component.get('c.getCurrentInsRecords');
            var recordOffset = component.get("v.currentCount");
            var recordLimit = component.get("v.initialRows");
            action.setParams({
                "recordLimit": recordLimit,
                "recordOffset": recordOffset,
                 "visalocation": component.get("v.visaLocation")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS"){
                    var resultData = response.getReturnValue();
                    var records =resultData;
                records.forEach(function(record){
                    record.link2 = '/'+record.Id; 
                    record.FulName = record.EmployeeAcc__r.Name;
                      var msg ='';
                   if(record.Employee_Family__c){
                        if(record.Employee_Family__r.Age__c >= 18 && record.Relation__c=='Child'){
                            record.StatusIcon ="action:close";
                            record.showClass = "redcolor";
                            msg = 'Child age more or equal to 18,';
                        }else{
                             record.StatusIcon ="action:approval"; 
                             record.showClass = "blackcolor";
                        }
                        
                   }
                    
                   if((record.Employee_Status__c == 'Active'  || (record.Employee_Status__c == 'Inactive'&& record.Comments__c != null))&& record.EID__c != null ){
                        record.StatusIcon ="action:approval";
                         record.showClass = "blackcolor";
                    }else{
                        if(record.EID__c == null){
                           
                             msg+= ' Emirates ID Missing';
                        }
                        record.StatusIcon ="action:close"; 
                        record.showClass = "redcolor";
                        }
                     record.comment = msg;
                      });
                    resolve(resultData);
                    recordOffset = recordOffset+recordLimit;
                    component.set("v.currentCount", recordOffset);   
                    
                    var actions = [
                        {label: 'Update Dependent Details', name: 'dependent'},
                        {label: 'Update Employee Details', name: 'emp'}
                        
                    ];
                     var actions2 = helper.getRowActions.bind(this, component);
                    component.set('v.columns', [
                        //{label: 'Ref Number', fieldName: 'link2', type: 'url',typeAttributes: { label:  { fieldName: 'Name' }, target:'_blank'},sortable:true},
                        //{label: 'Ref Number', fieldName: 'Name', type: 'text', sortable:true},
                        {label: 'Employee ID', fieldName: 'Employee_ID__c', type: 'text',"cellAttributes": {"class": {"fieldName": "showClass"}}, sortable:true},
                        
                        {label: 'Member Name', fieldName: 'Member_Name__c', type: 'text',"cellAttributes": {"class": {"fieldName": "showClass"}}, sortable:true},
                        {label: 'Plan', fieldName: 'Plan__c', type: 'text',"cellAttributes": {"class": {"fieldName": "showClass"}}, sortable:true},
                        {label: 'Relation', fieldName: 'Relation__c', type: 'text',"cellAttributes": {"class": {"fieldName": "showClass"}}, sortable:true},
                        {label: 'Emirates ID', fieldName: 'Emirates_ID__c', type: 'text',"cellAttributes": {"class": {"fieldName": "showClass"}}, sortable:true},
                        {label: 'Martial Status', fieldName: 'Marital_Status__c', type: 'text',"cellAttributes": {"class": {"fieldName": "showClass"}}, sortable:true},
                        {label: 'Renewal Notes', fieldName: 'Comments__c', type: 'text', "cellAttributes": {"class": {"fieldName": "showClass"}},editable: true},
                        {label: 'Employee Status', fieldName: 'Employee_Status__c', type: 'text',"cellAttributes": {"class": {"fieldName": "showClass"}}, sortable:true},
                        {label: 'Comments', fieldName: 'comment', type: 'text',"cellAttributes": {"class": {"fieldName": "showClass"}}, sortable:true},
                        //{label: 'Ready to Renew', cellAttributes:{ iconName: { fieldName: 'StatusIcon' }, iconPosition: 'right',sortable:true }},
                        {type: 'action', typeAttributes: { rowActions: actions2 } } 
                        //{type:'button',typeAttributes: {iconName: 'utility:edit',label: 'Edit',name: 'editRecord', title: 'editTitle', disabled: false, value: 'test'}},
                    ]);

                }                
            });
            $A.enqueueAction(action);
        }));
    },
     sortData: function (component, fieldName, sortDirection) {
        var data = component.get("v.data");
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortBy(fieldName, reverse))
        component.set("v.data", data);
    },
     
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
        function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    addDependentDetails: function (component, event){
        
        var row = event.getParam('row');
        var recordId = row.Employee_Family__c;
         let rel = row.Relation__c;
        
        if(recordId && rel != 'Principal'){
            component.set("v.familyId",recordId);
        component.set("v.showFamilyPopup",true);  
        }else{
            var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"Warning",
                "title":"Warning",
                "message":"Please choose Update Employee button",
                "mode":"dismissible"
            });
            toastReference.fire();
        }
            
   },
    editEmpDetails : function (component, event){
        
        var row = event.getParam('row');
        var recordId = row.EmployeeAcc__c;
        let rel = row.Relation__c;
       
       if(recordId && rel == 'Principal'){
        component.set("v.empId",recordId);
        component.set("v.showEmpPopup",true);
       }else{
           
           var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"Warning",
                "title":"Warning",
                "message":"Please choose Update Dependent button",
                "mode":"dismissible"
            });
            toastReference.fire();
       }
       
       
    },
    errorHandler : function (component, event,msg){
           
        var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"Warning",
                "title":"Warning",
                "message":msg,
                "mode":"dismissible"
            });
            toastReference.fire();
    
    },
    HandleRenewalProcess : function (component, event,helper){
        
       component.set("v.showSpinner", true);
       
       console.log(component.get("v.selectedRowsList"))
        
       var action = component.get('c.RenewProcess');
      
        action.setParams({
            renewList : component.get("v.selectedRowsList")            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
                       
            if (state === "SUCCESS") {  
                component.set("v.showSpinner", false);
                try{  
                    component.set("v.selectedRows",null);
                     helper.getCurrentInsuranceRecords(component, event, helper);
                }catch(ex){
                    console.log('--Error--'+ex);
                    }
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type":"Success",
                    "title":"Success",
                    "message":'Your request has been submitted',
                    "mode":"dismissible"
                });
                toastReference.fire();
                //alert('win')
            }
            else if (state === "ERROR") {
                component.set("v.showSpinner", false);
               var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        
                     
                     var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"Error",
                            "title":"Error",
                            "message":'Please check with system admin - '+errors[0].message,
                            "mode":"dismissible"
                        });
                        toastReference.fire(); 
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
          }); 
        
        $A.enqueueAction(action);  
       
        
    },
    
    getLoggedUserDetails : function(component, event, helper) {
        var exeAction = component.get("c.fetchUser");
        
          exeAction.setCallback(this, function(response) {
            var state = response.getState();
                       
              if (state === "SUCCESS") { 
                  var res = response.getReturnValue();
                  console.log('----'+res.UserRole.Name);
                  if(res.Profile.Name == $A.get("$Label.c.INS_ZoneCordProfileName")){
                      
                      component.set("v.CustomLabel","Renew and send for HR approval");
                  }else{
                       component.set("v.CustomLabel","Bulk Renewal");
                  }
              
              }});
              $A.enqueueAction(exeAction);   
                  
        
    },
   
})