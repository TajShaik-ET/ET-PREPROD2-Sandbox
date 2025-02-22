({
    processDoInit: function(component,event,helper){
        var action = component.get("c.getNannyMasterData");
        action.setCallback(this, function(obj){
            var state = obj.getState();
            if(state === 'SUCCESS'){
                var response = obj.getReturnValue();
                if(response!=null && response!= undefined){
                    component.set("v.nannyMasterDataMap", response);
                    console.log('nannyMasterDataMap = '+JSON.stringify(component.get("v.nannyMasterDataMap")));
                    
                    var commonCmp = component.find("serviceRequestCommonCmpNanny");
                    var commonInfoFromWrapper = component.get("v.commonInforReceivedFrmWrapper");
                    
                    if((component.get("v.commonFieldsToBePopulateLst") == undefined || component.get("v.commonFieldsToBePopulateLst").length == 0) && commonCmp == undefined){
                        var nannyRecords = new Map();
                        var routeList = [];
                        var nannyCommonInfo = commonInfoFromWrapper;
                        if(commonInfoFromWrapper['ET_Pricing_Method__c'] == 'Comprehensive Price per Route'){
                            routeList.push("Comprehensive Price per Route");
                        }
                        nannyRecords['nannyCommonInfo'] = nannyCommonInfo;
                        component.set("v.nannyRecords",nannyRecords); 
                        component.set("v.additionalFieldsToDisplay",routeList);
                        //component.set("v.multipleFields",fieldsWithMultipleValueLst );
                        var totalNumberOfLines = component.get("v.numberOfLines");
                        component.set("v.numberOfLines",totalNumberOfLines+1);
                        //  alert('doinit');
                        $A.createComponent(
                            "c:ET_SchoolBusNannyDetails",
                            {
                                "aura:id" : "schoolBusNannyDetailsCmp",
                                "lineNumber" : component.get("v.numberOfLines"),
                                "additionalFields" : routeList,
                                "nannyMasterDataMap" : component.get("v.nannyMasterDataMap"),
                                "editableFieldsByPricingTeam" : component.get("v.editableNannyFieldsforPricingTeam"),
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
                    var data = component.get("v.existingNannyTabData");
                    console.log('nanny existing data :'+JSON.stringify(data));
                    if(data != undefined && data != null){
                        if(data.manpowerCommonData != null){
                            component.set("v.existingNannyCommonData", data.manpowerCommonData);
                        }
                        if(data.manpowerLineItems != null){
                            component.set("v.existingNannyLineItems", data.manpowerLineItems);
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
        
        var nannyDetailsCmp=[];
        nannyDetailsCmp = component.find('schoolBusNannyDetailsCmp');
        //for loop here to get all the nanny details components
        //Itrate over it and find all collapsible component , itrate over them and collapse.
        
        if(nannyDetailsCmp != null ){
            if(nannyDetailsCmp.length!=undefined && nannyDetailsCmp.length > 0){
                
                for(var i=1;i<nannyDetailsCmp.length;i++){
                    var collapsibleCmp = nannyDetailsCmp[i].find('collapsibleCmp');
                    if(collapsibleCmp!=undefined){
                        collapsibleCmp.collapseAll();
                    }
                }
            }else{
                if(nannyDetailsCmp!=undefined ){
                    var collapsibleCmp = nannyDetailsCmp.find('collapsibleCmp');
                    if(collapsibleCmp!=undefined ){
                        collapsibleCmp.collapseAll();
                    }
                }
            }
        }       
        
        $A.createComponent(
            "c:ET_SchoolBusNannyDetails",{
                "aura:id" : "schoolBusNannyDetailsCmp",
                "lineNumber" : component.get("v.numberOfLines"),
                "multipleList" : multipleList,
                "additionalFields" : additionalFields,
                "nannyMasterDataMap" : component.get("v.nannyMasterDataMap"),
                "editableFieldsByPricingTeam" : component.get("v.editableNannyFieldsforPricingTeam"),
                "isPricingTeam" :component.get("v.isPricingTeam"),
                "quoteId" : component.get("v.quoteId"),
                "alterRatesObj": component.get("v.alterRatesWithServiceWrp")
                
            },
            function(newcomponent){
                if (newcomponent.isValid()) {
                    var newCmp = component.find("cmpBody");
                    var body = newCmp.get("v.body");
                    body.push(newcomponent);
                    newCmp.set("v.body", body);            
                    
                    if(component.find("schoolBusNannyDetailsCmp").length == undefined){
                        var commonNannyInfoCmp = component.find("serviceRequestCommonCmpNanny");
                        if(commonNannyInfoCmp){
                            commonNannyInfoCmp.set("v.isDisable", true);
                        }
                    }
                }
            }            
        );
    },
    
    copyNannyHelper : function(component, event, helper) {
        var lastLineData = helper.getLatestManpowerData(component, event, helper);
        debugger;
        console.log('lastLineData 158 = '+ JSON.stringify(lastLineData));
        var newLineNumber ;
        if(lastLineData.ET_Workforce_Line_Info__c != undefined){
            newLineNumber = Number(lastLineData['ET_Workforce_Line_Info__c'].split(':')[1]) +1;
        }
        else if(lastLineData.ET_Nanny_Line__c != undefined){
            newLineNumber = lastLineData.ET_Nanny_Line__c  + 1;
        }
        
        lastLineData['ET_Nanny_Line__c'] = newLineNumber;	
        lastLineData['sObjectType'] = 'ET_Work_force__c';	
        var deleteKeys = ['Id','ET_Pricing_Service_Request__c','ET_Service_Request_Common_Data__c','Specific_Workforce_Requirements__r',
                          'ET_Service_Request_Common_Data__r', 'Other_Cost_Requests__r', 'ET_Workforce_Line_Info__c',
                          'ET_Workforce_Record_Type_Name__c'];
        
        for(let key of deleteKeys){
            delete lastLineData[key];
        }
        
        var OtherCostRequests = lastLineData['ET_Other_Cost_Request__c'];
        if(OtherCostRequests && OtherCostRequests.length > 0){
            for(let otherCost of OtherCostRequests){
                delete otherCost['Work_force_Request__c'];
                delete otherCost['Id'];
                otherCost['sObjectType'] = 'ET_Other_Cost_Request__c';
            } 
        }
        var specialWorkForceRequests = lastLineData['ET_Special_Workforce_Requirement__c'];
        delete specialWorkForceRequests['Work_force_Request__c'];
        delete specialWorkForceRequests['Id'];
        specialWorkForceRequests['sObjectType'] = 'ET_Specific_Workforce_Requirement__c';
        console.log('lastLineData 185 = '+ JSON.stringify(lastLineData));
        this.createCopyComponent(component, event, helper, lastLineData);
    },
    
    createCopyComponent: function(component,event,helper,lastLineData ){
        
        var additionalFields = component.get("v.additionalFieldsToDisplay");
        
        var totalNumberOfLines = component.get("v.numberOfLines");
        component.set("v.numberOfLines",totalNumberOfLines+1);
        
        var schoolBusNannyDetailsCmp=[];
        schoolBusNannyDetailsCmp = component.find('schoolBusNannyDetailsCmp');
        //for loop here to get all the Nanny details components
        //Itrate over it and find all collapsible component , itrate over them and collapse.
        
        if(schoolBusNannyDetailsCmp != null ){
            if(schoolBusNannyDetailsCmp.length!=undefined && schoolBusNannyDetailsCmp.length > 0){
                
                for(var i=1;i<schoolBusNannyDetailsCmp.length;i++){
                    var collapsibleCmp = schoolBusNannyDetailsCmp[i].find('collapsibleCmp');
                    if(collapsibleCmp!=undefined){
                        collapsibleCmp.collapseAll();
                    }
                }
            }else{
                if(schoolBusNannyDetailsCmp!=undefined ){
                    var collapsibleCmp = schoolBusNannyDetailsCmp.find('collapsibleCmp');
                    if(collapsibleCmp!=undefined ){
                        collapsibleCmp.collapseAll();
                    }
                }
            }
        }       
        
        $A.createComponent(
            "c:ET_SchoolBusNannyDetails",{
                "aura:id" : "schoolBusNannyDetailsCmp",
                "lineNumber" : component.get("v.numberOfLines"),
                "additionalFields" : additionalFields,
                "nannyMasterDataMap" : component.get("v.nannyMasterDataMap"),
                "editableFieldsByPricingTeam" : component.get("v.editableDriverFieldsforPricingTeam"),
                "isPricingTeam" :  component.get("v.isPricingTeam"),
                "alterRatesObj": component.get("v.alterRatesWithServiceWrp"),
                "quoteId" : component.get("v.quoteId"),
                
            },
            function(newcomponent){
                if (newcomponent.isValid()) {
                    var newCmp = component.find("cmpBody");
                    var body = newCmp.get("v.body");
                    body.push(newcomponent);
                    newCmp.set("v.body", body);  
                    
                    if(component.find("schoolBusNannyDetailsCmp").length == undefined){
                        var commonNannyInfoCmp = component.find("serviceRequestCommonCmpDriver");
                        if(commonNannyInfoCmp){
                            commonNannyInfoCmp.set("v.isDisable", true);
                        }
                    }
                    
                }
            }            
        );
        
        // populate all data from currentLine, with a time delay...
        var delayInMilliseconds = 1000;
        window.setTimeout(
            $A.getCallback(function() {
                var schoolBusNannyDetailsCmp = component.find('schoolBusNannyDetailsCmp');
                for(var cmp of schoolBusNannyDetailsCmp){
                    if(cmp.get("v.lineNumber") == component.get("v.numberOfLines")){
                        cmp.prePopulateLineItemData(lastLineData);
                    }
                }
            }), delayInMilliseconds
        );  
        
    },
    
    
})