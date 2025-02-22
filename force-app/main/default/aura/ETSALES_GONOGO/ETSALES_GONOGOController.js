({
    initData: function(component, event, helper) {
        console.log('***In controller');
        helper.getOppAccountVehicleWrapperhelper(component, event, helper);
        helper.getOpportunityDetails(component, event, helper);
    },
    cancel:function(component){
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
    submitForApproval:function(component, event, helper){
        console.log('***In controller Submit for Approval');
        helper.submitForApprovalHelper(component, event, helper);
    },
})