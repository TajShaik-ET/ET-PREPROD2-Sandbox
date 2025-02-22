({
    doInit : function(component, event, helper) {
        console.log('inside doInit');
        var url_string = window.location.href;
        var url = new URL(url_string);
        var recordId = url.searchParams.get("recordId");
        if(recordId != null && recordId != '' && recordId != undefined) {
            component.set("v.recordId",recordId);
        }
        console.log('recordId -->'+component.get('v.recordId'));
        helper.getApprovalRequest(component,event,helper);
        helper.getSubmitFlag(component,event,helper);
        
    },
	onApprove : function(component, event, helper) {
        component.set("v.btnDis",true);
        helper.onSubmitAction(component,event,helper,"Approve");
	},
    onSubmit : function(component, event, helper) {
        helper.onSubmitRequest(component,event,helper,"Approve");
	},
    onReject : function(component, event, helper) {
		helper.onSubmitAction(component,event,helper,"Reject");
	},
    openModal : function(component, event, helper) {
		component.set("v.isModalOpen","true");
	},
    closeModel: function(component, event, helper) {
      component.set("v.isModalOpen", false);
   },
  
})