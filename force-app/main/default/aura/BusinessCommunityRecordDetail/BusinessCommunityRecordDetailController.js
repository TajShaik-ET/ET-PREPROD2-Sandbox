({
    handleRecordDetailApplicationEvent : function(component, event, helper) {

        var showIFrameAttribute = event.getParam("showIFrame");
        var recId = event.getParam("selectedRecordId");
        var selectedRecord = event.getParam("selectedRecordType");
        component.set("v.showIFrame", showIFrameAttribute);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", selectedRecord);
        
    },
})