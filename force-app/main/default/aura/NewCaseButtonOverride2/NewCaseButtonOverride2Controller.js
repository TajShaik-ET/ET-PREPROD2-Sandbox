({
    doInit : function(component, event, helper) { 
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
        console.log(JSON.stringify(pageRef));
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
        helper.fetchrecorddetails(component,objectName,recordidDetail);
    },
    showModal: function(component, event, helper) {
        helper.showSpinner(component, event, helper);
        component.set("v.isOpen", true);
    },
    HideModal: function(component, event, helper) {
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
                component.set("v.isNext" , true); 
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
        var action = component.get("c.getRecTypeId");
        var recordTypeLabel = component.find("typefld").get("v.value");
        var recordTypel2 = component.find("rectype").get("v.value");
        var objeName=component.get("v.parentobj");
        var sobjec=component.get("v.parentdetails")
        var resourceRecordId =null;
        if(component.get("v.resourceRecord")){
            resourceRecordId=component.get("v.resourceRecord").Id;
        }
        console.log('recordTypeLabel---->'+recordTypeLabel);
        console.log('recordTypel2---->'+recordTypel2);
        action.setParams({
            "recordTypeLabel": recordTypeLabel
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
                            "Case_Type__c":recordTypel2,
                            "ETST_Student__c":component.get("v.recordId"),
                            "Record_Type__c":recordTypeLabel,
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
                            "Case_Type__c":recordTypel2,
                            "Record_Type__c":recordTypeLabel,
                            "AccountId":component.get("v.recordId")
                        }
                        
                        
                    });  
                    
                }
                    else if(objeName=='Contact'){
                        createRecordEvent.setParams({
                            "entityApiName": 'Case',
                            "recordTypeId": RecTypeID,
                            'defaultFieldValues': {
                                "Case_Type__c":recordTypel2,
                                "Record_Type__c":recordTypeLabel,
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
                                    "Case_Type__c":recordTypel2,
                                    "Record_Type__c":recordTypeLabel,
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
                                    "Case_Type__c":recordTypel2,
                                    "Record_Type__c":recordTypeLabel,
                                    "ETI_Customer_Vehicle__c":component.get("v.recordId"),
                                    "AccountId":sobjec.Account__c
                                }
                                
                                
                            });  
                            
                        }     else if(objeName=='SALine_Assigned_Vehicle__c'){
                            createRecordEvent.setParams({
                                "entityApiName": 'Case',
                                "recordTypeId": RecTypeID,
                                'defaultFieldValues': {
                                    "Case_Type__c":recordTypel2,
                                    "Record_Type__c":recordTypeLabel,
                                    "Assigned_Vehicle__c":component.get("v.recordId"),
                                    "Sales_Agreement__c":sobjec.Sales_Agreement__c
                                }
                                
                                
                            });  
                            
                        }
                            else if(objeName=='ET_Location__c'){
                                createRecordEvent.setParams({
                                    "entityApiName": 'Case',
                                    "recordTypeId": RecTypeID,
                                    'defaultFieldValues': {
                                        "Case_Type__c":recordTypel2,
                                        "Record_Type__c":recordTypeLabel,
                                        "Location__c":component.get("v.recordId")
                                    }
                                    
                                    
                                });  
                                
                            }
                                else if(objeName=='ET_Sales_Agreement__c'){
                                    createRecordEvent.setParams({
                                        "entityApiName": 'Case',
                                        "recordTypeId": RecTypeID,
                                        'defaultFieldValues': {
                                            "Case_Type__c":recordTypel2,
                                            "Record_Type__c":recordTypeLabel,
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
                                                "Case_Type__c":recordTypel2,
                                                "Record_Type__c":recordTypeLabel
                                                
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
    },
    
    
})