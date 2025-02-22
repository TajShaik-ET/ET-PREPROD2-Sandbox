({
    createErrorCmp: function(component,errorMessage){
        $A.createComponent(
            "c:ET_DisplayErrorMessage",
            {
                "aura:id": "errMessage",
                //  "index" : x,
                message: errorMessage,
                type: "Error"
            },
            function(newcomponent) {
                if (component.isValid()) {
                    var newCmp = component.find("errorMessage");
                    var body = newCmp.get("v.body");
                    body.push(newcomponent);
                    newCmp.set("v.body", body);
                }
            }
        );
    },
    
    saveCombinationInfo: function(component,event,helper, mappingDataMap){
        var action = component.get("c.saveCombinationsToDatabase");
        component.set('v.loaded', !component.get('v.loaded'));
        //alert('inside helper of modal ,, printing opp id :' + component.get("v.opportunityRecordId"));
        console.log('combinationMap :: '+ JSON.stringify(mappingDataMap));
        return new Promise(function(resolve, reject){
            action.setParams({"combinationMap": mappingDataMap,
                              "serviceRequestId": component.get("v.serviceRequestRecordId")});
            action.setCallback(this, function(response){
                console.log(response.getState());
                if(response.getState() == 'SUCCESS'){
                    component.set('v.loaded', !component.get('v.loaded'));
                    alert('All Combinaton got saved successfully. Please proceed with Intiate Quotation');
                    resolve(response.getReturnValue());
                }else{
                    component.set('v.loaded', !component.get('v.loaded'));
                    var errors = response.getError();
                    reject(response.getError()[0]);
                }
            });
            $A.enqueueAction(action);
            
        });
        
    },
    
     getVehAndManpowerInfo : function(component,event,helper){
        var action = component.get("c.getvehAndManpowerCombinataions");
        action.setParams({ serviceRequestId : component.get("v.serviceRequestRecordId") });
        component.set('v.loaded', !component.get('v.loaded'));
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set('v.loaded', !component.get('v.loaded'));
            if (state === "SUCCESS") {
                component.set("v.data", response.getReturnValue());
                helper.loadExistingCombinationsHelper(component,event,helper);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    
    loadExistingCombinationsHelper: function(component,event,helper){
        helper.loadExistingCombinations(component,helper).then($A.getCallback(function(result) {
            //var existingCombinations = ;
            var allDataMap = component.get("v.data");
            console.log('allDataMap = '+ JSON.stringify(allDataMap));
            if(result == 'noExistingCombination'){
                component.set("v.allTabDataWithUpdatedUnitAvailableNo",allDataMap);
                console.log('datamap in mapping modal init:: ',JSON.stringify(allDataMap));
            }else{
                var existingComboMap = {};
                for(var combination of component.get("v.existingCombinations")){
                    if(combination.ET_Vehicle_Unique_key__c && existingComboMap[combination.ET_Vehicle_Unique_key__c] ){
                        existingComboMap[combination.ET_Vehicle_Unique_key__c] += combination.ET_Number_of_Vehicles__c;
                    }else if(combination.ET_Vehicle_Unique_key__c){
                        existingComboMap[combination.ET_Vehicle_Unique_key__c] = combination.ET_Number_of_Vehicles__c;
                    }
                    
                    if(combination.ET_Driver_Unique_Id__c && existingComboMap[combination.ET_Driver_Unique_Id__c] ){
                        existingComboMap[combination.ET_Driver_Unique_Id__c] +=  combination.ET_Number_of_Drivers__c;
                    }else if(combination.ET_Driver_Unique_Id__c){
                        existingComboMap[combination.ET_Driver_Unique_Id__c] =  combination.ET_Number_of_Drivers__c;
                    }
                    
                    
                    if(combination.ET_Supervisor_Unique_Key__c && existingComboMap[combination.ET_Supervisor_Unique_Key__c]){
                        existingComboMap[combination.ET_Supervisor_Unique_Key__c] +=  combination.ET_Number_of_Supervisors__c;
                    }else if(combination.ET_Supervisor_Unique_Key__c){
                        existingComboMap[combination.ET_Supervisor_Unique_Key__c] =  combination.ET_Number_of_Supervisors__c;
                    }
                    
                    
                    if(combination.ET_Coordinator_Unique_Key__c && existingComboMap[combination.ET_Coordinator_Unique_Key__c]){
                        existingComboMap[combination.ET_Coordinator_Unique_Key__c] +=  combination.ET_Number_of_Coordinators__c;
                    }else if(combination.ET_Coordinator_Unique_Key__c){
                        existingComboMap[combination.ET_Coordinator_Unique_Key__c] =  combination.ET_Number_of_Coordinators__c;
                    }
                    
                    
                    if(combination.ET_Accountant_Unique_Key__c && existingComboMap[combination.ET_Accountant_Unique_Key__c]){
                        existingComboMap[combination.ET_Accountant_Unique_Key__c] +=  combination.ET_Number_of_Accountants__c;
                    }else if(combination.ET_Accountant_Unique_Key__c){
                        existingComboMap[combination.ET_Accountant_Unique_Key__c] =  combination.ET_Number_of_Accountants__c;
                    }
                    
                    
                    if(combination.ET_Nanny_Unique_Key__c && existingComboMap[combination.ET_Nanny_Unique_Key__c]){
                        existingComboMap[combination.ET_Nanny_Unique_Key__c] +=  combination.ET_Number_of_Nannies__c;
                    }else if(combination.ET_Nanny_Unique_Key__c){
                        existingComboMap[combination.ET_Nanny_Unique_Key__c] =  combination.ET_Number_of_Nannies__c;
                    }
                    
                    
                    if(combination.ET_Other_Employee_Unique_Key__c && existingComboMap[combination.ET_Other_Employee_Unique_Key__c]){
                        existingComboMap[combination.ET_Other_Employee_Unique_Key__c] +=  combination.ET_Number_of_Other_Employees__c;
                    }else if(combination.ET_Other_Employee_Unique_Key__c){
                        existingComboMap[combination.ET_Other_Employee_Unique_Key__c] =  combination.ET_Number_of_Other_Employees__c;
                    }
                    
                    
                }
                var newAllDataMap = {};
                for(var key in allDataMap){
                    var newSubDataMap = {};
                    for(var innerKey in allDataMap[key]){
                        var data =  allDataMap[key];
                        if(existingComboMap[innerKey]){
                            data[innerKey] = parseInt(data[innerKey]) - parseInt(existingComboMap[innerKey]);
                        }
                        newSubDataMap[innerKey] = data[innerKey];
                    }
                    newAllDataMap[key] = newSubDataMap;
                    
                }
                component.set("v.allTabDataWithUpdatedUnitAvailableNo",newAllDataMap);
                console.log('newAllDataMap : ',JSON.stringify(newAllDataMap));
                
                // to create existing Mapping rows
                for(var combination of component.get("v.existingCombinations")){
                    $A.createComponent(
                        "c:ET_MappingRow",
                        {
                            "aura:id": "mappingRow",
                            existingMappingRowData: combination,
                            data: component.get("v.allTabDataWithUpdatedUnitAvailableNo"),
                            isPricingTeam  : component.get("v.isPricingTeam"),
                            serviceRequestRecordId :component.get("v.serviceRequestRecordId"),
                        },
                        function(newcomponent) {
                            if (component.isValid()) {
                                var newCmp = component.find("cmpBody");
                                var body = newCmp.get("v.body");
                                body.push(newcomponent);
                                newCmp.set("v.body", body);
                                //component.set("v.addPricingComboBttnDisable", true);
                            }
                        }
                    );
                }
                
            }  
        }))
    },
    
    loadExistingCombinations: function(component,helper){
        return new Promise(function(resolve,reject){
            var action =  component.get("c.fetchExistingCombinations");
            action.setParams({'serviceRequestId' : component.get("v.serviceRequestRecordId")});
            component.set('v.loaded', !component.get('v.loaded'));
            action.setCallback(this, function(response){
                component.set('v.loaded', !component.get('v.loaded'));
                if(response.getState() == 'SUCCESS'){
                    var result = response.getReturnValue();
                    if(result){
                        if(result.accountantPricingChoice){
                            component.set("v.accountantPricingChoice", result.accountantPricingChoice);
                        }
                        if(result.supervisorPricingChoice){
                            component.set("v.supervisorPricingChoice", result.supervisorPricingChoice);
                        }
                        if(result.coordinatorPricingChoice){
                            component.set("v.coordinatorPricingChoice", result.coordinatorPricingChoice);
                        }
                        component.set("v.existingCombinations", result.combinations);
                        resolve('resolve');
                    }
                    resolve('noExistingCombination');
                }
                reject('reject');
            });
            $A.enqueueAction(action);
        })
        
    }
    
})