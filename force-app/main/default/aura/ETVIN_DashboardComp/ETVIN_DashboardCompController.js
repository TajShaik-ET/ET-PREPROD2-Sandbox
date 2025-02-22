({
	doInit : function(component, event, helper) {
        
        helper.getInsurancedetails(component, event, helper);
        helper.getClaimdetails(component, event, helper);
        helper.getCorrdetails(component, event, helper);
        helper.getCancellationdetails(component, event, helper);
        helper.getMulkiyaReqdetails(component, event, helper);
        
		
	},
     getSelectedTab : function (component, event, helper) {
        
         var input = event.currentTarget.id;
         component.set('v.selectedTabId',input);
         component.set('v.detailpage',false);
         
     }
})