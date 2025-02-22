({
    doInit: function(component, event, helper) {
        //   var data = component.get("v.data");
        //    var vehicleInformation = data['vehicleInformation'];
        // alert('Init');
        
        var allDataMap = component.get("v.data");
        console.log('allDataMap = ',JSON.stringify(allDataMap));
        if(allDataMap['vehicleInfo'] != undefined){
            component.set("v.vehicleDetailsMap", allDataMap['vehicleInfo'] );
        }
        var vehicleDetailsMap = component.get("v.vehicleDetailsMap");
        console.log('vehicleDetailsMap  = '+ JSON.stringify(vehicleDetailsMap));
        if(vehicleDetailsMap != undefined){
            var vehicleNameLst = [];
            for(var key in vehicleDetailsMap){
                vehicleNameLst.push({label:key.split('=>')[0], value: key }); 
            }
            //alert('vehicleNameLst' + vehicleNameLst);
            component.set("v.vehicleNames", vehicleNameLst);
            // component.set("v.vehicleNameAndAvailableNumberMap", vehiclenameAndAvailableNumberMap);
        }
        
        var driverDetailsMap = allDataMap['driverInfo'];
        if(driverDetailsMap != undefined){
            var driverNameLst = [];
            for(var key in driverDetailsMap){
                driverNameLst.push({label:key.split('=>')[0], value: key }); 
            } 
            component.set("v.driverNames", driverNameLst);
        }
        
        var supervisorDetailsMap = allDataMap['supervisorInfo'];
        if(supervisorDetailsMap != undefined){
            var supervisorNameLst = [];
            for(var key in supervisorDetailsMap){
                supervisorNameLst.push({label:key.split('=>')[0], value: key }); 
            } 
            component.set("v.supervisorNames", supervisorNameLst);
        }
        
        
        var nannyDetailsMap = allDataMap['nannyInfo'];
        console.log(JSON.stringify(nannyDetailsMap));
        if(nannyDetailsMap != undefined){
            var nannyNameLst = [];
            for(var key in nannyDetailsMap){
                nannyNameLst.push({label:key.split('=>')[0], value: key });  
            }
            console.log('nannyNameLst :' + JSON.stringify(nannyNameLst));
            component.set("v.nannyNames", nannyNameLst);
        }
        
        
        var coordinatorDetailsMap = allDataMap['coordinatorInfo'];
        if(coordinatorDetailsMap != undefined){
            var coordinatorNameLst = [];
            for(var key in coordinatorDetailsMap){
                coordinatorNameLst.push({label:key.split('=>')[0], value: key });
            }
            component.set("v.coordinatorNames", coordinatorNameLst);
        }
        
        var accountantDetailsMap = allDataMap['accountantInfo'];
        if(accountantDetailsMap != undefined){
            var accountantNameLst = [];
            for(var key in accountantDetailsMap){
                accountantNameLst.push({label:key.split('=>')[0], value: key }); 
            }
            component.set("v.accountantNames", accountantNameLst);
        }
        
        var otherEmpDetailsMap = allDataMap['otherEmployeeInfo'];
        if(otherEmpDetailsMap != undefined){
            var otherEmpNameLst = [];
            for(var key in otherEmpDetailsMap){
                otherEmpNameLst.push({label:key.split('=>')[0], value: key }); 
            }
            component.set("v.otherEmpNames", otherEmpNameLst);
        }
        
        var existingRowData = component.get("v.existingMappingRowData");
        console.log('existing row data ::', JSON.stringify(existingRowData));
        if(existingRowData){
            if(existingRowData.ET_Vehicle_Unique_key__c){
                component.set("v.isVehicleTabSelected", true);
                
            }
            if(existingRowData.ET_Supervisor_Unique_Key__c){
                component.set("v.isSupervisorRequired", true);
                
            }
            if(existingRowData.ET_Nanny_Unique_Key__c){
                component.set("v.isNanyTabSelected", true);
                
            }
            if(existingRowData.ET_Driver_Unique_Id__c){
                component.set("v.isDriverTabSelected", true);
                
            }
            if(existingRowData.ET_Coordinator_Unique_Key__c){
                component.set("v.isCoordinatorRequired", true);
                
            }
            if(existingRowData.ET_Accountant_Unique_Key__c){
                component.set("v.isAccountantRequired", true);
                
            }
            if(existingRowData.ET_Other_Employee_Unique_Key__c){
                component.set("v.isOtherEmployeeRequired", true);
                
            }
            component.set("v.mapping",existingRowData);
            component.set("v.isCombinationSaved", true);
            component.set("v.isDisable", true);
        }
        
        
        
    },
    
    updateAvailableNumberMessages: function(component,event,helper){
        helper.setResourceAvailableNumber(component,event,helper, 'Vehicle');
        helper.setResourceAvailableNumber(component,event,helper, 'Driver');
        helper.setResourceAvailableNumber(component,event,helper, 'Nanny');
        helper.setResourceAvailableNumber(component,event,helper, 'Supervisor');
        helper.setResourceAvailableNumber(component,event,helper, 'Coordinator');
        helper.setResourceAvailableNumber(component,event,helper, 'Accountant');
        helper.setResourceAvailableNumber(component,event,helper, 'OtherEmp');
    },
    
    
    onChangeVehicle: function(component,event,helper){
        helper.setResourceAvailableNumber(component,event,helper, 'Vehicle');
        // set other Manpower list of Values based on selected Vehicle Service Type..
        var selectedVehicle = event.getSource().get("v.value");
        var allDataMap = component.get("v.data");
        var vehicleServiceInfo ; 
        var currentVehServiceType ;
        if(allDataMap['vehicleServiceInfo'] != undefined){
            vehicleServiceInfo = allDataMap['vehicleServiceInfo'];
        }
        if(vehicleServiceInfo){
            currentVehServiceType = vehicleServiceInfo[selectedVehicle];
        }
        console.log('currentVehServiceType = ' + currentVehServiceType);
        
        // with given service Type get line Names for other services..
        var driverList =[];
        var nannyList =[];
        var supervisorList =[];
        var coordinatorList =[];
        var accountantList =[];
        var otherEmployeeList =[];
        for(var key in allDataMap){
            if(key != 'vehicleServiceInfo' && key.includes("Service")){
                if(key == 'driverServiceInfo'){
                    var driverObj =  allDataMap['driverServiceInfo'];
                    for(var innerKey in driverObj){
                        if(driverObj[innerKey] == currentVehServiceType){
                            driverList.push(innerKey);
                        }
                    }
                }
                else if(key == 'nannyServiceInfo'){
                    var nannyObj =  allDataMap['nannyServiceInfo'];
                    for(var innerKey in nannyObj){
                        if(nannyObj[innerKey] == currentVehServiceType){
                            nannyList.push(innerKey);
                        }
                    }
                }
                    else if(key == 'supervisorServiceInfo'){
                        var supervisorObj =  allDataMap['supervisorServiceInfo'];
                        for(var innerKey in supervisorObj){
                            if(supervisorObj[innerKey] == currentVehServiceType){
                                supervisorList.push(innerKey);
                            }
                        }
                    }
                        else if(key == 'coordinatorServiceInfo'){
                            var coordinatorObj =  allDataMap['coordinatorServiceInfo'];
                            for(var innerKey in coordinatorObj){
                                if(coordinatorObj[innerKey] == currentVehServiceType){
                                    coordinatorList.push(innerKey);
                                }
                            }
                        }
                            else if(key == 'accountantServiceInfo'){
                                var accountantObj =  allDataMap['accountantServiceInfo'];
                                for(var innerKey in accountantObj){
                                    if(accountantObj[innerKey] == currentVehServiceType){
                                        accountantList.push(innerKey);
                                    }
                                }
                            }
                                else if(key == 'otherEmployeeServiceInfo'){
                                    var otherEmployeeObj =  allDataMap['otherEmployeeServiceInfo'];
                                    for(var innerKey in otherEmployeeObj){
                                        if(otherEmployeeObj[innerKey] == currentVehServiceType){
                                            otherEmployeeList.push(innerKey);
                                        }
                                    }
                                }
            }
        }
        console.log('driverList = ' + driverList);
        // convert names to picklist values for all services as per need and assign to component pickList attributes..
        if(driverList != undefined && driverList.length){
            var driverNamesLst = [];
            for(var driver of driverList){
                driverNamesLst.push({label:driver.split('=>')[0], value: driver }); 
            }
            component.set("v.driverNames", driverNamesLst);
        }
        if(nannyList != undefined && nannyList.length){
            var nannyNamesLst = [];
            for(var nanny of nannyList){
                nannyNamesLst.push({label:nanny.split('=>')[0], value: nanny }); 
            }
            component.set("v.nannyNames", nannyNamesLst);
        }
        if(supervisorList != undefined && supervisorList.length){
            var supervisorNamesLst = [];
            for(var supervisor of supervisorList){
                supervisorNamesLst.push({label:supervisor.split('=>')[0], value: supervisor }); 
            }
            component.set("v.supervisorNames", supervisorNamesLst);
        }
        if(coordinatorList != undefined && coordinatorList.length){
            var coordinatorNamesLst = [];
            for(var coordinator of coordinatorList){
                coordinatorNamesLst.push({label:coordinator.split('=>')[0], value: coordinator }); 
            }
            component.set("v.coordinatorNames", coordinatorNamesLst);
        }
        if(accountantList != undefined && accountantList.length){
            var accountantNamesLst = [];
            for(var accountant of accountantList){
                accountantNamesLst.push({label:accountant.split('=>')[0], value: accountant }); 
            }
            component.set("v.accountantNames", accountantNamesLst);
        }
        if(otherEmployeeList != undefined && otherEmployeeList.length){
            var otherEmployeeNamesLst = [];
            for(var otherEmployee of otherEmployeeList){
                otherEmployeeNamesLst.push({label:otherEmployee.split('=>')[0], value: otherEmployee }); 
            }
            component.set("v.otherEmpNames", otherEmployeeNamesLst);
        }   
    },
    
    onChangeDriver: function(cmp, event, helper){
        //cmp.set("v.showError", false);
        //cmp.set("v.errorMessage",'');
        
        helper.setResourceAvailableNumber(cmp,event,helper, 'Driver');
    },
    onChangeNanny: function(cmp, event, helper){
        //cmp.set("v.showError", false);
        //cmp.set("v.errorMessage",'');
        
        helper.setResourceAvailableNumber(cmp,event,helper, 'Nanny');
    },
    onChangeSupervisor: function(cmp, event, helper){
        //cmp.set("v.showError", false);
        //cmp.set("v.errorMessage",'');
        
        helper.setResourceAvailableNumber(cmp,event,helper, 'Supervisor');
    },
    onChangeCoordinator: function(cmp, event, helper){
        //cmp.set("v.showError", false);
        //cmp.set("v.errorMessage",'');
        
        helper.setResourceAvailableNumber(cmp,event,helper, 'Coordinator');
    }, 
    
    onChangeAccountant: function(cmp, event, helper){
        //cmp.set("v.showError", false);
        //cmp.set("v.errorMessage",'');
        
        helper.setResourceAvailableNumber(cmp,event,helper, 'Accountant');
    }, 
    onChangeOtherEmp: function(cmp, event, helper){
        //cmp.set("v.showError", false);
        //cmp.set("v.errorMessage",'');
        
        helper.setResourceAvailableNumber(cmp,event,helper, 'OtherEmp');
    }, 
    
    
    handleRemove: function(component, event, helper) {
        if(component.get("v.isCombinationSaved")){
            helper.sendDataToMappingModal(component,event,helper,'Delete');
        }else{
            helper.sendDataToMappingModal(component,event,helper,'fakeDelete');
        }
        component.destroy();
    },
    
    calculateAvailableNoforSelectedVehicle:  function(component, event, helper) {
        /* component.set("v.currentSelectedVehicleAvailaleNumber",component.get("v.vehicleNameAndAvailableNumberMap")[vahicleType]);
    var selectedVehicle = component.get("v.mapping.ET_Vehicle_Unique_key__c");
    var vehicleNameAndAvailableNumberMap = component.get("v.vehicleNameAndAvailableNumberMap"); 
    
    if(selectedVehicle != undefined && vehicleNameAndAvailableNumberMap != undefined && vehicleNameAndAvailableNumberMap[selectedVehicle] != undefined){
      var totalNumber = parseInt(vehicleNameAndAvailableNumberMap[selectedVehicle] );
      if(totalNumber != undefined){
      var avilableVehicleNumber = totalNumber - component.get("v.mapping.ET_Number_of_Vehicles__c");
      if(avilableVehicleNumber >= 0){
        vehicleNameAndAvailableNumberMap[selectedVehicle] = avilableVehicleNumber;
        component.set("v.currentSelectedVehicleAvailaleNumber", avilableVehicleNumber);
      component.set("v.vehicleNameAndAvailableNumberMap", vehicleNameAndAvailableNumberMap);
      }
    }
  }*/
    },
    
    saveCombination: function(component,event,helper){
        component.set("v.showError", false);
        component.set("v.errorMessage",'');
        var elementLst = [];
        var allElementIdslst = component.get("v.auraIdLst");
        for(let ele of allElementIdslst){
            if(component.find(ele) != undefined){
                elementLst.push(component.find(ele));
            }
        }
        var anyOneElementIsNotZero = false;
        
        var allValid = elementLst.reduce(function (validSoFar, inputCmp) {
            // alert('inputCmp.value '+ inputCmp.get('v.value'));
            if(!isNaN(inputCmp.get('v.value')) && inputCmp.get('v.value') != 0){
                anyOneElementIsNotZero = true;
            }             
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true);
        if(allValid){
            if(anyOneElementIsNotZero){
                if(helper.sendDataToMappingModal(component,event,helper,'Save')){
                    component.set("v.isCombinationSaved",true );
                    component.set("v.isDisable", true);
                }
            }else{
                component.set("v.showError", true);
                component.set("v.errorMessage",'Not a valid combination to save');
            }
            
        }
    }
});