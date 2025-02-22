({
    doInit : function(component, event, helper) {
        if(component.get("v.quoteId") != undefined && component.get("v.quoteId") != null){
            //window.open("/apex/ET_Quotation_Pricing_PDF?quoteId="+component.get('v.quoteId'));		
            helper.preveiwQuote(component, event, helper, component.get("v.quoteId"));		
        }else{
            //window.open("/apex/ET_Quotation_Pricing_PDF?quoteId="+component.get('v.recordId'));	
            helper.preveiwQuote(component, event, helper, component.get("v.recordId"));				
        }
        //to close popup
        var action = component.get('c.closeAction');
      	$A.enqueueAction(action);
    },
    closeAction :function(component, event, helper){
    	$A.get("e.force:closeQuickAction").fire();
 	},
    
})