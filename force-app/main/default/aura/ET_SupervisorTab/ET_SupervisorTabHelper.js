({
    processDoInit: function(component,event,helper){
        var action = component.get("c.getSupervisorMasterData");
        action.setCallback(this, function(obj){
            var state = obj.getState();
            if(state === 'SUCCESS'){
                var response = obj.getReturnValue();
                if(response!=null && response!= undefined){
                    component.set("v.supervisorMasterDataMap", response);
                    console.log(JSON.stringify(component.get("v.supervisorMasterDataMap")));
                    
                    var commonCmp = component.find("serviceRequestCommonCmpSupervisor"); 
                    var commonInfoFromWrapper = component.get("v.commonInforReceivedFrmWrapper");
                    
                    if((component.get("v.commonFieldsToBePopulateLst") == undefined || component.get("v.commonFieldsToBePopulateLst").length == 0) && commonCmp == undefined){
                        var supervisorRecords = new Map();
                        var routeList = [];
                        var supervisorCommonInfo = commonInfoFromWrapper;
                        if(commonInfoFromWrapper['ET_Pricing_Method__c'] == 'Comprehensive Price per Route'){
                            routeList.push("Comprehensive Price per Route");
                        }
                        supervisorRecords['supervisorCommonInfo'] = supervisorCommonInfo;
                        component.set("v.supervisorRecords",supervisorRecords); 
                        component.set("v.additionalFieldsToDisplay",routeList);
                        //component.set("v.multipleFields",fieldsWithMultipleValueLst );
                        var totalNumberOfLines = component.get("v.numberOfLines");
                        component.set("v.numberOfLines",totalNumberOfLines+1);
                        //  alert('doinit');
                        $A.createComponent(
                            "c:ET_SupervisorDetails",
                            {
                                "aura:id" : "supervisorDetailsCmp",
                                "lineNumber" : component.get("v.numberOfLines"),
                                "additionalFields" : routeList,
                                "supervisorMasterDataMap" : component.get("v.supervisorMasterDataMap"),
                                "editableFieldsByPricingTeam" : component.get("v.editableSupervisorFieldsforPricingTeam"),
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
                    
                    var data = component.get("v.existingSupervisorTabData");
                    console.log('supervisor existing data :'+JSON.stringify(data));
                    if(data != undefined && data != null){
                        if(data.manpowerCommonData != null){
                            component.set("v.existingSupervisorCommonData", data.manpowerCommonData);
                        }
                        if(data.manpowerLineItems != null){
                            component.set("v.existingSupervisorLineItems", data.manpowerLineItems);
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
    
            var supervisorDetailsCmp=[];
           supervisorDetailsCmp = component.find('supervisorDetailsCmp');
            //for loop here to get all the supervisor details components
            //Itrate over it and find all collapsible component , itrate over them and collapse.
        
            if(supervisorDetailsCmp != null ){
                if(supervisorDetailsCmp.length!=undefined && supervisorDetailsCmp.length > 0){
                
                    for(var i=1;i<supervisorDetailsCmp.length;i++){
                        var collapsibleCmp = supervisorDetailsCmp[i].find('collapsibleCmp');
                        if(collapsibleCmp!=undefined){
                            collapsibleCmp.collapseAll();
                        }
                    }
                }else{
                    if(supervisorDetailsCmp!=undefined ){
                        var collapsibleCmp = supervisorDetailsCmp.find('collapsibleCmp');
                        if(collapsibleCmp!=undefined ){
                            collapsibleCmp.collapseAll();
                        }
                    }
                }
            }       
        
            $A.createComponent(
                "c:ET_SupervisorDetails",{
                    "aura:id" : "supervisorDetailsCmp",
                    "lineNumber" : component.get("v.numberOfLines"),
                    "multipleList" : multipleList,
                    "additionalFields" : additionalFields,
                    "supervisorMasterDataMap" : component.get("v.supervisorMasterDataMap"),
                    "quoteId" : component.get("v.quoteId"),
                    "editableFieldsByPricingTeam" : component.get("v.editableSupervisorFieldsforPricingTeam"),
                    "isPricingTeam" :  component.get("v.isPricingTeam"),
                    "alterRatesObj": component.get("v.alterRatesWithServiceWrp")
                },
                function(newcomponent){
                    if (newcomponent.isValid()) {
                        var newCmp = component.find("cmpBody");
                        var body = newCmp.get("v.body");
                        body.push(newcomponent);
                        newCmp.set("v.body", body);
                        
                        if(component.find("supervisorDetailsCmp").length == undefined){
                            var commonSupervisorInfoCmp = component.find("serviceRequestCommonCmpSupervisor");
                            if(commonSupervisorInfoCmp){
                                commonSupervisorInfoCmp.set("v.isDisable", true);
                            }
                        }
                    }
                }            
            );
       }
    
})