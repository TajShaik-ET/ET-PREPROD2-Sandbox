({
    doInit: function(component,event,helper){
        //console.log('printing driver data from parent cmp : '+JSON.stringify(component.get("v.existingDriverTabData")));
    },

    getDeletedIds : function(component,event,helper){
        var vehicleDeletedIds = component.get("v.deletedVehicleChildDetailCmpList");
        var manpowerDeletedIds = componet.get("v.deletedManpowerChildDetailCmpList");
        var deletedIds;
        var data;
        if(vehicleDeletedIds != undefined && vehicleDeletedIds.length > 0){
            if(!deletedIds){
                deletedIds = {};
            }
            deletedIds['vehicleLineItemsToBeDeleted'] = vehicleDeletedIds;
        }
        if(manpowerDeletedIds != undefined && manpowerDeletedIds.length > 0){
            if(!deletedIds){
                deletedIds = {};
            }
            deletedIds['manpowerLineItemsToBeDeleted'] = manpowerDeletedIds;
        }
        if(deletedIds){
            data['deletedIds'] = deletedIds;
        }

        return data;
       
        
    },
    intializeTabs: function(component,event,helper){
        var params = event.getParam('arguments');
        if (params) {
            var backgroundColor;
            var commonFieldsToBePopulateLst;
            var commonInforReceivedFrmWrapper;
            var existingData;
            if(params.backgroundColor){
                backgroundColor = params.backgroundColor;
            }
            if(params.commonFieldsToBePopulateLst){
                commonFieldsToBePopulateLst = params.commonFieldsToBePopulateLst;
            }
            if(params.commonInforReceivedFrmWrapper){
                commonInforReceivedFrmWrapper = params.commonInforReceivedFrmWrapper;
            }
            if(params.existingData){
                existingData = params.existingData;
            }
           
            var tabId = component.getLocalId();
            component.set("v.backgroundColor",backgroundColor);
            component.set("v.commonFieldsToBePopulateLst",commonFieldsToBePopulateLst);
            component.set("v.commonInforReceivedFrmWrapper",commonInforReceivedFrmWrapper);
            if(tabId == 'driverTab'){
                component.set("v.existingDriverTabData",existingData);
               
            }else if(tabId == 'schoolBusNanniesTab'){
                component.set("v.existingNannyTabData",existingData);
            }
            else if(tabId == 'supervisorTab'){
                component.set("v.existingSupervisorTabData",existingData);
            }
            else if(tabId == 'coordinatorTab'){
                component.set("v.existingCoordinatorTabData",existingData);
            }
            else if(tabId == 'accountantTab'){
                component.set("v.existingAccountantTabData",existingData);
            }
            else if(tabId == 'otherEmployeeTab'){
                component.set("v.existingOtherEmpTabData",existingData);
            }else if(tabId == 'vehicleTab'){
                component.set("v.existingVehicleTabData",existingData);
            }  
            helper.processDoInit(component,event,helper);
        }
        
    },
    
   
        
})