({
    getSearchResult : function(component,event,helper){
        
        
        
        if(component.get("v.hideCliamBtn")){
           
             var actions = [
             {
                'label': 'View',
                'iconName': 'utility:preview',
                'name': 'show_details',
                
            },
             
            {
                'label': 'Correction',
                'iconName': 'utility:edit',
                'name': 'correction'
            },
            {
                'label': 'Cancellation',
                'iconName': 'utility:close',
                'name': 'cancellation'
            },
            /*{
                'label': 'Vehicle Theft',
                'iconName': 'utility:announcement',
                'name': 'vehicleTheft'
            },*/
            {
                'label': 'Available for Mulkiya',
                'iconName': 'utility:anywhere_alert',
                'name': 'vehicleOnline'
            }
             
          
            
        ];
          }else if(component.get("v.workShopButtons")){
                 
                 var actions = [
                 {
                 'label': 'View',
                 'iconName': 'utility:preview',
                 'name': 'show_details',
                 
                 },
                 {
                 'label': 'Claim',
                 'iconName': 'standard:partner_fund_claim',
                 'name': 'Claim',
                 
                 },
                /* {
                 'label': 'Vehicle Theft',
                 'iconName': 'utility:announcement',
                 'name': 'vehicleTheft'
                 },*/
                     {
                         'label': 'Available for Mulkiya',
                         'iconName': 'utility:anywhere_alert',
                         'name': 'vehicleOnline'
                     }
             ];
                 
                 
         }else{
             
             var actions = [
             {
                'label': 'View',
                'iconName': 'utility:preview',
                'name': 'show_details',
                
            },
             {
                'label': 'Claim',
                'iconName': 'standard:partner_fund_claim',
                'name': 'Claim',
                
            },
            {
                'label': 'Correction',
                'iconName': 'utility:edit',
                'name': 'correction'
            },
            {
                'label': 'Cancellation',
                'iconName': 'utility:close',
                'name': 'cancellation'
            },
             {
                'label': 'Vehicle Theft',
                'iconName': 'utility:announcement',
                'name': 'vehicleTheft'
            },
                 {
                     'label': 'Available for Mulkiya',
                     'iconName': 'utility:anywhere_alert',
                     'name': 'vehicleOnline'
                 }
           /*  {
                'label': 'Renewal',
                'iconName': 'action:add_contact',
                'name': 'Renewal'
                
            }*/
            
        ];
        }
        
          component.set('v.InsuranceColumns', [
          
            {label: 'Insurance Ref Number', fieldName: 'link2', type: 'url',typeAttributes: { label:  { fieldName: 'Name' }, target:'_blank'}},
            
            {label: 'Policy Number', fieldName: 'linkName', type: 'url',typeAttributes: { label:  { fieldName: 'policyNumber' }, target:'_blank'}},
            {label: 'Chassis Number', fieldName: 'chassisNumber', type: 'text'},
            {label: 'Plate Number', fieldName: 'plateNumber', type: 'text'},
            {label: 'Internal Number', fieldName: 'InternalNumber', type: 'text'},
            {label: 'Enrollment Date', fieldName: 'ETVIN_Enrollment_Date__c', type: 'date'},
        	{label: 'Expire Date', fieldName: 'ETVIN_Expiry_Date__c', type: 'date'},
            {label: 'Status', cellAttributes:{ iconName: { fieldName: 'StatusIcon' }, iconPosition: 'right' }},
            {label: 'Actions', type: 'action', typeAttributes: { rowActions: actions } }

        ]);
        var exeAction = component.get("c.getInsuranceDetails");
        var pageSize = component.get("v.pageSize");
        exeAction.setParams({
            "policyNumber":component.get("v.policyNumber"),
            "plateNumber": component.get("v.plateNumber"),
            "chassisNumber": component.get("v.chassisNumber"),
            "engineNumber": component.get("v.engineNumber"),
            "vehicleModel": component.get("v.vehicleModel"),
            "InsPartner":component.get("v.selectedSerachFilterValue")
        });
        this.serverSideCall(component,exeAction).then(
            function(res) {
                
                var records =res;
                records.forEach(function(record){
                    record.link2 = '/'+record.Id;
                    record.plateNumber = record.Vehicle__r.Plate_Number__c;
                   record.chassisNumber = record.Vehicle__r.Chassis_No__c;
                   record.InternalNumber = record.Vehicle__r.Internal_No__c;
                    if(record.ETVIN_Insurance_Policy_Number__c){
                        record.policyNumber = record.ETVIN_Insurance_Policy_Number__r.Name;
                    }
                    
                     if(record.ETVIN_Insurance_Status__c == 'Active'){
                        record.StatusIcon ="action:approval";}else{
                        record.StatusIcon ="action:close";  
                        }
                    if(record.ETVIN_Insurance_Policy_Number__c != null){
                        record.linkName = '/'+record.Id; }else
                        { record.linkName ='';}
                                      
                    
                });
                
                component.set('v.Insurancedata',res);
                component.set("v.totalSize", component.get("v.Insurancedata").length);
                //console.log('Res'+JSON.stringify(res));
                component.set("v.paginationList", res.slice(0,pageSize));
            }
        ).catch(
            function(error) {
                console.log('Error---'+JSON.stringify(error));
            }
        );
    }, 
    
    
    serverSideCall : function(component,action) {
        
        return new Promise(function(resolve, reject) { 
            action.setCallback(this, 
                               function(response) {
                                   
                                   var state = response.getState();
                                   // console.log(state);
                                   if (state === "SUCCESS") {
                                       resolve(response.getReturnValue());
                                   } else {
                                       reject(((response.getError())[0]).message);
                                   }
                               }); 
            $A.enqueueAction(action);
        });
    },
              
              
   getCurrenetPageData:function(component, event, helper,start,pageSize) {
        
        component.set("v.paginationList", component.get('v.Insurancedata').slice(start,start+pageSize));
        
    },
              
              
     getPartnerList : function(component, event, helper){
        
        
       var exeAction = component.get("c.getPartnerAccList");
       
       this.serverSideCall(component,exeAction).then(
            function(res) {
                //console.log('rec---'+JSON.stringify(res));
                component.set("v.PartnerList",res);
                
            }
        ).catch(
            function(errorMessage) {
                
                console.log('Error---'+JSON.stringify(errorMessage));
            }
        );
        
    },
        
     
    callBatchClsRenwPrcs : function(component, event, helper) {
      
       
       var exeAction = component.get("c.callBatchClsVehicleRenewPrcs");
       
         exeAction.setParams({
            "PartnerId":component.get("v.selectedValue"),
            "Prcs":component.get("v.RenewValue")
        }); 
        
       
        this.serverSideCall(component,exeAction).then(
            function(res) {
                
                // console.log(res+'-----Batch-----'); 
                var interval = setInterval($A.getCallback(function () {
                        var jobStatus = component.get("c.getBatchJobStatus");
                        if(jobStatus != null){
                            jobStatus.setParams({ jobID : res});
                            jobStatus.setCallback(this, function(jobStatusResponse){
                                var state = jobStatus.getState();
                                if (state === "SUCCESS"){
                                    var job = jobStatusResponse.getReturnValue();
                                    component.set('v.apexJob',job);
                                    var processedPercent = 0;
                                    if(job.JobItemsProcessed != 0){
                                        processedPercent = (job.JobItemsProcessed / job.TotalJobItems) * 100;
                                    }
                                    var progress = component.get('v.progress');
                                    component.set('v.progress', progress === 100 ? clearInterval(interval) :  processedPercent);
                                   var sta =  component.get('v.apexJob.Status');
                                    if(sta == 'Completed'){
                                        component.set("v.cnfrmBtn",false);
                                    }
                                        
                                    
                                }
                            });
                            $A.enqueueAction(jobStatus);
                        }
                    }), 2000);
                    
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        );
        
        
    },
    
    getCorrPicklistVal : function(component, event, helper) { 
       
         
        var exeAction = component.get("c.getselectOptions");
        exeAction.setParams({ 
            "objObject": "Case",
            "fld":"ETIN_Correction_for__c"
        });
        this.serverSideCall(component,exeAction).then(
            function(res) {
                console.log('res-pl-'+res);
                component.set('v.CorrPickList', res);
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        );
        
    },
    
     getClaimDocDetails : function(component, event, helper){
        
         var exeAction = component.get("c.getInsClaimDetails");
        
       this.serverSideCall(component,exeAction).then(
            function(res) {
                   //console.log('--docs---'+JSON.stringify(res)); 
                 component.set("v.ClaimDocList",res);
                
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        );
        
     },
    
      getLoggedUserDetails : function(component, event, helper) {
        var exeAction = component.get("c.fetchUser");
        
         this.serverSideCall(component,exeAction).then(
            function(res) {
       
                if(res.UserRole.Name == 'Vehicle Insurance Zone'){
                  
                     component.set('v.hideCliamBtn', true); 
                   
                     
                }else if(res.UserRole.Name == 'Vehicle Workshop'){
                    
                     component.set('v.workShopButtons', true); 
                }else {
                    component.set('v.hideCliamBtn', false); 
                }
               
                try{
                    helper.getSearchResult(component, event, helper);
                }catch(e){
                    console.log('--user Error--'+e.message);
                }
                    
            }
        ).catch(
            function(error) {
                component.set('v.hideCliamBtn', false); 
                helper.getSearchResult(component, event, helper);
                console.log('Error---'+JSON.stringify(error));
            }
        );
        
         
    },
    CSV2JSON: function (component,csv) {
              
        var arr = []; 
        arr =  csv.split('\n');
        //console.log('Array  = '+array);
        // console.log('arr = '+arr);
        arr.pop();
        var jsonObj = [];
        var headers = arr[0].split(',');
        for(var i = 1; i < arr.length; i++) {
            var data = arr[i].split(',');
            var obj = {};
            for(var j = 0; j < data.length; j++) {
                obj[headers[j].trim()] = data[j].trim();
                //console.log('obj headers = ' + obj[headers[j].trim()]);
            }
            jsonObj.push(obj);
        }
        var json = JSON.stringify(jsonObj);
        //console.log('json = '+ json);
        return json;
        
   },
       
     UploadDataToCRM : function (component,jsonstr){
      
      var action = component.get('c.insertData');
        //  alert('Server Action' + action);    
        action.setParams({
            strfromle : jsonstr
            });
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            
            if (state === "SUCCESS") {  
               
                var result=response.getReturnValue();
                component.find("file").getElement().value='';
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type":"Success",
                    "title":"success",
                    "message":'Your data is updated successfully',
                    "mode":"dismissible"
                });
                toastReference.fire();
                 component.set("v.ShowSpinner",false);
                //$A.get('e.force:refreshView').fire(); 
            }
            else if (state === "ERROR") {
               component.set("v.ShowSpinner",false);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"Error",
                            "title":"Error",
                            "message":'Please check with System admin'+errors[0].message,
                            "mode":"sticky"
                        });
                        toastReference.fire();
                    }
                } else {
                    console.log("Unknown error");
                     component.set("v.ShowSpinner",false);
                    //alert('Unknown');
                }
            }
        }); 
        
        $A.enqueueAction(action);  
        
    },
        
     UploadRenewalDataToCRM : function (component,jsonstr){
         
          var action = component.get('c.insertDataRenewal');
        //  alert('Server Action' + action);    
        action.setParams({
            strfromle : jsonstr
            });
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            
            if (state === "SUCCESS") {  
               
                var result=response.getReturnValue();
                 component.find("file1").getElement().value='';
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type":"Success",
                    "title":"success",
                    "message":'Your data is updated successfully',
                    "mode":"dismissible"
                });
                toastReference.fire();
                 component.set("v.ShowSpinner",false);
                //$A.get('e.force:refreshView').fire(); 
            }
            else if (state === "ERROR") {
               component.set("v.ShowSpinner",false);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"Error",
                            "title":"Error",
                            "message":'Please check with System admin'+errors[0].message,
                            "mode":"sticky"
                        });
                        toastReference.fire();
                    }
                } else {
                    console.log("Unknown error");
                     component.set("v.ShowSpinner",false);
                    //alert('Unknown');
                }
            }
        }); 
        
        $A.enqueueAction(action);  
        
     }
 
})