({
    doInit : function(component, event, helper) {
        debugger;
        helper.getRegistrationRecord(component, event, helper);
    },
    
    approveRequest :function(component, event, helper) {
        
        try{
            helper.createCommunityUserHelper(component,event, helper);
        }catch(er){
            console.log('er.message')
        }
        
        
    },
    rejectRequest : function(component, event, helper) {
        try{
            
            component.find('fieldId').set("v.value",'Rejected');
            component.find('submitForm').submit();
            var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type" : 'Success',
                "title" : 'Success',
                "message" : 'Request is rejected successfully',
                "mode" : "sticky"
            });
            toastReference.fire();
            $A.get("e.force:closeQuickAction").fire();
        }
        catch(e){
            console.log(e.message)
        }
    },
    
    handleOnLoad : function(component, event, helper) {
        var requestStatus = component.find("fieldId").get("v.value");
        if(requestStatus == 'Approved' ){
            showMsg = 'Request is Already Approved!';
        }
        else{
            showMsg = 'Do you want approve request, if yes please click on \'Approve\' else click on \'Reject\'';
        }
    },
    
    onSuccessMethod : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})