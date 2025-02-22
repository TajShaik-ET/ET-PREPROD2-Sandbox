({
    processDoInit: function(component,event,helper){
        var action = component.get("c.getCoordinatorMasterData");
        action.setCallback(this, function(obj){
            var state = obj.getState();
            if(state === 'SUCCESS'){
                var response = obj.getReturnValue();
                if(response!=null && response!= undefined){
                    component.set("v.coordinatorMasterDataMap", response);
                    console.log(JSON.stringify(component.get("v.coordinatorMasterDataMap")));
                    
                    var commonCmp = component.find("serviceRequestCommonCmpCoordinator");
                    var commonInfoFromWrapper = component.get("v.commonInforReceivedFrmWrapper");
                    
                    if((component.get("v.commonFieldsToBePopulateLst") == undefined || component.get("v.commonFieldsToBePopulateLst").length == 0) && commonCmp == undefined){
                        var coordinatorRecords = new Map();
                        var routeList = [];
                        var coordinatorCommonInfo = commonInfoFromWrapper;
                        if(commonInfoFromWrapper['ET_Pricing_Method__c'] == 'Comprehensive Price per Route'){
                            routeList.push("Comprehensive Price per Route");
                        }
                        coordinatorRecords['coordinatorCommonInfo'] = coordinatorCommonInfo;
                        component.set("v.coordinatorRecords",coordinatorRecords); 
                        component.set("v.additionalFieldsToDisplay",routeList);
                        //component.set("v.multipleFields",fieldsWithMultipleValueLst );
                        var totalNumberOfLines = component.get("v.numberOfLines");
                        component.set("v.numberOfLines",totalNumberOfLines+1);
                        //  alert('doinit');
                        $A.createComponent(
                            "c:ET_CoordinatorDetails",
                            {
                                "aura:id" : "coordinatorDetailsCmp",
                                "lineNumber" : component.get("v.numberOfLines"),
                                "additionalFields" : routeList,
                                "coordinatorMasterDataMap" : component.get("v.coordinatorMasterDataMap"),
                                "editableFieldsByPricingTeam" : component.get("v.editableCoordinatorFieldsforPricingTeam"),
                                "isPricingTeam" :  component.get("v.isPricingTeam"),
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
                    var data = component.get("v.existingCoordinatorTabData");
                    console.log('coordinator existing data :'+JSON.stringify(data));
                    if(data != undefined && data != null){
                        if(data.manpowerCommonData != null){
                            component.set("v.existingCoordinatorCommonData", data.manpowerCommonData);
                        }
                        if(data.manpowerLineItems != null){
                            component.set("v.existingCoordinatorLineItems", data.manpowerLineItems);
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
    
            var coordinatorDetailsCmp=[];
           coordinatorDetailsCmp = component.find('schoolBuscoordinatorDetailsCmp');
            //for loop here to get all the coordinator details components
            //Itrate over it and find all collapsible component , itrate over them and collapse.
        
            if(coordinatorDetailsCmp != null ){
                if(coordinatorDetailsCmp.length!=undefined && coordinatorDetailsCmp.length > 0){
                
                    for(var i=1;i<coordinatorDetailsCmp.length;i++){
                        var collapsibleCmp = coordinatorDetailsCmp[i].find('collapsibleCmp');
                        if(collapsibleCmp!=undefined){
                            collapsibleCmp.collapseAll();
                        }
                    }
                }else{
                    if(coordinatorDetailsCmp!=undefined ){
                        var collapsibleCmp = coordinatorDetailsCmp.find('collapsibleCmp');
                        if(collapsibleCmp!=undefined ){
                            collapsibleCmp.collapseAll();
                        }
                    }
                }
            }       
        
            $A.createComponent(
                "c:ET_CoordinatorDetails",{
                    "aura:id" : "coordinatorDetailsCmp",
                    "lineNumber" : component.get("v.numberOfLines"),
                    "multipleList" : multipleList,
                    "additionalFields" : additionalFields,
                    "coordinatorMasterDataMap" : component.get("v.coordinatorMasterDataMap"),
                    "editableFieldsByPricingTeam" : component.get("v.editableCoordinatorFieldsforPricingTeam"),
                    "isPricingTeam" :  component.get("v.isPricingTeam"),
                    "alterRatesObj": component.get("v.alterRatesWithServiceWrp"),
                    "quoteId" : component.get("v.quoteId")
                    
                },
                function(newcomponent){
                    if (newcomponent.isValid()) {
                        var newCmp = component.find("cmpBody");
                        var body = newCmp.get("v.body");
                        body.push(newcomponent);
                        newCmp.set("v.body", body); 
                        
                        if(component.find("coordinatorDetailsCmp").length == undefined){
                            var commonCoordinatorInfoCmp = component.find("serviceRequestCommonCmpCoordinator");
                            if(commonCoordinatorInfoCmp){
                                commonCoordinatorInfoCmp.set("v.isDisable", true);
                            }
                        }
                    }
                }            
            );
       }
    
})