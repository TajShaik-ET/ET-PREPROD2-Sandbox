({
    doInit: function(component, event, helper){
        debugger;
        console.log('quote Id in Vehicle Tab  :' +component.get("v.quoteId"));
        helper.processDoInit(component,event,helper);
    },
    //SK-
    getOpprecordTypeName: function(component, event, helper){
        var params = event.getParam('arguments');
        
        if(params){
            component.set("v.OpprecordTypeName", params.OpprecordTypeName);
            if(params.OpprecordTypeName == 'Leasing/ Rental'){
                console.log('inside getOpprecordTypeName of ET_VehicleTab ' + JSON.stringify(component.get("v.OpprecordTypeName")));
            } else {
                
            }
        }
    },
	handleAddMore : function(component, event, helper) {
       debugger;
        var vehicleRecords = helper.getTabCommonData(component,event,helper);
        if(vehicleRecords){
            var fleetType = component.get("v.fleetType");
            console.log("fleetType = "+ fleetType);
            console.log("multipleFieldIds1 = "+ component.get("v.multipleFields"));
            if(fleetType){
                var multipleFieldIds = component.get("v.multipleFields"); 
                
                if(fleetType == 'Multiple'){
                     if(!multipleFieldIds){
                        multipleFieldIds = [];
                    }
                    multipleFieldIds.push('ET_Fleet_Type__c');
                }
				console.log("multipleFieldIds = "+ multipleFieldIds);
                component.set("v.vehicleRecords",vehicleRecords);
                //helper.validateAllDetails(component,event,helper) ||  component.find("vehicleDetailsCmp") == undefined || (component.find("vehicleDetailsCmp") != undefined && component.find("vehicleDetailsCmp").length == undefined && component.find("vehicleDetailsCmp").find("collapsibleCmp") == undefined
                if(helper.validateAllDetails(component,event,helper) || component.find("vehicleDetailsCmp") == undefined || (component.find("vehicleDetailsCmp") != undefined && component.find("vehicleDetailsCmp").length == undefined && component.find("vehicleDetailsCmp").find("collapsibleCmp") == undefined) ){
                    helper.createComponent(component, event, helper,multipleFieldIds);
                }
            }else{
                component.set("v.showToast",true);
            }
        }
    },
    
    copyVehicleController : function(component, event, helper) {
       helper.copyVehicleHelper(component, event, helper);
    },

    handleNotifyRequirementTabEvent: function(component,event,helper){
        helper.decreaseVehicleLineCount(component,event,helper);
    },

    doRefresh: function(component,event,helper){
        debugger;
        var data = component.get("v.existingVehicleTabData");
        console.log('data 44= '+ JSON.stringify(data));
        if(data){
            var id = event.getParam("childCmpAuraId");
            var lineItemNumber = event.getParam("childTabLineNumber");
            console.log('id = '+ id + ' '+ 'lineItemNumber = '+ lineItemNumber);
            //&& component.get("v.commonFieldsToBePopulateLstcreateComponent") != undefined && component.get("v.commonFieldsToBePopulateLstcreateComponent").length>0 -- removed from below condition...
            if(id == 'serviceRequestCommonCmpVehicle' && component.get("v.existingVehicleCommonData") != undefined ){
                (component.find(id)).prePopulateCommonData(Object.assign({},component.get("v.existingVehicleCommonData"))).then(
                    $A.getCallback(function(result) {
                        var vehicleRecords = helper.getTabCommonData(component,event,helper);
                        if(vehicleRecords){ 
                                component.set("v.vehicleRecords",vehicleRecords);
                                if(data.vehicleLineItems != null){
                                    var items = data.vehicleLineItems;
                                    var multipleFieldIds = component.get("v.multipleFields");
                                    if(data.vehicleCommonData != null && data.vehicleCommonData.ET_Fleet_Type__c != null && data.vehicleCommonData.ET_Fleet_Type__c == 'Multiple'){
                                        multipleFieldIds.push('ET_Fleet_Type__c');
                                    }
                                    for(var item of items){
                                        helper.createComponent(component, event, helper,multipleFieldIds); 
                                    }
                                }
                                
                        }
                    })
                )
            }
            // Set the Data in Vehicle lines asynchronously
            else if(id ==  'vehicleDetailsCmp' && component.get("v.existingVehicleLineItems") != undefined){
                console.log('id : ' + id );
                var dataInput = component.get("v.existingVehicleLineItems");
                var vehicleLine1Data;
                var vehicleLineCurrentData;
                for(var data of dataInput){
                    console.log('line no : ' + data.ET_Vehicle_Line__c );
                    if(data.ET_Vehicle_Line__c == 1){
                        vehicleLine1Data = data;
                    }
                    if(data.ET_Vehicle_Line__c == lineItemNumber){
                        vehicleLineCurrentData = data;
                    }
                }
                var vehicleDeatilCmps = component.find(id);
                if(vehicleDeatilCmps != undefined && vehicleDeatilCmps.length == undefined){
                    vehicleDeatilCmps.prePopulateVehicleData(vehicleLine1Data);
                }else if(vehicleDeatilCmps != undefined && vehicleDeatilCmps.length != undefined){
                
                    for(var cmp of vehicleDeatilCmps){
                        if(cmp.get("v.lineNumber") == lineItemNumber){
                            cmp.prePopulateVehicleData(vehicleLineCurrentData);
                        }
                    }
                }
            }
        }
        
    },
  
    getDataController : function(component, event, helper) {
        var vehicleRecordMap = helper.getDataHelper(component, event, helper);
        return vehicleRecordMap;
    },

    handleAlterRateEvent : function(component, event, helper) {
        var alterRatesObj = event.getParam("alterRatesObj");
        console.log('alterRatesObj tab = '+JSON.stringify(alterRatesObj) );
        component.set("v.alterRatesWithServiceWrp", alterRatesObj);
        var childComponent =component.find('vehicleDetailsCmp');
        if(childComponent.length != undefined){
            for(var child of childComponent){
                child.set("v.alterRatesObj", alterRatesObj);
            } 
        }
        else if(childComponent.length == undefined){
            childComponent.set("v.alterRatesObj", alterRatesObj);
        }
    },
    
    onQuoteIdChange : function(component, event, helper) {
        var childComponent =component.find("vehicleDetailsCmp");
        /*if multiple child components present - childComponent is list other wise it's a single object..
          so checking with length, if it's undefined - it's single object and can directly access that single child component..
          If multiple child components iterate over the components and set the Values.. */
        console.log('quoteId in Vehicle Tab  = '+ component.get("v.quoteId"));
        if(childComponent !=undefined && childComponent.length != undefined){
            for(var child of childComponent){
            	child.set("v.quoteId", component.get("v.quoteId"));
            } 
        }
        else if( childComponent !=undefined && childComponent.length == undefined){
            childComponent.set("v.quoteId", component.get("v.quoteId"));
        }
    },
    
    updateChildVehicleDetailsController : function(component, event, helper) {
        var params = event.getParam('arguments');
        if (params) {
            var param1 = params.param1;
            var childComponent =component.find("vehicleDetailsCmp");
            if(childComponent !=undefined && childComponent.length != undefined){
                for(var child of childComponent){
                   // child.set("v.vehicleLine.ET_Annual_Target_Price__c", 0);
                    child.set("v.showAnnualTargetPrice", param1);
                } 
            }
            else if( childComponent !=undefined && childComponent.length == undefined){
                //child.set("v.vehicleLine.ET_Annual_Target_Price__c", 0);
                childComponent.set("v.showAnnualTargetPrice", param1);
            }
        }
    },

    getOpprecordTypeName: function(component,event,helper){
        var params = event.getParam('arguments');
        //alert('getOpprecordTypeName: '+params);
        if(params){
            component.set("v.OpprecordTypeName", params.OpprecordTypeName);
            console.log('inside getOpprecordTypeName in of ET_VehicleTabController ' + JSON.stringify(component.get("v.OpprecordTypeName")));
        }
    },
    
})