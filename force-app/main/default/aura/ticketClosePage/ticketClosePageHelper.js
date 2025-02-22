({
    closeTicketHelper : function(component, event, helper) {
        var utility = component.find("SS_TicketingSystem_UtilityMethods");
        var backendMethod = "manageTicket";
        var params = {
            'ticketId' : component.get("v.ticketId"),
            'comments': component.get("v.comments"),
            'status': 'closed'
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                console.log('response = '+ response);
                component.set('v.isCancelModal',false);
                if(response = 'Success'){
                    utility.showToast("Ticket Management", 'Ticket Cancelled Successfully', "success", "dismissible");
                    window.location.reload(true);
                }
                
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                utility.showToast("Ticket Management", errorToShow, "error", "dismissible");
            })
        )	
    }
})