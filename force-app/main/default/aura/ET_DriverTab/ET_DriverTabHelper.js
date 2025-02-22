({
    processDoInit: function(component,event,helper){
        var action = component.get("c.getDriverMasterData");
        action.setCallback(this, function(obj){
            var state = obj.getState();
            if(state === 'SUCCESS'){
                var response = obj.getReturnValue();
                if(response!=null && response!= undefined){
                    component.set("v.driverMasterDataMap", response);
                    console.log('diver Master data : ' + JSON.stringify(component.get("v.driverMasterDataMap")));
                    var commonCmp = component.find("serviceRequestCommonCmpDriver");
                    var commonInfoFromWrapper = component.get("v.commonInforReceivedFrmWrapper"); // Not in use now //Mani
                    if((component.get("v.commonFieldsToBePopulateLst") == undefined || component.get("v.commonFieldsToBePopulateLst").length == 0) && commonCmp == undefined){
                        var driverRecords = new Map();
                        var routeList = [];
                        var driverCommonInfo = commonInfoFromWrapper;
                        if(commonInfoFromWrapper['ET_Pricing_Method__c'] == 'Comprehensive Price per Route'){
                            routeList.push("Comprehensive Price per Route");
                        }
                        driverRecords['driverCommonInfo'] = driverCommonInfo;
                        component.set("v.driverRecords",driverRecords); 
                        component.set("v.additionalFieldsToDisplay",routeList);
                        //component.set("v.multipleFields",fieldsWithMultipleValueLst);
                        var totalNumberOfLines = component.get("v.numberOfLines");
                        component.set("v.numberOfLines",totalNumberOfLines+1);
                        $A.createComponent(
                            "c:ET_DriverDetails",
                            {
                                "aura:id" : "driverDetailsCmp",
                                "lineNumber" : component.get("v.numberOfLines"),
                                "additionalFields" : routeList,
                                "driverMasterDataMap" : component.get("v.driverMasterDataMap"),
                                "editableFieldsByPricingTeam" : component.get("v.editableDriverFieldsforPricingTeam"),
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
                                }
                            }            
                        );
                    }
                    var data = component.get("v.existingDriverTabData");
                    console.log('driver existing data :'+JSON.stringify(data));
                    if(data != undefined && data != null){
                        if(data.manpowerCommonData != null){
                            component.set("v.existingDriverCommonData", data.manpowerCommonData);
                        }
                        if(data.manpowerLineItems != null){
                            component.set("v.existingDriverLineItems", data.manpowerLineItems);
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
        
        var driverDetailsCmp=[];
        driverDetailsCmp = component.find('driverDetailsCmp');
        //for loop here to get all the driver details components
        //Itrate over it and find all collapsible component , itrate over them and collapse.
        
        if(driverDetailsCmp != null ){
            if(driverDetailsCmp.length!=undefined && driverDetailsCmp.length > 0){
                
                for(var i=1;i<driverDetailsCmp.length;i++){
                    var collapsibleCmp = driverDetailsCmp[i].find('collapsibleCmp');
                    if(collapsibleCmp!=undefined){
                        collapsibleCmp.collapseAll();
                    }
                }
            }else{
                if(driverDetailsCmp!=undefined ){
                    var collapsibleCmp = driverDetailsCmp.find('collapsibleCmp');
                    if(collapsibleCmp!=undefined ){
                        collapsibleCmp.collapseAll();
                    }
                }
            }
        }       
        
        $A.createComponent(
            "c:ET_DriverDetails",{
                "aura:id" : "driverDetailsCmp",
                "lineNumber" : component.get("v.numberOfLines"),
                "multipleList" : multipleList,
                "additionalFields" : additionalFields,
                "driverMasterDataMap" : component.get("v.driverMasterDataMap"),
                "editableFieldsByPricingTeam" : component.get("v.editableDriverFieldsforPricingTeam"),
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
                    
                    if(component.find("driverDetailsCmp").length == undefined){
                        var commonDriverInfoCmp = component.find("serviceRequestCommonCmpDriver");
                        if(commonDriverInfoCmp){
                            commonDriverInfoCmp.set("v.isDisable", true);
                        }
                    }
                    
                }
            }            
        );
    },
    
    decreasDriverLineCount: function(component,event,helepr){
        var count = component.get("v.numberOfLines");
        component.set("v.numberOfLines",count-1);
        
        var deletedDriverLineNumber = event.getParam("deletedlineItemNumber");
        var driverDetailCmpLst = component.find("driverDetailsCmp");
        if(driverDetailCmpLst != undefined && driverDetailCmpLst.length > 0){
            for(var driverDetailCmp of driverDetailCmpLst){
                var driverDetailCmpLineNumber = driverDetailCmp.get("v.lineNumber");
                if(driverDetailCmpLineNumber > deletedDriverLineNumber){
                    driverDetailCmp.set("v.lineNumber", driverDetailCmpLineNumber-1);
                }
            }
        }
    },
    
    copyDriverHelper : function(component, event, helper) {
        var lastLineData = helper.getLatestManpowerData(component, event, helper);
        console.log('lastLineData 158 = '+ JSON.stringify(lastLineData));
        var newLineNumber ;
        if(lastLineData.ET_Workforce_Line_Info__c != undefined){
            newLineNumber = Number(lastLineData['ET_Workforce_Line_Info__c'].split(':')[1]) +1;
        }
        else if(lastLineData.ET_Driver_Line__c != undefined){
            newLineNumber = lastLineData.ET_Driver_Line__c  + 1;
        }
        
        lastLineData['ET_Driver_Line__c'] = newLineNumber;	
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
        
        var driverDetailsCmp=[];
        driverDetailsCmp = component.find('driverDetailsCmp');
        //for loop here to get all the driver details components
        //Itrate over it and find all collapsible component , itrate over them and collapse.
        
        if(driverDetailsCmp != null ){
            if(driverDetailsCmp.length!=undefined && driverDetailsCmp.length > 0){
                
                for(var i=1;i<driverDetailsCmp.length;i++){
                    var collapsibleCmp = driverDetailsCmp[i].find('collapsibleCmp');
                    if(collapsibleCmp!=undefined){
                        collapsibleCmp.collapseAll();
                    }
                }
            }else{
                if(driverDetailsCmp!=undefined ){
                    var collapsibleCmp = driverDetailsCmp.find('collapsibleCmp');
                    if(collapsibleCmp!=undefined ){
                        collapsibleCmp.collapseAll();
                    }
                }
            }
        }       
        
        $A.createComponent(
            "c:ET_DriverDetails",{
                "aura:id" : "driverDetailsCmp",
                "lineNumber" : component.get("v.numberOfLines"),
                "additionalFields" : additionalFields,
                "driverMasterDataMap" : component.get("v.driverMasterDataMap"),
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
                    
                    if(component.find("driverDetailsCmp").length == undefined){
                        var commonDriverInfoCmp = component.find("serviceRequestCommonCmpDriver");
                        if(commonDriverInfoCmp){
                            commonDriverInfoCmp.set("v.isDisable", true);
                        }
                    }
                    
                }
            }            
        );
        
        // populate all data from currentLine, with a time delay...
        var delayInMilliseconds = 1000;
        window.setTimeout(
            $A.getCallback(function() {
                var driverDetailsCmp = component.find('driverDetailsCmp');
                for(var cmp of driverDetailsCmp){
                    if(cmp.get("v.lineNumber") == component.get("v.numberOfLines")){
                        cmp.prePopulateLineItemData(lastLineData);
                    }
                }
            }), delayInMilliseconds
        );  
        
    },
    
    populateDataInCopyLine: function(component, event, helper,lineItemNumber,lastLineData) {
        var driverDetailsCmp = component.find('driverDetailsCmp');
        for(var cmp of driverDetailsCmp){
            if(cmp.get("v.lineNumber") == lineItemNumber){
                cmp.prePopulateLineItemData(lastLineData);
            }
        }
        
    },
    /* Method 	   : getManPowerLinesDetailsHelper
       Description : To filter and return Main Drivers to Driver Detail page - to attach Reliever Driver To Main Driver 
    */
    getManPowerLinesDetailsHelper : function(component,event,helper){
        var workForceLinesList = [];
        var childComponent =component.find('driverDetailsCmp');
        if(childComponent !=undefined && childComponent.length != undefined){
            for(var child of childComponent){
                console.log('workForceRecord = ' + JSON.stringify(child.get('v.workForceRecord')));
                if(child.get('v.workForceRecord.Type__c') == 'Main'){
                    var lineNumber ;
                    if(child.get('v.workForceRecord.ET_Driver_Line__c')){
                        lineNumber = child.get('v.workForceRecord.ET_Driver_Line__c');
                    }
                    else if(child.get('v.workForceRecord.ET_Workforce_Line_Info__c')){
                        lineNumber = child.get('v.workForceRecord.ET_Workforce_Line_Info__c').split(':')[1];
                    }
                    if(child.get('v.workForceRecord.ET_Driver_Category__c') && lineNumber  ){
                        var workforceLine = child.get('v.workForceRecord.ET_Driver_Category__c')+ '=>'+lineNumber;
                        workForceLinesList.push(workforceLine);
                    }
                }
            } 
        }
        else if( childComponent !=undefined && childComponent.length == undefined){
            if(childComponent.get('v.workForceRecord.Type__c') == 'Main'){
                var lineNumber ;
                if(childComponent.get('v.workForceRecord.ET_Driver_Line__c')){
                    lineNumber = childComponent.get('v.workForceRecord.ET_Driver_Line__c');
                }
                else if(childComponent.get('v.workForceRecord.ET_Workforce_Line_Info__c')){
                    lineNumber = childComponent.get('v.workForceRecord.ET_Workforce_Line_Info__c').split(':')[1];
                }
                if(childComponent.get('v.workForceRecord.ET_Driver_Category__c') && lineNumber  ){
                    var workforceLine = childComponent.get('v.workForceRecord.ET_Driver_Category__c')+ '=>'+lineNumber;
                    workForceLinesList.push(workforceLine);
                }
            }
        }
        // assign workforceLinesList to all driver lines
        if(childComponent !=undefined && childComponent.length != undefined){
            for(var child of childComponent){
                child.set("v.driverLineDetails", workForceLinesList);
            } 
        }
        else if( childComponent !=undefined && childComponent.length == undefined){
            childComponent.set("v.driverLineDetails",workForceLinesList);
        }
        
        console.log('workForceLinesList = '+ JSON.stringify(workForceLinesList));
    },
    
    
    
})