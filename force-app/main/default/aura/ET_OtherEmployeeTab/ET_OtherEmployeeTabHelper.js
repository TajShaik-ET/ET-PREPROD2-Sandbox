({
    processDoInit: function(component,event,helper){
        var action = component.get("c.getOtherEmpMasterData");
        action.setCallback(this, function(obj){
            var state = obj.getState();
            if(state === 'SUCCESS'){
                var response = obj.getReturnValue();
                if(response!=null && response!= undefined){
                    component.set("v.otherEmployeeMasterDataMap", response);
                    console.log(JSON.stringify(component.get("v.otherEmployeeMasterDataMap")));
                    
                    var commonCmp = component.find("serviceRequestCommonCmpOtherEmp");
                    var commonInfoFromWrapper = component.get("v.commonInforReceivedFrmWrapper");
                    
                    if((component.get("v.commonFieldsToBePopulateLst") == undefined || component.get("v.commonFieldsToBePopulateLst").length == 0) && commonCmp == undefined){
                        var otherEmployeeRecords = new Map();
                        var routeList = [];
                        var otherEmployeeCommonInfo = commonInfoFromWrapper;
                        if(commonInfoFromWrapper['ET_Pricing_Method__c'] == 'Comprehensive Price per Route'){
                            routeList.push("Comprehensive Price per Route");
                        }
                        otherEmployeeRecords['otherEmployeeCommonInfo'] = otherEmployeeCommonInfo;
                        component.set("v.otherEmployeeRecords",otherEmployeeRecords); 
                        component.set("v.additionalFieldsToDisplay",routeList);
                        //component.set("v.multipleFields",fieldsWithMultipleValueLst );
                        var totalNumberOfLines = component.get("v.numberOfLines");
                        component.set("v.numberOfLines",totalNumberOfLines+1);
                        //  alert('doinit');
                        $A.createComponent(
                            "c:ET_OtherEmployeeDetails",
                            {
                                "aura:id" : "otherEmployeeDetailsCmp",
                                "lineNumber" : component.get("v.numberOfLines"),
                                "additionalFields" : routeList,
                                "otherEmployeeMasterDataMap" : component.get("v.otherEmployeeMasterDataMap"),
                                "isPricingTeam" :  component.get("v.isPricingTeam"),
                                "editableFieldsByPricingTeam" : component.get("v.editableOtherEmployeeFieldsforPricingTeam"),
                                "alterRatesObj": component.get("v.alterRatesWithServiceWrp"),
                                "quoteId" : component.get("v.quoteId")
                                
                            },
                            function(newcomponent){
                                if (component.isValid()) {
                                    var newCmp = component.find("cmpBody");
                                    var body = newCmp.get("v.body");
                                    body.push(newcomponent);
                                    newCmp.set("v.body", body);             
                                }
                            }   
                            
                        );
                    }
                    var data = component.get("v.existingOtherEmpTabData");
                    console.log('other emp existing data :'+JSON.stringify(data));
                    if(data != undefined && data != null){
                        if(data.manpowerCommonData != null){
                            component.set("v.existingOtherEmpCommonData", data.manpowerCommonData);
                        }
                        if(data.manpowerLineItems != null){
                            component.set("v.existingOtherEmpLineItems", data.manpowerLineItems);
                            // intializing line item components here too when local tab common data is same as application common data. 
                            if(component.get("v.commonFieldsToBePopulateLst") == null || component.get("v.commonFieldsToBePopulateLst").length == 0){
                                for(var i=0; i< data.manpowerLineItems.length -1; i++){
                                    helper.createComponent(component, event, helper,component.get("v.multipleFields")); 
                                }
                            }
                            
                        }
                    }
                }
            }else if (state === "ERROR") {
                let errors = response.getError();
                let message = 'Unknown error'; // Default error message
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                console.error(message);
            }
        });
        $A.enqueueAction(action);            
        
                    
    },
    createComponent: function(component,event,helper, multipleList){
       
        var additionalFields = component.get("v.additionalFieldsToDisplay");
    
        var totalNumberOfLines = component.get("v.numberOfLines");
            component.set("v.numberOfLines",totalNumberOfLines+1);
    
            var otherEmployeeDetailsCmp=[];
           otherEmployeeDetailsCmp = component.find('otherEmployeeDetailsCmp');
            //for loop here to get all the otherEmployee details components
            //Itrate over it and find all collapsible component , itrate over them and collapse.
        
            if(otherEmployeeDetailsCmp != null ){
                if(otherEmployeeDetailsCmp.length!=undefined && otherEmployeeDetailsCmp.length > 0){
                
                    for(var i=1;i<otherEmployeeDetailsCmp.length;i++){
                        var collapsibleCmp = otherEmployeeDetailsCmp[i].find('collapsibleCmp');
                        if(collapsibleCmp!=undefined){
                            collapsibleCmp.collapseAll();
                        }
                    }
                }else{
                    if(otherEmployeeDetailsCmp!=undefined ){
                        var collapsibleCmp = otherEmployeeDetailsCmp.find('collapsibleCmp');
                        if(collapsibleCmp!=undefined ){
                            collapsibleCmp.collapseAll();
                        }
                    }
                }
            }       
        
            $A.createComponent(
                "c:ET_OtherEmployeeDetails",{
                    "aura:id" : "otherEmployeeDetailsCmp",
                    "lineNumber" : component.get("v.numberOfLines"),
                    "multipleList" : multipleList,
                    "additionalFields" : additionalFields,
                    "otherEmployeeMasterDataMap" : component.get("v.otherEmployeeMasterDataMap"),
                    "isPricingTeam" :  component.get("v.isPricingTeam"),
                    "alterRatesObj": component.get("v.alterRatesWithServiceWrp"),
                     "quoteId" : component.get("v.quoteId"),
                    "editableFieldsByPricingTeam" : component.get("v.editableOtherEmployeeFieldsforPricingTeam")
    
                },
                function(newcomponent){
                    if (newcomponent.isValid()) {
                        var newCmp = component.find("cmpBody");
                        var body = newCmp.get("v.body");
                        body.push(newcomponent);
                        newCmp.set("v.body", body); 
                        
                        if(component.find("otherEmployeeDetailsCmp").length == undefined){
                            var commonOtherEmpInfoCmp = component.find("serviceRequestCommonCmpOtherEmp");
                            if(commonOtherEmpInfoCmp){
                                commonOtherEmpInfoCmp.set("v.isDisable", true);
                            }
                        }
                    }
                }            
            );
       }
    
})