({
    doInit : function(component, event, helper) {
        var oppId = component.get('v.recordId');
        if(oppId){
         helper.getActivatedSRId(component,oppId);
        }
    }
})