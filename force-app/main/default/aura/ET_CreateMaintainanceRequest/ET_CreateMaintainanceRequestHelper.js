({
    addTableRows: function(component, event) {
        component.set('v.showSpinner',true);
        var mainReqList = component.get("v.maintenanceRequestList");
        mainReqList.push({
            'sobjectType': 'Maintenance_Request__c',
            'Make_manufacturer_type__c': '',
            'Model_Type__c': '',
            'Model_Year__c': '',
            'Chassis_No__c': '',
            'Current_KM_Hrs__c': '',
            'Location__c': ''
        });
        component.set("v.maintenanceRequestList", mainReqList);
        component.set('v.showSpinner',false);
    },
    
})