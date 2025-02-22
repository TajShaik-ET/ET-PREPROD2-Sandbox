({
    doinit : function(component, event, helper) {
        helper.setCommunityLanguage(component, event, helper);
        var VehicleInfoDataList = component.get("v.VehicleInfoDataList");
        console.log('con>> '+con);
        VehicleInfoDataList.push({'sObjectType':'ET_Customer_Vehicle__c'});
        component.set("v.VehicleInfoDataList",VehicleInfoDataList);
        component.set("v.IsSpinner", true);
        var showHParam = helper.getJsonFromUrl().showH;
        component.set('v.showHistory',showHParam);
       	helper.getJsonFromUrl1(component, event, helper);
        var con= component.get('v.recordId');
        console.log('con>> '+con);
        console.log('showHParam>> '+showHParam);
        helper.getAmanLookups(component, event, helper);
    },
    
})