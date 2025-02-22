({
    doInit : function(component, event, helper) {
        var recordId  = component.get('v.recordId');
        if(recordId){
            helper.checkOppStageIsValid(component,recordId);
        }   
    }
})