({
    processDoInit: function(component,event,helper){
        debugger;
        var data = component.get("v.existingVehicleTabData");
        if(data != undefined && data != null){
            var fleetType;
            if(data.vehicleCommonData != null){
                component.set("v.existingVehicleCommonData", data.vehicleCommonData);
                //alert(JSON.stringify(data.vehicleCommonData));
                fleetType = data.vehicleCommonData.ET_Fleet_Type__c ;
                if(fleetType != null){
                    component.set("v.fleetType", fleetType);
                }
            }
            if(data.vehicleLineItems != null){
                component.set("v.existingVehicleLineItems", data.vehicleLineItems);
                if(component.get("v.commonFieldsToBePopulateLst") == null || component.get("v.commonFieldsToBePopulateLst").length == 0){
                    var vehicleRecords = helper.getTabCommonData(component,event,helper);
                    if(vehicleRecords){ 
                        component.set("v.vehicleRecords",vehicleRecords);
                        var multipleFieldIds = component.get("v.multipleFields");
                        if(fleetType && fleetType == 'Multiple'){
                            if(!multipleFieldIds){
                                multipleFieldIds = [];
                            }
                            multipleFieldIds.push('ET_Fleet_Type__c');
                        }
                        for(var item of data.vehicleLineItems){
                            helper.createComponent(component, event, helper,multipleFieldIds); 
                        }
                    }
                }
                
            }
        }
    },
    verifySpecificVehicleInfo: function(component,event, helper){
        var vehicleSpecificCommonFieldLst = [];
        vehicleSpecificCommonFieldLst.push(component.find("ET_Fleet_Type__c"));
        var allValid = vehicleSpecificCommonFieldLst.reduce(function (validSoFar, inputCmp) {            
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true); 
        return allValid;
        
    },
    /* 
     Method : copyVehicleHelper
     Description : To copy the Vehicle line 
    */
    copyVehicleHelper : function(component, event, helper) {
        this.getLatestVehicleLineDetails(component, event, helper);
        var lastLineData = component.get('v.vehicleCopyRecords')['VehicleLastLine'];
        let newLineNumber = lastLineData['ET_Vehicle_Line__c'] +1;
        if(newLineNumber < 21){
            lastLineData['ET_Vehicle_Line__c'] = newLineNumber;	
            lastLineData['sObjectType'] = 'Vehicle__c';	
            //In case of cloning - already saved data - delete all existing ids from given wrapper
            var deleteKeys = ['Id','ET_Pricing_Service_Request__c','ET_Service_Request_Common_Data__c','ET_Pricing_Service_Request__r',
                              'ET_Service_Request_Common_Data__r', 'Other_Cost_Requests__r' ];
            
            for(let key of deleteKeys){
                delete lastLineData[key];
            }
            
            var OtherCostRequests2 = lastLineData['ET_Other_Cost_Request__c'];
            if(OtherCostRequests2 && OtherCostRequests2.length > 0){
                for(let otherCost of OtherCostRequests2){
                    delete otherCost['Vehicle_Request__c'];
                    delete otherCost['Id'];
                    otherCost['sObjectType'] = 'ET_Other_Cost_Request__c';
                } 
            }
            debugger;
            this.createCopyComponent(component, event, helper, lastLineData);
        }else{
            var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"warning",
                "title":"warning",
                "message":"You cannot add more than 20 Vehicles",
                "mode":"sticky"
            });
            toastReference.fire();
            
            
        }
    },
    
    
    getLatestVehicleLineDetails : function(component, event, helper) {
        debugger;
        var vehicleDetailsChildCmp=[];
        var vehicleDetailsCmp=[];
        // get all existing Vehicle lines...
        vehicleDetailsChildCmp = component.find("vehicleDetailsCmp");
        
        // if only one line 
        if(vehicleDetailsChildCmp != undefined && vehicleDetailsChildCmp.length == undefined){
            vehicleDetailsCmp = vehicleDetailsChildCmp;
        }
        
        // if multiple lines present - assign latest vehicle line to 'vehicleDetailsCmp'..
        if(vehicleDetailsChildCmp != undefined && vehicleDetailsChildCmp.length != undefined && vehicleDetailsChildCmp.length >0){
            let noOfChildCmpns = vehicleDetailsChildCmp.length ;
            vehicleDetailsCmp = vehicleDetailsChildCmp[noOfChildCmpns-1];
        }
        
        // get common info in Vehicle
        var vehicleRecords = helper.getTabCommonData(component,event,helper);
        
        
        if(vehicleRecords){
            var fleetType = component.get("v.fleetType");
            if(fleetType){
                var multipleFieldIds = component.get("v.multipleFields"); 
                
                if(fleetType == 'Multiple'){
                    if(!multipleFieldIds){
                        multipleFieldIds = [];
                    }
                    multipleFieldIds.push('ET_Fleet_Type__c');
                }
                component.set("v.vehicleCopyRecords",vehicleRecords);
            }
        }
        
        var vehicleRecordMap = component.get("v.vehicleCopyRecords");
        
        // extract and prepare latest line data in 'vehicleCopyRecords' wrapper Map
        if( vehicleRecordMap != undefined && vehicleRecordMap['vehicleCommonInfo'] != null){
            var commonVehicleData = vehicleRecordMap['vehicleCommonInfo'];
            if(vehicleDetailsCmp != undefined && vehicleDetailsCmp.length == undefined  && vehicleDetailsCmp.find("collapsibleCmp") != undefined){
                var originalRec = vehicleDetailsCmp.get("v.vehicleLine");
                // create a duplicate object(Vehicle line) with last Vehicle line..
                var record = Object.assign({}, originalRec); 
                for(let key in record){
                    if((record[key] == null || record[key] == '' || record[key] == 0) && commonVehicleData[key] != ''){
                        record[key] = commonVehicleData[key];
                    }
                }
                for(let key in commonVehicleData){
                    if((record[key] == null || record[key] == '' || record[key] == 0) && commonVehicleData[key] != null && commonVehicleData[key] != ''){
                        record[key] = commonVehicleData[key];
                    }
                }
                
                if( vehicleDetailsCmp.get("v.contractValue") != undefined &&  vehicleDetailsCmp.get("v.contractValue") != null && (commonVehicleData['ET_Contract_Period__c']).includes('Multiple') ){
                    record['ET_Contract_Period__c'] =  vehicleDetailsCmp.get("v.contractValue");
                }else if(commonVehicleData['ET_Contract_Period__c'] != undefined && commonVehicleData['ET_Contract_Period__c'] != ''){
                    record['ET_Contract_Period__c'] = commonVehicleData['ET_Contract_Period__c'];
                }
                
                if(vehicleDetailsCmp.get("v.displaySpecialRequirements")){
                    record = helper.addSpecialRequirementsInVehicleRecord(vehicleDetailsCmp,record);
                }
                var otherCostsCmpList = vehicleDetailsCmp.find("vehicleOtherCostCmp");
                var otherCostDataList = [];
                if(otherCostsCmpList != undefined && otherCostsCmpList.length == undefined){
                    // create a new object with existing object -- to avoid copy by reference...
                    var otherCostData  = Object.assign({}, otherCostsCmpList.get("v.otherCostTabSpecificRecords")) ;
                    if(otherCostData && vehicleDetailsCmp.get("v.displaySpecialRequirements")){
                        if(otherCostsCmpList.get("v.costTypeValue")){
                            otherCostData['ET_Cost_Type__c'] = otherCostsCmpList.get("v.costTypeValue");
                        }
                        otherCostData['Other_Cost_Type__c'] = 'Dynamic';
                        otherCostDataList.push(otherCostData);
                    }
                }else if(otherCostsCmpList != undefined && otherCostsCmpList.length > 0){
                    for(var i=0; i < otherCostsCmpList.length; i++ ){
                        // create a new object with existing object -- to avoid copy by reference...
                        var otherCostData  = Object.assign({}, otherCostsCmpList[i].get("v.otherCostTabSpecificRecords")) ;
                        if(otherCostData && vehicleDetailsCmp.get("v.displaySpecialRequirements")){
                            if(otherCostsCmpList[i].get("v.costTypeValue")){
                                otherCostData['ET_Cost_Type__c'] = otherCostsCmpList[i].get("v.costTypeValue");
                            }
                            otherCostData['Other_Cost_Type__c'] = 'Dynamic';
                            otherCostDataList.push(otherCostData);
                        }
                    }
                }
                
                var predefinedOtherCostlst = vehicleDetailsCmp.find("vehicleReqCmp");
                if(predefinedOtherCostlst != undefined && predefinedOtherCostlst.length == undefined){
                    var predefinedCostData  = Object.assign({}, predefinedOtherCostlst.get("v.predefinedOtherCostRecord")) ;
                    if(predefinedCostData && vehicleDetailsCmp.get("v.displaySpecialRequirements")){
                        if(predefinedOtherCostlst.get("v.costTypeValue")){
                            predefinedCostData['ET_Cost_Type__c'] = predefinedOtherCostlst.get("v.costTypeValue");
                        }
                        predefinedCostData['Other_Cost_Type__c'] = 'Predefined';
                        otherCostDataList.push(predefinedCostData);
                    }
                }else if(predefinedOtherCostlst != undefined && predefinedOtherCostlst.length > 0){
                    for(var i=0; i < predefinedOtherCostlst.length; i++ ){
                        var predefinedCostData  = Object.assign({}, predefinedOtherCostlst[i].get("v.predefinedOtherCostRecord")) ;
                        if(predefinedCostData && vehicleDetailsCmp.get("v.displaySpecialRequirements")){
                            if(predefinedOtherCostlst[i].get("v.costTypeValue")){
                                predefinedCostData['ET_Cost_Type__c'] = predefinedOtherCostlst[i].get("v.costTypeValue");
                            }
                            predefinedCostData['Other_Cost_Type__c'] = 'Predefined';
                            otherCostDataList.push(predefinedCostData);
                        }
                    }
                }
                if(otherCostDataList  && otherCostDataList.length > 0){
                    record['ET_Other_Cost_Request__c'] = otherCostDataList;
                }
                vehicleRecordMap['VehicleLastLine'] = record;
            }
            component.set('v.vehicleCopyRecords' ,vehicleRecordMap );
        }
        
    },
    
    getDataHelper : function(component, event, helper) {
        var vehicleDetailsCmp=[];
        vehicleDetailsCmp = component.find("vehicleDetailsCmp");
        var vehicleRecordMap = component.get("v.vehicleRecords");
        var vehicleRecordLst = [];
        var deletedVehicleDetailCmpIdLst = component.get("v.deletedVehicleChildDetailCmpList");
        
        if(helper.validateAllDetails(component,event,helper) && vehicleRecordMap != undefined && vehicleRecordMap['vehicleCommonInfo'] != null){
            var commonVehicleData = vehicleRecordMap['vehicleCommonInfo'];
            if(vehicleDetailsCmp != undefined && vehicleDetailsCmp.length == undefined  && vehicleDetailsCmp.find("collapsibleCmp") != undefined){
                var record = vehicleDetailsCmp.get("v.vehicleLine");
                // check if annual Target Price field filled or not, if Request for Target price selected..
                // In case of any error - show the message and report Validity and stop the execution...
                if(component.get("v.showAnnualTargetPrice") && !record.ET_Annual_Target_Price__c){
                    var toastReference = $A.get("e.force:showToast");
                    toastReference.setParams({
                        "type":"error",
                        "title":"error",
                        "message":"Please fill Annual Target Price in Vehicle details",
                        "mode":"sticky"
                    });
                    toastReference.fire();
                    vehicleDetailsCmp.find('annualTargetPrice').reportValidity();
                    return;     
                }
                for(let key in record){
                    if(key != 'Vehicle_Notes__c' &&(record[key] == null || record[key] == '' ) && commonVehicleData[key] != ''){
                        record[key] = commonVehicleData[key];
                    }
                }
                for(let key in commonVehicleData){
                    if(key != 'Vehicle_Notes__c' &&(record[key] == null || record[key] == '') && commonVehicleData[key] != null && commonVehicleData[key] != ''){
                        record[key] = commonVehicleData[key];
                    }
                }
                if( vehicleDetailsCmp.get("v.contractValue") != undefined &&  vehicleDetailsCmp.get("v.contractValue") != null && (commonVehicleData['ET_Contract_Period__c']).includes('Multiple') ){
                    record['ET_Contract_Period__c'] =  vehicleDetailsCmp.get("v.contractValue");
                }else if(commonVehicleData['ET_Contract_Period__c'] != undefined && commonVehicleData['ET_Contract_Period__c'] != ''){
                    record['ET_Contract_Period__c'] = commonVehicleData['ET_Contract_Period__c'];
                }
                
                if(vehicleDetailsCmp.get("v.displaySpecialRequirements")){
                    record = helper.addSpecialRequirementsInVehicleRecord(vehicleDetailsCmp,record);
                }
                var otherCostsCmpList = vehicleDetailsCmp.find("vehicleOtherCostCmp");
                var otherCostDataList = [];
                if(otherCostsCmpList != undefined && otherCostsCmpList.length == undefined){
                    var otherCostData  = otherCostsCmpList.get("v.otherCostTabSpecificRecords");
                    if(otherCostData && vehicleDetailsCmp.get("v.displaySpecialRequirements")){
                        if(otherCostsCmpList.get("v.costTypeValue")){
                            otherCostData['ET_Cost_Type__c'] = otherCostsCmpList.get("v.costTypeValue");
                        }
                        otherCostData['Other_Cost_Type__c'] = 'Dynamic';
                        otherCostDataList.push(otherCostData);
                    }
                }else if(otherCostsCmpList != undefined && otherCostsCmpList.length > 0){
                    for(var i=0; i < otherCostsCmpList.length; i++ ){
                        var otherCostData  = otherCostsCmpList[i].get("v.otherCostTabSpecificRecords");
                        if(otherCostData && vehicleDetailsCmp.get("v.displaySpecialRequirements")){
                            if(otherCostsCmpList[i].get("v.costTypeValue")){
                                otherCostData['ET_Cost_Type__c'] = otherCostsCmpList[i].get("v.costTypeValue");
                            }
                            otherCostData['Other_Cost_Type__c'] = 'Dynamic';
                            otherCostDataList.push(otherCostData);
                        }
                    }
                }
                
                var predefinedOtherCostlst = vehicleDetailsCmp.find("vehicleReqCmp");
                if(predefinedOtherCostlst != undefined && predefinedOtherCostlst.length == undefined){
                    var predefinedCostData  = predefinedOtherCostlst.get("v.predefinedOtherCostRecord");
                    if(predefinedCostData && vehicleDetailsCmp.get("v.displaySpecialRequirements")){
                        if(predefinedOtherCostlst.get("v.costTypeValue")){
                            predefinedCostData['ET_Cost_Type__c'] = predefinedOtherCostlst.get("v.costTypeValue");
                        }
                        predefinedCostData['Other_Cost_Type__c'] = 'Predefined';
                        otherCostDataList.push(predefinedCostData);
                    }
                }else if(predefinedOtherCostlst != undefined && predefinedOtherCostlst.length > 0){
                    for(var i=0; i < predefinedOtherCostlst.length; i++ ){
                        var predefinedCostData  = predefinedOtherCostlst[i].get("v.predefinedOtherCostRecord");
                        if(predefinedCostData && vehicleDetailsCmp.get("v.displaySpecialRequirements")){
                            if(predefinedOtherCostlst[i].get("v.costTypeValue")){
                                predefinedCostData['ET_Cost_Type__c'] = predefinedOtherCostlst[i].get("v.costTypeValue");
                            }
                            predefinedCostData['Other_Cost_Type__c'] = 'Predefined';
                            otherCostDataList.push(predefinedCostData);
                        }
                    }
                }   
                if(otherCostDataList && otherCostDataList.length > 0){
                    record['ET_Other_Cost_Request__c'] = otherCostDataList;
                }
                vehicleRecordLst.push(record);
                vehicleRecordMap['vehicleTabInfo'] = vehicleRecordLst;
            }
            
            // vehicle lines data - operation
            else if(vehicleDetailsCmp != undefined && vehicleDetailsCmp.length >0){
                for(var i=0;i<vehicleDetailsCmp.length;i++){
                    var record = new Object();
                    
                    if(vehicleDetailsCmp[i] != undefined && vehicleDetailsCmp[i].find("collapsibleCmp") != undefined){
                        record = vehicleDetailsCmp[i].get("v.vehicleLine");
                        // check if annual Target Price field filled or not, if Request for Target price selected..
                        // In case of any error - show the message and report Validity and stop the execution...
                        if(component.get("v.showAnnualTargetPrice") && !record.ET_Annual_Target_Price__c){
                            var toastReference = $A.get("e.force:showToast");
                            toastReference.setParams({
                                "type":"error",
                                "title":"error",
                                "message":"Please fill Annual Target Price in Vehicle details",
                                "mode":"sticky"
                            });
                            toastReference.fire();
                            for(var j=0;j<vehicleDetailsCmp.length;j++){
                                vehicleDetailsCmp[j].find('annualTargetPrice').reportValidity();
                            }
                            return;     
                        }
                        for(let key in record){
                            if(key != 'Vehicle_Notes__c' && key != 'Add_Trailer_Equipment__c' && key != 'Add_Refregirator__c'  && (record[key] == null || record[key] == '') && commonVehicleData[key] != ''){
                                record[key] = commonVehicleData[key];
                            } 
                        }
                        for(let key in commonVehicleData){
                            if(key != 'Vehicle_Notes__c' && key != 'Add_Trailer_Equipment__c' && key != 'Add_Refregirator__c' && (record[key] == null || record[key] == '' ) && commonVehicleData[key] != null && commonVehicleData[key] != '' ){
                                record[key] = commonVehicleData[key];
                            }
                        }
                        
                        console.log('record 164 = '+ JSON.stringify(record));
                        if( vehicleDetailsCmp[i].get("v.contractValue") != undefined &&  vehicleDetailsCmp[i].get("v.contractValue") != null && (commonVehicleData['ET_Contract_Period__c']).includes('Multiple') ){
                            record['ET_Contract_Period__c'] =  vehicleDetailsCmp[i].get("v.contractValue");
                        }else if(commonVehicleData['ET_Contract_Period__c'] != undefined && commonVehicleData['ET_Contract_Period__c'] != ''){
                            record['ET_Contract_Period__c'] = commonVehicleData['ET_Contract_Period__c'];
                        }
                        
                        console.log('record 165 = '+ JSON.stringify(record));
                        if(vehicleDetailsCmp[i].get("v.displaySpecialRequirements")){
                            record = helper.addSpecialRequirementsInVehicleRecord(vehicleDetailsCmp[i],record);
                        }
                        console.log('record 166 = '+ JSON.stringify(record));
                        var otherCostsCmpList = vehicleDetailsCmp[i].find("vehicleOtherCostCmp");
                        //console.log('otherCostsCmpList>> ',JSON.stringify(otherCostsCmpList));
                        var otherCostDataList = [];
                        
                        if(otherCostsCmpList != undefined && otherCostsCmpList.length == undefined){
                            var otherCostData  = otherCostsCmpList.get("v.otherCostTabSpecificRecords");
                            if(otherCostData && vehicleDetailsCmp[i].get("v.displaySpecialRequirements")){
                                if(otherCostsCmpList.get("v.costTypeValue")){
                                    otherCostData['ET_Cost_Type__c'] = otherCostsCmpList.get("v.costTypeValue");
                                }
                                otherCostData['Other_Cost_Type__c'] = 'Dynamic';
                                otherCostDataList.push(otherCostData);
                            }
                        }
                        else if(otherCostsCmpList != undefined && otherCostsCmpList.length > 0){
                            for(var j=0; j < otherCostsCmpList.length; j++ ){
                                var otherCostData  = otherCostsCmpList[j].get("v.otherCostTabSpecificRecords");
                                if(otherCostData && vehicleDetailsCmp[i].get("v.displaySpecialRequirements")){
                                    if(otherCostsCmpList[j].get("v.costTypeValue")){
                                        otherCostData['ET_Cost_Type__c'] = otherCostsCmpList[j].get("v.costTypeValue");
                                    }
                                    otherCostData['Other_Cost_Type__c'] = 'Dynamic';
                                    otherCostDataList.push(otherCostData);
                                }
                            }
                        }
                        var predefinedOtherCostlst = vehicleDetailsCmp[i].find("vehicleReqCmp");
                        //console.log('predefinedOtherCostlst>> ',JSON.stringify(predefinedOtherCostlst));
                        if(predefinedOtherCostlst != undefined && predefinedOtherCostlst.length == undefined){
                           // console.log('predefinedOtherCostlst 222@@ :  ',JSON.stringify(predefinedOtherCostlst));
                            var predefinedCostData  = predefinedOtherCostlst.get("v.predefinedOtherCostRecord");
                           // console.log('predefinedCostData @@ :  ',JSON.stringify(predefinedCostData));
                            if(predefinedCostData && vehicleDetailsCmp[i].get("v.displaySpecialRequirements")){
                                console.log('INNN @@ ');
                                if(predefinedOtherCostlst.get("v.costTypeValue")){
                                    predefinedCostData['ET_Cost_Type__c'] = predefinedOtherCostlst.get("v.costTypeValue");
                                }
                                predefinedCostData['Other_Cost_Type__c'] = 'Predefined';
                                otherCostDataList.push(predefinedCostData);
                            }
                        }
                        else if(predefinedOtherCostlst != undefined && predefinedOtherCostlst.length > 0){
                            for(var j=0; j < predefinedOtherCostlst.length; j++ ){
                                debugger;
                                var predefinedCostData  = predefinedOtherCostlst[j].get("v.predefinedOtherCostRecord");
                                if(predefinedCostData && vehicleDetailsCmp[i].get("v.displaySpecialRequirements")){
                                    debugger;
                                  //  console.log('predefinedOtherCostlst[j].get("v.costTypeValue") = '+ predefinedOtherCostlst[j].get("v.costTypeValue"));
                                    if(predefinedOtherCostlst[j].get("v.costTypeValue")){
                                        predefinedCostData['ET_Cost_Type__c'] = predefinedOtherCostlst[j].get("v.costTypeValue");
                                    }
                                    predefinedCostData['Other_Cost_Type__c'] = 'Predefined';
                                    otherCostDataList.push(predefinedCostData);
                                }
                            }
                        } 
                        console.log('record 382 = '+ JSON.stringify(record));
                        console.log('otherCostDataList :  ',JSON.stringify(component.get("v.otherCostDataList")));
                        if(otherCostDataList.length > 0){
                            record['ET_Other_Cost_Request__c'] = otherCostDataList;
                        }
                        console.log('record 239 = '+ JSON.stringify(record));
                        debugger;
                        vehicleRecordLst.push(record);
                    }
                }
                vehicleRecordMap['vehicleTabInfo'] = vehicleRecordLst;
                vehicleRecordMap['deletedVehicleCmpIds']  = deletedVehicleDetailCmpIdLst;
            }
            // vehicleRecordMap[''] = 
            component.set('v.vehicleRecords', vehicleRecordMap );
            console.log('vehicleRecordMap 281:  ',JSON.stringify(component.get("v.vehicleRecords")));
            debugger;
            return vehicleRecordMap;
        }
        return null;
        
    },
    
    addSpecialRequirementsInVehicleRecord : function(vehicleDetailsCmp, record){
        var annualSpecRequirementLstCommaSeparated = vehicleDetailsCmp.get("v.selectedAnnualSpecReqLst");
        var onetimeSpecRequirementLstCommaSeparated = vehicleDetailsCmp.get("v.selectedOnetimeSpecReqLst");
        
        if(annualSpecRequirementLstCommaSeparated){
            record['ET_Other_Annual_Requirement__c'] = annualSpecRequirementLstCommaSeparated;
        }
        if(onetimeSpecRequirementLstCommaSeparated){
            record['ET_Other_One_Time_Requirement__c'] = onetimeSpecRequirementLstCommaSeparated;
        }
        return record;
    },
    
    createCopyComponent : function(component, event, helper,lastLineData) {
        var additionalFields = component.get("v.additionalFieldsToDisplay");
        var vehicleDetailsCmp=[];
        vehicleDetailsCmp = component.find('vehicleDetailsCmp');
        //for loop here to get all the vehicle details components
        //Itrate over it and find all collapsible component , itrate over them and collapse.
        if(vehicleDetailsCmp != null){
            if(vehicleDetailsCmp!=undefined && vehicleDetailsCmp.length!=undefined && vehicleDetailsCmp.length > 0){
                
                for(var i=1;i<vehicleDetailsCmp.length;i++){
                    var collapsibleCmp = vehicleDetailsCmp[i].find('collapsibleCmp');
                    if(collapsibleCmp!=undefined){
                        collapsibleCmp.collapseAll();
                    }
                }
            }else{
                if(vehicleDetailsCmp!=undefined ){
                    var collapsibleCmp = vehicleDetailsCmp.find('collapsibleCmp');
                    if(collapsibleCmp!=undefined){
                        collapsibleCmp.collapseAll();
                    }
                }
            }
        }
        var count = component.get("v.numberOfLines");
        count = count + 1;
        component.set("v.numberOfLines",count);
        $A.createComponent(
            "c:ET_VehicleDetails",{
                "aura:id" : "vehicleDetailsCmp",
                "lineNumber" : component.get("v.numberOfLines"),
                "additionalFields" : additionalFields,
                "editableFieldsByPricingTeam": component.get("v.editableVehicleFieldsforPricingTeam"),
                "isPricingTeam" :  component.get("v.isPricingTeam"),
                "alterRatesObj": component.get("v.alterRatesWithServiceWrp"),
                "predefinedOtherCostMasterData": component.get("v.predefinedOtherCostMasterData"),
                "quoteId" : component.get("v.quoteId"),
                "OpprecordTypeName" : component.get("v.OpprecordTypeName"),
                "showAnnualTargetPrice" : component.get("v.showAnnualTargetPrice"),
                "vehicleLine": lastLineData
            },
            function(newcomponent){
                if (newcomponent.isValid()) {
                    var newCmp = component.find("cmpBody");
                    var body = newCmp.get("v.body");
                    body.push(newcomponent);
                    newCmp.set("v.body", body);
                    
                    if(component.find("vehicleDetailsCmp").length == undefined){
                        var commonVehicleInfoCmp = component.find("serviceRequestCommonCmpVehicle");
                        component.set("v.fleetTypeDisabled",true);
                        if(commonVehicleInfoCmp){
                            commonVehicleInfoCmp.set("v.isDisable", true);
                        }
                    }
                }
            }            
        );
        
        // populate all data from currentLine
        this.populateDataInCopyLine(component, event, helper,component.get("v.numberOfLines"),lastLineData);
        
    },
    
    populateDataInCopyLine: function(component, event, helper,lineItemNumber,lastLineData) {
        var vehicleDeatilCmps = component.find('vehicleDetailsCmp');
        for(var cmp of vehicleDeatilCmps){
            if(cmp.get("v.lineNumber") == lineItemNumber){
                cmp.prePopulateVehicleData(lastLineData);
            }
        }
        
    },
    
    createComponent : function(component, event, helper,multipleList) {
        debugger;
        var additionalFields = component.get("v.additionalFieldsToDisplay");
        var vehicleDetailsCmp=[];
        vehicleDetailsCmp = component.find('vehicleDetailsCmp');
        //for loop here to get all the vehicle details components
        //Itrate over it and find all collapsible component , itrate over them and collapse.
        if(vehicleDetailsCmp != null){
            if(vehicleDetailsCmp!=undefined && vehicleDetailsCmp.length!=undefined && vehicleDetailsCmp.length > 0){
                
                for(var i=1;i<vehicleDetailsCmp.length;i++){
                    var collapsibleCmp = vehicleDetailsCmp[i].find('collapsibleCmp');
                    if(collapsibleCmp!=undefined){
                        collapsibleCmp.collapseAll();
                    }
                }
            }else{
                if(vehicleDetailsCmp!=undefined ){
                    var collapsibleCmp = vehicleDetailsCmp.find('collapsibleCmp');
                    if(collapsibleCmp!=undefined){
                        collapsibleCmp.collapseAll();
                    }
                }
            }
        }
        var count = component.get("v.numberOfLines");
        count = count + 1;
        if (count < 21) {
            console.log('alterRatesWithServiceWrp= ' + JSON.stringify(component.get("v.alterRatesWithServiceWrp")));
            component.set("v.numberOfLines", count);
            $A.createComponent(
                "c:ET_VehicleDetails", {
                "aura:id": "vehicleDetailsCmp",
                "multipleList": multipleList,
                "lineNumber": component.get("v.numberOfLines"),
                "additionalFields": additionalFields,
                "editableFieldsByPricingTeam": component.get("v.editableVehicleFieldsforPricingTeam"),
                "isPricingTeam": component.get("v.isPricingTeam"),
                "alterRatesObj": component.get("v.alterRatesWithServiceWrp"),
                "predefinedOtherCostMasterData": component.get("v.predefinedOtherCostMasterData"),
                //SK- "oppId" : component.get("v.oppId"),
                "OpprecordTypeName" : component.get("v.OpprecordTypeName"),
                "quoteId": component.get("v.quoteId"),
                "showAnnualTargetPrice": component.get("v.showAnnualTargetPrice"),
                //Taj
                "serviceRequestRecordId": component.get("v.serviceRequestRecordId")
            },
                function (newcomponent) {
                    if (newcomponent) {
                        if (newcomponent.isValid()) {
                            console.log('newcomponent===' + newcomponent)
                            var newCmp = component.find("cmpBody");
                            var body = newCmp.get("v.body");
                            body.push(newcomponent);
                            newCmp.set("v.body", body);

                            if (component.find("vehicleDetailsCmp").length == undefined) {
                                var commonVehicleInfoCmp = component.find("serviceRequestCommonCmpVehicle");
                                component.set("v.fleetTypeDisabled", true);
                                if (commonVehicleInfoCmp) {
                                    commonVehicleInfoCmp.set("v.isDisable", true);
                                }
                            }
                        }
                    } else {
                        $A.get('e.force:refreshView').fire();
                    }
                }
            );
        } else {
            var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type": "warning",
                "title": "warning",
                "message": "You cannot add more than 20 Vehicles",
                "mode": "sticky"
            });
            toastReference.fire();
        }
    },
    
    decreaseVehicleLineCount: function(component,event,helepr){
        var count = component.get("v.numberOfLines");
        component.set("v.numberOfLines",count-1);
        var deletedVehicleLineNumber = event.getParam("deletedlineItemNumber");
        var vehicleDetailCmpLst = component.find("vehicleDetailsCmp");
        var indexOfDeletedComp ;
        debugger;
        if(vehicleDetailCmpLst != undefined && vehicleDetailCmpLst.length > 0){
            for(var vehicleDetailCmp of vehicleDetailCmpLst){
                var vehicleDetailCmpLineNumber = vehicleDetailCmp.get("v.lineNumber");
                var cmpData = vehicleDetailCmp.get("v.vehicleLine");
                if(vehicleDetailCmpLineNumber == deletedVehicleLineNumber){
                    indexOfDeletedComp = vehicleDetailCmpLst.indexOf(vehicleDetailCmp); 
                    if(cmpData.Id){
                        //alert('cmp id which got deleted : '+ cmpData.Id);
                        var deletedCmpLst = component.get("v.deletedVehicleChildDetailCmpList");
                        deletedCmpLst.push(cmpData.Id);
                        component.set("v.deletedVehicleChildDetailCmpList", deletedCmpLst);
                    }
                    vehicleDetailCmp.destroy();
                }
                if(vehicleDetailCmpLineNumber > deletedVehicleLineNumber){
                    vehicleDetailCmp.set("v.lineNumber", vehicleDetailCmpLineNumber-1);
                    //var lineApiName = helper.getTabLineNumberApiName(tabAuraId);
                    if(cmpData != undefined && cmpData.ET_Vehicle_Line__c != undefined){
                        var lineNumber = parseInt(cmpData.ET_Vehicle_Line__c);
                        cmpData.ET_Vehicle_Line__c = lineNumber - 1;
                    }
                    vehicleDetailCmp.set("v.vehicleLine",cmpData);
                }
            }
            
            // delete the deletedComponent from list...
            debugger;
            vehicleDetailCmpLst.splice(indexOfDeletedComp, 1); 
        }
        else if(vehicleDetailCmpLst != undefined && vehicleDetailCmpLst.length == undefined){
            var vehicleDetailCmpLineNumber = vehicleDetailCmpLst.get("v.lineNumber");
            var cmpData = vehicleDetailCmpLst.get("v.vehicleLine");
            if(vehicleDetailCmpLineNumber == deletedVehicleLineNumber){
                if(cmpData.Id){
                    //alert('cmp id which got deleted : '+ cmpData.Id);
                    var deletedCmpLst = component.get("v.deletedVehicleChildDetailCmpList");
                    deletedCmpLst.push(cmpData.Id);
                    component.set("v.deletedVehicleChildDetailCmpList", deletedCmpLst);
                }
            }
        }
        
    },
})