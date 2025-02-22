({
    validateAllDetails: function(cmp, event, helper){
       
        var isValid = true;
        var tabDetailsCmp=[];
        var requiredFieldsLst = [];
        var requiredFieldIdLst = [];
        var cmpId = cmp.getLocalId();
        var tabSpecialRequirementComponentId;
        var tabOtherCostComponentId;
        var predefinedOtherCostId;
        
        var commonWorkforceDetailFieldIds = cmp.get("v.commonWorkforceDetailFieldIds");
        var colapsibleCmpInsideTabDetailsCmp;
        //alert(cmpId);
        if(cmpId == 'driverTab'){
            requiredFieldIdLst = cmp.getSuper().get("v.driverDetailFieldsToValidate");
            tabDetailsCmp= cmp.find('driverDetailsCmp');
            tabSpecialRequirementComponentId = 'driverSpecialRequirements';
            tabOtherCostComponentId = 'driverOtherCostCmp';
            
        }else if(cmpId == 'vehicleTab'){
            requiredFieldIdLst = cmp.getSuper().get("v.vehicleDetailFieldsToValidate");
            tabOtherCostComponentId = 'vehicleOtherCostCmp';
            predefinedOtherCostId = 'vehicleReqCmp';
            tabDetailsCmp= cmp.find('vehicleDetailsCmp');
            
        }else if(cmpId == 'schoolBusNanniesTab'){
            requiredFieldIdLst = cmp.getSuper().get("v.nannyDetailFieldsToValidate");
            tabDetailsCmp= cmp.find('schoolBusNannyDetailsCmp'); 
            tabSpecialRequirementComponentId = 'nanySpecialRequirements';
            tabOtherCostComponentId = 'nannyOtherCostCmp';
            
        }
            else if(cmpId == 'supervisorTab'){
                requiredFieldIdLst = cmp.getSuper().get("v.supervisorDetailFieldsToValidate");
                tabDetailsCmp= cmp.find('supervisorDetailsCmp'); 
                tabSpecialRequirementComponentId = 'supervisorSpecialRequirements';
                tabOtherCostComponentId = 'supervisorOtherCostCmp';
            }
                else if(cmpId == 'coordinatorTab'){
                    requiredFieldIdLst = cmp.getSuper().get("v.coordinatorDetailFieldsToValidate");
                    tabDetailsCmp= cmp.find('coordinatorDetailsCmp');
                    tabSpecialRequirementComponentId = 'coordinatorSpecialRequirements';
                    tabOtherCostComponentId = 'coordinatorOtherCostCmp';
                }
                    else if(cmpId == 'accountantTab'){
                        requiredFieldIdLst = cmp.getSuper().get("v.accountantDetailFieldsToValidate");
                        tabDetailsCmp= cmp.find('accountantDetailsCmp'); 
                        tabSpecialRequirementComponentId = 'accountantSpecialRequirements';
                        tabOtherCostComponentId = 'accountantOtherCostCmp';
                    }
                        else if(cmpId == 'otherEmployeeTab'){
                            requiredFieldIdLst = cmp.getSuper().get("v.otherEmployeeDetailFieldsToValidate");
                            tabDetailsCmp= cmp.find('otherEmployeeDetailsCmp'); 
                            tabSpecialRequirementComponentId = 'otherEmployeeSpecialRequirements';
                            tabOtherCostComponentId = 'otherEmpOtherCostCmp';
                        }
                            else if(cmpId == 'otherCostTab'){
                                requiredFieldIdLst = cmp.getSuper().get("v.otherCostDetailFieldsToValidate");
                                tabDetailsCmp= cmp.find('otherCostDetailsCmp'); 
                                //tabOtherCostComponentId = '';
                                //tabSpecialRequirementComponentId = 'otherEmployeeSpecialRequirements';
                            }
        
        var tabFieldLstWithMultiDivIds;
        if(cmpId != 'otherCostTab'){
            tabFieldLstWithMultiDivIds = cmp.get("v.multipleFields");
        }
        
        
        var tabFieldLstWithMultiVal = [];
        var commonFieldsAuraIdMap = new Map();
        var workforcerecordWithoutSpecialRequirement;
        if(tabDetailsCmp != undefined  && cmpId != 'otherCostTab'){
            
            if(tabDetailsCmp.length!=undefined && tabDetailsCmp.length > 0){        
                commonFieldsAuraIdMap = tabDetailsCmp[0].get("v.commonFieldsAuraIdMap");
            }else{
                commonFieldsAuraIdMap = tabDetailsCmp.get("v.commonFieldsAuraIdMap");
            } 
            
        }
        
        
        
        
        
        if(tabFieldLstWithMultiDivIds != undefined && tabFieldLstWithMultiDivIds.length > 0){
            for(var id of tabFieldLstWithMultiDivIds){
                tabFieldLstWithMultiVal.push(commonFieldsAuraIdMap[id]);
            }
            if(tabFieldLstWithMultiVal != undefined &&  tabFieldLstWithMultiVal.length > 0){
                requiredFieldIdLst = requiredFieldIdLst.concat(tabFieldLstWithMultiVal);
            }
            
            
        }
 
        //var requiredFirldIdLst = cmp.get("v.driverDetailFieldsToValidate");
        //console.log('requiredFirldIdLst : ' + requiredFirldIdLst);
        //driverDetailsCmp = cmp.find('driverDetailsCmp');
        if(tabDetailsCmp!=undefined){
            
            if(tabDetailsCmp.length!=undefined && tabDetailsCmp.length > 0){
                
                for(var i=0;i<tabDetailsCmp.length;i++){
                    if( tabDetailsCmp[i].find("collapsibleCmp") != undefined ){
                        requiredFieldsLst = [];
                        
                        if(cmpId == 'vehicleTab'){
                            var vehicleFuelTypesRequired = tabDetailsCmp[i].get("v.vehicleLine").ET_Vehicle_Fuel__c;
                            if(vehicleFuelTypesRequired && vehicleFuelTypesRequired == 'Yes'){
                                requiredFieldsLst.push(tabDetailsCmp[i].find("fuelType"));
                            }
                            var vehicleSpecificRequirement = tabDetailsCmp[i].get("v.vehicleLine").ET_Specific_requirements__c;
                            if(vehicleSpecificRequirement && vehicleSpecificRequirement == 'Yes'){
                                requiredFieldsLst = helper.includeWorkforceOtherCostsRequiredElement(tabOtherCostComponentId,tabDetailsCmp[i],requiredFieldsLst);
                                requiredFieldsLst = helper.includePredefinedOtherCostsRequiredElement(predefinedOtherCostId,tabDetailsCmp[i],requiredFieldsLst);
                            }
                            
                        }
                        
                        for(var id in requiredFieldIdLst){
                            requiredFieldsLst.push(tabDetailsCmp[i].find(requiredFieldIdLst[id]));
                        }
                        if(cmpId != 'vehicleTab' && cmpId != 'otherCostTab'){
                            var workForceInfo = tabDetailsCmp[i].get("v.workForceRecord");
                            if( workForceInfo!= undefined && workForceInfo.ET_Special_Requirements__c == 'Yes'){
                                requiredFieldsLst = helper.includeWorkforceSpecialrequirementElement(cmp,tabSpecialRequirementComponentId,tabDetailsCmp[i], requiredFieldsLst,commonWorkforceDetailFieldIds);
                                requiredFieldsLst = helper.includeWorkforceOtherCostsRequiredElement(tabOtherCostComponentId,tabDetailsCmp[i],requiredFieldsLst);
                            }
                        }
                        
                        
                        
                        
                        if(requiredFieldsLst.length!=undefined && requiredFieldsLst.length > 0){
                            console.log('required fields = '+ JSON.stringify(requiredFieldsLst));
                            if(!helper.validateFields(requiredFieldsLst)){
                                isValid = false;
                                var collapsibleCmp = tabDetailsCmp[i].find('collapsibleCmp');
                                if(collapsibleCmp!=undefined ){
                                    collapsibleCmp.expand();
                                }
                            }
                            
                            /* console.log('allValid : ' + allValid);
                        if (allValid) {
                            alert('All form entries look valid. Ready to submit!');
                        } else {
                            alert('Please update the invalid form entries and try again.');
                        }*/
                        }   
                        
                    }
                }
                
            }else{
                //console.log('single driver');
                if( tabDetailsCmp.find("collapsibleCmp") != undefined ){
                    requiredFieldsLst = [];
                    if(cmpId == 'vehicleTab'){
                        console.log('tabDetailsCmp.get("v.vehicleLine") = '+ JSON.stringify(tabDetailsCmp.get("v.vehicleLine")));
                        var vehicleFuelTypesRequired = tabDetailsCmp.get("v.vehicleLine").ET_Vehicle_Fuel__c;
                        if(vehicleFuelTypesRequired && vehicleFuelTypesRequired == 'Yes'){
                            if(tabDetailsCmp.find("fuelType")){
                                requiredFieldsLst.push(tabDetailsCmp.find("fuelType"));
                            }
                            
                        }
                        var vehicleSpecificRequirement = tabDetailsCmp.get("v.vehicleLine").ET_Specific_requirements__c;
                        if(vehicleSpecificRequirement && vehicleSpecificRequirement == 'Yes'){
                            requiredFieldsLst = helper.includeWorkforceOtherCostsRequiredElement(tabOtherCostComponentId,tabDetailsCmp,requiredFieldsLst);
                            requiredFieldsLst = helper.includePredefinedOtherCostsRequiredElement(predefinedOtherCostId,tabDetailsCmp,requiredFieldsLst);
                        }
                    }
                    for(var id in requiredFieldIdLst){
                        if(tabDetailsCmp.find(requiredFieldIdLst[id])){
                            requiredFieldsLst.push(tabDetailsCmp.find(requiredFieldIdLst[id]));
                        }
                        
                    }
                    if(cmpId != 'vehicleTab' && cmpId != 'otherCostTab'){
                        var workForceInfo = tabDetailsCmp.get("v.workForceRecord");
                        if(workForceInfo!= undefined && workForceInfo.ET_Special_Requirements__c == 'Yes'){
                            requiredFieldsLst =  helper.includeWorkforceSpecialrequirementElement(cmp,tabSpecialRequirementComponentId,tabDetailsCmp, requiredFieldsLst,commonWorkforceDetailFieldIds);
                            requiredFieldsLst = helper.includeWorkforceOtherCostsRequiredElement(tabOtherCostComponentId,tabDetailsCmp,requiredFieldsLst);
                        }
                    }
                    console.log('required fields = '+ JSON.stringify(requiredFieldsLst));
                    return helper.validateFields(requiredFieldsLst); 
                }
                isValid = false;
            }
            return isValid; 
        }
        return !isValid;
    },
    
    
    
    validateFields: function(fieldLst){
        console.log('required fields2 = '+ JSON.stringify(fieldLst));
        if(fieldLst){
            var allValid = fieldLst.reduce(function (validSoFar, inputCmp) { 
                if(inputCmp){
                    inputCmp.showHelpMessageIfInvalid();
                    return validSoFar && inputCmp.get('v.validity').valid;
                }
                return true;
            }, true);
            return allValid;
        }
    },
    
    /* validateValues: function(fieldLst){
        var allValid =  fieldLst.reduce(function (validSoFar, inputCmp) {            
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        return allValid;
    }*/
    
    includeWorkforceOtherCostsRequiredElement: function(tabOtherCostComponentId,tabDetailCmp,requiredFieldsLst){
        var OtherCostCmps =  tabDetailCmp.find(tabOtherCostComponentId);
        if(OtherCostCmps && OtherCostCmps.length == undefined){
            //var requiredFieldsLst = [];
            var requiredFieldIdLst = OtherCostCmps.get("v.otherCostDetailFieldsToValidate");
            for(var id in requiredFieldIdLst){
                if(OtherCostCmps.find(requiredFieldIdLst[id])){
                    requiredFieldsLst.push(OtherCostCmps.find(requiredFieldIdLst[id]));
                }
            }
            
        }else if(OtherCostCmps && OtherCostCmps.length > 0){
            var requiredFieldIdLst = OtherCostCmps[0].get("v.otherCostDetailFieldsToValidate");
            for(var otherCostCmp of OtherCostCmps){
                //var requiredFieldsLst = [];
                for(var id in requiredFieldIdLst){
                    if(otherCostCmp.find(requiredFieldIdLst[id])){
                        requiredFieldsLst.push(otherCostCmp.find(requiredFieldIdLst[id]));
                    }
                }
                
                
            }
        }
        
        return requiredFieldsLst;
    },
    
    //Below function Added by Noor Shaik
    includePredefinedOtherCostsRequiredElement: function(predefinedOtherCostId,tabDetailCmp,requiredFieldsLst){
        console.log('predefinedOtherCostId = '+ predefinedOtherCostId + ' tabDetailCmp' + tabDetailCmp);
        var OtherCostCmps =  tabDetailCmp.find(predefinedOtherCostId);
        if(OtherCostCmps && OtherCostCmps.length == undefined){
            //var requiredFieldsLst = [];
            var requiredFieldIdLst = OtherCostCmps.get("v.otherCostDetailFieldsToValidate");
            for(var id in requiredFieldIdLst){
                if(OtherCostCmps.find(requiredFieldIdLst[id])){
                    requiredFieldsLst.push(OtherCostCmps.find(requiredFieldIdLst[id]));
                }
            }
            
        }else if(OtherCostCmps && OtherCostCmps.length > 0){
            var requiredFieldIdLst = OtherCostCmps[0].get("v.otherCostDetailFieldsToValidate");
            for(var otherCostCmp of OtherCostCmps){
                //var requiredFieldsLst = [];
                for(var id in requiredFieldIdLst){
                    if(otherCostCmp.find(requiredFieldIdLst[id])){
                        requiredFieldsLst.push(otherCostCmp.find(requiredFieldIdLst[id]));
                    }
                }
                
                
            }
        }
        
        return requiredFieldsLst;
    },
    
    includeWorkforceSpecialrequirementElement: function(component,tabSpecialRequirementComponentId, tabDetailCmp,requiredFieldsLst,commonWorkforceDetailFieldIds ){
        //var commonWorkforceDetailFieldIds = component.get("v.commonWorkforceDetailFieldIds");
        /*bit strange bahaviour of lightning detected : even thought i didnt set the modified value back to attribute using attribute.set, 
        attribute value is got changed..why???? */ 
        var commonWorkforceDetailFieldIdsLocal = [...commonWorkforceDetailFieldIds]; //copy by value..not by reference
        if(tabSpecialRequirementComponentId != undefined && tabSpecialRequirementComponentId != null){
            var commonWorkforceDetailCmp =  tabDetailCmp.find(tabSpecialRequirementComponentId);
            var dependentRequiredFieldsMap = component.get("v.commonWorkforceDepenedentFieldIdsMap");
            for(var costTypeId in dependentRequiredFieldsMap){
                if(commonWorkforceDetailCmp){
                    // if commonWorkforceDetailCmp is list
                    if(commonWorkforceDetailCmp !=undefined && commonWorkforceDetailCmp.length != undefined){
                        for(var child of commonWorkforceDetailCmp){
                            if(child.find(costTypeId).get("v.value")){
                                commonWorkforceDetailFieldIdsLocal.push(dependentRequiredFieldsMap[costTypeId]);
                            }
                        } 
                    }
                    // if commonWorkforceDetailCmp is a single element...
                    else if( commonWorkforceDetailCmp !=undefined && commonWorkforceDetailCmp.length == undefined){
                        if(commonWorkforceDetailCmp.find(costTypeId).get("v.value")){
                            commonWorkforceDetailFieldIdsLocal.push(dependentRequiredFieldsMap[costTypeId]);
                        }
                    }
                    
                }
            }
            if(commonWorkforceDetailFieldIdsLocal != undefined && commonWorkforceDetailFieldIdsLocal.length > 0){
                for(var id of commonWorkforceDetailFieldIdsLocal){
                    if(commonWorkforceDetailCmp){
                        // if commonWorkforceDetailCmp is list
                        if(commonWorkforceDetailCmp !=undefined && commonWorkforceDetailCmp.length != undefined){
                            for(var child of commonWorkforceDetailCmp){
                                requiredFieldsLst.push(child.find(id)); 
                            } 
                        }
                        // if commonWorkforceDetailCmp is a single element...
                        else if( commonWorkforceDetailCmp !=undefined && commonWorkforceDetailCmp.length == undefined){
                            requiredFieldsLst.push(commonWorkforceDetailCmp.find(id)); 
                        }
                    }
                }
            }
        }
        return requiredFieldsLst;
    },
    
    
    decreasTabLineCount: function(component,event,helper, tabAuraId){
        var count = component.get("v.numberOfLines");
        component.set("v.numberOfLines",count-1);
        var deletedTabLineNumber = event.getParam("deletedlineItemNumber");
        var tabDetailCmpLst = component.find(tabAuraId);
        if(tabDetailCmpLst != undefined && tabDetailCmpLst.length > 0){
            console.log('typeof tabDetailCmpLst = '+ typeof tabDetailCmpLst);
            for( var i = 0; i < tabDetailCmpLst.length; i++){ 
                var tabDetailCmp = tabDetailCmpLst[i];
                var tabDetailCmpLineNumber =tabDetailCmp.get("v.lineNumber");
                var cmpData = tabDetailCmp.get("v.workForceRecord");
                if(tabDetailCmpLineNumber == deletedTabLineNumber){
                    if(cmpData.Id){
                        helper.setDeletedTabChildAttributeValue(tabAuraId,component,cmpData.Id)
                    }
                }
                if(tabDetailCmpLineNumber > deletedTabLineNumber){
                    tabDetailCmp.set("v.lineNumber", tabDetailCmpLineNumber-1);
                    var lineApiName = helper.getTabLineNumberApiName(tabAuraId);
                    if(lineApiName){
                        if(cmpData != undefined && cmpData[lineApiName]!= undefined){
                            var lineNumber = parseInt(cmpData[lineApiName]);
                            cmpData[lineApiName] = lineNumber - 1;
                            
                        }
                        else if(cmpData != undefined && cmpData.ET_Workforce_Line_Info__c != undefined){
                            var lineArray = cmpData.ET_Workforce_Line_Info__c.split(":");
                            var workforceUpdatedLineInfo = lineArray[0] + ':' + String(parseInt(lineArray[1]) -1) ;
                            cmpData.ET_Workforce_Line_Info__c = workforceUpdatedLineInfo;
                            
                        }
                    }
                    tabDetailCmp.set("v.workForceRecord",cmpData);
                }
                
                // delete the deleted line from the Lineslist...
                if(tabDetailCmpLineNumber == deletedTabLineNumber){
                   //tabDetailCmpLst.splice(i, 1);
                    tabDetailCmp.destroy();
                }
                console.log('tabDetailCmpLst size 1= '+ tabDetailCmpLst.length);
            }
            
            var tabDetailCmpLst = component.find(tabAuraId);
            console.log('tabDetailCmpLst size = '+ tabDetailCmpLst.length);
        }
        else if(tabDetailCmpLst != undefined && tabDetailCmpLst.length == undefined){
            var tabDetailCmpLineNumber = tabDetailCmpLst.get("v.lineNumber");
            var cmpData = tabDetailCmpLst.get("v.workForceRecord");
            if(tabDetailCmpLineNumber == deletedTabLineNumber){
                if(cmpData.Id){
                    helper.setDeletedTabChildAttributeValue(tabAuraId,component,cmpData.Id)
                }
            }
        }
    },
    
    getTabLineNumberApiName: function(tabAuraId){
        var apiName;
        if(tabAuraId){
            if(tabAuraId.includes('driver')){
                apiName = 'ET_Driver_Line__c';
            }else if(tabAuraId.includes('nanny')){
                apiName = 'ET_Nanny_Line__c';
            }
                else if(tabAuraId.includes('supervisor')){
                    apiName = 'ET_Supervisor_Line__c';
                }
                    else if(tabAuraId.includes('coordinator')){
                        apiName = 'ET_Coordinator_Line__c';
                    }
                        else if(tabAuraId.includes('accountant')){
                            apiName = 'ET_Accountant_Line__c';
                        }
                            else if(tabAuraId.includes('otherEmployee')){
                                apiName = 'ET_OtherEmployee_Line__c';
                            }
            return apiName;
        } 
    },
    
    setDeletedTabChildAttributeValue: function(tabAuraId,component,cmpDataId){
        var attribute;
        if(tabAuraId){
            if(tabAuraId.includes('driver')){
                attribute = component.get("v.deletedDriverChildDetailCmpList");
                attribute.push(cmpDataId);
                component.set("v.deletedDriverChildDetailCmpList", attribute);
            }else if(tabAuraId.includes('nanny')){
                attribute = component.get("v.deletedNannyChildDetailCmpList");
                attribute.push(cmpDataId);
                component.set("v.deletedNannyChildDetailCmpList", attribute);
            }
                else if(tabAuraId.includes('supervisor')){
                    attribute = component.get("v.deletedSupervisorChildDetailCmpList");
                    attribute.push(cmpDataId);
                    component.set("v.deletedSupervisorChildDetailCmpList", attribute);
                }
                    else if(tabAuraId.includes('coordinator')){
                        attribute = component.get("v.deletedCoordinatorChildDetailCmpList");
                        attribute.push(cmpDataId);
                        component.set("v.deletedCoordinatorChildDetailCmpList", attribute);
                    }
                        else if(tabAuraId.includes('accountant')){
                            attribute = component.get("v.deletedAccountantChildDetailCmpList");
                            attribute.push(cmpDataId);
                            component.set("v.deletedAccountantChildDetailCmpList", attribute);
                        }
                            else if(tabAuraId.includes('otherEmployee')){
                                attribute = component.get("v.deletedOtherEmpChildDetailCmpList");
                                attribute.push(cmpDataId);
                                component.set("v.deletedOtherEmpChildDetailCmpList", attribute);
                            }
        }
    },
    
    /* Method 	   : getTabCommonData
       Description : to get common data in each Vehicle - that is 'Vehicle Common Information'
     */
    
    getTabCommonData : function(component, event, helper) {
        component.set("v.showToast",false); 
        var tabId = component.getLocalId();
        var tabCommonInfoKey;
        var existingRecords;
        var commonCmp;
        var localTabCommonInfo;
        if(tabId == 'driverTab'){
            tabCommonInfoKey = 'driverCommonInfo';
            existingRecords = component.get("v.driverRecords");
            localTabCommonInfo = {};
            commonCmp = component.find("serviceRequestCommonCmpDriver");
        }else if(tabId == 'vehicleTab'){
            tabCommonInfoKey = 'vehicleCommonInfo';
            existingRecords = component.get("v.vehicleRecords");
            localTabCommonInfo = {};
            commonCmp = component.find("serviceRequestCommonCmpVehicle");
            
        }else if(tabId == 'schoolBusNanniesTab'){
            tabCommonInfoKey = 'nannyCommonInfo';
            existingRecords = component.get("v.nannyRecords");
            localTabCommonInfo = {};
            commonCmp = component.find("serviceRequestCommonCmpNanny");
        }
            else if(tabId == 'supervisorTab'){
                tabCommonInfoKey = 'supervisorCommonInfo';
                existingRecords = component.get("v.supervisorRecords");
                localTabCommonInfo = {};
                commonCmp = component.find("serviceRequestCommonCmpSupervisor");
                
            }
                else if(tabId == 'coordinatorTab'){
                    tabCommonInfoKey = 'coordinatorCommonInfo';
                    existingRecords = component.get("v.coordinatorRecords");
                    localTabCommonInfo = {};
                    commonCmp = component.find("serviceRequestCommonCmpCoordinator");
                    
                }
                    else if(tabId == 'accountantTab'){
                        tabCommonInfoKey = 'accountantCommonInfo';
                        existingRecords = component.get("v.accountantRecords");
                        localTabCommonInfo = {};
                        commonCmp = component.find("serviceRequestCommonCmpAcc");
                        
                    }
                        else if(tabId == 'otherEmployeeTab'){
                            tabCommonInfoKey = 'otherEmployeeCommonInfo';
                            existingRecords = component.get("v.otherEmployeeRecords");
                            localTabCommonInfo = {};
                            commonCmp = component.find("serviceRequestCommonCmpOtherEmp");
                            
                        } 
        // var existingRecords = component.get("v.nannyRecords");
        if(existingRecords != undefined && existingRecords[tabCommonInfoKey] != undefined && existingRecords[tabCommonInfoKey] != null){
            console.log('existingRecords'+existingRecords)
            //helper.createComponent(component, event, helper,component.get("v.multipleFields"));
            return existingRecords;
        }
        //var commonCmp = component.find("serviceRequestCommonCmpNanny");
        var commonInfoFromWrapper = component.get("v.commonInforReceivedFrmWrapper");
        console.log('commonInfoFromWrapper :: '+ JSON.stringify(commonInfoFromWrapper) );
        var tabRecords = new Map();
        var tabCommonInfo;
        var fieldsWithMultipleValueLst;
        var routeList = [];
        
        if(commonCmp == undefined){
            //tabCommonInfo = {};
            tabCommonInfo =  Object.assign({},commonInfoFromWrapper);               
            if(commonInfoFromWrapper['ET_Pricing_Method__c'] == 'Comprehensive Price per Route'){
                routeList.push("Comprehensive Price per Route");
            }
        }else{
            // Mani
            /* if(!commonCmp.validateDetails()){
                    component.set("v.showToast",true);
                    return null;
                }*/
            var res = commonCmp.checkForMultiple();
            console.log('res = '+ res);
            fieldsWithMultipleValueLst = commonCmp.get("v.fieldsWithMultipleValueCurrentLst");
            console.log('fieldsWithMultipleValueLst = '+ JSON.stringify(fieldsWithMultipleValueLst));
            tabCommonInfo  =   Object.assign({},commonCmp.get("v.commonServiceRequestDetails"));  
            localTabCommonInfo = Object.assign({},tabCommonInfo);
            for(let key in  tabCommonInfo){
                if(key != 'Notes__c'&& tabCommonInfo[key] == '' || tabCommonInfo[key] == null ){
                    tabCommonInfo[key] = commonInfoFromWrapper[key];
                }
            }
            for(let key in commonInfoFromWrapper){
                if(key != 'Notes__c'&& (tabCommonInfo[key] == null || tabCommonInfo[key] == '' || tabCommonInfo[key] == 0) && commonInfoFromWrapper[key] != null && commonInfoFromWrapper[key] != ''){
                    tabCommonInfo[key] = commonInfoFromWrapper[key];
                    }
                }
                
                
                
                if( commonCmp.get("v.contractValue") != undefined &&  commonCmp.get("v.contractValue") != null && (commonInfoFromWrapper['ET_Contract_Period__c']).includes('Multiple') ){
                    tabCommonInfo['ET_Contract_Period__c'] =  commonCmp.get("v.contractValue");
                    localTabCommonInfo['ET_Contract_Period__c'] =  commonCmp.get("v.contractValue");
                }else if(commonInfoFromWrapper['ET_Contract_Period__c'] != undefined && commonInfoFromWrapper['ET_Contract_Period__c'] != ''){
                    tabCommonInfo['ET_Contract_Period__c'] = commonInfoFromWrapper['ET_Contract_Period__c'];
                } 
                if(tabCommonInfo['ET_Pricing_Method__c'] == 'Comprehensive Price per Route'){
                    routeList.push("Comprehensive Price per Route");
                }
            }
        
        if(tabId == 'vehicleTab'){
            
            tabCommonInfo['ET_Fleet_Type__c'] = component.get("v.fleetType");
            localTabCommonInfo['ET_Fleet_Type__c'] = component.get("v.fleetType");
        }
        
        localTabCommonInfo['ET_Pricing_Method__c'] = tabCommonInfo['ET_Pricing_Method__c'];
        
        console.log('tabCommonInfo :: '+ JSON.stringify(tabCommonInfo) );
        tabRecords[tabCommonInfoKey] = tabCommonInfo;
        tabRecords['localTabCommonInfo'] = localTabCommonInfo;
        component.set("v.additionalFieldsToDisplay",routeList);
        component.set("v.multipleFields",fieldsWithMultipleValueLst );
        console.log('multipleFieldsFinal = '+ JSON.stringify(component.get("v.multipleFields")));
        console.log('tabRecords = '+ JSON.stringify(tabRecords));
        return tabRecords;
        
    },
    
    getLatestManpowerData : function(component, event,helper) {
        try{
            var tabId = component.getLocalId();
            var tabOtherCostCmpAuraId;
            var tabDetailCmpAuraId;
            var tabRecordMap = new Map();
            var tabCommonInfoKey;
            var tabInfoMapKey;
            var deletedTabDetailCmpIdLst;
            var deletdTabDetailCmpKey;
            if(tabId == 'driverTab'){
                //tabCommonInfoKey = ;
                tabDetailCmpAuraId = 'driverDetailsCmp';
                tabRecordMap = component.get("v.driverRecords");
                tabCommonInfoKey = 'driverCommonInfo';
                tabInfoMapKey = 'driverTabInfo';
                deletedTabDetailCmpIdLst = component.get("v.deletedDriverChildDetailCmpList");
                deletdTabDetailCmpKey = 'deletedDriverCmpIds';
                tabOtherCostCmpAuraId = 'driverOtherCostCmp';
                //workforceType = 'Driver';
            }else if(tabId == 'schoolBusNanniesTab'){
                tabDetailCmpAuraId = 'schoolBusNannyDetailsCmp';
                tabRecordMap = component.get("v.nannyRecords");
                tabCommonInfoKey = 'nannyCommonInfo';
                tabInfoMapKey = 'nannyTabInfo';
                deletedTabDetailCmpIdLst = component.get("v.deletedNannyChildDetailCmpList");
                deletdTabDetailCmpKey = 'deletedNannyCmpIds';
                tabOtherCostCmpAuraId = 'nannyOtherCostCmp';
                //workforceType = 'Nanny';
            }
                else if(tabId == 'supervisorTab'){
                    tabDetailCmpAuraId = 'supervisorDetailsCmp';
                    tabRecordMap = component.get("v.supervisorRecords");
                    tabCommonInfoKey = 'supervisorCommonInfo';
                    tabInfoMapKey = 'supervisorTabInfo';
                    deletedTabDetailCmpIdLst = component.get("v.deletedNannyChildDetailCmpList");
                    deletdTabDetailCmpKey = 'deletedSupervisorCmpIds';
                    tabOtherCostCmpAuraId = 'supervisorOtherCostCmp';
                    //workforceType = 'Supervisor';
                }
                    else if(tabId == 'coordinatorTab'){
                        tabDetailCmpAuraId = 'coordinatorDetailsCmp';
                        tabRecordMap = component.get("v.coordinatorRecords");
                        tabCommonInfoKey = 'coordinatorCommonInfo';
                        tabInfoMapKey = 'coordinatorTabInfo';
                        deletedTabDetailCmpIdLst = component.get("v.deletedCoordinatorChildDetailCmpList");
                        deletdTabDetailCmpKey = 'deletedCoordinatorCmpIds';
                        tabOtherCostCmpAuraId = 'coordinatorOtherCostCmp';
                        //workforceType = 'Coordinator';
                    }
                        else if(tabId == 'accountantTab'){
                            tabDetailCmpAuraId = 'accountantDetailsCmp';
                            tabRecordMap = component.get("v.accountantRecords");
                            tabCommonInfoKey = 'accountantCommonInfo';
                            tabInfoMapKey = 'accountantTabInfo';
                            deletedTabDetailCmpIdLst = component.get("v.deletedAccountantChildDetailCmpList");
                            deletdTabDetailCmpKey = 'deletedAccountantCmpIds';
                            tabOtherCostCmpAuraId = 'accountantOtherCostCmp';
                            //workforceType = 'Accountant';
                        }
                            else if(tabId == 'otherEmployeeTab'){
                                tabDetailCmpAuraId = 'otherEmployeeDetailsCmp';
                                tabRecordMap = component.get("v.otherEmployeeRecords");
                                tabCommonInfoKey = 'otherEmployeeCommonInfo';
                                tabInfoMapKey = 'otherEmployeeTabInfo';
                                deletedTabDetailCmpIdLst = component.get("v.deletedOtherEmpChildDetailCmpList");
                                deletdTabDetailCmpKey = 'deletedOtherEmpCmpIds';
                                tabOtherCostCmpAuraId = 'otherEmpOtherCostCmp';
                                //workforceType = 'OtherEmployee';
                            } 
            var tabDetailCmp;
            // get all existing Vehicle lines...
            console.log('tabDetailCmpAuraId = '+tabDetailCmpAuraId);
            var tabDetailsChildCmp = component.find(tabDetailCmpAuraId);
            
            console.log('tabDetailsChildCmp = '+JSON.stringify(tabDetailsChildCmp));
            // if only one line 
            debugger;
            if(tabDetailsChildCmp != undefined && tabDetailsChildCmp.length == undefined){
                tabDetailCmp = tabDetailsChildCmp;
            }
            
            // if multiple lines present - assign latest vehicle line to 'vehicleDetailsCmp'..
            if(tabDetailsChildCmp != undefined && tabDetailsChildCmp.length != undefined && tabDetailsChildCmp.length >0){
                let noOfChildCmpns = tabDetailsChildCmp.length ;
                tabDetailCmp = tabDetailsChildCmp[noOfChildCmpns-1];
            }
            console.log('tabDetailCmp = '+JSON.stringify(tabDetailCmp));
            var tabRecordLst = [];
            if(tabRecordMap!= undefined && tabRecordMap[tabCommonInfoKey] != null){
                console.log('tabRecordMap'+JSON.stringify(tabRecordMap));
                var commonTabData = tabRecordMap[tabCommonInfoKey];
                if(tabDetailCmp != undefined && tabDetailCmp.length == undefined && tabDetailCmp.find("collapsibleCmp") != undefined){
                    var specialRequirementData;
                    var record = tabDetailCmp.get("v.workForceRecord");
                    var originalRec = tabDetailCmp.get("v.workForceRecord");
                    console.log('originalRec = '+ JSON.stringify(originalRec));
                    // create a duplicate object(Manpower line) with last Manpower line..
                    var record = Object.assign({}, originalRec); 
                    console.log('new record'+record);
                    for(var key in record){
                        if((record[key] == null || record[key] == '') && commonTabData[key] != ''){
                            record[key] = commonTabData[key]; 
                        }
                    }
                    for(let key in commonTabData){
                        if((record[key] == null || record[key] == '' || record[key] == 0) && commonTabData[key] != null && commonTabData[key] != ''){
                            record[key] = commonTabData[key];
                        }
                    }
                    
                    if( tabDetailCmp.get("v.contractValue") != undefined &&  tabDetailCmp.get("v.contractValue") != null && (commonTabData['ET_Contract_Period__c']).includes('Multiple') ){
                        record['ET_Contract_Period__c'] =  tabDetailCmp.get("v.contractValue");
                    }else if(commonTabData['ET_Contract_Period__c'] != undefined && commonTabData['ET_Contract_Period__c'] != ''){
                        record['ET_Contract_Period__c'] = commonTabData['ET_Contract_Period__c'];
                    }
                    specialRequirementData = tabDetailCmp.get("v.specialTabRequirementData");
                    if(specialRequirementData != undefined && record['ET_Special_Requirements__c'] == 'Yes'){
                        record['ET_Special_Workforce_Requirement__c'] =  specialRequirementData;
                    }
                    
                    var otherCostsCmpList = tabDetailCmp.find(tabOtherCostCmpAuraId);
                    var otherCostDataList = [];
                    if(otherCostsCmpList != undefined && otherCostsCmpList.length == undefined){
                        //  create a new object with existing object - to avoid copy by reference
                        var otherCostData  = Object.assign({}, otherCostsCmpList.get("v.otherCostTabSpecificRecords")) ;
                        if(otherCostData && record['ET_Special_Requirements__c'] == 'Yes'){
                            //record['ET_Other_Cost_Request__c'] = 
                            if(otherCostsCmpList.get("v.costTypeValue")){
                                otherCostData['ET_Cost_Type__c'] = otherCostsCmpList.get("v.costTypeValue");
                            }
                            
                            otherCostDataList.push(otherCostData);
                        }
                    }else if(otherCostsCmpList != undefined && otherCostsCmpList.length > 0){
                        for(var i=0; i < otherCostsCmpList.length; i++ ){
                            //  create a new object with existing object - to avoid copy by reference
                            var otherCostData  = Object.assign({}, otherCostsCmpList[i].get("v.otherCostTabSpecificRecords")) ;
                            //var otherCostData  = otherCostsCmpList[i].get("v.otherCostTabSpecificRecords");
                            if(otherCostData && record['ET_Special_Requirements__c'] == 'Yes'){
                                //record['ET_Other_Cost_Request__c'] = 
                                if(otherCostsCmpList[i].get("v.costTypeValue")){
                                    otherCostData['ET_Cost_Type__c'] = otherCostsCmpList[i].get("v.costTypeValue");
                                }
                                
                                otherCostDataList.push(otherCostData);
                            }
                        }
                    }
                    if(otherCostDataList && otherCostDataList.length > 0){
                        record['ET_Other_Cost_Request__c'] = otherCostDataList;
                    }
                    return record;
                }
            }
        }
        catch(error){
            console.log('error = '+error)
        }
    },
    
    
    getWholeTabData : function(component, event,helper) {
        var tabId = component.getLocalId();
        var tabOtherCostCmpAuraId;
        var tabDetailCmpAuraId;
        var tabRecordMap = new Map();
        var tabCommonInfoKey;
        var tabInfoMapKey;
        var deletedTabDetailCmpIdLst;
        var deletdTabDetailCmpKey;
        if(tabId == 'driverTab'){
            //tabCommonInfoKey = ;
            tabDetailCmpAuraId = 'driverDetailsCmp';
            tabRecordMap = component.get("v.driverRecords");
            tabCommonInfoKey = 'driverCommonInfo';
            tabInfoMapKey = 'driverTabInfo';
            deletedTabDetailCmpIdLst = component.get("v.deletedDriverChildDetailCmpList");
            deletdTabDetailCmpKey = 'deletedDriverCmpIds';
            tabOtherCostCmpAuraId = 'driverOtherCostCmp';
            //workforceType = 'Driver';
        }else if(tabId == 'schoolBusNanniesTab'){
            tabDetailCmpAuraId = 'schoolBusNannyDetailsCmp';
            tabRecordMap = component.get("v.nannyRecords");
            tabCommonInfoKey = 'nannyCommonInfo';
            tabInfoMapKey = 'nannyTabInfo';
            deletedTabDetailCmpIdLst = component.get("v.deletedNannyChildDetailCmpList");
            deletdTabDetailCmpKey = 'deletedNannyCmpIds';
            tabOtherCostCmpAuraId = 'nannyOtherCostCmp';
            //workforceType = 'Nanny';
        }
            else if(tabId == 'supervisorTab'){
                tabDetailCmpAuraId = 'supervisorDetailsCmp';
                tabRecordMap = component.get("v.supervisorRecords");
                tabCommonInfoKey = 'supervisorCommonInfo';
                tabInfoMapKey = 'supervisorTabInfo';
                deletedTabDetailCmpIdLst = component.get("v.deletedNannyChildDetailCmpList");
                deletdTabDetailCmpKey = 'deletedSupervisorCmpIds';
                tabOtherCostCmpAuraId = 'supervisorOtherCostCmp';
                //workforceType = 'Supervisor';
            }
                else if(tabId == 'coordinatorTab'){
                    tabDetailCmpAuraId = 'coordinatorDetailsCmp';
                    tabRecordMap = component.get("v.coordinatorRecords");
                    tabCommonInfoKey = 'coordinatorCommonInfo';
                    tabInfoMapKey = 'coordinatorTabInfo';
                    deletedTabDetailCmpIdLst = component.get("v.deletedCoordinatorChildDetailCmpList");
                    deletdTabDetailCmpKey = 'deletedCoordinatorCmpIds';
                    tabOtherCostCmpAuraId = 'coordinatorOtherCostCmp';
                    //workforceType = 'Coordinator';
                }
                    else if(tabId == 'accountantTab'){
                        tabDetailCmpAuraId = 'accountantDetailsCmp';
                        tabRecordMap = component.get("v.accountantRecords");
                        tabCommonInfoKey = 'accountantCommonInfo';
                        tabInfoMapKey = 'accountantTabInfo';
                        deletedTabDetailCmpIdLst = component.get("v.deletedAccountantChildDetailCmpList");
                        deletdTabDetailCmpKey = 'deletedAccountantCmpIds';
                        tabOtherCostCmpAuraId = 'accountantOtherCostCmp';
                        //workforceType = 'Accountant';
                    }
                        else if(tabId == 'otherEmployeeTab'){
                            tabDetailCmpAuraId = 'otherEmployeeDetailsCmp';
                            tabRecordMap = component.get("v.otherEmployeeRecords");
                            tabCommonInfoKey = 'otherEmployeeCommonInfo';
                            tabInfoMapKey = 'otherEmployeeTabInfo';
                            deletedTabDetailCmpIdLst = component.get("v.deletedOtherEmpChildDetailCmpList");
                            deletdTabDetailCmpKey = 'deletedOtherEmpCmpIds';
                            tabOtherCostCmpAuraId = 'otherEmpOtherCostCmp';
                            //workforceType = 'OtherEmployee';
                        } 
        
        var tabDetailCmp = component.find(tabDetailCmpAuraId);
        
        
        var tabRecordLst = [];
        console.log('tabDetailRecordMapCmp'+JSON.stringify(tabDetailCmp));
        if(helper.validateAllDetails(component,event,helper) && tabRecordMap!= undefined && tabRecordMap[tabCommonInfoKey] != null){
            console.log('tabRecordMap'+JSON.stringify(tabRecordMap));
            var commonTabData = tabRecordMap[tabCommonInfoKey];
            debugger;
            if(tabDetailCmp != undefined && tabDetailCmp.length == undefined && tabDetailCmp.find("collapsibleCmp") != undefined){
                var specialRequirementData;
                var record = tabDetailCmp.get("v.workForceRecord");
                // record['workforceType'] == workforceType;
                console.log('record'+record);
                for(var key in record){
                    if((record[key] == null || record[key] == '') && commonTabData[key] != ''){
                        record[key] = commonTabData[key]; 
                    }
                    
                }
                for(let key in commonTabData){
                    if((record[key] == null || record[key] == '' || record[key] == 0) && commonTabData[key] != null && commonTabData[key] != ''){
                        record[key] = commonTabData[key];
                    }
                }
                
                if( tabDetailCmp.get("v.contractValue") != undefined &&  tabDetailCmp.get("v.contractValue") != null && (commonTabData['ET_Contract_Period__c']).includes('Multiple') ){
                    record['ET_Contract_Period__c'] =  tabDetailCmp.get("v.contractValue");
                }else if(commonTabData['ET_Contract_Period__c'] != undefined && commonTabData['ET_Contract_Period__c'] != ''){
                    record['ET_Contract_Period__c'] = commonTabData['ET_Contract_Period__c'];
                }
                specialRequirementData = tabDetailCmp.get("v.specialTabRequirementData");
                if(specialRequirementData != undefined && record['ET_Special_Requirements__c'] == 'Yes'){
                    record['ET_Special_Workforce_Requirement__c'] =  specialRequirementData;
                }
                
                var otherCostsCmpList = tabDetailCmp.find(tabOtherCostCmpAuraId);
                var otherCostDataList = [];
                if(otherCostsCmpList != undefined && otherCostsCmpList.length == undefined){
                    var otherCostData  = otherCostsCmpList.get("v.otherCostTabSpecificRecords");
                    if(otherCostData && record['ET_Special_Requirements__c'] == 'Yes'){
                        //record['ET_Other_Cost_Request__c'] = 
                        if(otherCostsCmpList.get("v.costTypeValue")){
                            otherCostData['ET_Cost_Type__c'] = otherCostsCmpList.get("v.costTypeValue");
                        }
                        
                        otherCostDataList.push(otherCostData);
                    }
                }else if(otherCostsCmpList != undefined && otherCostsCmpList.length > 0){
                    for(var i=0; i < otherCostsCmpList.length; i++ ){
                        var otherCostData  = otherCostsCmpList[i].get("v.otherCostTabSpecificRecords");
                        if(otherCostData && record['ET_Special_Requirements__c'] == 'Yes'){
                            //record['ET_Other_Cost_Request__c'] = 
                            if(otherCostsCmpList[i].get("v.costTypeValue")){
                                otherCostData['ET_Cost_Type__c'] = otherCostsCmpList[i].get("v.costTypeValue");
                            }
                            
                            otherCostDataList.push(otherCostData);
                        }
                    }
                }
                if(otherCostDataList.length > 0){
                    record['ET_Other_Cost_Request__c'] = otherCostDataList;
                }
                tabRecordLst.push(record);
                tabRecordMap[tabInfoMapKey] = tabRecordLst;
            }
            else if(tabDetailCmp != undefined && tabDetailCmp.length > 0){
                console.log('tabDetailCmp'+tabDetailCmp.length);
                for(var i=0;i<tabDetailCmp.length;i++){
                    var record = new Object();
                    if(tabDetailCmp[i] != undefined && tabDetailCmp[i].find("collapsibleCmp") != undefined){
                        record = tabDetailCmp[i].get("v.workForceRecord");
                        //record['workforceType'] == workforceType;
                        for(var key in record){
                            if((record[key] == null || record[key] == '') && commonTabData[key] != ''){
                                record[key] = commonTabData[key];
                            }
                        }
                        for(let key in commonTabData){
                            if((record[key] == null || record[key] == '' || record[key] == 0) && commonTabData[key] != null && commonTabData[key] != ''){
                                record[key] = commonTabData[key];
                            }
                        }
                        
                        console.log('record per itiration', JSON.stringify(record));
                        if( tabDetailCmp[i].get("v.contractValue") != undefined &&  tabDetailCmp[i].get("v.contractValue") != null && (commonTabData['ET_Contract_Period__c']).includes('Multiple') ){
                            record['ET_Contract_Period__c'] =  tabDetailCmp[i].get("v.contractValue");
                        }else if(commonTabData['ET_Contract_Period__c'] != undefined && commonTabData['ET_Contract_Period__c'] != ''){
                            record['ET_Contract_Period__c'] = commonTabData['ET_Contract_Period__c'];
                        }
                        
                        specialRequirementData = tabDetailCmp[i].get("v.specialTabRequirementData");
                        if(specialRequirementData != undefined && record['ET_Special_Requirements__c'] == 'Yes'){
                            record['ET_Special_Workforce_Requirement__c'] =  specialRequirementData;
                        }
                        var otherCostsCmpList = tabDetailCmp[i].find(tabOtherCostCmpAuraId);
                        var otherCostDataList = [];
                        if(otherCostsCmpList != undefined && otherCostsCmpList.length == undefined){
                            var otherCostData  = otherCostsCmpList.get("v.otherCostTabSpecificRecords");
                            if(otherCostData && record['ET_Special_Requirements__c'] == 'Yes'){
                                //record['ET_Other_Cost_Request__c'] = 
                                if(otherCostsCmpList.get("v.costTypeValue")){
                                    otherCostData['ET_Cost_Type__c'] = otherCostsCmpList.get("v.costTypeValue");
                                }
                                
                                otherCostDataList.push(otherCostData);
                            }
                        }else if(otherCostsCmpList != undefined && otherCostsCmpList.length > 0){
                            // var otherCostsCmpList = tabDetailCmp[i].find(tabOtherCostCmpAuraId);
                           for(var k=0; k < otherCostsCmpList.length; k++ ){
                                var otherCostData  = otherCostsCmpList[k].get("v.otherCostTabSpecificRecords");
                                if(otherCostData && record['ET_Special_Requirements__c'] == 'Yes'){
                                    //record['ET_Other_Cost_Request__c'] = 
                                    if(otherCostsCmpList[k].get("v.costTypeValue")){
                                        otherCostData['ET_Cost_Type__c'] = otherCostsCmpList[k].get("v.costTypeValue");
                                    }
                                    console.log('otherCostData..'+JSON.stringify(otherCostData)); 
                                    otherCostDataList.push(otherCostData);
                                }
                            }
                        }
                        if(otherCostDataList.length > 0){
                            record['ET_Other_Cost_Request__c'] = otherCostDataList;
                        }
                        tabRecordLst.push(record);
                    }
                }
                tabRecordMap[tabInfoMapKey] = tabRecordLst;
                tabRecordMap[deletdTabDetailCmpKey] = deletedTabDetailCmpIdLst;
            }
            //component.set('v.nannyRecords', tabRecordMap );
            console.log('tabRecordMap :  ',JSON.stringify(tabRecordMap));
            
            //-----------------------------------------
            return tabRecordMap;
            //return tabDetailCmp;
        }
        return null;
    },
    
    prePopulateDataAfterEvent : function(component,event,helper){
        var tabId = component.getLocalId();
        var tabDetailCmpAuraId;
        var existingManpowerCommonInfo;
        var existingManpowerLineItems;
        var commonCmpId;
        if(tabId == 'driverTab'){
            tabDetailCmpAuraId = 'driverDetailsCmp';
            commonCmpId = 'serviceRequestCommonCmpDriver';
            existingManpowerCommonInfo = component.get("v.existingDriverCommonData");
            existingManpowerLineItems = component.get("v.existingDriverLineItems");
            
        }else if(tabId == 'schoolBusNanniesTab'){
            tabDetailCmpAuraId = 'schoolBusNannyDetailsCmp';
            commonCmpId = 'serviceRequestCommonCmpNanny';
            existingManpowerCommonInfo = component.get("v.existingNannyCommonData");
            existingManpowerLineItems = component.get("v.existingNannyLineItems");
        }
            else if(tabId == 'supervisorTab'){
                tabDetailCmpAuraId = 'supervisorDetailsCmp';
                commonCmpId = 'serviceRequestCommonCmpSupervisor';
                existingManpowerCommonInfo = component.get("v.existingSupervisorCommonData");
                existingManpowerLineItems = component.get("v.existingSupervisorLineItems");
            }
                else if(tabId == 'coordinatorTab'){
                    tabDetailCmpAuraId = 'coordinatorDetailsCmp';
                    commonCmpId = 'serviceRequestCommonCmpCoordinator';
                    existingManpowerCommonInfo = component.get("v.existingCoordinatorCommonData");
                    existingManpowerLineItems = component.get("v.existingCoordinatorLineItems");
                }
                    else if(tabId == 'accountantTab'){
                        tabDetailCmpAuraId = 'accountantDetailsCmp';
                        commonCmpId = 'serviceRequestCommonCmpAcc';
                        existingManpowerCommonInfo = component.get("v.existingAccountantCommonData");
                        existingManpowerLineItems = component.get("v.existingAccountantLineItems");
                    }
                        else if(tabId == 'otherEmployeeTab'){
                            tabDetailCmpAuraId = 'otherEmployeeDetailsCmp';
                            commonCmpId = 'serviceRequestCommonCmpOtherEmp';
                            existingManpowerCommonInfo = component.get("v.existingOtherEmpCommonData");
                            existingManpowerLineItems = component.get("v.existingOtherEmpLineItems");
                        } 
        var id = event.getParam("childCmpAuraId");
        var lineItemNumber = event.getParam("childTabLineNumber");
        if(id == commonCmpId && existingManpowerCommonInfo != undefined){
            return (component.find(id)).prePopulateCommonData(Object.assign({},existingManpowerCommonInfo));
        }else if(id ==  tabDetailCmpAuraId && existingManpowerLineItems != undefined){
            
            var manpowerLine1Data;
            var manpowerLineCurrentData;
            for(var data of existingManpowerLineItems){
                var manpowerLineNumber = data.ET_Workforce_Line_Info__c.split(':')[1];
                if(manpowerLineNumber == 1){
                    manpowerLine1Data = data;
                }
                if(manpowerLineNumber == lineItemNumber){
                    manpowerLineCurrentData = data;
                }
            }
            var manpowerDeatilCmps = component.find(id);
            if(manpowerDeatilCmps != undefined && manpowerDeatilCmps.length == undefined){
                manpowerDeatilCmps.prePopulateLineItemData(manpowerLine1Data);
            }else if(manpowerDeatilCmps != undefined && manpowerDeatilCmps.length != undefined){
                
                for(var cmp of manpowerDeatilCmps){
                    if(cmp.get("v.lineNumber") == lineItemNumber){
                        cmp.prePopulateLineItemData(manpowerLineCurrentData);
                    }
                }
            }
        }
    },
    
   
    
    
})