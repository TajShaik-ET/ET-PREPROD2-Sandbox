({
    updateTabsHelper :  function(component, event, helper,selectedTab,selectedTabValue) {
        debugger;
        var originalArray = component.get("v.selectedTabs");
        
        if(selectedTabValue){
            originalArray.push(selectedTab);
        }else{
            var filteredItems = originalArray.filter(function(item) {
                return item !== selectedTab
            })
            console.log('filteredItems ',filteredItems);
            originalArray = filteredItems;
        }
        
        component.set("v.selectedTabs",originalArray);
        var originalArray = component.get("v.selectedTabs");
        console.log('originalArray'+originalArray);
        if(originalArray.length > 0){
            component.set("v.atleastOneTabIsSelected", true);
        }else{
            component.set("v.atleastOneTabIsSelected", false); 
        }
        var newArray = [];
        var lookupObject  = {};
        for(var i in originalArray) {
            lookupObject[originalArray[i]] = originalArray[i];
        }
        var firstTab ;
        for(i in lookupObject) {
            newArray.push(lookupObject[i]);
            firstTab = lookupObject[i];
        }
        //Taj
        const message = {
            selectedTabs: newArray
        };
        component.find("changeInTabsLMS").publish(message);
        
        helper.updateTabsVisibilityFromList(component, event, helper,newArray,selectedTabValue,selectedTab, firstTab);
    }, 
    
    getActiveQuoteId : function(component, event, helper){
        var action = component.get("c.getActiveQuoteId");
        action.setParams({ serviceRequestId : component.get("v.serviceRequestRecordId") });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                component.set("v.activeQuoteId" , response );     
            }
            else if (state === "INCOMPLETE") {
                console.log('Network Issue or Server Down');
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message + "Method : " + 'getActiveQuoteId');
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    
    EditableFieldsForPricingTeam : function(component, event, helper){
        var action = component.get("c.getEditableFieldsforPricingTeam");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('editableFieldsforPricingTeam = ' + response.getReturnValue());
                var resObj = JSON.parse(response.getReturnValue()) ;
                if(resObj){
                    component.set("v.editableVehicleFieldsforPricingTeam",resObj.Vehicle );
                    component.set("v.editableDriverFieldsforPricingTeam",resObj.Driver );
                    component.set("v.editableNannyFieldsforPricingTeam",resObj.Nanny );
                    component.set("v.editableSupervisorFieldsforPricingTeam",resObj.Supervisors );
                    component.set("v.editableCoordinatorFieldsforPricingTeam",resObj.Coordinators );
                    component.set("v.editableAccntantFieldsforPricingTeam",resObj.Accountant );
                    component.set("v.editableOtherEmployeeFieldsforPricingTeam",resObj.Other_Employee );
                }
                
            }
            else if (state === "INCOMPLETE") {
                console.log('Network Issue or Server Down');
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message + "Method :" + 'EditableFieldsForPricingTeam');
                            var toastReference = $A.get("e.force:showToast");
                            toastReference.setParams({
                                "type":"Error",
                                "title":"Error",
                                "message":"Internal Server Error. Please Contact System Admin.",
                                "mode":"sticky"
                            });
                            toastReference.fire();
                            //helper.showToastHelper('Error','error',errors[0].message,'sticky');
                            //alert('Internal Server Error. Please Contact System Admin.');
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    
    UserPermissions : function(component, event, helper){
        var action = component.get("c.getUserPermissions");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('getUserPermissions = ' + JSON.stringify(response.getReturnValue()));
                var resObj = response.getReturnValue() ;
                if(resObj){ 
                    component.set("v.isPricingTeam" , resObj.isPricingTeam);
                    console.log('isPricingTeam__q'+resObj.isPricingTeam);
                }   
            }
            else if (state === "INCOMPLETE") {
                console.log('Network Issue or Server Down');
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message + "Method :" + 'UserPermissions');
                            helper.showToastHelper('Error','error',errors[0].message,'sticky');
                            //alert('Internal Server Error. Please Contact System Admin.');
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    
    
    /* Method : processAllTabData 
       Description : To set -- tabInfoToSendToMappingCmpMap --> That is to set info needs to set in Customize Pricing...
       				 Sets Vehicle Display Name and Vehicle Number
    */
    
    processAllTabData: function(component, event, helper, tabRawData){
        console.log('map::', tabRawData);
        if(tabRawData['vehicleCommonInfo'] != undefined && tabRawData['vehicleTabInfo'] != undefined){
            
            var vehicleInfoLst = tabRawData['vehicleTabInfo'];
            var vehicleDisplayNameAndNumberMap = new Map();
            var vehicleNameAndServiceTypeMap = new Map();
            for(var vehicle of tabRawData['vehicleTabInfo']){
                //var vehicleDisplayName = vehicle['ET_Vehicle_MAKE__c'] + '_' + vehicle['ET_Vehicle_Model__c'] + '_' +vehicle['ET_Vehicle_Specs__c'] + '_' + vehicle['ET_Vehicle_Model_Year__c'];
                var vehicleDisplayName = vehicle['ET_Vehicle_MAKE__c'] + '_' + vehicle['ET_Vehicle_Model__c'] + '_' + vehicle['ET_Vehicle_Model_Year__c'];
                var vehicleNumber = parseInt(vehicle['ET_Vehicle_Quantity__c']);  
                var vehicleServiceType = vehicle['ET_Service_Type__c'];  
                //vehicleDisplayName =  vehicleDisplayName.substring(0, vehicleDisplayName.lastIndexOf('_'));
                if(vehicle['ET_Vehicle_Line__c'] != undefined){
                    vehicleDisplayName = vehicleDisplayName + '=>' + vehicle['ET_Vehicle_Line__c'];
                }
                if(vehicleDisplayNameAndNumberMap[vehicleDisplayName] == undefined){
                    vehicleDisplayNameAndNumberMap[vehicleDisplayName] = vehicleNumber;
                    vehicleNameAndServiceTypeMap[vehicleDisplayName] = vehicleServiceType;
                }
                else{
                    vehicleDisplayNameAndNumberMap[vehicleDisplayName] = parseInt(vehicleDisplayNameAndNumberMap[vehicleDisplayName]) + parseInt(vehicleNumber);
                }
            }
            
            if(vehicleDisplayNameAndNumberMap != undefined){
                var map = component.get("v.tabInfoToSendToMappingCmpMap");
                if(map != undefined){
                    map['vehicleInfo'] = vehicleDisplayNameAndNumberMap;
                    map['vehicleServiceInfo'] = vehicleNameAndServiceTypeMap;
                }else{
                    map = new Map();
                    map['vehicleInfo'] = vehicleDisplayNameAndNumberMap;
                    map['vehicleServiceInfo'] = vehicleNameAndServiceTypeMap;
                }
                console.log('tabInfoToSendToMappingCmpMap :  '+ JSON.stringify(map));
                component.set("v.tabInfoToSendToMappingCmpMap", map );
            }
            
        }
        
        if(tabRawData['driverCommonInfo'] != undefined && tabRawData['driverTabInfo'] != undefined){
            var driverDisplayNameAndNumberMap = new Map();
            var driverNameAndServiceTypeMap = new Map();
            for(var driver of tabRawData['driverTabInfo']){
                var driverDisplayName = driver['ET_Driver_Category__c']; 
                var driverNumber = parseInt(driver['ET_No_of_Drivers__c']); 
                var driverServiceType = driver['ET_Service_Type__c'];  
                if(driver['ET_Driver_Line__c'] != undefined){
                    driverDisplayName = driverDisplayName + '=>' + driver['ET_Driver_Line__c'];
                }
                else if(driver['ET_Workforce_Line_Info__c']){
                    driverDisplayName = driverDisplayName + '=>' + (driver['ET_Workforce_Line_Info__c']).split(':')[1];     
                }
                //driverDisplayName =  driverDisplayName.substring(0, driverDisplayName.lastIndexOf('_')-1);
                if(driverDisplayNameAndNumberMap[driverDisplayName] == undefined){
                    driverDisplayNameAndNumberMap[driverDisplayName] = driverNumber;
                    driverNameAndServiceTypeMap[driverDisplayName] = driverServiceType;
                }else{
                    driverDisplayNameAndNumberMap[driverDisplayName] = parseInt(driverDisplayNameAndNumberMap[driverDisplayName]) +  parseInt(driverNumber);
                }
            }
            
            if(driverDisplayNameAndNumberMap != undefined){
                var map = component.get("v.tabInfoToSendToMappingCmpMap");
                if(map != undefined){
                    map['driverInfo'] = driverDisplayNameAndNumberMap;
                    map['driverServiceInfo'] = driverNameAndServiceTypeMap;
                }else{
                    map = new Map();
                    map['driverInfo'] = driverDisplayNameAndNumberMap;
                    map['driverServiceInfo'] = driverNameAndServiceTypeMap;
                }
                console.log('tabInfoToSendToMappingCmpMap :  '+ JSON.stringify(map));
                component.set("v.tabInfoToSendToMappingCmpMap", map );
            }
            
            
        }
        
        if(tabRawData['nannyCommonInfo'] != undefined && tabRawData['nannyTabInfo'] != undefined){
            var nannyDisplayNameAndNumberMap = new Map();
            var nannyNameAndServiceTypeMap = new Map();
            for(var nanny of tabRawData['nannyTabInfo']){
                var nannyDisplayName =  nanny['ET_Nanny_Category__c'];
                var nannyNumber = parseInt(nanny['ET_Number_of_Nannies__c']);  
                var nannyServiceType = nanny['ET_Service_Type__c'];  
                if(nanny['ET_Nanny_Line__c'] != undefined){
                    nannyDisplayName = nannyDisplayName + '=>' + nanny['ET_Nanny_Line__c'];
                }
                else if(nanny['ET_Workforce_Line_Info__c']){
                    nannyDisplayName = nannyDisplayName + '=>' + (nanny['ET_Workforce_Line_Info__c']).split(':')[1];     
                }
                if(nannyDisplayNameAndNumberMap[nannyDisplayName] == undefined){
                    nannyNameAndServiceTypeMap[nannyDisplayName] = nannyServiceType;
                    nannyDisplayNameAndNumberMap[nannyDisplayName] = nannyNumber;
                }else{
                    nannyDisplayNameAndNumberMap[nannyDisplayName] = parseInt(nannyDisplayNameAndNumberMap[nannyDisplayName]) +  parseInt(nannyNumber);
                }
            }
            
            if(nannyDisplayNameAndNumberMap != undefined){
                var map = component.get("v.tabInfoToSendToMappingCmpMap");
                if(map != undefined){
                    map['nannyInfo'] = nannyDisplayNameAndNumberMap;
                    map['nannyServiceInfo'] = nannyNameAndServiceTypeMap;
                }else{
                    map = new Map();
                    map['nannyInfo'] = nannyDisplayNameAndNumberMap;
                    map['nannyServiceInfo'] = nannyNameAndServiceTypeMap;
                }
                console.log('tabInfoToSendToMappingCmpMap :  '+ JSON.stringify(map));
                component.set("v.tabInfoToSendToMappingCmpMap", map );
            }
            
            
        }
        
        if(tabRawData['supervisorCommonInfo'] != undefined && tabRawData['supervisorTabInfo'] != undefined){
            var supervisorDisplayNameAndNumberMap = new Map();
            var supervisorNameAndServiceTypeMap = new Map();
            for(var supervisor of tabRawData['supervisorTabInfo']){
                var supervisorDisplayName = supervisor['ET_Supervisor_Category__c' ];
                var supervisorNumber = parseInt(supervisor['ET_Number_of_Supervisors__c']);  
                var supervisorServiceType = supervisor['ET_Service_Type__c'];  
                if(supervisor['ET_Supervisor_Line__c'] != undefined){
                    supervisorDisplayName = supervisorDisplayName + '=>' + supervisor['ET_Supervisor_Line__c'];
                }
                else if(supervisor['ET_Workforce_Line_Info__c']){
                    supervisorDisplayName = supervisorDisplayName + '=>' + (supervisor['ET_Workforce_Line_Info__c']).split(':')[1];     
                }
                if(supervisorDisplayNameAndNumberMap[supervisorDisplayName] == undefined){
                    supervisorNameAndServiceTypeMap[supervisorDisplayName] = supervisorServiceType;
                    supervisorDisplayNameAndNumberMap[supervisorDisplayName] = supervisorNumber;
                }else{
                    supervisorDisplayNameAndNumberMap[supervisorDisplayName] = parseInt(supervisorDisplayNameAndNumberMap[supervisorDisplayName]) +  parseInt(supervisorNumber);
                }
            }
            
            if(supervisorDisplayNameAndNumberMap != undefined){
                var map = component.get("v.tabInfoToSendToMappingCmpMap");
                if(map != undefined){
                    map['supervisorServiceInfo'] = supervisorNameAndServiceTypeMap;
                    map['supervisorInfo'] = supervisorDisplayNameAndNumberMap;
                }else{
                    map = new Map();
                    map['supervisorServiceInfo'] = supervisorNameAndServiceTypeMap;
                    map['supervisorInfo'] = supervisorDisplayNameAndNumberMap;
                }
                console.log('tabInfoToSendToMappingCmpMap :  '+ JSON.stringify(map));
                component.set("v.tabInfoToSendToMappingCmpMap", map );
            }
            
            
        }
        
        if(tabRawData['coordinatorCommonInfo'] != undefined && tabRawData['coordinatorTabInfo'] != undefined){
            var coordinatorDisplayNameAndNumberMap = new Map();
            var coordinatorNameAndServiceTypeMap = new Map();
            for(var coordinator of tabRawData['coordinatorTabInfo']){
                var coordinatorDisplayName =  coordinator['ET_Coordinator_Category__c'];
                var coordinatorNumber = parseInt(coordinator['ET_Number_of_Coordinators__c']);  
                var coordinatorServiceType = coordinator['ET_Service_Type__c'];  
                if(coordinator['ET_Coordinator_Line__c'] != undefined){
                    coordinatorDisplayName = coordinatorDisplayName + '=>' + coordinator['ET_Coordinator_Line__c'];
                }
                else if(coordinator['ET_Workforce_Line_Info__c']){
                    coordinatorDisplayName = coordinatorDisplayName + '=>' + (coordinator['ET_Workforce_Line_Info__c']).split(':')[1];     
                }
                if(coordinatorDisplayNameAndNumberMap[coordinatorDisplayName] == undefined){
                    coordinatorNameAndServiceTypeMap[coordinatorDisplayName] = coordinatorServiceType;
                    coordinatorDisplayNameAndNumberMap[coordinatorDisplayName] = coordinatorNumber;
                }else{
                    coordinatorDisplayNameAndNumberMap[coordinatorDisplayName] = parseInt(coordinatorDisplayNameAndNumberMap[coordinatorDisplayName]) +  parseInt(coordinatorNumber);
                }
            }
            
            if(coordinatorDisplayNameAndNumberMap != undefined){
                var map = component.get("v.tabInfoToSendToMappingCmpMap");
                if(map != undefined){
                    map['coordinatorInfo'] = coordinatorDisplayNameAndNumberMap;
                    map['coordinatorServiceInfo'] = coordinatorNameAndServiceTypeMap;
                }else{
                    map = new Map();
                    map['coordinatorInfo'] = coordinatorDisplayNameAndNumberMap;
                    map['coordinatorServiceInfo'] = coordinatorNameAndServiceTypeMap;
                }
                console.log('tabInfoToSendToMappingCmpMap :  '+ JSON.stringify(map));
                component.set("v.tabInfoToSendToMappingCmpMap", map );
            }
            
            
        }
        
        if(tabRawData['accountantCommonInfo'] != undefined && tabRawData['accountantTabInfo'] != undefined){
            var accountantDisplayNameAndNumberMap = new Map();
            var accountantNameAndServiceTypeMap = new Map();
            for(var accountant of tabRawData['accountantTabInfo']){
                var accountantDisplayName = ''; 
                var accountantNumber ; 
                var accountantServiceType = accountant['ET_Service_Type__c'];  
                for(let key in accountant){
                    
                    if(key == 'ET_Accountant_Category__c' ){
                        accountantDisplayName = accountant[key];
                    }
                    if(key == 'ET_Number_of_Accountants__c'){
                        accountantNumber = parseInt(accountant[key]);  
                        
                    } 
                    
                }
                if(accountant['ET_Accountant_Line__c'] != undefined){
                    accountantDisplayName = accountantDisplayName + '=>' + accountant['ET_Accountant_Line__c'];
                }
                else if(accountant['ET_Workforce_Line_Info__c']){
                    accountantDisplayName = accountantDisplayName + '=>' + (accountant['ET_Workforce_Line_Info__c']).split(':')[1];     
                }
                if(accountantDisplayNameAndNumberMap[accountantDisplayName] == undefined){
                    accountantDisplayNameAndNumberMap[accountantDisplayName] = accountantNumber;
                    accountantNameAndServiceTypeMap[accountantDisplayName] = accountantServiceType;
                }else{
                    accountantDisplayNameAndNumberMap[accountantDisplayName] = parseInt(accountantDisplayNameAndNumberMap[accountantDisplayName]) +  parseInt(accountantNumber);
                }
            }
            
            if(accountantDisplayNameAndNumberMap != undefined){
                var map = component.get("v.tabInfoToSendToMappingCmpMap");
                if(map != undefined){
                    map['accountantInfo'] = accountantDisplayNameAndNumberMap;
                    map['accountantServiceInfo'] = accountantNameAndServiceTypeMap;
                }else{
                    map = new Map();
                    map['accountantInfo'] = accountantDisplayNameAndNumberMap;
                    map['accountantServiceInfo'] = accountantNameAndServiceTypeMap;
                }
                console.log('tabInfoToSendToMappingCmpMap :  '+ JSON.stringify(map));
                component.set("v.tabInfoToSendToMappingCmpMap", map );
            }
            
            
        }
        if(tabRawData['otherEmployeeCommonInfo'] != undefined && tabRawData['otherEmployeeTabInfo'] != undefined){
            var otherEmployeeDisplayNameAndNumberMap = new Map();
            var otherEmployeeNameAndServiceTypeMap = new Map();
            for(var otherEmployee of tabRawData['otherEmployeeTabInfo']){
                var otherEmployeeDisplayName = ''; 
                var otherEmployeeNumber ; 
                var otherEmployeeServiceType = otherEmployee['ET_Service_Type__c'];  
                for(let key in otherEmployee){
                    if(key == 'ET_Other_employee_Category__c' ){
                        otherEmployeeDisplayName = otherEmployee[key];
                    }
                    if(key == 'ET_Number_of_Other_Employees__c'){
                        otherEmployeeNumber = parseInt(otherEmployee[key]);  
                        
                    } 
                    
                }
                if(otherEmployee['ET_OtherEmployee_Line__c'] != undefined){
                    otherEmployeeDisplayName = otherEmployeeDisplayName + '=>' + otherEmployee['ET_OtherEmployee_Line__c'];
                }
                else if(otherEmployee['ET_Workforce_Line_Info__c']){
                    otherEmployeeDisplayName = otherEmployeeDisplayName + '=>' + (otherEmployee['ET_Workforce_Line_Info__c']).split(':')[1];     
                }
                if(otherEmployeeDisplayNameAndNumberMap[otherEmployeeDisplayName] == undefined){
                    otherEmployeeNameAndServiceTypeMap[otherEmployeeDisplayName] = otherEmployeeServiceType;
                    otherEmployeeDisplayNameAndNumberMap[otherEmployeeDisplayName] = otherEmployeeNumber;
                }else{
                    otherEmployeeDisplayNameAndNumberMap[otherEmployeeDisplayName] = parseInt(otherEmployeeDisplayNameAndNumberMap[otherEmployeeDisplayName]) +  parseInt(otherEmployeeNumber);
                }
            }
            
            if(otherEmployeeDisplayNameAndNumberMap != undefined){
                var map = component.get("v.tabInfoToSendToMappingCmpMap");
                if(map != undefined){
                    map['otherEmployeeInfo'] = otherEmployeeDisplayNameAndNumberMap;
                    map['otherEmployeeServiceInfo'] = otherEmployeeNameAndServiceTypeMap;
                }else{
                    map = new Map();
                    map['otherEmployeeInfo'] = otherEmployeeDisplayNameAndNumberMap;
                    map['otherEmployeeServiceInfo'] = otherEmployeeNameAndServiceTypeMap;
                }
                console.log('tabInfoToSendToMappingCmpMap :  '+ JSON.stringify(map));
                component.set("v.tabInfoToSendToMappingCmpMap", map );
            }
            
            
        }
    },
    
    
    updateTabsVisibilityFromList :  function(component, event, helper,selectedTabsList,selectedTabValue,selectedTab, firstTab) {
        debugger;
        if(selectedTabsList.length == 0){
            component.set("v.displayTabs",false);
        }else{
            component.set("v.displayTabs",true);
            
        }
        if(selectedTab  == 'Drivers'){
            if(selectedTabValue){
                component.set("v.displayDriverTab",true);
                /*var delayInMilliseconds = 500; //0.08 seconds
                window.setTimeout(
                    $A.getCallback(function() {
                        helper.intializeTabComponent(component,helper,selectedTab);
                    }), delayInMilliseconds
                ); */   
                
            }else{
                
                /* if(component.find("driverTab")!=null || component.find("driverTab")!='undefined'){
                    component.find("driverTab").destroy();
                }else{
                    console.log(' Driver tab is already Destroyed ');
                }*/
                component.set("v.displayDriverTab",false);
            }
        }
        
        if(selectedTab == 'Vehicle'){
            if(selectedTabValue){
                component.set("v.displayVehicleTab",true);
                /*var delayInMilliseconds = 500; //0.08 seconds
                window.setTimeout(
                    $A.getCallback(function() {
                        helper.intializeTabComponent(component,helper,selectedTab);
                    }), delayInMilliseconds
                );    */
                
            }else{
                
                /*if(component.find("vehicleTab")!=null || component.find("vehicleTab")!='undefined'){
                    component.find("vehicleTab").destroy();
                }else{
                    console.log(' Vehicle tab is already Destroyed ');
                }*/
                component.set("v.displayVehicleTab",false);
            }
            
        }
        
        if(selectedTab == 'School_Bus_Nannies'){
            if(selectedTabValue){
                component.set("v.displaySchoolNanniesTab",true);
                /*var delayInMilliseconds = 500; //0.08 seconds
                window.setTimeout(
                    $A.getCallback(function() {
                        helper.intializeTabComponent(component,helper,selectedTab);
                    }), delayInMilliseconds
                );   */ 
            }else{
                
                /*if(component.find("schoolBusNanniesTab")!=null || component.find("schoolBusNanniesTab")!='undefined'){
                    component.find("schoolBusNanniesTab").destroy();
                }else{
                    console.log(' Nanny tab is already Destroyed ');
                }*/
                component.set("v.displaySchoolNanniesTab",false);
            }
        }
        
        if(selectedTab == 'Supervisors'){
            if(selectedTabValue){
                component.set("v.displaySupervisorTab",true);
                /*var delayInMilliseconds = 500; //0.08 seconds
                window.setTimeout(
                    $A.getCallback(function() {
                        helper.intializeTabComponent(component,helper,selectedTab);
                    }), delayInMilliseconds
                );  */  
                
            }else{
                
                /*if(component.find("supervisorTab")!=null || component.find("supervisorTab")!='undefined'){
                    component.find("supervisorTab").destroy();
                }else{
                    console.log(' Supervisor tab is already Destroyed ');
                }*/
                component.set("v.displaySupervisorTab",false);
            }
        }
        
        
        if(selectedTab == 'Coordinators'){
            if(selectedTabValue){
                component.set("v.displayCoordinatorTab",true);
                /*var delayInMilliseconds = 500; //0.08 seconds
                window.setTimeout(
                    $A.getCallback(function() {
                        helper.intializeTabComponent(component,helper,selectedTab);
                    }), delayInMilliseconds
                );   */ 
                
            }else{
                
                /*if(component.find("coordinatorTab")!=null || component.find("coordinatorTab")!='undefined'){
                    component.find("coordinatorTab").destroy();
                }else{
                    console.log(' Coordinator tab is already Destroyed ');
                }*/
                component.set("v.displayCoordinatorTab",false);
            }
        }
        
        if(selectedTab == 'Accountant'){
            if(selectedTabValue){
                component.set("v.displayAccountantTab",true);
                /*var delayInMilliseconds = 500; //0.08 seconds
                window.setTimeout(
                    $A.getCallback(function() {
                        helper.intializeTabComponent(component,helper,selectedTab);
                    }), delayInMilliseconds
                );    */
            }else{
                
                /*if(component.find("accountantTab")!=null || component.find("accountantTab")!='undefined'){
                    component.find("accountantTab").destroy();
                }else{
                    console.log(' Accountant tab is already Destroyed ');
                }*/
                component.set("v.displayAccountantTab",false);
            }
        }
        
        if(selectedTab == 'Other_Employees'){
            if(selectedTabValue){
                component.set("v.displayOtherEmployeesTab",true);
                /*var delayInMilliseconds = 500; //0.08 seconds
                window.setTimeout(
                    $A.getCallback(function() {
                        helper.intializeTabComponent(component,helper,selectedTab);
                    }), delayInMilliseconds
                );  */  
            }else{
                
                /*if(component.find("otherEmployeeTab")!=null || component.find("otherEmployeeTab")!='undefined'){
                    component.find("otherEmployeeTab").destroy();
                }else{
                    console.log(' Other Employee tab is already Destroyed ');
                }*/
                component.set("v.displayOtherEmployeesTab",false);
            }
            
        }
        
        if(selectedTab == 'Other_Cost'){
            if(selectedTabValue){
                component.set("v.displayOtherCostTab",true);
                /*var delayInMilliseconds = 500; //0.08 seconds
                window.setTimeout(
                    $A.getCallback(function() {
                        helper.intializeTabComponent(component,helper,selectedTab);
                    }), delayInMilliseconds
                );  */  
            }else{
                
                /*if(component.find("otherCostTab")!=null || component.find("otherCostTab")!='undefined'){
                    component.find("otherCostTab").destroy();
                }else{
                    console.log(' Other Cost tab is already Destroyed ');
                }*/
                component.set("v.displayOtherCostTab",false);
            }
            
        }
        
        if(selectedTabValue){
            component.set("v.selectedTabId",selectedTab);
        }else{
            component.set("v.selectedTabId",firstTab);
        }
        
    },
    
    
    saveServiceRequestData :  function(component, event, helper,serviceRequestId, dataFrmAllTabs) {
        debugger;
        console.log('dataFrmAllTabs'+JSON.stringify(dataFrmAllTabs));
        //console.log('saveMappingModalData'+JSON.stringify(driverdata['driverTabInfo']));
        var action = component.get("c.saveServiceRequestData");
        var operation;
        if(component.get("v.existingApplicationData")){
            operation = 'Edit';
        }else{
            operation = 'Save';
        }
        console.log('dataFrmAllTabs from saveServiceRequestData method : '+ JSON.stringify(dataFrmAllTabs));
        action.setParams({
            'allTabData' : dataFrmAllTabs,
            'serviceRequestId': serviceRequestId,
            'operation' : operation,
            'existingCommonDataTabLst' : component.get("v.existingCommonDataTabListUponLoading")
            
        });
        component.set('v.loaded', !component.get('v.loaded'));
        
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                component.set('v.loaded', !component.get('v.loaded'));
                var result = a.getReturnValue();
                console.log('Result from save : ' + result);
                if(result == 'Success'){
                    //Taj
                    //this.handleVehicleQuantityChange(component, event, helper);
                    this.handleVehicleQuantityChange(component, event, helper)
                        .then(function (response) {
                            var result = response;
                            if (result == true)
                                helper.showToast(component, event, helper, 'Warning', 'Pricing combinations are deleted. Please create again.', 'warning', 'sticky');
                            if (result == false || result == 'undefined' || result == null)
                                helper.showToast(component, event, helper, 'Warning', 'Please udpate Pricing combinations again.', 'warning', 'sticky');
                            console.log('handleVehicleQuantityChange result: ' + result);
                        })
                        .catch(function (error) {
                            var errors = error;
                            if (errors && errors[0] && errors[0].message) {
                                console.log('handleVehicleQuantityChange error:');
                                console.table(errors);
                                component.set("v.error", errors[0].message);
                            }
                        });
                    
                    if(component.get("v.opportunityRecordId")){
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"success",
                            "title":"success",
                            "message":"All Information got saved successfully, Redirecting to the Pricing Request",
                            "mode":"sticky"
                        });
                        toastReference.fire();
                        // alert('All Informatio got saved successfully, Redirecting to the Pricing Request');
                        //window.open('/c/CreatePricingServiceRequestApp.app?recordId='+component.get('v.serviceRequestRecordId'), '_self');
                        window.open('/lightning/cmp/c__ET_ServiceRequestForm?c__recordId='+component.get('v.serviceRequestRecordId'), '_self');
                    }else{
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"success",
                            "title":"success",
                            "message":"All Information got saved successfully",
                            "mode":"sticky"
                        });
                        toastReference.fire();
                        // alert('All Information got saved successfully');
                        //location.reload();
                        $A.get('e.force:refreshView').fire(); //Taj commented
                    }
                    
                    
                    var oppRecordType = component.get("v.oppRecordType");
                    if(oppRecordType){
                        if(oppRecordType == 'ETSALES_Leasing' || oppRecordType == 'ETSALES_Manpower'){
                            component.set("v.disableCustomizePricingBttn", true);
                            component.set("v.disableQuoteBttn", false); 
                        }
                    }else{
                        component.set("v.disableCustomizePricingBttn", false); 
                    }
                }
                
                console.log('state '+a.getState());
                
                //var response=a.getReturnValue();
                //if(response!=null && response!= undefined){
                // }
            }
            else if (state === "INCOMPLETE") {
                console.log('Network Issue or Server Down');
            }
                else if (state === "ERROR") {
                    component.set('v.loaded', !component.get('v.loaded'));
                    var errors = a.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message + "Method :SaveServiceRequest" );
                            var toastReference = $A.get("e.force:showToast");
                            toastReference.setParams({
                                "type":"Error",
                                "title":"Error",
                                "message":"Something wrong happened! Information didn\'t get saved successfully. Please Try again or contact System Admin.",
                                "mode":"sticky"
                            });
                            toastReference.fire();
                            // helper.showToastHelper('Error','error',errors[0].message,'sticky');
                            // alert("Error message: " +errors[0].message);
                            //alert('Something wrong happened! Information didn\'t get saved successfully. Please Try again or contact System Admin');
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },

    //Taj
    handleVehicleQuantityChange: function (component, event, helper) {
        return new Promise(function (resolve, reject) {
            var changeInVehicleQuantity = component.get("v.changeInVehicleQuantity");
            if (changeInVehicleQuantity == true) {
                var action = component.get("c.deletePricingRequestMapping");
                action.setParams({
                    'serviceRequestRecordId': component.get("v.serviceRequestRecordId")
                });
                action.setCallback(this, function (response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        resolve(response.getReturnValue());
                        var result = response.getReturnValue();
                        if (result == true)
                            helper.showToast(component, event, helper, 'Warning', 'Pricing combinations are deleted. Please create again.', 'warning', 'sticky');
                        if (result == false || result == 'undefined' || result == null)
                            helper.showToast(component, event, helper, 'Warning', 'Please udpate Pricing combinations again.', 'warning', 'sticky');
                        console.log('handleVehicleQuantityChange result: ' + result)
                    } else if (state === "ERROR") {
                        reject(response.getError());
                        var errors = response.getError();
                        if (errors && errors[0] && errors[0].message) {
                            console.log('handleVehicleQuantityChange error:');
                            console.table(errors);
                            component.set("v.error", errors[0].message);
                        }
                    }
                });
                $A.enqueueAction(action);
            }
        });
    },

    generateQuotationCalc: function(component,event,helper,serviceRequestId){
        debugger;
        var action = component.get("c.createQuotation");
        //var action = component.get("c.tempFuture");
        
        // console.log('combinationMap :: '+ JSON.stringify(mappingDataMap));
        
        action.setParams({"serviceRequestId" :serviceRequestId });
        component.set('v.loaded', !component.get('v.loaded'));
        action.setCallback(this, function(response){
            console.log('generateQuotationCalc: ',response.getState());
            var state = response.getState();
            if(state == 'SUCCESS'){
                component.set('v.loaded', !component.get('v.loaded'));
                var result = response.getReturnValue();
                console.log('quoteId = '+ result);
                //component.set("v.quoteId", result);
                helper.setOperationStatus(component,helper);
                if(result != null){
                    /* 
                    $A.createComponent(
                        "c:ET_QuoteCalcQuickAction",
                        {
                            "aura:id": "quoteCalQuickActionFromWrapper",
                            "quoteId": result,
                            
                        },
                        function(newButton, status, errorMessage){
                            //Add the new button to the body array
                            if (status === "SUCCESS") {
                            }
                            else if (status === "INCOMPLETE") {
                                console.log("No response from server or client is offline.")
                                // Show offline error
                            }
                                else if (status === "ERROR") {
                                    console.log("Error: " + errorMessage);
                                    // Show error message
                                }
                        }
                    );
                    */
                    // window.open("/apex/ET_Quotation_Pricing_PDF?quoteId="+component.get('v.quoteId'));
                    component.set("v.quoteId", result.quoteId);
                    const tlSalesTeamProfiles = $A.get("$Label.c.TL_SalesTeam_Profiles");
                    const profileSalesTL = tlSalesTeamProfiles.split(';');
                    console.log('profileSalesTL:');
                    console.table(profileSalesTL);
                    const isTLSales = profileSalesTL.includes(result.loggedInProfileName);
                    console.log('isTLSales: '+isTLSales);
                    if (isTLSales && result.errorMsg != null && result.quoteId == null) {
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type": "warning",
                            "title": "Warning",
                            "message": "Please contact Pricing team for Creating Quotation: Line Item issue " + result.errorMsg,
                            "mode": "sticky"
                        });
                        toastReference.fire();
                    } else if (!isTLSales && result.errorMsg != null && result.quoteId != null) {
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type": "warning",
                            "title": "Warning",
                            "message": "Please review Line Item issue " + result.errorMsg,
                            "mode": "sticky"
                        });
                        toastReference.fire();
                    } else if (!isTLSales && result.errorMsg != null && result.quoteId != null) {
                        window.open("/apex/ET_Quotation_Pricing_PDF?quoteId=" + result.quoteId);
                        $A.get('e.force:refreshView').fire();
                        window.location.reload();
                    } else if (!isTLSales && result.quoteId == null) {
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type": "warning",
                            "title": "Warning",
                            "message": "Something went wrong; quotation object creation didn't happen",
                            "mode": "sticky"
                        });
                        toastReference.fire();
                    }
                    //alert('Quote is generated successfully. Quotation object :' + result);
                }else{
                    var toastReference = $A.get("e.force:showToast");
                    toastReference.setParams({
                        "type":"warning",
                        "title":"warning",
                        "message":"something went wrong; quotation object creation didnt happen",
                        "mode":"sticky"
                    });
                    toastReference.fire();
                    // alert('something went wrong; quotation object creation didnt happen');
                }
            }
            else if (state === "INCOMPLETE") {
                console.log('Network Issue or Server Down');
            }
                else if (state === "ERROR") {
                    component.set('v.loaded', !component.get('v.loaded'));
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message + "Method : generateQuotationCalc" );
                        }
                        
                        
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"Error",
                            "title":"Error",
                            "message":"unexpected Error occurs while Processing your request. Please try again or contact System Admin.",
                            "mode":"sticky"
                        });
                        toastReference.fire();
                        //helper.showToastHelper('Error','error',errors[0].message,'sticky');
                        alert('Error message: '+errors[0].message);
                        //alert('unexpected Error occurs while Processing your request. Please try again or contact System Admin.');
                        // helper.showToastHelper('Error','error',errors[0].message,'sticky');
                        //alert('Error message: '+errors[0].message);
                    } 
                    else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
        
        
    },
    
    generateTotalProjectQuotation: function(component,event,helper){
        var quoteDetail = component.get("v.quoteDetail");
        console.log('quoteDetail: Open ' + JSON.stringify(quoteDetail));
        if (quoteDetail.Quote_Type__c == 'Manual' && quoteDetail.ContentDocumentLinks.length > 0) {
            window.open("/lightning/r/ContentDocument/" + quoteDetail.ContentDocumentLinks[0].ContentDocumentId + "/view"); //lightning/r/ContentDocument/069UE000002ho8TYAQ/view
        } else {
            window.open("/apex/ET_Quotation_Pricing_PDF?quoteId="+component.get('v.totalProjectQuoteId'));
        }	
        //window.open("/apex/ET_Quotation_Pricing_PDF?quoteId="+component.get('v.totalProjectQuoteId'));				
    },
    
    saveAllTabCommonDataIntoSystem : function(component,event,helepr){
        var commonDetails = component.get("v.commonDetailsForAllTab");
        console.log(' common data : ' + JSON.stringify(commonDetails));
        var oppId = component.get("v.opportunityRecordId");
        // alert('oppId in saveAllTabCommonDataIntoSystem : ' + oppId);
        
        if(oppId != undefined && commonDetails != undefined ){
            var data = new Map();
            data['allTabCommonData'] = commonDetails;
            var action = component.get("c.saveAllTabCommonData");
            action.setParams({"opportunityId": String(oppId), "data" : data});
            
            action.setCallback(this, function(response){
                console.log('saveAllTabCommonDataIntoSystem: ',response.getState());
                if(response.getState() == 'SUCCESS'){
                    var result = response.getReturnValue();
                    if(result != null){
                        component.set("v.serviceRequestRecordId", result.serviceReqId);
                        component.set("v.commonDetailsId", result.commonDataId);
                        //alert('Quote is generated successfully. Quotation object :' + result);
                    }else{
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"warning",
                            "title":"warning",
                            "message":"something went wrong; pricing service request creation didnt happen",
                            "mode":"sticky"
                        });
                        toastReference.fire();
                        //alert('something went wrong; pricing service request creation didnt happen');
                    }
                }
                else if(state === "ERROR") {
                    component.set('v.loaded', !component.get('v.loaded'));
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message + "Method : generateQuotationCalc" );
                        }
                        //alert('unexpected Error occurs while Processing your request. Please try again or contact System Admin.');
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"Error",
                            "title":"Error",
                            "message":"unexpected Error occurs while Processing your request. Please try again or contact System Admin.",
                            "mode":"sticky"
                        });
                        toastReference.fire();
                        //helper.showToastHelper('Error','error',errors[0].message,'sticky');
                        //alert('Error message: '+errors[0].message);
                    } 
                    else {
                        console.log("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        }
        
        
    },
    
    loadExistingData: function(component,event,helper){
        var existingCommonDataTabListUponLoading = [];
        component.set("v.existingCommonDataTabListUponLoading", existingCommonDataTabListUponLoading);
        //var oppId = component.get("v.opportunityRecordId");
        var serviceRequestId = component.get("v.serviceRequestRecordId");
        if(serviceRequestId != undefined){
            var action = component.get("c.fetchExistingApplicationData");
            action.setParams({"serviceRequestId": String(serviceRequestId)
                             });
            component.set('v.loaded', !component.get('v.loaded'));
            action.setCallback(this, function(response){
                console.log('loadExistingData: ',response.getState());
                if(response.getState() == 'SUCCESS'){
                    var result = response.getReturnValue();
                    console.log('Existing application Data = ' + JSON.stringify(result));
                    if(result != null){
                        console.log('setOperationStatus1');
                        helper.setOperationStatus(component,helper);
                        console.log('setOperationStatus2');
                        component.set("v.existingApplicationData",result);
                        if(result.opportunityRecordType){
                            component.set("v.oppRecordType", result.opportunityRecordType);
                        }
                        /*if(result.appCommonData != undefined && result.appCommonData != null){
                            component.set("v.existingAppCommonDetails", result.appCommonData);
                            helper.setCommonCmpExistingData(component,event, helper);
                        }*/
                        
                        if(result.elementRatesWithServiceWrpList != undefined && result.elementRatesWithServiceWrpList != null){
                            component.set("v.alterRatesWrWithServiceList", result.elementRatesWithServiceWrpList);
                        }
                        console.log('alterRatesWrWithServiceList11= '+ JSON.stringify(component.get("v.alterRatesWrWithServiceList")));
                        
                        if(result.vehicleCompleteData != undefined && result.vehicleCompleteData != null){
                            console.log('existing vehicle found');
                            component.set("v.existingVehicleTabData", result.vehicleCompleteData);
                            if(result.vehicleCompleteData.vehicleCommonData){
                                existingCommonDataTabListUponLoading.push('Vehicle');
                            }
                        }
                        
                        if(result.driverCompleteData != null && (result.driverCompleteData.manpowerCommonData != null ||  result.driverCompleteData.manpowerLineItems.length >0)){
                            //console.log('existing vehicle found');
                            component.set("v.existingDriverTabData", result.driverCompleteData);
                            console.log('result.driverCompleteData=='+result.driverCompleteData);
                            if(result.driverCompleteData.manpowerCommonData){
                                existingCommonDataTabListUponLoading.push('Driver');
                                // component.set("v.disableCustomizePricingBttn", false); 
                            }
                            /*component.set("v.displayDriverTab", true);
                                (component.find("serviceRequestDataCmp")).existingSelectedTab('Drivers',true);*/
                        }
                        if(result.nannyCompleteData != null && (result.nannyCompleteData.manpowerCommonData != null || result.nannyCompleteData.manpowerLineItems.length >0)){
                            // console.log('existing vehicle found');
                            component.set("v.existingNannyTabData", result.nannyCompleteData);
                            if(result.nannyCompleteData.manpowerCommonData){
                                existingCommonDataTabListUponLoading.push('Nanny');
                                //component.set("v.disableCustomizePricingBttn", false); 
                            }
                            /*component.set("v.displaySchoolNanniesTab", true);
                                (component.find("serviceRequestDataCmp")).existingSelectedTab('School_Bus_Nannies',true);*/
                        }
                        if(result.supervisorCompleteData != null && (result.supervisorCompleteData.manpowerCommonData != undefined || result.supervisorCompleteData.manpowerLineItems.length >0)){
                            // console.log('existing vehicle found');
                            component.set("v.existingSupervisorTabData", result.supervisorCompleteData);
                            if(result.supervisorCompleteData.manpowerCommonData){
                                existingCommonDataTabListUponLoading.push('Supervisor');
                                //component.set("v.disableCustomizePricingBttn", false); 
                            }
                            /*component.set("v.displaySupervisorTab", true);
                                (component.find("serviceRequestDataCmp")).existingSelectedTab('Supervisors',true);*/
                        }
                        if(result.coordinatorCompleteData != null && (result.coordinatorCompleteData.manpowerCommonData != undefined || result.coordinatorCompleteData.manpowerLineItems.length >0)){
                            //console.log('existing vehicle found');
                            component.set("v.existingCoordinatorTabData", result.coordinatorCompleteData);
                            if(result.coordinatorCompleteData.manpowerCommonData){
                                existingCommonDataTabListUponLoading.push('Coordinator');
                                //component.set("v.disableCustomizePricingBttn", false); 
                            }
                            /*component.set("v.displayCoordinatorTab", true);
                                (component.find("serviceRequestDataCmp")).existingSelectedTab('Coordinators',true);*/
                        }
                        if(result.accountantCompleteData != null && (result.accountantCompleteData.manpowerCommonData != undefined || result.accountantCompleteData.manpowerLineItems.length >0)){
                            // console.log('existing vehicle found');
                            component.set("v.existingAccountantTabData", result.accountantCompleteData);
                            if(result.accountantCompleteData.manpowerCommonData){
                                existingCommonDataTabListUponLoading.push('Accountant');
                                //component.set("v.disableCustomizePricingBttn", false); 
                            }
                            /*component.set("v.displayAccountantTab", true);
                                (component.find("serviceRequestDataCmp")).existingSelectedTab('Accountant',true);*/
                        }
                        if(result.otherEmpCompleteData != null && (result.otherEmpCompleteData.manpowerCommonData != undefined || result.otherEmpCompleteData.manpowerLineItems.length >0)){
                            // console.log('existing vehicle found');
                            component.set("v.existingOtherEmpTabData", result.otherEmpCompleteData);
                            if(result.otherEmpCompleteData.manpowerCommonData){
                                existingCommonDataTabListUponLoading.push('OtherEmployee');
                                //component.set("v.disableCustomizePricingBttn", false); 
                            }
                            /* component.set("v.displayOtherEmployeesTab", true);
                                 (component.find("serviceRequestDataCmp")).existingSelectedTab('Other_Employees',true);*/
                        }
                        if(result.otherCostCompleteData != null && result.otherCostCompleteData.otherCostLineItems.length >0 ){
                            component.set("v.existingOtherCostTabData", result.otherCostCompleteData);
                        }
                        component.set("v.existingCommonDataTabListUponLoading", existingCommonDataTabListUponLoading);
                        if(result.appCommonData != undefined && result.appCommonData != null){
                            console.log('result.appCommonData  = '+ JSON.stringify(result.appCommonData ));
                            component.set("v.existingAppCommonDetails", result.appCommonData);
                            //update common details id to recordEditForm...
                            component.set("v.commonDetailsId", result.commonDataId);
                            // show Edit Button
                            var Editcmp = component.find("editButton");
                            $A.util.toggleClass(Editcmp,'slds-hide');
                            helper.setCommonCmpExistingData(component,event, helper);
                        }
                        component.set('v.loaded', !component.get('v.loaded'));
                        //alert('Quote is generated successfully. Quotation object :' + result);
                    }else{
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"warning",
                            "title":"warning",
                            "message":"no existing data found, loading application blank",
                            "mode":"sticky"
                        });
                        toastReference.fire();
                        // alert('no existing data found, loading application blank');
                    }
                }
                else if (response.getState() === "INCOMPLETE") {
                    component.set('v.loaded', !component.get('v.loaded'));
                    console.log('Network Issue or Server Down');
                }
                    else if (response.getState() === "ERROR") {
                        component.set('v.loaded', !component.get('v.loaded'));
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + 
                                            errors[0].message + "Method :" );
                                var toastReference = $A.get("e.force:showToast");
                                toastReference.setParams({
                                    "type":"Error",
                                    "title":"Error",
                                    "message":"Internal Error. Please Try again or Contact System Admin.",
                                    "mode":"sticky"
                                });
                                toastReference.fire();
                                // helper.showToastHelper('Error','error',errors[0].message,'sticky');
                                //alert('Internal Error. Please Try again or Contact System Admin.');
                            }
                        } else {
                            console.log("Unknown error");
                        }
                    }
            });
            $A.enqueueAction(action);
        }
    },
    
    setCommonCmpExistingData: function(component,event,helper){
        var oppRecordType = component.get("v.oppRecordType");
        var existingCommonData = component.get("v.existingAppCommonDetails");
        if(component.get("v.commonCmpLoadingDone") && existingCommonData != undefined){
            //var existingCommonDataTabListUponLoading = component.get("v.existingCommonDataTabListUponLoading");
            component.set("v.showAnnualTargetPrice",existingCommonData.ET_Request_for_Target_Price__c);
            var serviceRequestCommonCmp = component.find("serviceRequestCommonCmp");
            serviceRequestCommonCmp.prePopulateCommonData(existingCommonData);
            if(serviceRequestCommonCmp.validateDetails()){
                //component.set("v.proceedBttnDisable", true);
                serviceRequestCommonCmp.set("v.isDisable",true);
                var contractYearVaues =  serviceRequestCommonCmp.get("v.contractValue");
                var commonServiceRequestDetails = serviceRequestCommonCmp.get("v.commonServiceRequestDetails");
                commonServiceRequestDetails['ET_Contract_Period__c'] = contractYearVaues;
                component.set("v.commonDetailsForAllTab", commonServiceRequestDetails);
                component.set("v.requirementVisibility", true);
                component.set("v.fieldsWithMultipleValueLst", serviceRequestCommonCmp.get("v.fieldsWithMultipleValueCurrentLst"));
                component.set("v.disableSaveButton",false);
                if(component.get("v.existingVehicleTabData")){
                    (component.find("serviceRequestDataCmp")).existingSelectedTab('Vehicle',true);
                    if(oppRecordType && oppRecordType == 'ETSALES_Leasing'){
                        component.set("v.disableCustomizePricingBttn", true);
                        component.set("v.disableQuoteBttn", false);
                    }else{
                        component.set("v.disableCustomizePricingBttn", false);
                    }
                }
                if(component.get("v.existingDriverTabData")){
                    (component.find("serviceRequestDataCmp")).existingSelectedTab('Drivers',true);
                    if(oppRecordType && oppRecordType == 'ETSALES_Manpower'){
                        component.set("v.disableCustomizePricingBttn", true);
                        component.set("v.disableQuoteBttn", false);
                    }else{
                        component.set("v.disableCustomizePricingBttn", false);
                    } 
                    
                }
                if(component.get("v.existingNannyTabData")){
                    (component.find("serviceRequestDataCmp")).existingSelectedTab('School_Bus_Nannies',true);
                    /* var delayInMilliseconds = 80;
                            window.setTimeout(
                                $A.getCallback(function() {
                                     //component.set("v.displaySchoolNanniesTab", true);
                            		(component.find("serviceRequestDataCmp")).existingSelectedTab('School_Bus_Nannies',true);
                                }), delayInMilliseconds
                            );*/
                    if(oppRecordType && oppRecordType == 'ETSALES_Manpower'){
                        component.set("v.disableCustomizePricingBttn", true);
                        component.set("v.disableQuoteBttn", false);
                    }else{
                        component.set("v.disableCustomizePricingBttn", false);
                    } 
                }
                if(component.get("v.existingSupervisorTabData")){
                    (component.find("serviceRequestDataCmp")).existingSelectedTab('Supervisors',true);
                    /*var delayInMilliseconds = 80;
                            window.setTimeout(
                                $A.getCallback(function() {
                                      //component.set("v.displaySupervisorTab", true);
                            		(component.find("serviceRequestDataCmp")).existingSelectedTab('Supervisors',true);
                                }), delayInMilliseconds
                            );*/
                    if(oppRecordType && oppRecordType == 'ETSALES_Manpower'){
                        component.set("v.disableCustomizePricingBttn", true);
                        component.set("v.disableQuoteBttn", false);
                    }else{
                        component.set("v.disableCustomizePricingBttn", false);
                    } 
                }
                if(component.get("v.existingCoordinatorTabData")){
                    (component.find("serviceRequestDataCmp")).existingSelectedTab('Coordinators',true);
                    /*var delayInMilliseconds = 80;
                            window.setTimeout(
                                $A.getCallback(function() {
                                      //component.set("v.displayCoordinatorTab", true);
                            		(component.find("serviceRequestDataCmp")).existingSelectedTab('Coordinators',true);
                                }), delayInMilliseconds
                            );*/
                    if(oppRecordType && oppRecordType == 'ETSALES_Manpower'){
                        component.set("v.disableCustomizePricingBttn", true);
                        component.set("v.disableQuoteBttn", false);
                    }else{
                        component.set("v.disableCustomizePricingBttn", false);
                    } 
                }
                if(component.get("v.existingAccountantTabData")){
                    (component.find("serviceRequestDataCmp")).existingSelectedTab('Accountant',true);
                    /*var delayInMilliseconds = 80;
                            window.setTimeout(
                                $A.getCallback(function() {
                                     //component.set("v.displayAccountantTab", true);
                            		(component.find("serviceRequestDataCmp")).existingSelectedTab('Accountant',true);
                                }), delayInMilliseconds
                            );*/
                    if(oppRecordType && oppRecordType == 'ETSALES_Manpower'){
                        component.set("v.disableCustomizePricingBttn", true);
                        component.set("v.disableQuoteBttn", false);
                    }else{
                        component.set("v.disableCustomizePricingBttn", false);
                    } 
                }
                if(component.get("v.existingOtherEmpTabData")){
                    (component.find("serviceRequestDataCmp")).existingSelectedTab('Other_Employees',true);
                    /*var delayInMilliseconds = 80;
                            window.setTimeout(
                                $A.getCallback(function() {
                                     //component.set("v.displayOtherEmployeesTab", true);
                            		(component.find("serviceRequestDataCmp")).existingSelectedTab('Other_Employees',true);
                                }), delayInMilliseconds
                            );*/
                    if(oppRecordType && oppRecordType == 'ETSALES_Manpower'){
                        component.set("v.disableCustomizePricingBttn", true);
                        component.set("v.disableQuoteBttn", false);
                    }else{
                        component.set("v.disableCustomizePricingBttn", false);
                    } 
                }
                if(component.get("v.existingOtherCostTabData")){
                    (component.find("serviceRequestDataCmp")).existingSelectedTab('Other_Cost',true);
                    
                }
                //helper.intializeTabComponent(component,helper,'Vehicle');//selectedTabId
            }
        }
    },
    
    /* intializeTabComponent: function(component,helper,selectedTab){
        console.log('Entered ');
        if(component.get("v.requirementVisibility") && component.get("v.displayTabs") && selectedTab != undefined){
            if(selectedTab  == 'Drivers'){
                $A.createComponent(
                    "c:ET_DriverTab",{
                        "aura:id" : "driverTab",
                        "backgroundColor" : component.get("v.backgroundColor"),
                        "commonFieldsToBePopulateLst" : component.get("v.fieldsWithMultipleValueLst"),
                        "commonInforReceivedFrmWrapper" : component.get("v.commonDetailsForAllTab"),
                        "existingDriverTabData" : component.get("v.existingDriverTabData")
                    },
                    function(newcomponent){
                        if (newcomponent.isValid()) {
                            //component.set("v.displayDriverTab",true);
                            var newCmp = component.find("driverTabBody");
                            console.log(newCmp);
                            var body = newCmp.get("v.body");
                            body.push(newcomponent);
                            newCmp.set("v.body", body);
                        }
                    }            
                );    
            }
            
            if(selectedTab == 'Vehicle' ){
                //console.log('alterRatesWrWithServiceList= '+ JSON.stringify(component.get("v.alterRatesWrWithServiceList")));
                
                //component.set("v.displayOtherCostTab",true);
                $A.createComponent(
                    "c:ET_VehicleTab",{
                        "aura:id" : "vehicleTab",
                        "backgroundColor" : component.get("v.backgroundColor"),
                        "commonFieldsToBePopulateLst" : component.get("v.fieldsWithMultipleValueLst"),
                        "commonInforReceivedFrmWrapper" : component.get("v.commonDetailsForAllTab"),
                        "existingVehicleTabData" : component.get("v.existingVehicleTabData"),
                        "alterRatesWithServiceWrp" : component.get("v.alterRatesWrWithServiceList"),
                        "showAnnualTargetPrice" : component.get("v.showAnnualTargetPrice")
                    },
                    function(newcomponent){
                        if (newcomponent.isValid()) {
                            //component.set("v.displayVehicleTab",true);
                            var newCmp = component.find("vehicleTabBody");
                            console.log(newCmp);
                            var body = newCmp.get("v.body");
                            body.push(newcomponent);
                            newCmp.set("v.body", body);
                        }
                    }            
                );
            }
            
            if(selectedTab == 'School_Bus_Nannies'){
                //component.set("v.displayOtherCostTab",true);
                $A.createComponent(
                    "c:ET_SchoolBusNanniesTab",{
                        "aura:id" : "schoolBusNanniesTab",
                        "backgroundColor" : component.get("v.backgroundColor"),
                        "commonFieldsToBePopulateLst" : component.get("v.fieldsWithMultipleValueLst"),
                        "commonInforReceivedFrmWrapper" : component.get("v.commonDetailsForAllTab"),
                        "existingNannyTabData" : component.get("v.existingNannyTabData")
                    },
                    function(newcomponent){
                        if (newcomponent.isValid()) {
                            //component.set("v.displaySchoolNanniesTab",true);
                            var newCmp = component.find("nannyTabBody");
                            console.log(newCmp);
                            var body = newCmp.get("v.body");
                            body.push(newcomponent);
                            newCmp.set("v.body", body);
                        }
                    }            
                );
            }
            
            if(selectedTab == 'Supervisors'){
                $A.createComponent(
                    "c:ET_SupervisorTab",{
                        "aura:id" : "supervisorTab",
                        "backgroundColor" : component.get("v.backgroundColor"),
                        "commonFieldsToBePopulateLst" : component.get("v.fieldsWithMultipleValueLst"),
                        "commonInforReceivedFrmWrapper" : component.get("v.commonDetailsForAllTab"),
                        "existingSupervisorTabData" : component.get("v.existingSupervisorTabData")
                    },
                    function(newcomponent){
                        if (newcomponent.isValid()) {
                            //component.set("v.displaySupervisorTab",true);
                            var newCmp = component.find("supervisorTabBody");
                            console.log(newCmp);
                            var body = newCmp.get("v.body");
                            body.push(newcomponent);
                            newCmp.set("v.body", body);
                        }
                    }            
                );
                //component.set("v.displayOtherCostTab",true);
            }
            if(selectedTab == 'Coordinators' ){
                $A.createComponent(
                    "c:ET_CoordinatorTab",{
                        "aura:id" : "coordinatorTab",
                        "backgroundColor" : component.get("v.backgroundColor"),
                        "commonFieldsToBePopulateLst" : component.get("v.fieldsWithMultipleValueLst"),
                        "commonInforReceivedFrmWrapper" : component.get("v.commonDetailsForAllTab"),
                        "existingCoordinatorTabData" : component.get("v.existingCoordinatorTabData")
                    },
                    function(newcomponent){
                        if (newcomponent.isValid()) {
                            //component.set("v.displayCoordinatorTab",true);
                            var newCmp = component.find("coordinatorTabBody");
                            console.log(newCmp);
                            var body = newCmp.get("v.body");
                            body.push(newcomponent);
                            newCmp.set("v.body", body);
                        }
                    }            
                );
                //component.set("v.displayOtherCostTab",true);
            }
            if(selectedTab == 'Accountant' ){
                $A.createComponent(
                    "c:ET_AccountantCashierTab",{
                        "aura:id" : accountantTab,
                        "backgroundColor" : component.get("v.backgroundColor"),
                        "commonFieldsToBePopulateLst" : component.get("v.fieldsWithMultipleValueLst"),
                        "commonInforReceivedFrmWrapper" : component.get("v.commonDetailsForAllTab"),
                        "existingAccountantTabData" : component.get("v.existingAccountantTabData")
                    },
                    function(newcomponent){
                        if (newcomponent.isValid()) {
                            //component.set("v.displayAccountantTab",true);
                            var newCmp = component.find("accountantTabBody");
                            console.log(newCmp);
                            var body = newCmp.get("v.body");
                            body.push(newcomponent);
                            newCmp.set("v.body", body);
                        }
                    }            
                );
                //component.set("v.displayOtherCostTab",true);
            }
            
            if(selectedTab == 'Other_Employees' ){
                
                $A.createComponent(
                    "c:ET_OtherEmployeeTab",{
                        "aura:id" : otherEmployeeTab,
                        "backgroundColor" : component.get("v.backgroundColor"),
                        "commonFieldsToBePopulateLst" : component.get("v.fieldsWithMultipleValueLst"),
                        "commonInforReceivedFrmWrapper" : component.get("v.commonDetailsForAllTab"),
                        "existingOtherEmpTabData" : component.get("v.existingOtherEmpTabData")
                    },
                    function(newcomponent){
                        if (newcomponent.isValid()) {
                            //component.set("v.displayOtherEmployeesTab",true);
                            var newCmp = component.find("otherEmpTabBody");
                            console.log(newCmp);
                            var body = newCmp.get("v.body");
                            body.push(newcomponent);
                            newCmp.set("v.body", body);
                            
                            
                            
                        }
                    }            
                );
                //component.set("v.displayOtherCostTab",true);
                
            }
            
            if(selectedTab == 'Other_Cost'){
                
                $A.createComponent(
                    "c:ET_OtherCostTab",{
                        "aura:id" : "otherCostTab",
                        "backgroundColor" : component.get("v.backgroundColor")
                    },
                    function(newcomponent){
                        if (newcomponent.isValid()) {
                            //component.set("v.displayOtherCostTab",true);
                            var newCmp = component.find("otherCostTabBody");
                            console.log(newCmp);
                            var body = newCmp.get("v.body");
                            body.push(newcomponent);
                            newCmp.set("v.body", body);
                            
                            
                            
                        }
                    }            
                );
                //component.set("v.displayOtherCostTab",true);
                
            }
        }
    },*/
    
    getSObjectName: function(component,RecordId,helper){
        var action = component.get("c.getSObjectNameFromRecordId");
        action.setParams({"RecordId": String(RecordId)});
        component.set('v.loaded', !component.get('v.loaded'));
        action.setCallback(this, function(response){
            console.log('getSObjectName: ',response.getState());
            if(response.getState() == 'SUCCESS'){
                var result = response.getReturnValue();
                console.log('result in doinit of wrapper : ' + JSON.stringify(result));
                if(result != null){
                    if(result == 'Opportunity'){
                        component.set("v.opportunityRecordId",RecordId);
                    }else if(result == 'ET_Pricing_Service_Request__c'){
                        component.set("v.serviceRequestRecordId",RecordId);
                        helper.loadExistingData(component,event,helper);
                    }
                }
            }
            component.set('v.loaded', !component.get('v.loaded'));
        });
        $A.enqueueAction(action);
    },

    //SK
    getOppRecTypeIdHelper: function(component,RecordId,helper,childCompName) {
        console.log('RecordId: '+RecordId);
        var action = component.get("c.getOpportunityRecordTypeId");
        action.setParams({ 
            "opportunityId": String(RecordId) 
        });
        component.set('v.loaded', !component.get('v.loaded'));
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            var returnValue = response.getReturnValue();
            component.set("v.OpprecordTypeName", returnValue);
            console.log("OpprecordTypeName:  " + returnValue);

            // Find and call method on serviceRequestCommonCmp
           
            var serviceRequestDataCmp = component.find("serviceRequestDataCmp");
            if (serviceRequestDataCmp && childCompName == 'ET_ServiceRequestData') {
                serviceRequestDataCmp.opprecTypeDataCmp(returnValue);
            } else {
                console.log("OpprecordTypeName serviceRequestDataCmp aura:method not found");
            } //Taj commented

            var serviceRequestCommonCmp = component.find("serviceRequestCommonCmp");
            if (serviceRequestCommonCmp && childCompName == 'ET_ServiceRequestCommonData') {
                serviceRequestCommonCmp.opprecTypeCommonCmp(returnValue);
            } else {
                console.log("OpprecordTypeName serviceRequestCommonCmp aura:method not found");
            }
            var vehicleTab = component.find("vehicleTab");
            if (vehicleTab && childCompName == 'ET_VehicleTab') {
                vehicleTab.opprecTypevehicleTab(returnValue);
            } else {
                console.log("OpprecordTypeName vehicleTab aura:method not found");
            }
                
            } else {
                console.error("Failed with state: " + state);
                // Optionally handle the error state
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + errors[0].message);
                    }
                } else {
                    console.error("Unknown error");
                }
            }
        });
        component.set('v.loaded', !component.get('v.loaded'));
        $A.enqueueAction(action);
    },
    
    prepareDataForPricingCombinationScreen: function(component,event,helper){
        var dataFrmAllTabs  = component.get("v.dataFromAllOpenTabs");
        if(dataFrmAllTabs){
            if(dataFrmAllTabs['vehicleTabInfo']){
                var vehicleData = new Map();
                vehicleData['vehicleTabInfo'] = dataFrmAllTabs['vehicleTabInfo'];
                helper.processAllTabData(component, event, helper,vehicleData);    
            }
            if(dataFrmAllTabs['driverTabInfo']){
                var driverdata = new Map();
                driverdata['driverTabInfo'] = dataFrmAllTabs['driverTabInfo'];
                helper.processAllTabData(component, event, helper,driverdata);    
            }
            if(dataFrmAllTabs['nannyTabInfo']){
                var nannydata = new Map();
                nannydata['nannyTabInfo'] = dataFrmAllTabs['nannyTabInfo'];
                helper.processAllTabData(component, event, helper,nannydata);    
            }
            if(dataFrmAllTabs['supervisorTabInfo']){
                var supervisordata = new Map();
                supervisordata['supervisorTabInfo'] = dataFrmAllTabs['supervisorTabInfo'];
                helper.processAllTabData(component, event, helper,supervisordata);    
            }
            if(dataFrmAllTabs['coordinatorTabInfo']){
                var coordinatordata = new Map();
                coordinatordata['coordinatorTabInfo'] = dataFrmAllTabs['coordinatorTabInfo'];
                helper.processAllTabData(component, event, helper,coordinatordata);    
            }
            if(dataFrmAllTabs['accountantTabInfo']){
                var accountantdata = new Map();
                accountantdata['accountantTabInfo'] = dataFrmAllTabs['accountantTabInfo'];
                helper.processAllTabData(component, event, helper,accountantdata);    
            }
            if(dataFrmAllTabs['otherEmployeeTabInfo']){
                var otherEmpdata = new Map();
                otherEmpdata['otherEmployeeTabInfo'] = dataFrmAllTabs['otherEmployeeTabInfo'];
                helper.processAllTabData(component, event, helper,otherEmpdata);    
            }
            
            component.set("v.showModal",true);
        }
        
    },
    
    getDataCommon : function(component, event, helper, calledFromCustomizeBttn) {
        debugger;
        var selectedTabs = [];
        var dataFrmAllTabs = new Map();
        var deletedWholeTabLst;
        component.set("v.tabInfoToSendToMappingCmpMap", new Map());
        selectedTabs = component.get("v.selectedTabs");
        var vehicleData;
        if(selectedTabs.includes("Vehicle")){
            var vehicleLines = component.find('vehicleTab');
            if(vehicleLines!=undefined){
                vehicleData = vehicleLines.getData();
                debugger;
                console.log('vehicleData 1339',JSON.stringify(vehicleData));
                if(vehicleData != undefined && vehicleData != null){
                    dataFrmAllTabs['vehicleTabInfo'] = vehicleData['vehicleTabInfo'];
                    dataFrmAllTabs['vehicleTabCommonInfo'] = vehicleData['localTabCommonInfo'];
                    if(vehicleData['deletedVehicleCmpIds'] != null && (vehicleData['deletedVehicleCmpIds']).length > 0){
                        dataFrmAllTabs['deletedVehicleCmpIds'] = vehicleData['deletedVehicleCmpIds'];
                    }
                    
                    console.log('vehicleData :: '+ JSON.stringify(vehicleData));
                    helper.processAllTabData(component, event, helper,vehicleData);
                    //console.log(result);
                }
            }
        }else{
            if(component.get("v.existingVehicleTabData")){
                if(!deletedWholeTabLst){
                    deletedWholeTabLst = [];
                }
                deletedWholeTabLst.push('Vehicle');
            }
        }
        
        if(selectedTabs.includes("Drivers")){
            console.log('DRIVER');
            
            var driverLines = component.find('driverTab');
            console.log(driverLines);
            var driverdata;
            if(driverLines!=undefined){
                driverdata = driverLines.getData();
                console.log(driverdata)
                if(driverdata != undefined && driverdata != null){
                    dataFrmAllTabs['driverTabInfo'] = driverdata['driverTabInfo'];
                    dataFrmAllTabs['driverTabCommonInfo'] = driverdata['localTabCommonInfo'];
                    var manpowerDeleteCmpLst = component.get("v.manpowerDetailCmpsToDeleteList");
                    manpowerDeleteCmpLst.push.apply(manpowerDeleteCmpLst, driverdata['deletedDriverCmpIds']);
                    component.set("v.manpowerDetailCmpsToDeleteList", manpowerDeleteCmpLst );
                    console.log('driverdata :: '+ JSON.stringify(driverdata));
                    console.log('dataFrmAllTabs :: '+ JSON.stringify(dataFrmAllTabs));
                    helper.processAllTabData(component, event, helper,driverdata);
                    //console.log(result);
                }
            }
        }else{
            if(component.get("v.existingDriverTabData")){
                
                if(!deletedWholeTabLst){
                    deletedWholeTabLst = [];
                }
                deletedWholeTabLst.push('Driver');
            }
        }
        
        if(selectedTabs.includes("School_Bus_Nannies")){
            console.log('School_Bus_Nannies');
            var nannyLines = component.find('schoolBusNanniesTab');
            var nannydata;
            console.log('nannyLines');
            console.dir(nannyLines);
            if(nannyLines){
                nannydata = nannyLines.getData();
                if(nannydata != undefined && nannydata != null){
                    dataFrmAllTabs['nannyTabInfo'] = nannydata['nannyTabInfo'];
                    dataFrmAllTabs['nannyTabCommonInfo'] = nannydata['localTabCommonInfo'];
                    var manpowerDeleteCmpLst = component.get("v.manpowerDetailCmpsToDeleteList");
                    manpowerDeleteCmpLst.push.apply(manpowerDeleteCmpLst, nannydata['deletedNannyCmpIds']);
                    component.set("v.manpowerDetailCmpsToDeleteList", manpowerDeleteCmpLst );
                    console.log('nannydata :: '+ JSON.stringify(nannydata));
                    helper.processAllTabData(component, event, helper,nannydata);
                    //console.log(result);
                }
            }
        }else{
            if(component.get("v.existingNannyTabData")){
                if(!deletedWholeTabLst){
                    deletedWholeTabLst = [];
                }
                deletedWholeTabLst.push('Nanny');
            }
        }
        
        if(selectedTabs.includes("Supervisors")){
            var supervisorLines = component.find('supervisorTab');
            var supervisordata;
            console.log('supervisorLines  '+supervisorLines);
            if(supervisorLines!=undefined){
                supervisordata = supervisorLines.getData();
                if(supervisordata != undefined && supervisordata != null){
                    dataFrmAllTabs['supervisorTabInfo'] = supervisordata['supervisorTabInfo'];
                    dataFrmAllTabs['supervisorTabCommonInfo'] = supervisordata['localTabCommonInfo'];
                    var manpowerDeleteCmpLst = component.get("v.manpowerDetailCmpsToDeleteList");
                    manpowerDeleteCmpLst.push.apply(manpowerDeleteCmpLst, supervisordata['deletedSupervisorCmpIds']);
                    component.set("v.manpowerDetailCmpsToDeleteList", manpowerDeleteCmpLst );
                    helper.processAllTabData(component, event, helper,supervisordata);
                    //console.log(result);
                }
            }
        }else{
            if(component.get("v.existingSupervisorTabData")){
                if(!deletedWholeTabLst){
                    deletedWholeTabLst = [];
                }
                deletedWholeTabLst.push('Supervisor');
            }
        }
        
        if(selectedTabs.includes("Coordinators")){
            var coordinatorLines = component.find('coordinatorTab');
            var coordinatordata;
            
            if(coordinatorLines!=undefined){
                coordinatordata = coordinatorLines.getData();
                if(coordinatordata != undefined && coordinatordata != null){
                    dataFrmAllTabs['coordinatorTabInfo'] = coordinatordata['coordinatorTabInfo'];
                    dataFrmAllTabs['coordinatorTabCommonInfo'] = coordinatordata['localTabCommonInfo'];
                    var manpowerDeleteCmpLst = component.get("v.manpowerDetailCmpsToDeleteList");
                    manpowerDeleteCmpLst.push.apply(manpowerDeleteCmpLst, coordinatordata['deletedCoordinatorCmpIds']);
                    component.set("v.manpowerDetailCmpsToDeleteList", manpowerDeleteCmpLst );
                    helper.processAllTabData(component, event, helper,coordinatordata);
                    //console.log(result);
                }
            }
        }else{
            if(component.get("v.existingCoordinatorTabData")){
                if(!deletedWholeTabLst){
                    deletedWholeTabLst = [];
                }
                deletedWholeTabLst.push('Coordinator');
            }
        }
        
        
        if(selectedTabs.includes("Accountant")){
            var accountantLines = component.find('accountantTab');
            var accountantdata;
            
            if(accountantLines!=undefined){
                accountantdata = accountantLines.getData();
                if(accountantdata != undefined && accountantdata != null){
                    dataFrmAllTabs['accountantTabInfo'] = accountantdata['accountantTabInfo'];
                    dataFrmAllTabs['accountantTabCommonInfo'] = accountantdata['localTabCommonInfo'];
                    var manpowerDeleteCmpLst = component.get("v.manpowerDetailCmpsToDeleteList");
                    manpowerDeleteCmpLst.push.apply(manpowerDeleteCmpLst, accountantdata['deletedAccountantCmpIds']);
                    component.set("v.manpowerDetailCmpsToDeleteList", manpowerDeleteCmpLst );
                    helper.processAllTabData(component, event, helper,accountantdata);
                    //console.log(result);
                }
            }
        }else{
            if(component.get("v.existingAccountantTabData")){
                if(!deletedWholeTabLst){
                    deletedWholeTabLst = [];
                }
                deletedWholeTabLst.push('Accountant');
            }
        }
        
        
        if(selectedTabs.includes("Other_Employees")){
            var otherEmpLines = component.find('otherEmployeeTab');
            var otherEmpdata;
            
            if(otherEmpLines!=undefined){
                otherEmpdata = otherEmpLines.getData();
                if(otherEmpdata != undefined && otherEmpdata != null){
                    dataFrmAllTabs['otherEmployeeTabInfo'] = otherEmpdata['otherEmployeeTabInfo'];
                    dataFrmAllTabs['otherEmpTabCommonInfo'] = otherEmpdata['localTabCommonInfo'];
                    var manpowerDeleteCmpLst = component.get("v.manpowerDetailCmpsToDeleteList");
                    manpowerDeleteCmpLst.push.apply(manpowerDeleteCmpLst, otherEmpdata['deletedOtherEmpCmpIds']);
                    component.set("v.manpowerDetailCmpsToDeleteList", manpowerDeleteCmpLst );
                    helper.processAllTabData(component, event, helper,otherEmpdata);
                    //console.log(result);
                }
            }
        }else{
            if(component.get("v.existingOtherEmpTabData")){
                if(!deletedWholeTabLst){
                    deletedWholeTabLst = [];
                }
                deletedWholeTabLst.push('Other_Employee');
            }
        }
        debugger;
        if(selectedTabs.includes("Other_Cost")){
            debugger;
            var otherCostLines = component.find('otherCostTab');
            var otherCostdata;
            // console.log(otherCostdata__a+JSON.stringify(otherCostLines));
            //console.log(otherCostdata__a+JSON.stringify(otherCostdata));
            if(otherCostLines!=undefined){
                otherCostdata = otherCostLines.getData();
                //console.log(otherCostdata__a+JSON.stringify(otherCostdata));
                var deletedOtherCostIds = otherCostLines.get("v.deletedOtherCostChildDetailCmpList");
                debugger;
                if(deletedOtherCostIds){
                    dataFrmAllTabs['deletedOtherCostCmpIds'] = deletedOtherCostIds;
                }
                if(otherCostdata != undefined && otherCostdata != null){   
                    dataFrmAllTabs['otherCostTabInfo'] = otherCostdata['otherCostTabInfo'];
                }
            }
        }
        else{
            if(component.get("v.existingOtherCostTabData")){
                if(!deletedWholeTabLst){
                    deletedWholeTabLst = [];
                }
                deletedWholeTabLst.push('Other_Cost');
            }
        }
        
        if(deletedWholeTabLst){
            dataFrmAllTabs['deletedWholeTabLst'] = deletedWholeTabLst;
        }
        var manpowerDeleteCmpLst = component.get("v.manpowerDetailCmpsToDeleteList");
        if(manpowerDeleteCmpLst.length > 0){
            dataFrmAllTabs['deletedManpowerCmpIds'] = manpowerDeleteCmpLst;
        }
        var otherCostTabDeleteCmpLst = component.get("v.deletedOtherCostObjIdsLst");
        if(otherCostTabDeleteCmpLst && otherCostTabDeleteCmpLst.length > 0){
            dataFrmAllTabs['deletedOtherCostTabWiseIds'] = otherCostTabDeleteCmpLst;
        }
        component.set("v.dataFromAllOpenTabs", dataFrmAllTabs);
        console.log('dataFrmAllTabs : ' ,JSON.stringify(dataFrmAllTabs));
        var allOpenTabsInfoProcessed;
        var allTabIntializedBeforeSave;
        if(component.get("v.tabInfoToSendToMappingCmpMap") == undefined || component.get("v.dataFromAllOpenTabs") == undefined){
            allOpenTabsInfoProcessed = false; //intializing this variable here
        }else{  
            allOpenTabsInfoProcessed = true;
        }
        var operation;
        if(component.get("v.existingVehicleTabData") || component.get("v.existingDriverTabData")
           || component.get("v.existingNannyTabData")
           || component.get("v.existingSupervisorTabData")
           || component.get("v.existingCoordinatorTabData")
           || component.get("v.existingAccountantTabData")
           || component.get("v.existingOtherEmpTabData")){
            operation = 'Edit';
        }else{
            operation = 'Save';
        }
        
        for(var openTab of selectedTabs ){
            debugger;
            if(openTab == 'Vehicle' && ((component.get("v.tabInfoToSendToMappingCmpMap") != undefined && component.get("v.tabInfoToSendToMappingCmpMap")['vehicleInfo'] == undefined) ||  dataFrmAllTabs['vehicleTabInfo'] == undefined)){
                allOpenTabsInfoProcessed = false;
                if(operation == 'Edit'){
                    allTabIntializedBeforeSave = false;
                }
            }
            else if(openTab == 'Drivers' && ((component.get("v.tabInfoToSendToMappingCmpMap") != undefined  && component.get("v.tabInfoToSendToMappingCmpMap")['driverInfo'] == undefined) || dataFrmAllTabs['driverTabInfo'] == undefined)){
                allOpenTabsInfoProcessed = false;
                if(operation == 'Edit'){
                    allTabIntializedBeforeSave = false;
                }
            }
                else if(openTab == 'School_Bus_Nannies' && ((component.get("v.tabInfoToSendToMappingCmpMap") != undefined  && component.get("v.tabInfoToSendToMappingCmpMap")['nannyInfo'] == undefined) || dataFrmAllTabs['nannyTabInfo'] == undefined)){
                    allOpenTabsInfoProcessed = false;
                    if(operation == 'Edit'){
                        allTabIntializedBeforeSave = false;
                    }
                }
                    else if(openTab == 'Supervisors' && ((component.get("v.tabInfoToSendToMappingCmpMap") != undefined  && component.get("v.tabInfoToSendToMappingCmpMap")['supervisorInfo'] == undefined)||  dataFrmAllTabs['supervisorTabInfo'] == undefined )){
                        allOpenTabsInfoProcessed = false;
                        if(operation == 'Edit'){
                            allTabIntializedBeforeSave = false;
                        }
                    }
                        else if(openTab == 'Coordinators' && ((component.get("v.tabInfoToSendToMappingCmpMap") != undefined  && component.get("v.tabInfoToSendToMappingCmpMap")['coordinatorInfo'] == undefined) || dataFrmAllTabs['coordinatorTabInfo'] == undefined)){
                            allOpenTabsInfoProcessed = false;
                            if(operation == 'Edit'){
                                allTabIntializedBeforeSave = false;
                            }
                        }
                            else if(openTab == 'Accountant' && ((component.get("v.tabInfoToSendToMappingCmpMap") != undefined  && component.get("v.tabInfoToSendToMappingCmpMap")['accountantInfo'] == undefined) || dataFrmAllTabs['accountantTabInfo'] == undefined)){
                                allOpenTabsInfoProcessed = false;
                                if(operation == 'Edit'){
                                    allTabIntializedBeforeSave = false;
                                }
                            }
                                else if(openTab == 'Other_Employees' && ((component.get("v.tabInfoToSendToMappingCmpMap") != undefined  && component.get("v.tabInfoToSendToMappingCmpMap")['otherEmployeeInfo'] == undefined) || dataFrmAllTabs['otherEmployeeTabInfo'] == undefined)){
                                    allOpenTabsInfoProcessed = false;
                                    if(operation == 'Edit'){
                                        allTabIntializedBeforeSave = false;
                                    }
                                }
                                    else if(openTab == 'Other_Cost' &&  component.get("v.dataFromAllOpenTabs") != undefined &&  component.get("v.dataFromAllOpenTabs")['otherCostTabInfo'] == undefined){
                                        allOpenTabsInfoProcessed = false;
                                        if(operation == 'Edit'){
                                            allTabIntializedBeforeSave = false;
                                        }
                                    }
        }
        //}
        
        if(allOpenTabsInfoProcessed){
            debugger;
            //helper.openMappingModal(component,event,helper);
            //var oppId = component.get("v.opportunityRecordId");
            if(!calledFromCustomizeBttn){
                var serviceRequestId = component.get("v.serviceRequestRecordId");
                if(serviceRequestId != null && serviceRequestId != ''){
                    helper.saveServiceRequestData(component,event,helper,serviceRequestId,component.get("v.dataFromAllOpenTabs"));
                }
            }else{
                return true;
            }
            
        }
        else{
            if(operation == 'Edit'){
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type":"warning",
                    "title":"warning",
                    "message":"Please click on all opened tabs before updating the service request or check whether all opened tabs filled correctly",
                    "mode":"sticky"
                });
                toastReference.fire();
                // alert('Please click on all opened tabs before updating the service request or check whether all opened tabs filled correctly');
            }else{
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type":"warning",
                    "title":"warning",
                    "message":"Please check whether all opened tabs filled correctly",
                    "mode":"sticky"
                });
                toastReference.fire();
                //alert('Please check whether all opened tabs filled correctly');
            }
        }
    },
    
    
    checkValidityOfOperation : function(component,helper){
        var serviceRequestId = component.get("v.serviceRequestRecordId");
        if(serviceRequestId){
            return new Promise($A.getCallback(function(resolve,reject){
                var action = component.get("c.authorizedToCustomizePricing");
                action.setParams({"serviceRequestId": String(serviceRequestId)});
                
                action.setCallback(this, function(response){
                    
                    console.log('checkValidityOfOperation: ',response.getState());
                    if(response.getState() == 'SUCCESS'){
                        var result = response.getReturnValue();
                        console.log('result in doinit of wrapper : ' + JSON.stringify(result));
                        if(result != null){
                            if(result){
                                resolve('resolved');
                                
                            }else{
                                var toastReference = $A.get("e.force:showToast");
                                toastReference.setParams({
                                    "type":"warning",
                                    "title":"warning",
                                    "message":"Operation is invalid, Go-No-Go Approval is not granted",
                                    "mode":"sticky"
                                });
                                toastReference.fire();
                                // alert('Operation is invalid, Go-No-Go Approval is not granted');
                                reject('reject');
                            }
                        }else{
                            var toastReference = $A.get("e.force:showToast");
                            toastReference.setParams({
                                "type":"warning",
                                "title":"warning",
                                "message":"associated service request not found, Please try contacting Administrator",
                                "mode":"sticky"
                            });
                            toastReference.fire();
                            //alert('associated service request not found, Please try contacting Administrator')
                        }
                    }
                });
                $A.enqueueAction(action);
            })); 
        }else{
            var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"warning",
                "title":"warning",
                "message":"cannot find associated service request, Please contact Administration",
                "mode":"sticky"
            });
            toastReference.fire();
            // alert('couldn\'t find associated service request, Please contact Administration');
        }
        
    },
    
    setOperationStatus : function(component,helper,callingFrom){
        console.log('setOperationStatus:');
        var serviceRequestId = component.get("v.serviceRequestRecordId");
        console.log('serviceRequestId:'+serviceRequestId);
        if(serviceRequestId){
            console.log('serviceRequestId:'+serviceRequestId);
            var action = component.get("c.authorizeOperation");
            console.log('Apex action: ', action);
            action.setParams({"serviceRequestId": String(serviceRequestId),
                              "operation" : 'serviceRequestFormModification'});
        setTimeout(function(){
            action.setCallback(this, function(response){
                if (!response) {
                    console.error('Response is undefined or null!');
                    return;
                }
                console.log('Response object:', response); // Check the full response
                console.log('Response state:', response.getState());
                if(response.getState() == 'SUCCESS'){
                    var result = response.getReturnValue();
                    console.log('result in doinit of wrapper : ' + JSON.stringify(result));
                    if(result != null){
                        
                        component.set("v.serviceRequestModificationStatus", result);
                        if(callingFrom == 'fromPriceCustomizationButton'){
                            var mappingModalcmp = component.find('mappingModalCmp');
                            if(mappingModalcmp){
                                mappingModalcmp.setServiceRequestModificationStatus(component.get("v.serviceRequestModificationStatus"));
                            }
                        }
                        
                    }else{
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"warning",
                            "title":"warning",
                            "message":"associated service request not found, Please try contacting Administrator",
                            "mode":"sticky"
                        });
                        toastReference.fire();
                        // alert('associated service request not found, Please try contacting Administrator')
                    }
                }else if(response.getState() === 'ERROR'){
                    console.log('Error:', response.getError());
                    console.log('Error: ' + JSON.stringify(response.getError()));
                }
            });
            console.log('Before enqueueing action');
            $A.enqueueAction(action);
            console.log('After enqueueing action');
        }, 500);
        }else{
            var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"warning",
                "title":"warning",
                "message":"cannot find associated service request, Please contact Administration",
                "mode":"sticky"
            });
            toastReference.fire();
            // alert('couldn\'t find associated service request, Please contact Administration');
        }
        
    },
    
    //SK-
    checkValidityOfQuoteCreation: function(component,event,helper){
        console.log('.........checkValidityOfQuoteCreation mothod called.......');
        var serviceRequestId = component.get("v.serviceRequestRecordId");
        if(serviceRequestId != undefined){
            var action = component.get("c.authorizeOperation");
            action.setParams({"serviceRequestId": String(serviceRequestId),
                              "operation" : 'quoteCreation'});
            
            action.setCallback(this, function(response){
                
                console.log('checkValidityOfQuoteCreation: ',response.getState());
                if(response.getState() == 'SUCCESS')
                {
                    var result = response.getReturnValue();
                    console.log('result in doinit of wrapper : ' + JSON.stringify(result));
                    if(result != null)
                    {
                        if(result == 'GoNoGoApprrovalIsMissing'){
                            var toastReference = $A.get("e.force:showToast");
                            toastReference.setParams({
                                "type":"warning",
                                "title":"warning",
                                "message":"Operation is invalid, Go-No-Go Approval is not granted",
                                "mode":"sticky"
                            });
                            toastReference.fire();
                            //alert('Operation is invalid, Go-No-Go Approval is not granted');
                            //reject('reject');
                            
                        }else if(result == 'QuoteIsNotApprovedOrRejected'){
                            var toastReference = $A.get("e.force:showToast");
                            toastReference.setParams({
                                "type":"warning",
                                "title":"warning",
                                "message":"Operation is invalid, Active quote is still in approval process or already Approved.",
                                "mode":"sticky"
                            });
                            toastReference.fire();
                            //alert('Operation is invalid, Active quote is still in approval process or already Approved.');
                            //reject('reject');
                        }
                            else if(result == 'PricingCustomizationNotPresent'){
                                var toastReference = $A.get("e.force:showToast");
                                toastReference.setParams({
                                    "type":"warning",
                                    "title":"warning",
                                    "message":"Pricing Customization is not done. Please Reject the request and request concerned Sales team to do combinations.",
                                    "mode":"sticky"
                                });
                                toastReference.fire();
                                // alert('Pricing Customization is not done. Please Reject the request and request concerned Sales team to do combinations.');
                            }
                                else if(result == 'fuelValueMissing'){
                                    var toastReference = $A.get("e.force:showToast");
                                    toastReference.setParams({
                                        "type":"warning",
                                        "title":"warning",
                                        "message":"Vehicle Fuel Consumption value is missing in vehicle details.Please enter the value and try again.",
                                        "mode":"sticky"
                                    });
                                    toastReference.fire();
                                    // alert( 'Vehicle Fuel Consumption value is missing in vehicle details.Please enter the value and try again.');
                                }
                                    else{
                                        //resolve('resolved');
                                        helper.generateQuotationCalc(component,event,helper, serviceRequestId);
                                    }
                        
                    }else{
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"warning",
                            "title":"warning",
                            "message":"associated service request not found, Please try contacting Administrator",
                            "mode":"sticky"
                        });
                        toastReference.fire();
                        // alert('associated service request not found, Please try contacting Administrator')
                    }
                }
            });
            $A.enqueueAction(action);
        }else{
            var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"warning",
                "title":"warning",
                "message":"cannot find associated service request, Please contact Administration",
                "mode":"sticky"
            });
            toastReference.fire();
            //alert('couldn\'t find associated service request, Please contact Administration');
        }
        
    },
    
    saveAlterRatesHelper : function(component, event, helper) {
        
        var action = component.get("c.saveAlterRates");
        action.setParams({ alterRatesWrapper : JSON.stringify(component.get("v.alterRatesWrWithServiceList")),
                          serviceRequestId:component.get("v.serviceRequestRecordId"),
                          quoteId :component.get("v.quoteId"),
                          totalProjectQuoteId : component.get("v.totalProjectQuoteId")
                         });
        component.set('v.loaded', !component.get('v.loaded'));
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.loaded', !component.get('v.loaded'));
                console.log('alter Rates Saved');
                //window.open('/c/ET_QuoteCalculationApp.app?recordId='+component.get('v.quoteId') , '_blank'); 
                window.open("/apex/ET_Quotation_Pricing_PDF?quoteId="+component.get('v.quoteId'));				
            }
            else if (state === "INCOMPLETE") {
                console.log('Network Issue or Server Down');
                component.set('v.loaded', !component.get('v.loaded'));
            }
                else if (state === "ERROR") {
                    component.set('v.loaded', !component.get('v.loaded'));
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message + "Method :" );
                        }
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"Error",
                            "title":"Error",
                            "message":"Internal Error. Please check with system admin",
                            "mode":"sticky"
                        });
                        toastReference.fire();
                        // helper.showToastHelper('Error','error',errors[0].message,'sticky');
                        //alert('Internal Error. Please Try again or Contact System Admin.');
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    
    submitToHeadOfSalesHelper: function(component, event, helper) {
        var action = component.get('c.submitForOppApprovalToSalesHead');
        action.setParams({
            reqId : component.get("v.serviceRequestRecordId")
        });
        component.set('v.loaded', !component.get('v.loaded'));
        action.setCallback(this, function(response) {
            component.set('v.loaded', !component.get('v.loaded'));
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue() == 'true'){
                    var toastReference = $A.get("e.force:showToast");
                    toastReference.setParams({
                        "type":"success",
                        "title":"success",
                        "message":"Record has been successfully submitted for Approval",
                        "mode":"sticky"
                    });
                    toastReference.fire();
                    //alert('Record has been successfully submitted for Approval');   
                }
                else if(response.getReturnValue() != 'true' && response.getReturnValue() != 'false'){
                    helper.showToastHelper('Warning','warning',response.getReturnValue(),'sticky');
                    //alert(response.getReturnValue());
                }
                    else{
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"Error",
                            "title":"Error",
                            "message":"Internal Error. Please check with Admin",
                            "mode":"sticky"
                        });
                        toastReference.fire();
                        //alert('Internal Error. Please check with Admin');
                    }
            }
            else if(state == "ERROR"){
                var errors = response.getError(); 
                helper.showToastHelper('Error','error',errors[0].message,'sticky');
                //alert(errors[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    
    openActiveQuotationHelper : function(component, event, helper) {
        // window.open('/c/ET_QuoteCalculationApp.app?recordId='+component.get('v.quoteId') , '_blank'); 
        // window.open('/c/ET_showPDFQuotationCmp?quoteId='+component.get('v.quoteId') , '_blank'); 
        //window.open("/apex/ET_Quotation_Pricing_PDF?quoteId="+component.get('v.quoteId'));	
        var quoteDetail = component.get("v.quoteDetail");
        console.log('quoteDetail: Open ' + JSON.stringify(quoteDetail));
        if (quoteDetail.Quote_Type__c == 'Manual' && quoteDetail.ContentDocumentLinks.length > 0) {
            window.open("/lightning/r/ContentDocument/" + quoteDetail.ContentDocumentLinks[0].ContentDocumentId + "/view"); //lightning/r/ContentDocument/069UE000002ho8TYAQ/view
        } else {
            window.open("/apex/ET_Quotation_Pricing_PDF?quoteId=" + component.get('v.quoteId'));
        }				
    },

    getPredefinedMasterData: function(component, event, helper) {
        var action = component.get("c.getPredefinedOtherCostData");
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                var response=a.getReturnValue();
                if(response!=null && response!=undefined)
                    component.set("v.predefinedOtherCostMasterData",response);
                console.log('Predefined Data = '+JSON.stringify(response));
            }
        });
        $A.enqueueAction(action);
    },
    
    handlesubmitQuoteForApprovalHelper : function(component, event, helper) {
        debugger;
        component.set("v.isModalOpen","true");
    },
    
    onSubmitRequest : function(component,event,helper,appString) {
        var cmt = component.get("v.commentStr");
        var quoteDetail = component.get("v.quoteDetail");
        console.log('quoteDetail:onSubmitRequest' + JSON.stringify(quoteDetail));
        var action = component.get("c.submitForApproval");
        console.log('appString-->'+appString);
        console.log('comments-->'+cmt)
        component.set('v.loaded', !component.get('v.loaded'));
        action.setParams({
            'quoteId': component.get("v.quoteId"),
            'comments' : cmt,
            'filesData' : JSON.stringify(component.get('v.speaFileList')),
            'quoteDetailStr': JSON.stringify(quoteDetail) //component.get("v.quoteTypeSelected"),            
        });
        action.setCallback(this, function(response) {
            var vflg = response.getReturnValue();
            component.set("v.isModalOpen", false);
            var state = response.getState();
            var urlString = window.location.href;
            var baseURL = urlString.substring(0, urlString.indexOf('/c'));
            console.log(urlString);
            console.log(baseURL);
            if(state === "SUCCESS"){
                component.set('v.loaded', !component.get('v.loaded'));
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type":"success",
                    "title":"success",
                    "message":"Submitted for approval successfully",
                    "mode":"sticky"
                });
                toastReference.fire();
                //alert('Submitted for approval successfully');
                //window.location.href =baseURL+'/'+component.get("v.quoteId");
                //window.open(baseURL+'/'+component.get("v.quoteId"));
                $A.get('e.force:refreshView').fire();
                
            }
            else{
                component.set('v.loaded', !component.get('v.loaded'));
                var errors = response.getError();
                console.log('Error ' + errors[0].message);
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type":"Error",
                    "title":"Error",
                    "message":"Internal Error. Please check with system admin",
                    "mode":"sticky"
                });
                toastReference.fire();
                //helper.showToastHelper('Error','error',errors[0].message,'sticky');
                //alert('Internal Error. Please check with system admin.');            
            }
        });
        $A.enqueueAction(action);
    },
    
    getSubmitFlag : function(component,event,helper){
        var action = component.get("c.fetchSubmitFlag");
        action.setParams({
            'quoteId': component.get("v.quoteId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                var vflg = response.getReturnValue();
                console.log('vflg--->'+vflg);
                component.set("v.flag2",vflg);
            }            
        });
        $A.enqueueAction(action);
    },
    
    updateVehicleAndWorkforceRequestsForCommonDetails : function(component,event,helper, fields){
        debugger;
        var action = component.get('c.updateCommonInfoToVehicleAndWorkforce');
        action.setParams({
            commonReqId : component.get("v.commonDetailsId"),
            commonReqChanges : JSON.stringify(fields)
        });
        component.set('v.loaded', !component.get('v.loaded'));
        action.setCallback(this, function(response) {
            component.set('v.loaded', !component.get('v.loaded'));
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue() == true){
                    console.log('successfully updated...');
                }
                else if(response.getReturnValue() == false){
                }
                    else{
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"Error",
                            "title":"Error",
                            "message":"Internal Error. Please check with Admin",
                            "mode":"sticky"
                        });
                        toastReference.fire();
                        // alert('Internal Error. Please check with Admin');
                    }
            }
            else if(state == "ERROR"){
                var errors = response.getError();
                console.log('error = '+ errors[0].message);
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type":"Error",
                    "title":"Error",
                    "message":"Internal Error. Please check with Admin",
                    "mode":"sticky"
                });
                toastReference.fire();
                //alert('Internal Error. Please check with Admin');
            }
        });
        $A.enqueueAction(action);
    },
    
    submitCommonDetails : function(component,event,helper, fields){
        var commonDataCmp =  component.find("serviceRequestCommonCmp");
        //update changed data in main component
        commonDataCmp.set("v.commonServiceRequestDetails.ET_Request_for_Target_Price__c", fields.ET_Request_for_Target_Price__c);
        commonDataCmp.set("v.commonServiceRequestDetails.ET_Request_for_Separate_Prices__c", fields.ET_Request_for_Separate_Prices__c);
        
        // refresh updated details in common component
        commonDataCmp.set("v.commonServiceRequestDetails.ET_Contract_Type__c", fields.ET_Contract_Type__c);
        commonDataCmp.set("v.commonServiceRequestDetails.ET_Service_Emirate__c", fields.ET_Service_Emirate__c);
        commonDataCmp.set("v.commonServiceRequestDetails.ET_Working_Days_Per_Week__c", fields.ET_Working_Days_Per_Week__c);
        commonDataCmp.set("v.commonServiceRequestDetails.ET_Working_Months_Per_Year__c", fields.ET_Working_Months_Per_Year__c);
        commonDataCmp.set("v.commonServiceRequestDetails.ET_Pricing_Method__c", fields.ET_Pricing_Method__c);
        commonDataCmp.set("v.commonServiceRequestDetails.ET_Pricing_Type__c", fields.ET_Pricing_Type__c);
        commonDataCmp.set("v.commonServiceRequestDetails.ET_Price_Utilization__c", fields.ET_Price_Utilization__c);
        commonDataCmp.set("v.contractValue", component.get("v.contractValue"));
        
        // save common details to server
        component.find('recordEditForm').submit(fields);
        // show edit button 
        var Editcmp = component.find("editButton");
        $A.util.toggleClass(Editcmp,'slds-hide');
        var toastReference = $A.get("e.force:showToast");
        toastReference.setParams({
            "type":"success",
            "title":"success",
            "message":"Details updated successfully.",
            "mode":"sticky"
        });
        toastReference.fire();
        //alert('Details updated successfully.');
    },
    
    arrayRemoveElementByValue: function(arr, value) {
        
        return arr.filter(function(ele){
            return ele != value;
        });
    },
    
    
    showToastHelper : function(title,type,message,mode){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type":type,
            "message": message,
            "mode": mode
        });
        toastEvent.fire();
    },
    
    profilePermissions : function(component, event, helper){
        var action = component.get("c.getProfileInfo");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('getUserPermissions = ' + JSON.stringify(response.getReturnValue()));
                var resObj = response.getReturnValue() ;
                if(resObj.Name=='System Administrator'){ 
                    component.set("v.isSysAdmin" , false);
                    console.log('profile name__q'+resObj.Name);
                }   
            }
            else if (state === "INCOMPLETE") {
                console.log('Network Issue or Server Down');
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message + "Method :" + 'UserPermissions');
                            helper.showToastHelper('Error','error',errors[0].message,'sticky');
                            //alert('Internal Server Error. Please Contact System Admin.');
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    
    //Taj
    handleValidationsHelper: function (component, event, helper) {
        var quoteDetail = component.get("v.quoteDetail");
        console.log('quoteDetail:handleValidations' + JSON.stringify(quoteDetail));
        var speaFileList = component.get("v.speaFileList");
        console.log('speaFileList:' + speaFileList.length);
        var isDisabled = false;
        if (quoteDetail.Quote_Type__c == '' || quoteDetail.Quote_Type__c == null) {
            isDisabled = true;
        }
        if (quoteDetail.Contract_Year__c == '' || quoteDetail.Contract_Year__c == null) {
            isDisabled = true;
        }
        if (quoteDetail.Quote_Type__c == 'Manual' && (quoteDetail.Quote_Total_Investment__c == '' || quoteDetail.Quote_Total_Investment__c == null)) {
            isDisabled = true;
        }
        if (quoteDetail.Quote_Type__c == 'Manual' && (quoteDetail.Total_Investment_New_Vehicles_Manual__c == '' || quoteDetail.Total_Investment_New_Vehicles_Manual__c == null)) {
            isDisabled = true;
        }
        if (quoteDetail.Quote_Type__c == 'Manual' && speaFileList.length == 0) {
            isDisabled = true;
        }
        console.log('isDisabled: ' + isDisabled);
        component.set("v.disableSubmit", isDisabled);
    },

    showToastHelper : function(title, message, type, mode) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : title, //Info //Success //Error //Warning
            message: message,
            duration:'5000',
            type: type, //info //success //error //warning
            mode: mode //dismissible //pester //sticky
        });
        toastEvent.fire();
    },
    
})