({
    sendDataToMappingModal: function(component,event,helper,action){
        // var MapToSend = new Map(); 
        var receivedTabsData = component.get("v.data");
        var reserveOriginalData = new Map();
        // creating clone of original data for roll back purpose when any specific tab data goes worng in a combination
        for(var key in receivedTabsData){
            var innerMap = new Map();
            for(var innerKey in receivedTabsData[key] ){
                innerMap[innerKey] = receivedTabsData[key][innerKey];
            }
            reserveOriginalData[key] = innerMap;
        }
       
        var dataReceivedFrmCurrentCmp =  component.get("v.mapping");
        
        var vehicleDetailMap = new Map();//new Map();
        var driverDetailMap = new Map();
        var nannyDetailMap = new Map();
        var supervisorDetailMap = new Map();
        var coordinatorDetailMap = new Map();
        var accountantDetailMap = new Map();
        var otherEmpDetailMap = new Map();
        //var isCombinationValidSofar = true;
        
        
        if(receivedTabsData !=undefined && dataReceivedFrmCurrentCmp != undefined){
            if(action!='fakeDelete'){
                var vehicleDataFromReceivedData = receivedTabsData["vehicleInfo"];
                var driverDataFromUpdatedData = receivedTabsData["driverInfo"];
                var nannyDataFromUpdatedData = receivedTabsData["nannyInfo"];
                var supervisorDataFromUpdatedData = receivedTabsData["supervisorInfo"];
                var coordinatorDataFromUpdatedData = receivedTabsData["coordinatorInfo"];
                var accDataFromUpdatedData = receivedTabsData["accountantInfo"];
                var otherEmpDataFromUpdatedData = receivedTabsData["otherEmployeeInfo"];
                /*----------------vehicle---------------------------*/
                if(vehicleDataFromReceivedData != undefined ){
                    
                    vehicleDetailMap[dataReceivedFrmCurrentCmp.ET_Vehicle_Unique_key__c] = dataReceivedFrmCurrentCmp.ET_Number_of_Vehicles__c;
                    vehicleDataFromReceivedData = helper.validateCombinationData(vehicleDataFromReceivedData, vehicleDetailMap, action);
                    if(vehicleDataFromReceivedData != undefined && vehicleDataFromReceivedData != null){
                        receivedTabsData["vehicleInfo"] = vehicleDataFromReceivedData;
                    }else{  
                        component.set("v.data",reserveOriginalData);
                        //isCombinationValidSofar = false;
                        component.set("v.showError", true);
                        component.set("v.errorMessage", 'Selected Number of Vehicles are not available, Please enter appropriate Number for this combination and try to save it again');
                        return null;
                    }
                }
                
                /*-------------------driver--------------------------*/
                if(driverDataFromUpdatedData != undefined){
                    
                    driverDetailMap[dataReceivedFrmCurrentCmp.ET_Driver_Unique_Id__c] = dataReceivedFrmCurrentCmp.ET_Number_of_Drivers__c;
                    driverDataFromUpdatedData = helper.validateCombinationData(driverDataFromUpdatedData, driverDetailMap, action);
                    if(driverDataFromUpdatedData != undefined && driverDataFromUpdatedData != null){
                        receivedTabsData["driverInfo"] = driverDataFromUpdatedData;
                    }else{
                        component.set("v.data",reserveOriginalData);
                        //isCombinationValidSofar = false;
                        component.set("v.showError", true);
                        component.set("v.errorMessage", 'Selected Number of Drivers are not available, Please enter appropriate Number for this combination and and try to save it again');
                        return null;
                    }
                }
                
                /*-------------------Nanny--------------------------*/
                if(nannyDataFromUpdatedData != undefined){
                    
                    nannyDetailMap[dataReceivedFrmCurrentCmp.ET_Nanny_Unique_Key__c] = dataReceivedFrmCurrentCmp.ET_Number_of_Nannies__c;
                    nannyDataFromUpdatedData = helper.validateCombinationData(nannyDataFromUpdatedData, nannyDetailMap, action);
                    if(nannyDataFromUpdatedData != undefined && nannyDataFromUpdatedData != null){
                        receivedTabsData["nannyInfo"] = nannyDataFromUpdatedData;
                    }else{
                        component.set("v.data",reserveOriginalData);
                        //isCombinationValidSofar = false;
                        component.set("v.showError", true);
                        component.set("v.errorMessage", 'Selected Number of Nannies are not available, Please enter appropriate Number for this combinationand and try to save it again');
                        return null;
                    }
                }
                
                /*-------------------Supervisor--------------------------*/
                if(supervisorDataFromUpdatedData != undefined){
                    
                    supervisorDetailMap[dataReceivedFrmCurrentCmp.ET_Supervisor_Unique_Key__c] = dataReceivedFrmCurrentCmp.ET_Number_of_Supervisors__c;
                    supervisorDataFromUpdatedData = helper.validateCombinationData(supervisorDataFromUpdatedData, supervisorDetailMap, action);
                    if(supervisorDataFromUpdatedData != undefined && supervisorDataFromUpdatedData != null){
                        receivedTabsData["supervisorInfo"] = supervisorDataFromUpdatedData;
                    }else{
                        component.set("v.data",reserveOriginalData);
                        //isCombinationValidSofar = false;
                        component.set("v.showError", true);
                        component.set("v.errorMessage", 'Selected Number of Supervisor are not available, Please enter appropriate Number for this combination and try to save it again');
                        return null;
                    }
                }
                
                /*-------------------Coordinator--------------------------*/
                if(coordinatorDataFromUpdatedData != undefined){
                    
                    coordinatorDetailMap[dataReceivedFrmCurrentCmp.ET_Coordinator_Unique_Key__c] = dataReceivedFrmCurrentCmp.ET_Number_of_Coordinators__c;
                    coordinatorDataFromUpdatedData = helper.validateCombinationData(coordinatorDataFromUpdatedData, coordinatorDetailMap, action);
                    if(coordinatorDataFromUpdatedData != undefined && coordinatorDataFromUpdatedData != null){
                        receivedTabsData["coordinatorInfo"] = coordinatorDataFromUpdatedData;
                    }else{
                        component.set("v.data",reserveOriginalData);
                        //isCombinationValidSofar = false;
                        component.set("v.showError", true);
                        component.set("v.errorMessage", 'Selected Number of Coordinator are not available, Please enter appropriate Number for this combination and try to save it again');
                        return null;
                    }
                }
                
                /*-------------------Accountant--------------------------*/
                if(accDataFromUpdatedData != undefined){
                    
                    accountantDetailMap[dataReceivedFrmCurrentCmp.ET_Accountant_Unique_Key__c] = dataReceivedFrmCurrentCmp.ET_Number_of_Accountants__c;
                    accDataFromUpdatedData = helper.validateCombinationData(accDataFromUpdatedData, accountantDetailMap, action);
                    if(accDataFromUpdatedData != undefined && accDataFromUpdatedData != null){
                        receivedTabsData["accountantInfo"] = accDataFromUpdatedData;
                    }else{
                        component.set("v.data",reserveOriginalData);
                        //isCombinationValidSofar = false;
                        component.set("v.showError", true);
                        component.set("v.errorMessage", 'Selected Number of Accountant are not available, Please enter appropriate Number for this combination and try to save it again');
                        return null;
                    }
                }
                
                /*-------------------Other employee--------------------------*/
                if(otherEmpDataFromUpdatedData != undefined){
                    
                    otherEmpDetailMap[dataReceivedFrmCurrentCmp.ET_Other_Employee_Unique_Key__c] = dataReceivedFrmCurrentCmp.ET_Number_of_Other_Employees__c;
                    otherEmpDataFromUpdatedData = helper.validateCombinationData(otherEmpDataFromUpdatedData, otherEmpDetailMap, action);
                    if(otherEmpDataFromUpdatedData != undefined && otherEmpDataFromUpdatedData != null){
                        receivedTabsData["otherEmployeeInfo"] = otherEmpDataFromUpdatedData;
                    }else{
                        component.set("v.data",reserveOriginalData);
                        //isCombinationValidSofar = false;
                        component.set("v.showError", true);
                        component.set("v.errorMessage", 'Selected Number of Employee are not available, Please enter appropriate Number for this combination and try to save it again');
                        return null;
                    }
                }
                
            }
            var existingData = component.get("v.existingMappingRowData");
            var existingDataId;
            if(existingData){
                existingDataId = existingData.Id;
            }
            var sendDataEvent = component.getEvent("sendDataToModal");
            sendDataEvent.setParams({
                "dataMap" : receivedTabsData,
                "action" : action,
                "mappingRowRecordIdUponDeletion" : existingDataId});
            sendDataEvent.fire();
            return true;
            
        }
        return false;
        
        
        
    },
    
    
    validateCombinationData: function(specificTabDataFrmReceivedData, specificDataReceivedFrmCurrentCmp , action){
        for(var key in specificTabDataFrmReceivedData){
            for(var innerKey in specificDataReceivedFrmCurrentCmp ){
                if(key == innerKey){
                    var availableNumber;
                    if(action == 'Save'){
                        
                        availableNumber = parseInt(specificTabDataFrmReceivedData[key]) -  parseInt(specificDataReceivedFrmCurrentCmp[key]);
                        if(availableNumber >= 0){
                            specificTabDataFrmReceivedData[key] = availableNumber;
                        }else{
                            return null;
                        }
                    }else{
                        availableNumber = parseInt(specificTabDataFrmReceivedData[key]) +  parseInt(specificDataReceivedFrmCurrentCmp[key]);
                        specificTabDataFrmReceivedData[key] = availableNumber;
                    }
                    
                }
            }
            
        }
        return specificTabDataFrmReceivedData;
    },
    
    setResourceAvailableNumber: function(component, event, helper, resource){
        var data = component.get("v.data");
        if(data != undefined){
            if(resource == "Vehicle" && data['vehicleInfo'] != undefined && data['vehicleInfo'] != ''){
                var vahicleType = component.get("v.mapping.ET_Vehicle_Unique_key__c");
                component.set("v.vehicleKey", vahicleType.split('=>')[0]);
                component.set("v.currentSelectedVehicleAvailaleNumber",component.get("v.data")['vehicleInfo'][vahicleType]);
            }
            else if(resource == "Driver" && data['driverInfo'] != undefined && data['driverInfo'] != ''){
                var driverType = component.get("v.mapping.ET_Driver_Unique_Id__c");
                component.set("v.driverKey", driverType.split('=>')[0]);
                component.set("v.currentSelectedDriverAvailaleNumber",component.get("v.data")['driverInfo'][driverType]);
            }
                else if(resource == "Nanny" && data['nannyInfo'] != undefined && data['nannyInfo'] != ''){
                    var nannyType = component.get("v.mapping.ET_Nanny_Unique_Key__c");
                    component.set("v.nannyKey", nannyType.split('=>')[0]);
                    component.set("v.currentSelectedNannyAvailaleNumber",component.get("v.data")['nannyInfo'][nannyType]);
                }
                    else if(resource == "Supervisor" && data['supervisorInfo'] != undefined && data['supervisorInfo'] != ''){
                        var supervisorType = component.get("v.mapping.ET_Supervisor_Unique_Key__c");
                        component.set("v.supervisorKey", supervisorType.split('=>')[0]);
                        component.set("v.currentSelectedSupervisorAvailaleNumber",component.get("v.data")['supervisorInfo'][supervisorType]);
                    }
                        else if(resource == "Coordinator" && data['coordinatorInfo'] != undefined && data['coordinatorInfo'] != ''){
                            var coordinatorType = component.get("v.mapping.ET_Coordinator_Unique_Key__c");
                            component.set("v.coordinatorKey", coordinatorType.split('=>')[0]);
                            component.set("v.currentSelectedCoordinatorAvailaleNumber",component.get("v.data")['coordinatorInfo'][coordinatorType]);
                        }
                            else if(resource == "Accountant" && data['accountantInfo'] != undefined && data['accountantInfo'] != ''){
                                var accType = component.get("v.mapping.ET_Accountant_Unique_Key__c");
                                component.set("v.accountantKey", accType.split('=>')[0]);
                                component.set("v.currentSelectedAccountantAvailaleNumber",component.get("v.data")['accountantInfo'][accType]);
                            }
                                else if(resource == "OtherEmp" && data['otherEmployeeInfo'] != undefined && data['otherEmployeeInfo'] != ''){
                                    var empType = component.get("v.mapping.ET_Other_Employee_Unique_Key__c");
                                    component.set("v.otherEmpKey", empType.split('=>')[0]);
                                    component.set("v.currentSelectedOtherEmpAvailaleNumber",component.get("v.data")['otherEmployeeInfo'][empType]);
                                }
            
        }
    }
    
    
    
})