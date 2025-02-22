({
    doInit : function(component, event, helper) { 
        debugger;
        // get the fields API name and pass it to helper function  
        var controllingFieldAPI = component.get("v.controllingFieldAPI");
        var dependingFieldAPI = component.get("v.dependingFieldAPI");
        var recId=component.get("v.recordId");
        console.log('@@@@'+recId);
        
        var objDetails = component.get("v.objDetail");
        // call the helper function
        helper.fetchPicklistValues(component,objDetails,controllingFieldAPI, dependingFieldAPI);
        component.set("v.isOpen", true);
        var pageRef = component.get("v.pageReference");
        console.log('$$$$$$$$$$$$##'+pageRef);
        console.log('$$$$$$$$$$$$$$###2'+JSON.stringify(pageRef));
        var state = pageRef.state; // state holds any query params
        console.log('state = '+JSON.stringify(state));
        var base64Context = state.inContextOfRef;
        if(base64Context !=null){
            console.log('base64Context = '+base64Context);
            if (base64Context.startsWith("1\.")) {
                base64Context = base64Context.substring(2);
                console.log('base64Context = '+base64Context);
            }
            var addressableContext = JSON.parse(window.atob(base64Context));
            console.log('addressableContext = '+JSON.stringify(addressableContext));
            component.set("v.recordId", addressableContext.attributes.recordId);
            component.set("v.parentobj", addressableContext.attributes.objectApiName);
            console.log('base64Context = '+component.get("v.parentobj"));
        }
        var objectName=component.get("v.parentobj");
        var recordidDetail=component.get("v.recordId");
        if(!$A.util.isEmpty(recordidDetail)){
            helper.fetchrecorddetails(component,objectName,recordidDetail);
        }
    },
    showModal: function(component, event, helper) {
        helper.showSpinner(component, event, helper);
        component.set("v.isOpen", true);
    },
    HideModal: function(component, event, helper) {
        
        var recordidDetail=component.get("v.recordId");
        var urls  = "";
        if(!$A.util.isEmpty(recordidDetail)){
            urls = 'https://icrm.lightning.force.com/lightning/r/Account/'+recordidDetail+'/view';
        }
        else{
            urls = 'https://icrm.lightning.force.com/lightning/o/Case/list?filterName=00B3z000009dfgNEAQ';
        }
            
        var eUrl= $A.get("e.force:navigateToURL");
    	eUrl.setParams({
     		 "url": urls
    	});
    	eUrl.fire();       
        
        component.set("v.isOpen", false);
        
    },
    
    onControllerFieldChange: function(component, event, helper) {     
        var controllerValueKey = event.getSource().get("v.value"); // get selected controller field value
        var depnedentFieldMap = component.get("v.depnedentFieldMap");
        
        if (controllerValueKey != '--- None ---') {
            var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
            
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledDependentFld" , false);  
                component.set("v.isNext" , false);  
                helper.fetchDepValues(component, ListOfDependentFields);    
            }else{
                component.set("v.bDisabledDependentFld" , true); 
                component.set("v.isNext" , false); 
                component.set("v.listDependingValues", ['--- None ---']);
            }  
            
        } else {
            component.set("v.listDependingValues", ['--- None ---']);
            component.set("v.bDisabledDependentFld" , true);
            component.set("v.isNext" , true); 
        }
    },
    createRecord: function(component, event, helper) {
        helper.showSpinner(component, event, helper);
        component.set("v.isOpen", false);
        console.log('Insid Boolean1');
        var disabledDep = component.get("v.bDisabledDependentFld");
        var recordTypeLabel2 = component.find("typefld").get("v.value");
        var recordTypeLabel = component.find("rectype").get("v.value");
        console.log('Insid Boolean2'+disabledDep+'###'+!disabledDep);
        if(!disabledDep && $A.util.isEmpty(recordTypeLabel2) && recordTypeLabel != 'Inquiry and Notices'){
            console.log('Insid Boolean3');
            alert('Please select relevant business type');
            
        }
        else{
            console.log('--Inside else->'+disabledDep);
            var action = component.get("c.getRecTypeId");
            var recordTypeLabel = component.find("rectype").get("v.value");
            var recordTypeLabelUpdated; 
            var recordTypel2 = component.find("typefld").get("v.value");
            console.log('@@@@@@@@@@@@@'+recordTypel2);
            if(!$A.util.isEmpty(recordTypel2)){
                recordTypeLabelUpdated=recordTypeLabel +' - '+ recordTypel2;
            }
            else{
                recordTypeLabelUpdated=recordTypeLabel;
            }
            console.log('--new recordtype--'+recordTypeLabel);
            var objeName=component.get("v.parentobj");
            var sobjec=component.get("v.parentdetails");
            
            var resourceRecordId =null;
            if(component.get("v.resourceRecord")){
                resourceRecordId=component.get("v.resourceRecord").Id;
            }
            console.log('recordTypeLabel---->'+recordTypeLabel);
            console.log('recordTypel2---->'+recordTypel2);
            action.setParams({
                "recordTypeLabel": recordTypeLabelUpdated
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    
                    var createRecordEvent = $A.get("e.force:createRecord");
                    var RecTypeID  = response.getReturnValue();
                    console.log('---->'+JSON.stringify(RecTypeID));
                    console.log('---->'+sobjec);
                    if(objeName=='ETST_Student__c'){
                        createRecordEvent.setParams({
                            "entityApiName": 'Case',
                            "recordTypeId": RecTypeID,
                            'defaultFieldValues': {
                                "Business_Type__c":recordTypel2,
                                "ETST_Student__c":component.get("v.recordId"),
                                //"Case_Record_Types__c":recordTypeLabel,
                                "AccountId":sobjec.ETST_School__c,
                                "Parent_Name__c":sobjec.ETST_Account_Name__c,
                                "Assigned_Resource__c":resourceRecordId,
                                "Assigned_Vehicle__c":sobjec.ETST_Primary_Assigned_Vehicle__c
                            }
                            
                            
                        });
                    }
                    
                    else if(objeName=='Account'){
                        createRecordEvent.setParams({
                            "entityApiName": 'Case',
                            "recordTypeId": RecTypeID,
                            'defaultFieldValues': {
                                "Business_Type__c":recordTypel2,
                                "Case_Record_Types__c":recordTypeLabel,
                                "AccountId":component.get("v.recordId")
                            }
                            
                            
                        });  
                        
                    }
                        else if(objeName=='Contact'){
                            createRecordEvent.setParams({
                                "entityApiName": 'Case',
                                "recordTypeId": RecTypeID,
                                'defaultFieldValues': {
                                    "Business_Type__c":recordTypel2,
                                    "Case_Record_Types__c":recordTypeLabel,
                                    "ContactId":component.get("v.recordId"),
                                    "AccountId":sobjec.AccountId
                                }
                                
                                
                            });  
                            
                        }
                            else if(objeName=='SALine_Assigned_Resource__c'){
                                createRecordEvent.setParams({
                                    "entityApiName": 'Case',
                                    "recordTypeId": RecTypeID,
                                    'defaultFieldValues': {
                                        "Business_Type__c":recordTypel2,
                                        "Case_Record_Types__c":recordTypeLabel,
                                        "Assigned_Resource__c":component.get("v.recordId"),
                                        "Assigned_Vehicle__c":sobjec.ETST_Assigned_Vehicle__c,
                                        "Sales_Agreement__c":sobjec.Sales_Agreement__c
                                    }
                                    
                                    
                                });  
                                
                            } 
                                else if(objeName=='ET_Customer_Vehicle__c'){
                                    createRecordEvent.setParams({
                                        "entityApiName": 'Case',
                                        "recordTypeId": RecTypeID,
                                        'defaultFieldValues': {
                                            "Business_Type__c":recordTypel2,
                                            "Case_Record_Types__c":recordTypeLabel,
                                            "ETI_Customer_Vehicle__c":component.get("v.recordId"),
                                            "AccountId":sobjec.Account__c
                                        }
                                        
                                        
                                    });  
                                    
                                }     else if(objeName=='SALine_Assigned_Vehicle__c'){
                                    createRecordEvent.setParams({
                                        "entityApiName": 'Case',
                                        "recordTypeId": RecTypeID,
                                        'defaultFieldValues': {
                                            "Business_Type__c":recordTypel2,
                                            "Case_Record_Types__c":recordTypeLabel,
                                            "Assigned_Vehicle__c":component.get("v.recordId"),
                                            "Sales_Agreement__c":sobjec.Sales_Agreement__c
                                        }
                                        ,
                                        
                                    });  
                                    
                                }
                                    else if(objeName=='ET_Location__c'){
                                        createRecordEvent.setParams({
                                            "entityApiName": 'Case',
                                            "recordTypeId": RecTypeID,
                                            'defaultFieldValues': {
                                                "Business_Type__c":recordTypel2,
                                                "Case_Record_Types__c":recordTypeLabel,
                                                "Location__c":component.get("v.recordId")
                                            }
                                            
                                            
                                        });  
                                        
                                    }
                                        else if(objeName=='ET_Sales_Agreement__c'){
                                            createRecordEvent.setParams({
                                                "entityApiName": 'Case',
                                                "recordTypeId": RecTypeID,
                                                'defaultFieldValues': {
                                                    "Business_Type__c":recordTypel2,
                                                    "Case_Record_Types__c":recordTypeLabel,
                                                    "Sales_Agreement__c":component.get("v.recordId"),
                                                    "AccountId":sobjec.Salesforce_Customer__c
                                                }
                                                
                                                
                                            });  
                                            
                                        }
                                            else{
                                                createRecordEvent.setParams({
                                                    "entityApiName": 'Case',
                                                    "recordTypeId": RecTypeID,
                                                    'defaultFieldValues': {
                                                        "Business_Type__c":recordTypel2,
                                                        "Case_Record_Types__c":recordTypeLabel
                                                        
                                                    }
                                                    
                                                    
                                                });  
                                                
                                            }
                    createRecordEvent.fire();
                    
                } else if (state == "INCOMPLETE") {
                    helper.hideSpinner(component, event, helper);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Oops!",
                        "message": "No Internet Connection"
                    });
                    toastEvent.fire();
                    
                    
                } else if (state == "ERROR") {
                    helper.hideSpinner(component, event, helper);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Please contact your administrator"
                    });
                    toastEvent.fire();
                }
                
            });
            $A.enqueueAction(action);
        }
        var appEvent = $A.get("e.c:CreateCaseFromChatEvent");
        appEvent.setParams({
            "IsCaseCreated" : true });
        appEvent.fire();
    },
    
    
})