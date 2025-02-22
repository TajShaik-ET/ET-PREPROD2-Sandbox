({
    closeModel: function(component, event, helper) {
        component.set('v.isCancelModal',false);
        
    },
    closeTicket: function(component, event, helper){
        var mandatoryFieldsList = component.get("v.mandatoryFields");
        var mandatoryFieldsCmps = [];
        for(var id in mandatoryFieldsList){
            mandatoryFieldsCmps.push(component.find(mandatoryFieldsList[id]));
        }
        
        if(mandatoryFieldsList.length!=undefined && mandatoryFieldsList.length > 0){
            var allValid =mandatoryFieldsCmps.reduce(function (validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && !inputCmp.get('v.validity').valueMissing;
            }, true);
            
            console.log('allValid = '+ allValid);
            
            if (allValid) {  
                helper.closeTicketHelper(component, event, helper);
            }
        }
        
    } 
})