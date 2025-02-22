({
    queryCommentsHistory : function(component, event, helper) {
        var utility = component.find("SS_TicketingSystem_UtilityMethods");
        var backendMethod = "getCommentsHistory";
        var params = {
            'ticketId' : component.get("v.ticketId")
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                console.log('response = '+ response); 
                component.set('v.comments' , JSON.parse(response));
                console.log('length = '+ component.get('v.comments').length);
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                utility.showToast("Ticket Management", errorToShow, "error", "dismissible");
            })
        )	
    }
})